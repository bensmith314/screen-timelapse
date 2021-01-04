#!/bin/bash

printf "Do you want to remove all images stored? [y] or [n]\n"
printf ":"
read confirmation

if [[ $confirmation = "y" ]]; then
  eval rm -dr /Users/emeryross/scripts/timelapse/images/
  eval mkdir /Users/emeryross/scripts/timelapse/images/
fi
