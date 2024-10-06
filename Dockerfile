# Use the official Python image from DockerHub
FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and update repositories
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    curl \
    wget \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Add OpenJDK 17 repository and install Java
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for Java 17
ENV JAVA_HOME=/usr/lib/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Download and install Spark
RUN wget https://archive.apache.org/dist/spark/spark-3.5.3/spark-3.5.3-bin-hadoop3.tgz && \
    tar -xvzf spark-3.5.3-bin-hadoop3.tgz && \
    mv spark-3.5.3-bin-hadoop3 /usr/local/spark && \
    rm spark-3.5.3-bin-hadoop3.tgz

# Set environment variables for Spark
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Install PySpark globally using pip
RUN pip install pyspark

# Copy the requirements.txt before installing dependencies
COPY requirements.txt .

# Install dependencies from requirements.txt
RUN pip install -r requirements.txt

# Set working directory
WORKDIR /app

# Copy the application files to the container
COPY ./app /app

# Run the PySpark job
CMD ["python", "/app/main.py"]
