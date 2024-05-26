# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy only the requirements file to optimize Docker layer caching
COPY requirements.txt .

# Install any needed dependencies specified in requirements.txt
# This step is separated to leverage Docker layer caching
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . .

# Expose the port on which your Flask app will run
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py

# Run the Flask application with gunicorn for improved performance and concurrency
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
