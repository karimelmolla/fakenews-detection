from flask import Flask, request, jsonify, send_from_directory, render_template
from keras.models import load_model
import pickle
from tensorflow.keras.preprocessing.sequence import pad_sequences
import os

app = Flask(__name__)

# Load the model and tokenizer
cnn_model = load_model('K:/flask pycharm 1/models/DeepLearningCNN_model.h5')
with open('K:/flask pycharm 1/models/modeltokenizer.pkl', 'rb') as f:
    tokenizer = pickle.load(f)

# Load the sentiment analysis model
with open('K:/flask pycharm 1/models/pipeline.pkl', 'rb') as f:
    sentiment_model = pickle.load(f)

# Set the correct maxlen value
MAXLEN = 2747


@app.route('/')
def serve_index():
    return render_template('index.html')


@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        print(f"Received data: {data}")

        text = data['text']

        # Tokenize and pad the input text
        sequence = tokenizer.texts_to_sequences([text])
        padded_sequence = pad_sequences(sequence, maxlen=MAXLEN)

        # Make prediction
        prediction = cnn_model.predict(padded_sequence)[0][0]

        if prediction > 0.5:
            reliability = "Reliable News"
            reliability_score = 50 + (prediction * 50)
        else:
            reliability = "Fake News"
            reliability_score = prediction * 50

        reliability_score = round(reliability_score, 2)

        # Perform sentiment analysis
        sentiment = sentiment_model.predict([text])[0]
        sentiment_label = "Negative" if sentiment == 0 else "Positive" if sentiment == 1 else "Neutral"

        response = {
            'prediction': reliability,
            'reliability_score': reliability_score,
            'sentiment': sentiment_label
        }
        print(f"Response data: {response}")
        return jsonify(response)

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
