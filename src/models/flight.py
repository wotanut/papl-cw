import json
import os
import random
import re
from typing import Optional

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
    id: str = Field(primary_key=True, unique=True,max_length=7,min_length=7 ,description="Can be a string of 7 digits as all callsigns are unique") #NOTE - ID can be a string as all callsigns will be unique
    stage: FlightStage = Field(sa_column=Column(Enum(FlightStage)), default=FlightStage.PreDep.value)
    dep: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    dest: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    altn: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    ete: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[0-9]{4}$"))
    ADCReq: bool | None = Field(default=None, nullable=True) # ADC is a type of message
    #TODO: FK to Messages and FlightAware

class __Flight(Flight):
    id: str
    filedFL: str = Field(max_length=5, sa_column_args=CheckConstraint(r"^FL[0-9]{3}%"))
    currentFL: str = Field(max_length=5, sa_column_args=CheckConstraint(r"^FL[1-9]{3}%"))
    #NOTE - This would be where FL's will be stored as well as messages so that they're not accesible over the API and can't be accessed from initial set
    #TODO: Add filedFL and currentFL

def getICAO(flight: Flight):
    return flight.id[:3] # :3

def generateCallsign(airline: Optional[str], fltnmb: Optional[str]):
    """
    Generates a callsign from either a given airline icao or a flight number. If neither are provided generates one for both.
    
    WARNING:
        Does not check to see if the callsign is in use

    Returns:
    - Callsign: Str - A callsign for use
    """
    # Won't use a regex here so that someoen doesn't try and use XK234 as a valid callsign
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    airlines :dict = {}
    callsign = ""
    with open('../airlines.json') as f:
        airlines = json.load(f)
        f.close()
    if airline:
        # Check to see if it's a valid airline
        if airline in airlines:
            shouldChange = False
            for key, value in airlines.items():
                if airline == value and key == "IATA":
                    # Change it to be an ICAO code instead
                    shouldChange =  not shouldChange
                elif shouldChange == True or airline == value and key == "ICAO":
                    callsign = callsign + key.upper() # Adds the airline to the callsign
    else:
        # pick a random airline
        callsign = random.choice(list(airlines.values()))
    if fltnmb:
        # pass it through a regex for flight numbers
        nmbr = re.search(r"^[1-9][0-9]{0,3}[A-Z]?$", fltnmb)
        if nmbr: # A match was found
            callsign = callsign + fltnmb
    else:
        nmbr = random.choice(0,9999)
        strnmbr = str(nmbr).split(0)
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

def generateAirport(icao: Optional[str]) -> str:
    """
    Checks that the airport exists, if it doesn't, a random ICAO will be retruned.
    If an IATA code is provided, an IACO one will be returned (EG LHR provided EGLL returned)
    
    Returns:
    - Bool if unsuccesful (for whatever reason)
    - The ICAO code of the airport specified if not
    """
    invalid = False
    if len(icao) == 3:
        api_url = f'https://api.api-ninjas.com/v1/airports?iata={icao}'
    elif len(icao) == 4:
        api_url = f'https://api.api-ninjas.com/v1/airports?iaco={icao}'
    else:
        invalid = True
    response = requests.get(api_url, headers={'X-Api-Key': os.environ.get("APININJAS")})
    
    if response.ok and not invalid:
        return response.json()['icao'].upper()

    # Generate a random airport
    response = requests.get('https://ourairports.com/random') # Gets a random airport
    if response.ok:
        next = False
        for line in response.text:
            if "GPS Code" in line:
                next = True
            if next:
                icao = line.split(">")[1].split('<')[0] # searching through pure html, just need to get an attribute
                return icao

def generateETE(ete: Optional[str]) -> str:
    """
    Checks that the ETE provided is valid and if not generates one
    """
    if ete:
        while len(ete) != 4:
            ete = "0" + ete
        match = re.search(r"^(?!0000)[0-9]{4}$")
        if match:
            return ete
    ete = str(random.randint(0,999))
    while len(ete) != 4:
            ete = "0" + ete
    return ete