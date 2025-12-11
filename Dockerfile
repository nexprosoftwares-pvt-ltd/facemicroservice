# --- Base Image (Debian with Python) ---
FROM python:3.9-slim

# --- Install OS-level deps for dlib, face_recognition, opencv ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake \
    libopenblas-dev liblapack-dev libatlas-base-dev \
    libx11-6 libgtk2.0-dev libjpeg-dev \
    wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# --- Copy requirements early for caching ---
COPY requirements.txt .

# --- Install optimized packages ---
RUN pip install --upgrade pip

# Install prebuilt wheels to avoid compilation (instant install)
RUN pip install \
    dlib==19.24.4 \
    face-recognition==1.3.0 \
    face-recognition-models==0.3.0 \
    opencv-python-headless

# Install all other Python packages
RUN pip install -r requirements.txt

# --- Copy the rest of your app ---
COPY . .

# Expose the port Flask uses
ENV PORT=8080
EXPOSE 8080

# Run using gunicorn (production)
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
