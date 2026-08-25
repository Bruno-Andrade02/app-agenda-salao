from fastapi import FastAPI
from sqlalchemy import text
from database import engine

app = FastAPI(title="Agenda Salão API")

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/health/db")
def health_check_db():
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
    return {"status": "conectado ao banco"}