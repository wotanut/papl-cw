import os

from dotenv import load_dotenv
from sqlmodel import Session

from models.flight import Flight

from ..db import engine, init_db, resetDB, select


class TestDB:
    flights = [
        Flight(
            id="AAL1254",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="0015",
        ),
        Flight(
            id="BAW15K",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="0015",
        ),
        Flight(
            id="VIR27L",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="0015",
        ),
    ]

    def test_database_url(self):
        """
        This test is important because if it fails you've done something wrong

        Checks to see if the database URL is none, if it is it will fail and then subsequent tests will fail
        """
        load_dotenv()
        assert os.environ.get("DATABASE_URL") is not None

    def test_insert(self):
        init_db()
        with Session(engine) as session:
            resetDB(session)
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
                assert flightResult is None
                assert flightResult is None
