from fastapi.testclient import TestClient

from ..app import app

client = TestClient(app)

def checkInserted(json, url:str = "/"):
    response = client.get(url)
    assert response.json() == json
    assert response.status_code == 200

# def test_table_exists():


def test_good_flight_init():
    flight ={
            "id" : "BAW15K",
            "stage" : "departing",
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
    checkInserted(flight,"/get/flight")

def test_bad_flight_init():
    response = client.post(
        '/flight/init', 
        json={
            "id" : "BAW15K",
            "stage" : "e", 
            "dep" : "EGLL",
            "dest" : "KJFK",
            "altn" : "KBOS",
            "ete" : "0015"
        },
    ) # INVALID because stage can not be e
    assert response.status_code == 200