# Use Ubuntu as base image
FROM ubuntu:latest

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt update && apt install -y
