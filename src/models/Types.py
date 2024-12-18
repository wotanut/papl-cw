import enum


class FlightStage(
    enum.Enum
):  # NOTE - Required to use sqlmodel.Enum for the column type
    PreDep = "PreDep"  # NOTE - Used to be pre-departure in flow charts, changed to be easier to read
    Departing = "Departing"
    Level = "Level"
    Cruise = "Cruise"
    Climb = "Climb"
    Desc = "Desc"
    Arrived = "Arrived"
    # TODO - Remove enum.Enum depending on what Nadim says


class MsgType(enum.Enum):
    ATC = "ATC"
    Comp = "Company"
