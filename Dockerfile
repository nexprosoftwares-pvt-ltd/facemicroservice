FROM python:3.9-slim

# install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake \
    libopenblas-dev liblapack-dev libatlas-base-dev \
    libx11-6 libgtk2.0-dev libjpeg-dev \
    wget curl unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# upgrade pip
RUN pip install --upgrade pip

# install prebuilt wheels (skips compilation)
RUN pip install \
    dlib==19.24.4 \
    face-recognition==1.3.0 \
    face-recognition-models==0.3.0 \
    opencv-python-headless

# install normal dependencies
RUN pip install -r requirements.txt

# copy app code
COPY . .

ENV PORT 8080
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
