FROM python:3.9-slim

# Install system packages (compatible with Debian Trixie)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake \
    libopenblas-dev liblapack-dev \
    libx11-6 libgtk2.0-dev libjpeg-dev \
    wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first
COPY requirements.txt .

RUN pip install --upgrade pip

# Install prebuilt wheels (NO COMPILATION)
RUN pip install \
    dlib==19.24.4 \
    face-recognition==1.3.0 \
    face-recognition-models==0.3.0 \
    opencv-python-headless

# Install remaining Python packages
RUN pip install -r requirements.txt

# Copy app code
COPY . .

ENV PORT 8080
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
