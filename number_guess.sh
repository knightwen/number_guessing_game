#!/bin/bash

PSQL="psql -U postgres -d number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read username

# check whether user exists
user_info=$($PSQL "SELECT games_played, best_game FROM users WHERE user_name='$username';")

if [[ -n $user_info ]]; then
  IFS="|" read GAMES_PLAYED BEST_GAME <<< "$user_info"
  echo "Welcome back, $username! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  UPDATE=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_name = '$username';")
else
  echo "Welcome, $username! It looks like this is your first time here."
  INSERT=$($PSQL "INSERT INTO users(user_name, games_played) VALUES('$username', 1);")
fi

# game starts
secret_number=$(( RANDOM % 1000 + 1 ))
number_of_guesses=0

echo "Guess the secret number between 1 and 1000:"

while true; do
  read guess
  if ! [[ $guess =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  (( number_of_guesses++ ))

  if [[ $guess -eq $secret_number ]]; then
    echo "You guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!"

    # update best_game if better or not set
    UPDATE=$($PSQL "UPDATE users SET best_game = $number_of_guesses WHERE user_name='$username' AND (best_game IS NULL OR best_game > $number_of_guesses);")
    break
  elif [[ $guess -gt $secret_number ]]; then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
done
