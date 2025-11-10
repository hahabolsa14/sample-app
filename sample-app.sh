#!/bin/bash

# Clean up old tempdir
rm -rf tempdir

# Create directories
mkdir -p tempdir/templates tempdir/static

# Copy files
cp sample_app.py tempdir/
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/

# Create Dockerfile
cat > tempdir/Dockerfile << 'EOF'
FROM python:3.10-slim

WORKDIR /home/myapp

# Copy files
COPY ./static ./static/
COPY ./templates ./templates/
COPY sample_app.py .

EXPOSE 5050

CMD ["python3", "sample_app.py"]
EOF

cd tempdir

# Remove old container if exists
docker rm -f samplerunning 2>/dev/null

# Build and run container
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp

# Show running containers
docker ps -a
