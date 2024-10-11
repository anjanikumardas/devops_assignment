# Use an official Java runtime as the base image
FROM openjdk:11-jdk-slim

# Install Android SDK dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    && apt-get clean

# Set up environment variables
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Download Android SDK command-line tools
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip -O commandlinetools.zip && \
    unzip commandlinetools.zip && \
    rm commandlinetools.zip

# Accept Android SDK licenses
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager --licenses

# Install required SDKs and build tools
RUN ${ANDROID_HOME}/cmdline-tools/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-30" \
    "build-tools;30.0.3"

# Create a working directory
WORKDIR /app

# Copy the Android project to the Docker container
COPY . /app

# Build the Android app using Gradle
RUN ./gradlew build

# Define the default command to build the app
CMD ["./gradlew", "assembleDebug"]
