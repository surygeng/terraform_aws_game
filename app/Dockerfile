FROM python:3.11-slim

RUN pip install --no-cache-dir flask

EXPOSE 8080

WORKDIR /app
COPY . .

CMD ["python" "app.py"]


# surygeng/terraform-aws-game:v0.1 