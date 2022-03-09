#!/bin/bash

# write a function # Learn from https://bash.cyberciti.biz/guide/Pass_arguments_into_a_function
print_topic(){
	function_called=$0
	first_arg=$1
	echo ""
	echo ""
	echo ===============================================================
	echo \>\>\>\>\>\>\>\>\>\>\>\>\>\>\>\> $first_arg 
	echo ===============================================================
}

print_subtopic_and_run(){
	function_called=$0
	first_arg=$1
	run_script=$2
	echo --------------------------------------------------------------
	echo \>\>\>\>\>\>\>\>\>\>\>\>\>\>\>\> $first_arg
	echo --------------------------------------------------------------
	$run_script
	echo -------------------- $first_arg Done -------------------------
	echo ""
}

not_exists(){
	FILE=$1
	if [ -f "$FILE" ]; then
		echo "$FILE is an existing file."
		false
		return
	fi
	if [ -d "$FILE" ]; then
		echo "$FILE is an existing directory."
		false
		return 
	fi
	echo "$FILE does not exist."
	true
	return
}

create_folder_if_not_exists(){
	FILE=$1
	if not_exists $FILE; then
		echo "creating $FILE"
		mkdir $FILE
	fi
}

ask_user_yn(){
	text=$1
	echo -n "Do you want to $1? (y/n)? "
	read answer

	if [ "$answer" != "${answer#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
	    true
	else
	    false
	fi
	return
}

run_all=$(echo $1 | tr -d -)
