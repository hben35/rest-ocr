from flask import Flask, request, jsonify
import pytesseract
from PIL import Image
import io
import base64
import os

# Créez une instance Flask
app = Flask(__name__)

# Assurez-vous que Tesseract peut trouver les données de langue
pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'  # Chemin vers le binaire de Tesseract

@app.route('/ocr', methods=['POST'])
def ocr():
    # Récupérer l'image depuis la requête
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    file = request.files['image']
    
    if file.filename == '':
        return jsonify({'error': 'No image selected'}), 400

    try:
        # Ouvrir l'image
        img = Image.open(file.stream)
        # Appliquer l'OCR à l'image
        text = pytesseract.image_to_string(img)
        return jsonify({'text': text})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
