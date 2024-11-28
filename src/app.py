from fastapi import FastAPI
import requests

api = FastAPI()

@app.get("/")
def home():
    return {"hello" : "world"}

@app.get("/metar/{icao}")
def metar(icao: str):
    """
    Get's the metar from Vatsim but the metar should match the metar from real life
    https://vatsim.dev/services/apis#metar-api
    """
    req = requests.get("https://metar.vatsim.net/{icao}")
    return {"metar" : req.text}

# @app.get("/wx/{icao}")
# def wx(icao: str):
#     """
#     Get's the weather from Vatsim
#     """

@app.get("atis/{icao}")
def atis(icao: str):
    """
    Generates a random ATIS, I can't yet find an api to get an atis
    """
    return {"atis" : "LONDON HEATHROW AIRPORT INFORMATION A...  1420Z...  WIND 110 AT 7 KNOTS...  VISIBILITY 7 KILOMETERS...  CEILING 1300 OVERCAST...  TEMPERATURE 11, DEWPOINT 8...  QNH 1029, ALTIMETER 3039...  LANDING RUNWAY 27L...  DEPARTING RUNWAY 27R...  ADVISE CONTROLLER ON INITIAL CONTACT THAT YOU HAVE INFORMATION A... "}