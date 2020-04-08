#!/bin/bash

sudo pacman -Syu
sudo pacman -S $(cat packagesPacman.txt) 
