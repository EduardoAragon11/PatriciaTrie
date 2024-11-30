#!/bin/bash

# Define the Processing installation path
PROCESSING_PATH="/Documents/Programas/processing-4.3-linux-x64/processing-4.3"

# Check if the `processing-java` executable exists

# Check if a .pde file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/sketch.pde"
  exit 1
fi

PDE_FILE="$1"

# Verify that the .pde file exists
if [ ! -f "$PDE_FILE" ]; then
  echo "Error: File '$PDE_FILE' not found."
  exit 1
fi

# Get the directory of the sketch
SKETCH_DIR=$(dirname "$PDE_FILE")

# Ensure the .pde file matches the folder name (Processing requirement)
SKETCH_NAME=$(basename "$SKETCH_DIR")
PDE_NAME=$(basename "$PDE_FILE" .pde)

if [ "$SKETCH_NAME" != "$PDE_NAME" ]; then
  echo "Error: The .pde file must match the folder name."
  echo "Folder: $SKETCH_NAME, File: $PDE_NAME.pde"
  exit 1
fi

# Run the sketch using processing-java
"$PROCESSING_PATH/processing" --sketch="$SKETCH_DIR" --run
