from flask import Flask, jsonify
import os

app = Flask(__name__)

print("Cloud With VarJosh Flask Application Started")

@app.get("/")
def home():
    print("Home endpoint invoked")

    return jsonify(
        message="Welcome to Cloud With VarJosh",
        platform="GitHub Actions",
        runtime="Docker + Flask"
    )

@app.get("/health")
def health():
    print("Health endpoint invoked")
    return jsonify(status="healthy"), 200

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", 5000))
    )