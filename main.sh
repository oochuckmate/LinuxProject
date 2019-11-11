#!/bin/bash

#searches for todo items and prints them in order
function list_todo(){
	counter=1
	if [ -f ./todo ]; then
		filenames=$(find ~/todo -name '*')
		for filename in $filenames; do
			line=$(head -n 1 $filename)
			echo "$counter) $line"
			counter=$((counter+1))
		done
	else
		echo "Nothing at all!"
	fi
}

echo "Welcome to to-do list manager! Here are your current items."
list_todo
echo "What would you like to do?"

