from sqlmodel import (CheckConstraint, Column, Enum, Field, Relationship,
                      Session, SQLModel, create_engine, select)

from .flightStage import FlightStage


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