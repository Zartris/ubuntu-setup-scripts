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


# Update
print_topic "Updating ubuntu"
sudo apt update 
sudo apt-get update

# To enable nvidia drivers
print_topic "Updating drivers"
print_subtopic_and_run "Enable display drivers" "sudo ubuntu-drivers autoinstall"

print_topic "Installing tools"
print_subtopic_and_run "Installing termiator" "sudo apt install terminator -y"
print_subtopic_and_run "Installing git" "sudo apt install git -y"
print_subtopic_and_run "Installing openssh-server" "sudo apt install openssh-server -y"
print_subtopic_and_run "Installing net-tools" "sudo apt install net-tools -y"

print_topic "make development directories"
create_folder_if_not_exists "/home/$USER/code"
create_folder_if_not_exists "/home/$USER/code/python"
create_folder_if_not_exists "/home/$USER/code/cpp"
create_folder_if_not_exists "/home/$USER/code/ros_ws"








