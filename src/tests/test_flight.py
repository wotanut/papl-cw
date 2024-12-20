import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, select

from ..app import app
from ..db import engine, resetDB
from ..models.flight import Flight
from ..models.Types import FlightStage

client = TestClient(app)


def test_good_flight_init():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": FlightStage.PreDep.value,
            "dep": "EGLL",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015",
        }
        response = client.post(
            "/flight/init",
            json=flight,
        )
        assert response.status_code == 200
        # Should've been inserted

        statement = select(Flight).where(Flight.id == flight["id"])
        results = session.exec(statement)
        index = 0
        for result in results:
            assert result.id == flight["id"]
            assert result.stage.value == flight["stage"]
            assert result.dep == flight["dep"]
            assert result.dest == flight["dest"]
            assert result.altn == flight["altn"]
            assert result.ete == flight["ete"]
            index += 1
        assert index == 1
        resetDB(session)


def test_bad_stage():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": "e",
            "dep": "EGLL",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015",
        }  # Invalid because stage can not be e
        with pytest.raises(Exception):
            response = client.post(
                "/flight/init",
                json=flight,
            )
            assert response.status_code == 400

            # Should'nt have been inserted

            statement = select(Flight).where(Flight.id == flight["id"])
            results = session.exec(statement)
            assert results is None


def test_no_dep():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": "e",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015",
        }  # Invalid because no departure
        with pytest.raises(Exception):
            response = client.post(
                "/flight/init",
                json=flight,
            )
            assert response.status_code == 400

            # Should'nt have been inserted

            statement = select(Flight).where(Flight.id == flight["id"])
            results = session.exec(statement)
            assert results is None


def test_malformatted_dep():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": "e",
            "dep": "EGLLL",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015",
        }  # One extra L on departure
        with pytest.raises(Exception):
            response = client.post(
                "/flight/init",
                json=flight,
            )
            assert response.status_code == 400

            # Should'nt have been inserted

            statement = select(Flight).where(Flight.id == flight["id"])
            results = session.exec(statement)
            assert results is None


def test_lowercase_dep():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": FlightStage.PreDep.value,
            "dep": "egll",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015",
        }  # One extra L on departure
        response = client.post(
            "/flight/init",
            json=flight,
        )
        assert response.status_code == 200

        statement = select(Flight).where(Flight.id == flight["id"])
        results = session.exec(statement)
        index = 0
        for result in results:
            assert result.id == flight["id"]
            assert result.stage.value == flight["stage"]
            assert (
                result.dep == flight["dep"]
            )  # NOTE - Not testing for upper here because we're directly checking the DB
            # If / when I make an endpoint for it I WILL just call that and that should return upper
            assert result.dest == flight["dest"]
            assert result.altn == flight["altn"]
            assert result.ete == flight["ete"]
            index += 1
        assert index == 1
        resetDB(session)


def test_malformed_ete():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": "e",
            "dep": "EGLLL",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "0015A",
        }  # One extra L on departure
        with pytest.raises(Exception):
            response = client.post(
                "/flight/init",
                json=flight,
            )
            assert response.status_code == 400

            # Should'nt have been inserted

            statement = select(Flight).where(Flight.id == flight["id"])
            results = session.exec(statement)
            assert results is None


def test_negative_ete():
    with Session(engine) as session:
        resetDB(session)
        flight = {
            "id": "BAW15K",
            "stage": "e",
            "dep": "EGLLL",
            "dest": "KJFK",
            "altn": "KBOS",
            "ete": "-0115",
        }  # One extra L on departure
        with pytest.raises(Exception):
            response = client.post(
                "/flight/init",
                json=flight,
            )
            assert response.status_code == 400

            # Should'nt have been inserted

            statement = select(Flight).where(Flight.id == flight["id"])
            results = session.exec(statement)
            assert results is None
