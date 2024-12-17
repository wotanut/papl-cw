from typing import Literal, Optional, Union

from sqlmodel import CheckConstraint, Column, Enum, Field, SQLModel


class Message(SQLModel, table=True):
    """
    A message sent from a ground station to the aircraft


    Parameters
    ----------
    :type: Either ATC or Company. Company would appear on the ECAM but can be sent by any ground staiton.
    :sender: The station that sent it, for example LON_N_CTR, TELEX, BAWOPS, EZYOPS, etc..
    :content: The content of the message, for example "ADC Required, send an ADC when convenient via ADV menu."
    """
    id: Optional[int] = Field(default=None, primary_key=True, unique=True)
    type: Literal["ATC", "Company"] = Field(nullable=False)
    sender: str = Field(min_length=3,max_length=15) #NOTE - sender will appear as title for company msgs
    content: str = Field(max_length=70)
