# Utiliser l'image Docker officielle de Tesseract OCR compatible ARM
FROM jitesoft/tesseract-ocr:latest

# Installer Python et Flask
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer Flask et pytesseract
RUN pip3 install flask pytesseract

# Ajouter l'application Flask
COPY app.py /app.py

# Exposer le port 5000 pour l'API REST
EXPOSE 5000

# Commande pour démarrer l'application Flask
CMD ["python3", "app.py"]
