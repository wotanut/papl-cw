import os

from dotenv import load_dotenv
from sqlmodel import Session, SQLModel, create_engine, select

from models.flight import Flight

load_dotenv()
DATABASE_URL = os.environ.get("DATABASE_URL")

engine = create_engine(DATABASE_URL, echo=True)
# WARNING: Remove before committing

def init_db():
    SQLModel.metadata.create_all(engine)


def get_session():
    with Session(engine) as session:
        yield session


def resetDB(session: Session):
    """
    Reset's the database to it's initial form

    This is primarily a debug tool but could prove useful for an ADMIN ONLY API endpoint to allow admins to delete everything from the database and reinitialise it
    """
    # NOTE - Whenever you add more tables, they needed to be added here in order to properly reset the database
    with session:
        flights = select(Flight)  # Selects all the flights
        results = session.exec(flights)
        for result in results:
            session.delete(result)
        session.commit()
        session.close()

    init_db()
