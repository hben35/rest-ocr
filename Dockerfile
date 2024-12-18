# Utiliser l'image Docker officielle de Tesseract OCR compatible ARM
FROM jitesoft/tesseract-ocr:latest

# Passer à l'utilisateur root pour installer des paquets
USER root

# Mettre à jour les paquets et installer Python, Flask, et wget
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Créer le répertoire pour les fichiers de langue Tesseract
RUN mkdir -p /mnt/data/tesseract/tessdata

# Télécharger les fichiers de langue (anglais et français) depuis un autre serveur
RUN wget -O /mnt/data/tesseract/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/eng.traineddata
RUN wget -O /mnt/data/tesseract/tessdata/fra.traineddata https://github.com/tesseract-ocr/tessdata/raw/refs/heads/main/fra.traineddata

# Définir la variable d'environnement TESSDATA_PREFIX
ENV TESSDATA_PREFIX=/mnt/data/tesseract/tessdata/
RUN tesseract --version

# Installer Flask et pytesseract
RUN pip3 install flask pytesseract

# Ajouter l'application Flask dans l'image
COPY app.py /app.py

# Exposer le port 5000 pour l'API REST
EXPOSE 5000

# Commande pour démarrer l'application Flask
CMD ["python3", "./app.py"]
