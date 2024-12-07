from ..db import *
from sqlmodel import create_engine, SQLModel, Session, exists, func
import os
from fastapi import Depends
from typing import Annotated, Union
import pytest
from time import sleep

from models.flight import Flight

class TestDB:
    flights = [
        Flight(id="AAL1254", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
        Flight(id="BAW15K", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
        Flight(id="VIR27L", stage="Departing",dep="EGLL", dest="KJFK",altn="CYYZ",ete="0015"),
    ]


    def test_insert(self):
        init_db()
        # resetDB()
        with Session(engine) as session:
            for flight in self.flights:
                session.add(flight)
            session.commit()

            # Verify that all the flights were committed to the database
            for flight in self.flights:
                flightDB = session.get(Flight, flight.id)
                assert flightDB.id == flight.id
                assert flightDB.stage == flight.stage
                assert flightDB.dep == flight.dep
                assert flightDB.dest == flight.dest
                assert flightDB.altn == flight.altn
                assert flightDB.ete == flight.ete

    @pytest.mark.dependency(depends=['test_insert']) # Forces the inserts to be done first
    async def test_reset(self):
        with Session(engine) as session:

            statement = select(Flight)
            results = session.exec(statement)

            # NOTE: This will only work if the flights are ordered by the ID above
            index = 0
            for result in results:
                assert result.id == self.flights[index].id
                index += 1

            resetDB(session)

            for flight in self.flights:
                statement = select(Flight).where(Flight.id == flight.id)
                results = session.exec(statement)
                flightResult = results.first()
                assert flightResult == None
