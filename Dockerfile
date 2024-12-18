# Use the official Tesseract OCR image
FROM jitesoft/tesseract-ocr:4.1.1

# Switch to root user
USER root

# Update packages and install dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directory for Tesseract language files
RUN mkdir -p /mnt/data/tesseract/tessdata

# Download language files
RUN wget -O /mnt/data/tesseract/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/eng.traineddata && \
    wget -O /mnt/data/tesseract/tessdata/fra.traineddata https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/fra.traineddata

# Set environment variable
ENV TESSDATA_PREFIX=/mnt/data/tesseract/tessdata/

# Install Python packages
RUN pip3 install flask pytesseract

# Add Flask application to the image
COPY app.py /app.py

# Expose port 5000 for the REST API
EXPOSE 5000

# Define the command to run the application
CMD ["python3", "./app.py"]
