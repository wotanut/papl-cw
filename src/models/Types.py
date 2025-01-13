import enum


class FlightStage(
    enum.Enum
):  # NOTE - Required to use sqlmodel.Enum for the column type
    PreDep = "PreDep"
    Departing = "Departing"
    Level = "Level"
    Cruise = "Cruise"
    Climb = "Climb"
    Desc = "Desc"
    Arrived = "Arrived"


class MsgType(enum.Enum):
    ATC = "ATC"
    Comp = "Company"
