import logging
import os
from contextlib import asynccontextmanager
from typing import Annotated, Union

import requests
from dotenv import load_dotenv
from fastapi import Depends, FastAPI
from sqlmodel import Session, SQLModel, create_engine, exists

from db import *
from models.flight import Flight

# Database 

logger = logging.getLogger('uvicorn.error')
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
    return {"hello" : "world"}

@app.post('/flight/init')
async def init_flight(flight:Flight, session:SessionDep):
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
    return {"metar" : req.text}

# @app.get("/wx/{icao}")
# async def wx(icao: str):
#     """
#     Get's the weather from Vatsim
#     """

@app.get("atis/{icao}")
async def atis(icao: str):
    """
    Generates a random ATIS, I can't yet find an api to get an atis
    """
    return {"atis" : "LONDON HEATHROW AIRPORT INFORMATION A...  1420Z...  WIND 110 AT 7 KNOTS...  VISIBILITY 7 KILOMETERS...  CEILING 1300 OVERCAST...  TEMPERATURE 11, DEWPOINT 8...  QNH 1029, ALTIMETER 3039...  LANDING RUNWAY 27L...  DEPARTING RUNWAY 27R...  ADVISE CONTROLLER ON INITIAL CONTACT THAT YOU HAVE INFORMATION A... "}
