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
  IFS="|" read TOTAL_GAME NUMBER_GUESS <<< "$user_info"
  echo "Welcome back, $username! You have played $TOTAL_GAME games, and your best game took $NUMBER_GUESS guesses."
  update_user=$($PSQL "UPDATE users SET number_of_game = number_of_game + 1 WHERE user_name = '$username';")
fi

result=$(( RANDOM % 1000 + 1 ))
guess_count=0;

echo "Guess the secret number between 1 and 1000:"
# check data type
while true; do
  read guess_number
  if ! [[ $guess_number =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  (( guess_count++ ))

  if [[ $guess_number == $result ]]; then
    echo "You guessed it in $guess_count tries. The secret number was $result. Nice job!"
    # update database
    $PSQL "UPDATE users SET number_of_guess=$guess_count WHERE user_name='$username' AND (number_of_guess IS NULL OR number_of_guess > $guess_number);"
    break
  elif [[ $guess_number > $result ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done
