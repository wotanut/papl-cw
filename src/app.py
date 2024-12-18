import logging
import os
from contextlib import asynccontextmanager
from random import randint
from typing import Annotated, Optional, Union

import requests
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException
from sqlmodel import Session, SQLModel, create_engine, exists

from db import *
from models.flight import (Flight, generateAirport, generateCallsign,
                           generateETE, getFltNmbr, getICAO)
from models.message import Message

# Database

logger = logging.getLogger("uvicorn.error")
logger.setLevel(logging.DEBUG)

load_dotenv()
DATABASE_URL = os.environ.get("DATABASE_URL")

SessionDep = Annotated[Session, Depends(get_session)]

# @asynccontextmanager
# async def lifespan(app: FastAPI):
#     logger.debug("Startup")
#     await init_db()

# app = FastAPI(lifespan=lifespan)
app = FastAPI()


@app.on_event("startup")
async def startup_event():
    logger.debug("Starting Up")
    init_db()


@app.get("/")
async def home():
    return {"hello": "world"}


@app.post("/flight/init")
async def init_flight(flight: Flight, session: SessionDep):
    session.add(flight)
    session.commit()
    session.refresh(flight)
    return flight


@app.get("/metar/{icao}")
async def metar(icao: str):
    """
    Get's the metar from Vatsim but the metar should match the metar from real life
    https://vatsim.dev/services/apis#metar-api
    """
    req = requests.get("https://metar.vatsim.net/{icao}")
    return {"metar": req.text}


# @app.get("/wx/{icao}")
# async def wx(icao: str):
#     """
#     Get's the weather from Vatsim
#     """


@app.get("/init/request")
async def init(flight: Optional[Flight], session: SessionDep):
    """
    Generates a random flight for the aircraft. Normally this would send the aircraft registration but as that has no significance to a schedule
    (at least at this time) that's been left out. If no flight is supplied then a random one will be generated and returned. If an incorrect paramter
    is found it will be replace with a random corrected paramater and there will be an optional text entry for the scratchpad to display. Incorrect entries refer to a wrong flight ID (I.E BA154 as opposed to BAW154)
    An incorrectly formatted destination (LHR as opposed to EGLL), horrible ETE (0000) etc..

    Paramters:
    flight: Optional[Flight] - an optional parameter that will override any custom entries, assuming it is all of the correct format

    Raises:
    401: If the callsign is already in use

    Returns:
    - Errors: If an exception is raised will return any error, namely "Callsign in use"
    - entry: If there is an entry for the scratchpad to display
    - flight: The updated flight object (mainly for error validation)
    """
    errors = []
    entry = ""

    exists = Session.exec(exists().where(Flight.id == flight.id))
    if exists:
        errors.append("Callsign in use")
        raise HTTPException(status_code=401, detail="Callsign in use")

    if flight:
        try:
            airline, nmbr = getICAO(flight), getFltNmbr(flight)
            cs = generateCallsign(airline, nmbr)
        except Exception as e:
            errors.append(e)
            entry = "Invalid Callsign"
        dep, dest, altn = (
            generateAirport(flight.dep),
            generateAirport(flight.dest),
            generateAirport(flight.altn),
        )  # TODO - Better error validation
        ete = generateETE(flight.ete)
    else:
        cs = generateCallsign
        dep, dest, altn = generateAirport(), generateAirport(), generateAirport()
        ete = generateETE()
    newFlight = Flight(
        id=cs,
        stage=flight.stage,
        dep=dep,
        dest=dest,
        altn=altn,
        ete=ete,
        ADCReq=flight.ADCReq,
    )

    session.add(newFlight)
    session.commit()
    return {"success": True, flight: newFlight, entry: entry}


@app.get("/msg/adc")
async def sendADC(flight: Flight):
    """
    On request, checks to see if the aircraft requires an ADC to be submitted, if so will send an ADC required msg otherwise will send ADC not req
    """
    probaility = randint(0, 100)
    content = ""
    if probaility % 4 == 0 or flight.ADCReq == True:
        content = (
            f"ADC Required for {probaility} minutes delay. Send via company tablet"
        )
    else:
        content = "ADC Not rqrd"
    msg = Message("Company", sender=f"{getICAO(flight)}OPS", content=content)
    # TODO: Add that the message was sent to the message database
    return msg


@app.get("atis/{icao}")
async def atis(icao: str):
    """
    Generates a random ATIS, I can't yet find an api to get an atis
    """
    return {
        "atis": "LONDON HEATHROW AIRPORT INFORMATION A...  1420Z...  WIND 110 AT 7 KNOTS...  VISIBILITY 7 KILOMETERS...  CEILING 1300 OVERCAST...  TEMPERATURE 11, DEWPOINT 8...  QNH 1029, ALTIMETER 3039...  LANDING RUNWAY 27L...  DEPARTING RUNWAY 27R...  ADVISE CONTROLLER ON INITIAL CONTACT THAT YOU HAVE INFORMATION A... "
    }