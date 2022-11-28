#!/bin/bash
RND=$(( ( RANDOM % 1000 )  + 1 ))
echo -e "\n~~~ Number Guessing Game ~~~\n"
echo "Enter your username:"
read USERNAME
