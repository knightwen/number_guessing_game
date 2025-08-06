#!/bin/bash

PSQL="psql -U postgres -d number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read username

# check whether used before
user_info=$($PSQL "SELECT number_of_game,number_of_guess FROM users WHERE user_name='$username';")
# if so, welcome and update data.
if [[ -z $user_info ]]; then
  echo "Welcome, $username! It looks like this is your first time here."
  insert_name=($PSQL "INSERT INTO users(user_name, number_of_game) VALUES('$username', 1);")
# otherwise
else
  echo "$user_info" | while IFS="|" read TOTAL_GAME NUMBER_GUESS
  do
    echo "Welcome back, $username! You have played $TOTAL_GAME games, and your best game took $NUMBER_GUESS guesses."
    insert_totalGame=$($PSQL "INSERT INTO users(number_of_game) VALUES(number_of_game+1);")
  done
fi

result=$(( RANDOM % 1000 + 1 ))
guess_count=0;

echo "Guess the secret number between 1 and 1000:"
# check data type
while true; do
  read guess_number
  if [[ $guess_number =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  fi

  (($guess_count++))

  if [[ $guess_number == $result ]]; then
    echo "You guessed it in $guess_count tries. The secret number was $result. Nice job!"
    # insert into database
    break
  elif [[ $guess_number > $result ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done
