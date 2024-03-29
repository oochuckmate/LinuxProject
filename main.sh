#!/bin/bash

#searches for todo items and prints them in order
function list_todo(){
	echo "Here are your current items:"
	counter=0
	if [ -e ./todo/1 ]; then
		filenames=$(find ./todo/* -name '*')
		for filename in $filenames; do	
			counter=$((counter+1))
			line=$(head -n 1 $filename)
			echo "	$counter) $line"
		done
	else
		echo "	Nothing at all!"
	fi
}

#checks for invalid choices and if valid will print full file given
function detail(){
	echo
	if [ -e ./todo/$1 ]; then
		echo "Here is the full item: "
		echo
		file=$(find ./todo/* -name $1)
		cat $file
		echo
		echo "Returning to menu..."
	else
		echo "Invalid choice given! Returning to menu..."
	fi
	main
}

#mark a file as completed (move a file to todo_completed directory)
function mark_complete(){
	echo
	complete_counter=1
	if [ -e ./todo/1 ]; then
		list_todo
		echo "What file would you like to mark as complete?"
		read -p "Enter number: " n
		echo
		if [ -e ./todo/$n ]; then
			echo "Marking file $n as complete! Returning to menu..."
			if [ -e ./todo_completed/1 ]; then
				complete_filenames=$(find ./todo_completed/* -name '*')
				for complete_filename in $complete_filenames; do	
					complete_counter=$((complete_counter+1))
				done
			fi
			mv ./todo/$n ./todo_completed/$complete_counter
		else
			echo "That's not an item! Returning to menu..."
		fi
	else
		echo "No items found! Returning to menu..."
	fi
	main
}

#add a file to todo directory
function add(){
	echo
	counter=$((counter+1))
	echo "To add an item I will need a title and description."
	read -p "Title: " title
	read -p "Description: " description
	echo "$title
-----
$description" > ./todo/$counter
	chmod 600 ./todo/$counter
	echo "File added to list! Returning to menu..."
	main
}

#searches todo_completed items and prints them in order
function list_todo_completed(){
	echo
	echo "Here are your completed items:"
	completed=0
	if [ -e ./todo_completed/1 ]; then
		completed_files=$(find ./todo_completed/* -name '*')
		for filename in $completed_files; do	
			completed=$((completed+1))
			head=$(head -n 1 $filename)
			echo "	$completed) $head"
		done
	else
		echo "	Nothing has been completed! Returning to menu..."
	fi
	main
}

#main menu that repeats until quit
function main(){
	echo
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
	if [ $choice == 'A' ] || [ $choice == 'a' ]; then
		mark_complete
		main
	elif [ $choice == 'B' ] || [ $choice == 'b' ]; then
		add
		main
	elif [ $choice == 'C' ] || [ $choice == 'c' ]; then
		list_todo_completed
		main
	elif [ $choice == 'Q' ] || [ $choice == 'q' ]; then
		exit 0
	else
		detail $choice
	fi
}

#start of program
echo "Welcome to to-do list manager!"
main
