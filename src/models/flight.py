from sqlmodel import Field, Session, SQLModel, create_engine, select, Column, Enum, CheckConstraint
from .flightStage import FlightStage

class Flight(SQLModel, table=True):
    """
    The Flight model. Some important information

    Parameters
    ---
    ID: Must be exactly 7 characters with at least the first 3 being an ICAO code
    stage: A value from FlightStage, default's to PreDep
    

    See More
    ---

    """
    id: str = Field(primary_key=True, unique=True,max_length=7,min_length=7 ,description="Can be a string of 7 digits as all callsigns are unique") #NOTE - ID can be a string as all callsigns will be unique
    stage: FlightStage = Field(sa_column=Column(Enum(FlightStage)), default="PreDep")
    dep: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    dest: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    altn: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[A-Z]{4}$"))
    ete: str = Field(max_length=4,min_length=4,nullable=False,sa_column_args=CheckConstraint(r"^[0-9]{4}$"))
    #TODO: FK to Messages and FlightAware
    #TODO: ADC REQ and ADC

    