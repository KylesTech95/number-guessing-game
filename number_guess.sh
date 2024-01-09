#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# echo $($PSQL "truncate users;alter sequence users_user_id_seq restart with 1;")

# generate secret (random) number
SECRET_NUMBER=$(echo $((1 + RANDOM % 1000)))
GAMES_PLAYED=1
BEST_GAME=500
GUESS_COUNTER=0
echo  -e "\nEnter your username:"
sleep .5
read USERNAME

# username is already in db
USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
if [[ -z $USER_ID ]]
then
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
INSERT_USER=$($PSQL "insert into users(username,games_played,best_game) values('$USERNAME',$GAMES_PLAYED,$BEST_GAME)")
else
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
((GAMES_PLAYED++))
echo $($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
fi

# test
# echo $SECRET_NUMBER
# guess the number
echo -e "Guess the secret number between 1 and 1000:"

# add counter variable
# COUNTER=1

#start guessing numbers
# GUESS
while true
do
  read GUESS
  GUESS_COUNTER=$(echo $(($GUESS_COUNTER + 1)))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $GUESS -lt $SECRET_NUMBER ]] 
    then
      echo -e "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
      echo -e "It's lower than that, guess again:"
  else 
  if [[ $GUESSES -lt $BEST_GAME ]]
      then
        echo $($PSQL "UPDATE users SET best_game=$GUESS_COUNTER WHERE username='$USERNAME'")
      fi
      echo "You guessed it in $GUESS_COUNTER tries. The secret number was $SECRET_NUMBER. Nice job!"
      exit 

  fi
done 