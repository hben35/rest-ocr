# Use a base image that includes Python and Tesseract
FROM python:3.9-slim

# Switch to root user
USER root

# Update packages and install dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directory for Tesseract language files
RUN mkdir -p /mnt/data/tesseract/tessdata

# Download language files
RUN wget -O /mnt/data/tesseract/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata_fast/raw/refs/heads/main/fra.traineddata

# Set environment variable
ENV TESSDATA_PREFIX=/mnt/data/tesseract/tessdata/

# Install Flask, pytesseract, and requests
RUN pip3 install flask pytesseract requests

# Add Flask application to the image
COPY app.py /app.py

# Expose port 5000 for the REST API
EXPOSE 5000
RUN tesseract --version
# Define the command to run the application
CMD ["python3", "./app.py"]
