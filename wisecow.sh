#!/bin/bash

set -e

SRVPORT=4499
RSPFILE="/tmp/response.txt"

# Create response file with proper permissions
mkdir -p $(dirname $RSPFILE)
touch $RSPFILE
chmod 666 $RSPFILE

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if required commands are available
for cmd in cowsay fortune nc; do
    if ! command -v $cmd &> /dev/null; then
        log "Error: $cmd is not installed"
        exit 1
    fi
done

# Function to generate a new response
generate_response() {
    # Generate fortune and cowsay output
    fortune_msg=$(fortune)
    cowsay_output=$(cowsay "$fortune_msg")
    
    # Create HTTP response
    cat <<EOF > $RSPFILE
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close

$cowsay_output
EOF
}

# Check prerequisites
prerequisites() {
    command -v cowsay >/dev/null 2>&1 || { echo "Error: cowsay not found"; exit 1; }
    command -v fortune >/dev/null 2>&1 || { echo "Error: fortune not found"; exit 1; }
    command -v nc >/dev/null 2>&1 || { echo "Error: netcat not found"; exit 1; }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."
    
    # Generate initial response
    generate_response
    
    # Main server loop
    while true; do
        # Use nc to listen for connections and handle them
        cat $RSPFILE | nc -l -p $SRVPORT -s 0.0.0.0 -w 1 >/dev/null 2>&1
        # Generate a new response after each request
        generate_response
    done
}

# Run the server
main