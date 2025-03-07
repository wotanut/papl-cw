# This file tests the functions in models/flight.py

import re

from models.flight import (
    generateAirport,
    generateCallsign,
    generateETE,
    getFltNmbr,
    getICAO,
)

from ..models.flight import Flight

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
    def test_airports(self):
        """
        Tests the generate airport function
        """
        assert generateAirport("EGLL") == "EGLL"  # Test airport does exist
        assert generateAirport("LHR") == "EGLL"  # Test IATA airport
        assert (
            re.search(r"[A-Z]{4}", generateAirport("KEGL")) is not None
        )  # Test airport does not exist
        assert (
            re.search(r"[A-Z]{4}", generateAirport("")) is not None
        )  # Test no airport provided

        # Test to see that it doesn't just generate heathrow with no provided data
        previous = []
        for i in range(0, 500):
            previous.append(generateAirport())
        assert previous.count("EGLL") != 500


class TestCallsign:
    def test_valid_callsign(self):
        """
        Gives it a valid callsign and checks to see if the outcome is valid
        """
        assert (
            generateCallsign(getICAO(flights[0]), getFltNmbr(flights[0]))
            == flights[0].id
        )  # Valid callsign
        assert (
            generateCallsign("AAL", getFltNmbr(flights[0])) == flights[0].id
        )  # Valid callsign but uses IATA insstead of ICAO
        assert (
            re.search(
                rf"^[A-Z]{{3}}{getFltNmbr(flights[0])}$",
                generateCallsign("NMX", getFltNmbr(flights[0])),
            )
            is not None
        )  # Invalid callsign, bad airline
        # FIXME - Test case randomly breaks
        assert (
            re.search(
                rf"^[A-Z]{{3}}{getFltNmbr(flights[0])}$",
                generateCallsign(fltnmb=getFltNmbr(flights[0])),
            )
            is not None
        )  # Invalid callsign, no airline
        assert (
            re.search(
                rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",
                generateCallsign(airline=getICAO(flights[0]), fltnmb="12345"),
            )
            is not None
        )  # Invalid callsign, longer than 4 digit flt nmbr
        assert (
            re.search(
                rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",
                generateCallsign(airline=getICAO(flights[0]), fltnmb="123"),
            )
            is not None
        )  # Invalid callsign, shorter than 4 digit flt nmbr
        assert (
            re.search(
                rf"^{getICAO(flights[0])}[1-9][0-9]{{0,3}}[A-Z]?$$",
                generateCallsign(airline=getICAO(flights[0])),
            )
            is not None
        )  # Invalid callsign, no flt nmbr
        assert (
            re.search(r"^[A-Z]{3}[1-9][0-9]{0,3}[A-Z]?$$", generateCallsign())
            is not None
        )  # Invalid callsign, no callsign
        # NOTE - Could make the above test case more accurate by searching for the returned callsign in the airlines.json file but too time consuming rn
        # Focus on the mvp first


class TestETE:
    """
    Test the function for generating ETE's
    """

    def test_ete(self):
        assert generateETE(flights[0].ete) == "0015"
        assert (
            generateETE(flights[0].ete) != "15"
        )  # This is what is passed in originally to flight 0

        assert (
            generateETE(flights[1].ete) != "e"
        )  # This is what is passed in originally to flight 1
        assert re.search(r"^(?!0000)[0-9]{4}$", generateETE(flights[1].ete)) is not None

        # Flight 2
        assert generateETE(flights[2].ete) == flights[2].ete  # Shouldn't change

        # No ETE passed
        for i in range(0, 100):
            assert re.search(r"^(?!0000)[0-9]{4}$", generateETE()) is not None


class TestICAO:
    """
    Test airline ICAO validation
    """

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
