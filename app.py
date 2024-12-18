from flask import Flask, request, jsonify
from PIL import Image
import pytesseract
import requests
from io import BytesIO
import base64

app = Flask(__name__)

@app.route('/ocr', methods=['POST'])
def ocr_image():
    if 'img_url' in request.json:
        img_url = request.json['img_url']
        img = Image.open(requests.get(img_url, stream=True).raw)
    elif 'img_base64' in request.json:
        img_base64 = request.json['img_base64']
        img_data = base64.b64decode(img_base64)
        img = Image.open(BytesIO(img_data))
    else:
        return jsonify({"error": "No image provided"}), 400

    # OCR processing
    text = pytesseract.image_to_string(img, lang='fra')  # OCR in French
    return jsonify({"text": text})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
