#!/bin/bash

# Clean up any existing artifacts
rm -rf tempdir
docker stop samplerunning 2>/dev/null || true
docker rm samplerunning 2>/dev/null || true

# Create fresh directories
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# Copy application files
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Create Dockerfile
cat > tempdir/Dockerfile << 'DOCKERFILE'
FROM python
RUN pip install flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD python3 /home/myapp/sample_app.py
DOCKERFILE

# Build and run the application
cd tempdir
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a
