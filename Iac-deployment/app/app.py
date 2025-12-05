from flask import Flask

app = Flask(__name__)

@app.route("/")
def root():
    return "Hello from DevOps assignment!", 200

@app.route("/health")
def health():
    return "ok", 200

if __name__ == "__main__":
    # Listen on 0.0.0.0 so ALB can reach it, port 8080 per assignment
    app.run(host="0.0.0.0", port=8080)
