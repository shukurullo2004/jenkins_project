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

# Wait for container to fully start
sleep 10

# Verify container is running and responding
echo "=== Container Status ==="
docker ps | grep samplerunning

echo "=== Testing App Response ==="
# Test the app from build job itself
curl -f http://localhost:5050/ || echo "App not responding yet"

echo "=== Build Complete ==="
