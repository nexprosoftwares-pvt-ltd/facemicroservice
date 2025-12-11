FROM python:3.9-slim

# System deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake \
    libopenblas-dev liblapack-dev \
    libx11-6 libgtk2.0-dev libjpeg-dev \
    wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip

# --- Install precompiled dlib wheel (NO build, instant install) ---
RUN wget https://github.com/datamagic2020/dlib-prebuilt/releases/download/v19.24.0/dlib-19.24.0-cp39-cp39-linux_x86_64.whl \
    && pip install dlib-19.24.0-cp39-cp39-linux_x86_64.whl

# Install face-recognition & opencv (these DO NOT compile)
RUN pip install \
    face-recognition==1.3.0 \
    opencv-python-headless

# Install remaining dependencies
RUN pip install -r requirements.txt

COPY . .

ENV PORT=8080
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
