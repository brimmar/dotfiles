#!/bin/bash

current=$(brightnessctl -c backlight g)
max=$(brightnessctl -c backlight m)

percentage=$(((current*100) / max))

echo $percentage
