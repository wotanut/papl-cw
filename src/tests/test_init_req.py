# This file tests the endpoint /init/request
import re

from fastapi.testclient import TestClient
from sqlmodel import Session, select

from ..app import app
from ..db import engine, resetDB
from ..models.flight import Flight
from ..models.Types import FlightStage

client = TestClient(app)


def format_checker(flight: Flight):
    """
    Checks that all of the flight values are correct

    FIXME - Make a function for flight generate too
    """
    assert (
        re.search(r"^[A-Z]{3}[1-9][0-9]{0,3}[A-Z]?$", flight.id) is not None
    )  # Callsign
    assert flight.stage.value == FlightStage.PreDep.value
    assert re.search(r"[A-Z]{4}", flight.dep) is not None
    assert re.search(r"[A-Z]{4}", flight.dest) is not None
    assert re.search(r"[A-Z]{4}", flight.altn) is not None
    assert re.search(r"^(?!0000)[0-9]{4}$", flight.ete) is not None


def test_no_flight():
    with Session(engine) as session:
        resetDB(session)
        response = client.post(
            "/init/request",
        )
        assert response.status_code == 200
        assert response.json()["success"] is True
        # Should've been inserted

        statement = select(Flight)
        results = session.exec(statement)
        assert results is not None
        index = 0
        # Make sure something got inserted. Will check format shortly
        for result in results:
            format_checker(result)
            index += 1
        assert index == 1
        resetDB(session)
