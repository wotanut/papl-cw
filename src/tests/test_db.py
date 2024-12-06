from ..db import *
from sqlmodel import create_engine, SQLModel, Session, exists
import os
from fastapi import Depends
from typing import Annotated, Union
import pytest

from models.flight import Flight

DATABASE_URL = os.environ.get("DATABASE_URL")

flights = [
    Flight(id="BAW15K", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
    Flight(id="VIR27L", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
    Flight(id="AAL1254", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
]

class TestDB:
    def test_insert(self):
        init_db()
        with Session(engine) as session:
            for flight in flights:
                session.add(flight)
            session.commit()

            # Verify that all the flights were committed to the database
            for flight in flights:
                flightDB = session.get(Flight, flight.id)
                assert flightDB.id == flight.id
        
        