#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#echo -e "\n~~~ Number Guessing Game ~~~\n"
echo "Enter your username:"
read USERNAME_INPUT
USER_DETAILS=$($PSQL "SELECT * FROM users WHERE name='$USERNAME_INPUT'")
if [[ $USER_DETAILS ]]
then
  echo "$USER_DETAILS" | while IFS="|" read username games_played best_game
  do
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
  done
else
  echo "Welcome, $USERNAME_INPUT! It looks like this is your first time here."
  INSERT_USER_STATUS=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME_INPUT')")
fi
RND=$(( ( RANDOM % 1000 )  + 1 ))
#echo $RND
COUNT=0
echo -e "\nGuess the secret number between 1 and 1000:"
read INPUT
((COUNT=COUNT+1))
while [[ $INPUT != $RND ]]
do
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $INPUT > $RND ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi
  fi
  ((COUNT=COUNT+1))
  read INPUT
done
echo "You guessed it in $COUNT tries. The secret number was $RND. Nice job!"
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE name='$USERNAME_INPUT'")
if [[ "$BEST_GAME" -eq 0 ]] || [[ "$BEST_GAME" -gt $COUNT ]]
then
  UPDATE_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1, best_game = $COUNT WHERE name='$USERNAME_INPUT'")
else
  UPDATE_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE name='$USERNAME_INPUT'")
fi