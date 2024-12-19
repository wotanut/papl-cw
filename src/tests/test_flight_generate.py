# This file tests the functions in models/flight.py

import re

import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, select

from models.flight import (generateAirport, generateCallsign, generateETE,
                           getFltNmbr, getICAO)

from ..app import app
from ..db import *

client = TestClient(app)

flights = [
        Flight(
            id="AAL1254",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="15",
        ),
        Flight(
            id="BAW15K9",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="e",
        ),
        Flight(
            id="VIR27L",
            stage="Departing",
            dep="EGLL",
            dest="KJFK",
            altn="CYYZ",
            ete="8043",
        ),
    ]

class TestAirport:
    def test_valid_gener(self):
        """
        This test is important because if it fails you've done something wrong

        Checks to see if the database URL is none, if it is it will fail and then subsequent tests will fail
        """
        pass

class TestCallsign:
    def test_valid_callsign(self):
        """
        Gives it a valid callsign and checks to see if the outcome is valid
        """
        assert generateCallsign(getICAO(flights[0]),getFltNmbr(flights[0])) == flights[0].id # Valid callsign
        assert generateCallsign("AAL",getFltNmbr(flights[0])) == flights[0].id # Valid callsign but uses IATA insstead of ICAO
        assert re.search(rf"^[A-Z]{{3}}{getFltNmbr(flights[0])}$",generateCallsign("NMX",getFltNmbr(flights[0]))) != None # Invalid callsign, bad airline
        assert re.search(rf"^[A-Z]{{3}}{getFltNmbr(flights[0])}$",generateCallsign(fltnmb=getFltNmbr(flights[0]))) != None # Invalid callsign, no airline
        assert re.search(rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",generateCallsign(airline=getICAO(flights[0]),fltnmb="12345")) != None # Invalid callsign, longer than 4 digit flt nmbr
        assert re.search(rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",generateCallsign(airline=getICAO(flights[0]),fltnmb="123")) != None # Invalid callsign, shorter than 4 digit flt nmbr
        assert re.search(rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",generateCallsign(airline=getICAO(flights[0]))) != None # Invalid callsign, no flt nmbr
        assert re.search(rf"^[A-Z]{{3}}[1-9][0-9]{{0,3}}[A-Z]?$$",generateCallsign()) != None # Invalid callsign, no callsign
        # NOTE - Could make the above test case more accurate by searching for the returned callsign in the airlines.json file but too time consuming rn
        # Focus on the mvp first

class TestETE:
    def test_ete(self):
        assert generateETE(flights[0].ete) == "0015"
        assert generateETE(flights[0].ete) != "15" # This is what is passed in originally to flight 0

        
        assert generateETE(flights[1].ete) != "e" # This is what is passed in originally to flight 1
        assert re.search(r"^(?!0000)[0-9]{4}$",generateETE(flights[1].ete)) != None

        # Flight 2
        assert generateETE(flights[2].ete) == flights[2].ete # Shouldn't change

        # No ETE passed
        for i in range(0,100):
            assert re.search(r"^(?!0000)[0-9]{4}$",generateETE()) != None



class TestICAO:
    def test_valid_icao(self):
        """
        Tests that the icao works by passing in a valid flight number
        """
        assert getICAO(flights[0]) == "AAL"
        assert getICAO(flights[1]) == "BAW"
        assert getICAO(flights[2]) == "VIR"
        # TODO - Test for IATA (so AA as opposed to AAL)

    def test_valid_fltnmbr(self):
        """
        Tests that the icao works by passing in a valid flight number
        """
        assert getFltNmbr(flights[0]) == "1254"
        assert getFltNmbr(flights[2]) == "27L"