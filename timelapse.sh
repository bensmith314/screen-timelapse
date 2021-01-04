#!/bin/bash

startMessage1="Starting Timelapse Image Capture in "
startMessage2=" seconds"
timeToStart=5 # Countdown at beginning
imageTiming=4 # Time between screencaptures
frameNumber=0 # Current Frame
isRunning=""  # Status of Timelapse

function setFrame {
  eval rm frameNumber.txt
  eval touch frameNumber.txt
  echo $1 >> frameNumber.txt
}

function setRunStatus {
  eval rm isRunning.txt
  eval touch isRunning.txt
  echo $1 >> isRunning.txt
  isRunning=$1
}

function checkRunStatus {
  input="/Users/emeryross/scripts/timelapse/isRunning.txt"
  while IFS= read -r line
  do
    isRunning=$line
  done < "$input"
}

eval clear

# Get Current Frame Index
input="/Users/emeryross/scripts/timelapse/frameNumber.txt"
while IFS= read -r line
do
  frameNumber=$line
done < "$input"

if [[ $frameNumber -gt 0 ]]; then
  printf "Do you want to continue from frame [$frameNumber]? [y] or [n]\n"
  printf ":"
  read frameStart

  if [[ $frameStart = "n" ]]; then
    eval "./clearImages.sh"
    frameNumber=0
    setFrame $frameNumber
  fi
fi

# Startup Countdown
while [[ $timeToStart -gt 0 ]]; do
  printf "\r$startMessage1$timeToStart$startMessage2"
  sleep 1
  timeToStart=$((timeToStart-1))
done
echo

# Set Running Status
setRunStatus "true"

# Main Process
while [[ $isRunning = "true" ]]; do
  eval screencapture -xC /Users/emeryross/scripts/timelapse/images/frame$frameNumber.png
  frameNumber=$((frameNumber+1))
  setFrame $frameNumber

  printf "\rEnd Script? [y]:"
  read -t $imageTiming endScript
  if [[ $endScript = "y" ]]; then
    setRunStatus "false"
  fi

  checkRunStatus
done
