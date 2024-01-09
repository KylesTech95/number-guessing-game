#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# guess the number
GUESS(){
  if [[ $1 ]]
  then
  COUNTER=$(echo $(($COUNTER + 1)))
  fi
  echo $COUNTER
  read USER_GUESS
}

echo  -e "\nEnter your username:"
sleep .5
read USERNAME

# username is already in db
USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
if [[ -z $USER_ID ]]
then
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
INSERT_USERNAME=$($PSQL "insert into users(username) values('$USERNAME')")
else
echo -e "\nWelcome back, $USERNAME! You have played __games_played games, and your best game took __best_guesses__ guesses."
fi

# generate secret (random) number
SECRET_NUMBER=$(echo $((1 + RANDOM % 1000)))
# test
# echo $SECRET_NUMBER
# guess the number
echo -e "Guess the secret number between 1 and 1000:"

# add counter variable
COUNTER=1

#start guessing numbers
GUESS