from sqlmodel import Field, Session, SQLModel, create_engine, select

class Flight(SQLModel, table=True):
    id: int = Field(primary_key=True, unique=True)
    stage: str = Field(default="Departing") # TODO Limit to list of options
    dep: str = Field() # TODO limit to 4 digits
    dest: str = Field() # TODO limit to 4 digits
    altn: str = Field()# TODO limit to 4 digits
    ete: str = Field() # TODO force int in format xxxx