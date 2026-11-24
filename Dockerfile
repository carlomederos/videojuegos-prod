# imagen ligera de python; 3.12 porque SQLAlchemy 2.1 ya no soporta python 3.9
FROM python:3.12-slim

# sin archivos .pyc y con logs sin buffer para verlos en docker logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# primero solo requirements para aprovechar la cache de capas de docker
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# la app no corre como root
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

ENV FLASK_ENV=production \
    DATABASE_URL=mysql+pymysql://user:pwd@db/videojuegos

EXPOSE 8000

# --preload crea las tablas una sola vez antes de levantar los workers
CMD ["gunicorn", "-b", "0.0.0.0:8000", "--workers", "3", "--preload", "--access-logfile", "-", "app:app"]
