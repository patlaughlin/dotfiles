#!/bin/bash

# Identify the laptop display
LAPTOP="eDP-1-1"

# List of possible ultrawide monitors (DisplayPort outputs)
ULTRAWIDE_PORTS=("DP-0" "DP-1" "DP-2" "DP-3")

# Iterate through possible ultrawide ports to find the connected one
ULTRAWIDE=""
for PORT in "${ULTRAWIDE_PORTS[@]}"; do
    if xrandr | grep -q "$PORT connected"; then
        ULTRAWIDE="$PORT"
        break
    fi
done

# If an ultrawide monitor is connected, configure it
if [ -n "$ULTRAWIDE" ]; then
    # Set up the ultrawide monitor as primary at 144Hz
    xrandr --output "$ULTRAWIDE" --mode 3440x1440 --rate 144.00 --primary

    # Set up the laptop display at 165Hz, positioned directly to the left of the ultrawide
    xrandr --output "$LAPTOP" --mode 2560x1600 --rate 165.00 --left-of "$ULTRAWIDE"

    echo "Monitors configured: $ULTRAWIDE as primary at 144Hz, laptop at 165Hz positioned directly to the left."
else
    # If no ultrawide is connected, just set up the laptop display
    xrandr --output "$LAPTOP" --mode 2560x1600 --rate 165.00 --primary

    echo "No ultrawide monitor detected. Laptop display configured at 165Hz."
fi


# # Identify the displays
# LAPTOP="eDP-1"
# ULTRAWIDE="DP-1-2"

# # Check if the ultrawide monitor is connected
# if xrandr | grep -q "$ULTRAWIDE connected"; then
#     # Set up the ultrawide monitor as primary at 144Hz
#     xrandr --output "$ULTRAWIDE" --mode 3440x1440 --rate 144.00 --primary

#     # Set up the laptop display at 165Hz, positioned directly to the left of the ultrawide
#     xrandr --output "$LAPTOP" --mode 2560x1600 --rate 165.00 --left-of "$ULTRAWIDE"

#     echo "Monitors configured: Ultrawide as primary at 144Hz, laptop at 165Hz positioned directly to the left."
# else
#     # If ultrawide is not connected, just set up the laptop display
#     xrandr --output "$LAPTOP" --mode 2560x1600 --rate 165.00 --primary

#     echo "Ultrawide monitor not detected. Laptop display configured at 165Hz."
# fi

