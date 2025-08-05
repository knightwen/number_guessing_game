#!/bin/bash

PSQL="psql -U postgres -d number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read username

# check whether used before
user_info=$($PSQL "SELECT*FROM number_of_game,number_of_guess WHERE user_name='$username';")
# if so, welcome and update data.
if [[ -z $user_info ]]; then
echo "Welcome, $username! It looks like this is your first time here."
$PSQL "INSERT INTO user_stories(user_name) VALUES('$username');"
# otherwise
else
"Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
echo 
fi

echo "Guess the secret number between 1 and 1000:"
read player_number

# check data type

# compare and give clue
