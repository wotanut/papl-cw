import csv
import json
import os
import random
import re
from typing import Dict, List, Optional

import requests
from dotenv import load_dotenv
from sqlmodel import (CheckConstraint, Column, Enum, Field, Relationship,
                      Session, SQLModel, create_engine, select)

from .Types import FlightStage

load_dotenv()


class Flight(SQLModel, table=True):
    """
    The Flight model. Some important information

    Parameters
    ----------
    ID: Must be exactly 7 characters with at least the first 3 being an ICAO code
    stage: A value from FlightStage, default's to PreDep
    dep, dest, altn: A 4 digit ICAO code that is regex enforced. Ideally should be in uppercase anyway, but will return uppercase regardless of what you put in.
    ete: Enroute Time Expected, a 4 digit string that is formatted such as 0019 for each minute you are expected to fly.
    ADCReq: Used to specify if the user should be asked for an ADC, defualt is calculated on the change to cruise and has a 50/50 chance of occuring. Specifying a value will override this.

    Examples
    --------
    > Flight(id="AAL1254", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015")

    > Flight(id="BAW15K", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015",ADCReq=True)

    > Flight(id="VIR27L", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015",ADCReq=False)


    See More
    --------
    @flightStage
    """

    id: str = Field(
        primary_key=True,
        unique=True,
        max_length=7,
        min_length=7,
        description="Can be a string of 7 digits as all callsigns are unique",
    )  # NOTE - ID can be a string as all callsigns will be unique
    stage: FlightStage = Field(
        sa_column=Column(Enum(FlightStage)), default=FlightStage.PreDep.value
    )
    dep: str = Field(
        max_length=4,
        min_length=4,
        nullable=False,
        sa_column_args=CheckConstraint(r"^[A-Z]{4}$"),
    )
    dest: str = Field(
        max_length=4,
        min_length=4,
        nullable=False,
        sa_column_args=CheckConstraint(r"^[A-Z]{4}$"),
    )
    altn: str = Field(
        max_length=4,
        min_length=4,
        nullable=False,
        sa_column_args=CheckConstraint(r"^[A-Z]{4}$"),
    )
    ete: str = Field(
        max_length=4,
        min_length=4,
        nullable=False,
        sa_column_args=CheckConstraint(r"^[0-9]{4}$"),
    )
    ADCReq: bool | None = Field(default=None, nullable=True)  # ADC is a type of message
    # TODO: FK to Messages and FlightAware


# class __Flight(Flight):
#     id: str
#     filedFL: str = Field(max_length=5, sa_column_args=CheckConstraint(r"^FL[0-9]{3}%"))
#     currentFL: str = Field(
#         max_length=5, sa_column_args=CheckConstraint(r"^FL[1-9]{3}%")
#     )
    # NOTE - This would be where FL's will be stored as well as messages so that they're not accesible over the API and can't be accessed from initial set
    # TODO: Add filedFL and currentFL


def getICAO(flight: Flight):
    """
    Get's the ICAO Code of an airline
    """
    return flight.id[:3]  # :3

def getFltNmbr(flight: Flight):
    """
    Get's the flight number of a flight
    """
    return flight.id[3:]

def generateCallsign(airline: Optional[str] = None, fltnmb: Optional[str] = None):
    """
    Generates a callsign from either a given airline icao or a flight number. If neither are provided generates one for both.

    WARNING:
        Does not check to see if the callsign is in use

    Returns:
    - Callsign: Str - A callsign for use
    """
    # Won't use a regex here so that someoen doesn't try and use XK234 as a valid callsign
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    airlines: List[Dict] = []
    callsign = ""
    with open("/home/sam/Code/papl-cw/src/models/airlines.json") as f: #FIXME - unfuck this
        airlines = json.load(f)
        f.close()
    if airline:
        # Check to see if it's a valid airline
        shouldChange = False
        for line in airlines:
            for key,value in line.items():
                if airline == value and key == "IATA":
                    # Change it to be an ICAO code instead
                    shouldChange = True
                elif shouldChange == True or (airline == value and key == "ICAO"):
                    callsign = callsign + value.upper()  # Adds the airline to the callsign
                    break
    if callsign == '' or not airline: 
        # pick a random airline
        callsign = random.choice(airlines).get("ICAO")
    shouldChange = False # Reset the variable so it can be used for the fltnmbr
    if fltnmb:
        # pass it through a regex for flight numbers
        nmbr = re.search(r"^[1-9][0-9]{0,3}[A-Z]?$", fltnmb)
        if nmbr:  # A match was found
            callsign = callsign + fltnmb
        else:
            shouldChange = True
    if not fltnmb or shouldChange:
        nmbr = random.randint(0, 9999)
        strnmbr = str(nmbr)
        done = False
        for number in strnmbr:
            if number == "0":
                number = random.choice(alphabet)
                done = True
                callsign = callsign + number
            elif not done:
                callsign = callsign + number
        # TODO - Differentiate between America (15k, 2K etc.. and 1534)
    return callsign

def generateAirport(icao: Optional[str] = None) -> str:
    """
    Checks that the airport exists, if it doesn't, a random ICAO will be retruned.
    If an IATA code is provided, an IACO one will be returned (EG LHR provided EGLL returned)

    Returns:
    - Bool if unsuccesful (for whatever reason)
    - The ICAO code of the airport specified if not
    """
    rand = False
    with open("/home/sam/Code/papl-cw/src/models/airports.csv",newline='') as csvfile:
        if not icao:
            rand = True
        if len(icao) != 3 and len(icao) != 4: # Get a random airport
            print(len(icao))
            rand = True
        reader = csv.reader(csvfile,delimiter=" ")

        choice = random.randint(0, 4240)
        index = 0
        airfield = "EGLL" # Failsafe in case the airport wasn't found

        # ICAO is the 0th item, IATA is the 1st (0b index)
        for row in reader:
            if rand == True:
                if index -1 != choice:
                    continue
            line = row[0].split(',')
            iata = line[1]
            gps = line[0]
            if iata == icao or gps == icao:
                return gps
            if index - 1 == choice:
                airfield = gps
            index = index + 1

        return airfield
        
        # The airport wasn't found

def generateETE(ete: Optional[str] = None) -> str:
    """
    Checks that the ETE provided is valid and if not generates one
    """
    if ete != None:
        while len(ete) != 4:
            ete = "0" + ete
        match = re.search(r"^(?!0000)[0-9]{4}$",ete)
        if match:
            return ete
    ete = str(random.randint(0, 999))
    while len(ete) != 4:
        ete = "0" + ete
    return ete