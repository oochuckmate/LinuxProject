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

#moves an item into the todo_completed directory for menu founctionality
function mark_complete(){
	echo
	if [ -e ./todo/1 ]; then
		list_todo
		echo "What file would you like to mark as complete?"
		read -p "Enter number: " n
		complete_counter=1
		if [ -e ./todo/$n ]; then
			echo
			echo "Marking file $n as complete! Returning to menu..."
			if [ -e ./todo_completed/1 ]; then
				complete_filenames=$(find ./todo_completed/* -name '*')
				for complete_filename in $complete_filenames; do	
					complete_counter=$((complete_counter+1))
				done
			fi
		mv ./todo/$n ./todo_completed/$complete_counter
		else
			echo
			echo "That's not an item! Returning to menu..."
		fi
	else
		echo "No items found! Returning to menu..."
	fi
	main
}

#moves an item into todo_completed directory command line functionality
function mark_complete_command(){
	com_counter=1
	if [ -e ./todo/$1 ]; then
		echo "Marking file $1 as complete!"
		if [ -e ./todo_completed/1 ]; then
			com_filenames=$(find ./todo_completed/* -name '*')
			for com_filename in $com_filenames; do	
				com_counter=$((com_counter+1))
			done
		fi
		mv ./todo/$1 ./todo_completed/$com_counter
	else
		echo "That's not an item!"
	fi
}

#add a file to todo directory through menu
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
	echo "File $counter added to list! Returning to menu..."
	main
}

#add a file to todo directory through command line
function add_command(){
	add_counter=1
	if [ -e ./todo/1 ]; then
		todo_files=$(find ./todo/* -name '*')
		for todo_file in $todo_files; do	
			add_counter=$((add_counter+1))
		done
	fi
	STDIN=$(cat)
	echo "$1
-----
$STDIN" > ./todo/$add_counter
	chmod 600 ./todo/$add_counter
	echo "File $add_counter added."
}

#searches todo_completed items and prints them in order for menu functionality
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

#searches todo_completed items and prints them in order for command line functionality
function list_todo_completed_command(){
	echo
	echo "Here are your completed items:"
	completed_command=0
	if [ -e ./todo_completed/1 ]; then
		completed_files_command=$(find ./todo_completed/* -name '*')
		for filename_command in $completed_files_command; do	
			completed_command=$((completed_command+1))
			top=$(head -n 1 $filename_command)
			echo "	$completed_command) $top"
		done
	else
		echo "	Nothing has been completed!"
	fi
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

#prints help message for command line functionality
function help_command(){
	echo "Help message for command line use of to-do list manager
-----
help	  	  - display this help message
list 		  - lists uncompleted items
list completed    - list completed items
complete *number* - marks item of number given as complete
add *title* 	  - adds item with given title to uncompleted list and adds description based on standard input"
}

#command line functionality
function main_command(){
	case $1 in
	help)
		help_command
    	;;
	list)
		if [ $# -eq 1 ]; then
			list_todo
		elif [ $2 == "completed" ]; then
			list_todo_completed_command
		else
			main_command error
		fi
	;;
	complete)
		if [ $# -eq 1 ]; then
			main_command error
		else
			mark_complete_command $2
		fi
	;;
	add)
		if [ $# -eq 1 ]; then
			main_command error
		else
			add_command "$2"
		fi
	;;
	*)
		echo "Didn't recognise command. Displaying help message..."
		echo
    		help_command
    	;;
	esac
}

#start of program
if [ $# -lt 1 ]; then
	echo "Welcome to to-do list manager!"
	main
else
	if [ $# -eq 2 ]; then
		main_command "$1" "$2"
	elif [ $# -eq 1 ]; then
		main_command "$1"
	else
		main_command error
	fi
fi
