#!/bin/bash

#searches for todo items and prints them in order
function list_todo(){
	counter=0
	if [ -f ./todo ]; then
		filenames=$(find ~/todo -name '*')
		for filename in $filenames; do
			line=$(head -n 1 $filename)
			echo "	$counter) $line"
			counter=$((counter+1))
		done
		counter=$((counter+1))
	else
		echo "	Nothing at all!"
	fi
}

#print the rest of the file
function detail(){
	echo "detail"
}

#mark a file as completed (move a file to todo_completed directory)
function mark_complete(){
	echo "mark_complete"
}

#add a file to todo directory
function add(){
	echo "add"
}

#searches todo_completed items and prints them in order
function list_todo_completed(){
	echo "list_todo_completed"
}

#main menu that repeats until quit
function main(){
	echo
	echo "Here are your current items:"
	list_todo
	echo "What would you like to do?"
	if [ $counter -eq 0 ]; then
		echo "	A) Mark an item as completed
	B) Add a new item
	C) See completed items

	Q) Quit"
	else
		echo "	1-$counter) See more information about this item
	A) Mark an item as completed
	B) Add a new item
	C) See completed items
		
	Q) Quit"
	fi
	read -p "Enter choice: " choice
	if [ $choice == 'A' ]; then
		mark_complete
		main
	elif [ $choice == 'B' ]; then
		add
		main
	elif [ $choice == 'C' ]; then
		list_todo_completed
		main
	elif [ $choice == 'Q' ]; then
		exit 0
	else
		echo "Not a valid choice! Let's try again..."
		main
	fi
}

#start of program
echo "Welcome to to-do list manager!"
main
