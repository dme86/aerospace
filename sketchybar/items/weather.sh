#!/bin/bash

# Retrieve the public IP address
IP=$(curl -s https://api.ipify.org)

# Use IP geolocation API service to get the location information
LOCATION=$(curl -s "https://ipinfo.io/${IP}/json" | jq -r '.city')

# Make a request to wttr.in to get the weather for $LOCATION
WEATHER=$(curl -s "wttr.in/${LOCATION}?format=3")

# Make a rewuest to wttr.in to get the times for sunrise & sunset
SUNTIME=$(curl  -s "wttr.in/${LOCATION}?format=%S+%s")
SUNRISE=$(awk '{print $1}' <<< "$SUNTIME")
SUNSET=$(awk '{print $2}' <<< "$SUNTIME")

# Extract the weather icon and temperature from the weather information
TEMPERATURE=$(awk '{print $3}' <<< $WEATHER)
ICON=$(awk '{print $2}' <<< $WEATHER)
HOUR=$(date +%H)

# Change ICON depending on whether it is day or night at the moment
if [[ "$ICON" == *"☁"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO="󰖐"
  else
    ICO="󰼱"
  fi
elif [[ "$ICON" == *"☀"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO=""
  else
    ICO=""
  fi
elif [[ "$ICON" == *"⛅"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO=""
  else
    ICO="󰼱"
  fi
elif [[ "$ICON" == *"🌨"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO="󰖖"
  else
    ICO=""
  fi
elif [[ "$ICON" == *"🌦"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO=""
  else
    ICO=""
  fi
elif [[ "$ICON" == *"⛅️"* ]]; then
  if [[ $HOUR -ge 6 ]] && [[ $HOUR -lt 20 ]]; then
    ICO="󰖕"
  else
    ICO="󰼱"
  fi
fi

if [[  "$ICO" == "" ]]; then
  ICO="󱣶"
fi

# Add the weather item to the bracket
sketchybar --add event weather \
           --add item weather right   \
           --set weather icon="$ICO" \
                             label="$TEMPERATURE" \
                             label.align=left \
                             padding_left=5 \
                             padding_right=5

# Print the weather icon and temperature
# printf "$ICO $TEMPERATURE"
