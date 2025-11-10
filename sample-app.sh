#!/bin/bash
# Exit immediately if any command fails
set -e

echo "--- Cleaning up old containers ---"
docker stop samplerunning || true
docker rm samplerunning || true

echo "--- Preparing build directory ---"
rm -rf tempdir
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

echo "--- Creating Dockerfile ---"
# Create the Dockerfile
echo "FROM python:3.10-slim" >> tempdir/Dockerfile
# --- Added --no-rich to disable the progress bar that spawns a thread ---
echo "RUN pip install --no-cache-dir --no-rich flask" >> tempdir/Dockerfile
echo "COPY  ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY  ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY  sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

cd tempdir

echo "--- Building Docker image ---"
docker build -t sampleapp .

echo "--- Running Docker container ---"
docker run -t -d -p 5050:5050 --name samplerunning sampleapp

echo "--- Listing containers ---"
docker ps -a