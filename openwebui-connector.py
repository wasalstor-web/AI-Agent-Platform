from flask import Flask, request, jsonify
import logging

app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)

# Constants for authentication
JWT_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImIxYTVmNTlkLTdhYjYtNGFkMC1hYjBlLWE5MzQ1MzA2NmUyMyIsImV4cCI6MTc2MzM4MTYyN30.lb3G5Z9Wj8cFRggiqeGPkMlthCP0yinIYjK6LMewwY8"
API_KEY = "sk-3720ccd539704717ba9af3453500fe3c"

# Dummy model functions
def model_a(input_data):
    return "Response from Model A"

def model_b(input_data):
    return "Response from Model B"

def model_c(input_data):
    return "Response from Model C"

def model_d(input_data):
    return "Response from Model D"

def model_e(input_data):
    return "Response from Model E"

def model_f(input_data):
    return "Response from Model F"

# Language detection function (placeholder)
def detect_language(text):
    # Placeholder for actual language detection logic
    return "en" if "hello" in text else "ar"

@app.route('/api/v1/models/<model_name>', methods=['POST'])
def call_model(model_name):
    if request.headers.get('Authorization') != f"Bearer {JWT_TOKEN}":
        return jsonify({"error": "Unauthorized"}), 401

    input_data = request.json.get('input', '')
    language = detect_language(input_data)

    try:
        if language == "en":
            if model_name == "model_a":
                response = model_a(input_data)
            elif model_name == "model_b":
                response = model_b(input_data)
            # Add similar conditions for other English models
        else:
            if model_name == "model_c":
                response = model_c(input_data)
            elif model_name == "model_d":
                response = model_d(input_data)
            # Add similar conditions for other Arabic models

        return jsonify({"response": response}), 200

    except Exception as e:
        logging.error(f"Error: {str(e)}")
        return jsonify({"error": "An error occurred"}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

@app.route('/status', methods=['GET'])
def status():
    return jsonify({"status": "running"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)