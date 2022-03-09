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
	echo -n "Do you want to run this topic? (y/n)? "
	read answer

	if [ "$answer" != "${answer#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
	    true
	else
	    false
	fi
	return
}

run_all=$(echo $1 | tr -d -)

# Update
print_topic "Updating ubuntu"
if [[ $run_all =~ "y" ]] || ask_user_yn; then
	sudo apt update 
	sudo apt-get update
fi 

# To enable nvidia drivers
print_topic "Updating drivers"
if [[ $run_all =~ "y" ]] || ask_user_yn; then
	print_subtopic_and_run "Enable display drivers" "sudo ubuntu-drivers autoinstall"
fi

print_topic "Installing tools"
if [[ $run_all =~ "y" ]] || ask_user_yn; then
	print_subtopic_and_run "Installing termiator" "sudo apt install terminator -y"
	print_subtopic_and_run "Installing git" "sudo apt install git -y"
	print_subtopic_and_run "Installing openssh-server" "sudo apt install openssh-server -y"
	print_subtopic_and_run "Installing net-tools" "sudo apt install net-tools -y"
fi

print_topic "make development directories"
if [[ $run_all =~ "y" ]] || ask_user_yn; then
	create_folder_if_not_exists "/home/$USER/code"
	create_folder_if_not_exists "/home/$USER/code/python"
	create_folder_if_not_exists "/home/$USER/code/cpp"
	create_folder_if_not_exists "/home/$USER/code/ros_ws"
fi




echo ""
echo ""
echo ""
echo ""
echo "Done with the setup script, to complete it please reboot"






