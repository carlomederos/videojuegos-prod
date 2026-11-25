FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

ENV FLASK_ENV=production \
    DATABASE_URL=mysql+pymysql://user:pwd@db/videojuegos

EXPOSE 8000

CMD ["gunicorn", "-b", "0.0.0.0:8000", "--workers", "3", "--preload", "--access-logfile", "-", "app:app"]
