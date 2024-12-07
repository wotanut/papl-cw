from fastapi.testclient import TestClient
from sqlmodel import Session, select

from ..app import app
from ..db import *
from ..models.flight import FlightStage

client = TestClient(app)

def test_good_flight_init():
    with Session(engine) as session:
        resetDB(session)
        flight ={
                "id" : "BAW15K",
                "stage" : FlightStage.PreDep.value,
                "dep" : "EGLL",
                "dest" : "KJFK",
                "altn" : "KBOS",
                "ete" : "0015"
            }
        response = client.post(
            '/flight/init', 
            json=flight,
        )
        assert response.status_code == 200
        # Should've been inserted

        statement = select(Flight).where(Flight.id == flight["id"])
        results = session.exec(statement)
        index = 0
        for result in results:
            assert result.id == flight["id"]
            assert result.stage == flight["stage"]
            assert result.dep == flight["dep"]
            assert result.dest == flight["dest"]
            assert result.altn == flight["altn"]
            assert result.ete == flight["ete"]
            index += 1
        assert index == 1
        resetDB(session)



def test_bad_flight_init():
    with Session(engine) as session:
        resetDB(session)
        flight ={
                "id" : "BAW15K",
                "stage" : "e",
                "dep" : "EGLL",
                "dest" : "KJFK",
                "altn" : "KBOS",
                "ete" : "0015"
            }# Invalid because stage can not be e
        response = client.post(
            '/flight/init', 
            json=flight,
        )
        assert response.status_code == 200
        # Should'nt have been inserted

        statement = select(Flight).where(Flight.id == flight["id"])
        results = session.exec(statement)
        assert results == None