from sqlmodel import Field, Session, SQLModel, create_engine, select, Column, Enum
import enum
from .flightStage import FlightStage

class Flight(SQLModel, table=True):
    id: str = Field(primary_key=True, unique=True) # ID can be a string as all callsigns will be unique
    stage: FlightStage = Field(sa_column=Column(Enum(FlightStage)), default="PreDep") # TODO Limit to list of options
    dep: str = Field() # TODO limit to 4 digits
    dest: str = Field() # TODO limit to 4 digits
    altn: str = Field()# TODO limit to 4 digits
    ete: str = Field() # TODO force int in format xxxx
    #TODO: FK to Messages and FlightAware
    #TODO: ADC REQ and ADC