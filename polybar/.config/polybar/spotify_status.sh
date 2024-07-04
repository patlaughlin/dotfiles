#!/bin/bash

# Fetch the current song information
song=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)

# Check if Spotify is running and a song is playing
if [ -z "$song" ]; then
  echo "No song playing"
else
  echo "$song"
fi
