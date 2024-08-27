#!/bin/bash

# Identify the displays
LAPTOP="eDP"
ULTRAWIDE="DP-1-2"

# Check if the ultrawide monitor is connected
if xrandr | grep -q "$ULTRAWIDE connected"; then
    # Set up the ultrawide monitor as primary at 144Hz
    xrandr --output $ULTRAWIDE --mode 3440x1440 --rate 144.00 --primary

    # Set up the laptop display at 165Hz, positioned directly to the left of the ultrawide
    xrandr --output $LAPTOP --mode 2560x1600 --rate 165.00 --left-of $ULTRAWIDE

    echo "Monitors configured: Ultrawide as primary at 144Hz, laptop at 165Hz positioned directly to the left."
else
    # If ultrawide is not connected, just set up the laptop display
    xrandr --output $LAPTOP --mode 2560x1600 --rate 165.00 --primary

    echo "Ultrawide monitor not detected. Laptop display configured at 165Hz."
fi
