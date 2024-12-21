# This file tests the endpoint /init/request
import re

import pytest
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


class TestValid:
    def test_no_adc(self):
        with Session(engine) as session:
            flight = {
                "id": "BAW15K",
                "dep": "EGLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }
            resetDB(session)
            response = client.post("/init/request", json=flight)
            assert response.status_code == 200
            # Should've been inserted

            statement = select(Flight)
            results = session.exec(statement)
            assert results is not None
            index = 0
            # Make sure something got inserted. Will check format shortly
            for result in results:
                format_checker(result)
                # TODO- Check the returned json as well
                index += 1
            assert index == 1
            resetDB(session)

    # Test ADC
    def test_adc(self):
        # FIXME - Work ADC into this
        with Session(engine) as session:
            flight = {
                "id": "BAW15K",
                "dep": "EGLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }
            resetDB(session)
            response = client.post("/init/request", json=flight)
            assert response.status_code == 200
            # Should've been inserted

            statement = select(Flight)
            results = session.exec(statement)
            assert results is not None
            index = 0
            # Make sure something got inserted. Will check format shortly
            for result in results:
                format_checker(result)
                # TODO- Check the returned json as well
                index += 1
            assert index == 1
            resetDB(session)


class TestInvalid:
    def test_no_flight(self):
        with Session(engine) as session:
            resetDB(session)
            response = client.post(
                "/init/request",
            )
            assert response.status_code == 200
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

    def test_bad_stage(self):
        with Session(engine) as session:
            resetDB(session)
            invalid_flight = {
                "id": "BAW15K",
                "stage": "e",
                "dep": "EGLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }  # Invalid because stage can not be e
            with pytest.raises(Exception):
                response = client.post(
                    "/init/request",
                    json=invalid_flight,
                )
                assert response.status_code == 400

                # Should'nt have been inserted

                statement = select(Flight).where(Flight.id == invalid_flight["id"])
                results = session.exec(statement)
                assert results is None

    def test_no_dep(self):
        with Session(engine) as session:
            resetDB(session)
            invalid_flight = {
                "id": "BAW15K",
                "stage": "e",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }  # Invalid because no departure
            with pytest.raises(Exception):
                response = client.post(
                    "/init/request",
                    json=invalid_flight,
                )
                assert response.status_code == 400

                # Should'nt have been inserted

                statement = select(Flight).where(Flight.id == invalid_flight["id"])
                results = session.exec(statement)
                assert results is None

    def test_malformatted_dep(self):
        with Session(engine) as session:
            resetDB(session)
            invalid_flight = {
                "id": "BAW15K",
                "stage": "e",
                "dep": "EGLLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }  # One extra L on departure
            with pytest.raises(Exception):
                response = client.post(
                    "/init/request",
                    json=invalid_flight,
                )
                assert response.status_code == 400

                # Should'nt have been inserted

                statement = select(Flight).where(Flight.id == invalid_flight["id"])
                results = session.exec(statement)
                assert results is None

    def test_lowercase_dep(self):
        with Session(engine) as session:
            resetDB(session)
            valid_flight = {
                "id": "BAW15K",
                "stage": FlightStage.PreDep.value,
                "dep": "egll",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015",
            }  # One extra L on departure
            response = client.post(
                "/init/request",
                json=valid_flight,
            )
            assert response.status_code == 200

            statement = select(Flight).where(Flight.id == valid_flight["id"])
            results = session.exec(statement)
            index = 0
            for result in results:
                assert result.id == valid_flight["id"]
                assert result.stage.value == valid_flight["stage"]
                assert (
                    result.dep == valid_flight["dep"].upper()
                )  # NOTE - Not testing for upper here because we're directly checking the DB
                # If / when I make an endpoint for it I WILL just call that and that should return upper
                assert result.dest == valid_flight["dest"]
                assert result.altn == valid_flight["altn"]
                assert result.ete == valid_flight["ete"]
                index += 1
            assert index == 1
            resetDB(session)

    def test_malformed_ete(self):
        with Session(engine) as session:
            resetDB(session)
            invalid_flight = {
                "id": "BAW15K",
                "dep": "EGLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "0015A",
            }  # Malformed ETE
            with pytest.raises(Exception):
                response = client.post(
                    "/init/request",
                    json=invalid_flight,
                )
                assert response.status_code == 400

                # Should'nt have been inserted

                # statement = select(Flight).where(Flight.id == invalid_flight["id"])
                # results = session.exec(statement)
                # assert results is None

    def test_negative_ete(self):
        with Session(engine) as session:
            resetDB(session)
            invalid_flight = {
                "id": "BAW15K",
                "stage": "e",
                "dep": "EGLL",
                "dest": "KJFK",
                "altn": "KBOS",
                "ete": "-0115",
            }  # Malformed ETE once again
            with pytest.raises(Exception):
                response = client.post(
                    "/init/request",
                    json=invalid_flight,
                )
                assert response.status_code == 400

                # Should'nt have been inserted

                statement = select(Flight).where(Flight.id == invalid_flight["id"])
                results = session.exec(statement)
                assert results is None
