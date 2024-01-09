#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo  -e "\nEnter your username:"
sleep .5
read USERNAME