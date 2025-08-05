#!/bin/bash

echo -e "\nEnter your username:"
read username

# check whether used before
# if so
if [[ ]]; then
echo "Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses."
else
echo "Welcome, <username>! It looks like this is your first time here."
fi

echo "Guess the secret number between 1 and 1000:"
read player_number

# check data type

# compare and give clue
