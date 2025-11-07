from flask import Flask, render_template, request
import random 

app = Flask(__name__)
SECRET_NUMBER = random.randint(1, 20)

@app.route("/", methods=["GET", "POST"])
def index():
    message = ""
    if request.method == "POST":
        try:
            guess = int(request.form["guess"])
            if guess < SECRET_NUMBER:
                message = "Too low! Try again."
            elif guess > SECRET_NUMBER:
                message = "Too high! Try again."
            else:
                message = "Congratulations! You've guessed the number!"
        except ValueError:
            message = "Please enter a valid integer."
    return render_template("index.html", message=message)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)