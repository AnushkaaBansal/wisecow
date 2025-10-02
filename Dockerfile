FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cowsay \
    fortune \
    fortunes \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Create app directory and copy script
WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Create necessary directories with proper permissions
RUN mkdir -p /tmp && \
    chmod 777 /tmp

# Set PATH to include games
ENV PATH="/usr/games:${PATH}"

# Expose port
EXPOSE 4499

# Run the application
CMD ["/app/wisecow.sh"]