from flask import Flask, request, jsonify
import pytesseract
from PIL import Image
import io
import base64

app = Flask(__name__)

# Configurer le chemin de Tesseract (si nécessaire)
pytesseract.pytesseract.tesseract_cmd = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"  # Assurez-vous que cela est correct dans votre conteneur

@app.route('/ocr', methods=['POST'])
def ocr():
    data = request.get_json()

    # Vérifiez si une URL d'image ou une chaîne base64 est fournie
    if 'img_url' in data:
        img_url = data['img_url']
        image = Image.open(requests.get(img_url, stream=True).raw)
    elif 'img_base64' in data:
        img_data = base64.b64decode(data['img_base64'])
        image = Image.open(io.BytesIO(img_data))
    else:
        return jsonify({'error': 'No image provided'}), 400

    # Utiliser pytesseract pour effectuer l'OCR
    text = pytesseract.image_to_string(image)

    return jsonify({'text': text})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
