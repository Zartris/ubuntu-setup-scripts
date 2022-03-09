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

# Update
print_topic "Updating ubuntu"
if [[ $run_all =~ "y" ]] || ask_user_yn "update ubuntu"; then
	sudo apt update 
	sudo apt-get update
fi 

# To enable nvidia drivers
print_topic "Updating drivers"
if [[ $run_all =~ "y" ]] || ask_user_yn "update drivers"; then
	print_subtopic_and_run "Enable display drivers" "sudo ubuntu-drivers autoinstall"
	print_subtopic_and_run "install gpu utils" "sudo apt install nvidia-driver-510 nvidia-utils-510"
fi

print_topic "Installing tools"
if [[ $run_all =~ "y" ]] || ask_user_yn "install basic tools"; then
	print_subtopic_and_run "Installing termiator" "sudo apt install terminator -y"
	print_subtopic_and_run "Installing git" "sudo apt install git -y"
	print_subtopic_and_run "Installing openssh-server" "sudo apt install openssh-server -y"
	print_subtopic_and_run "Installing net-tools" "sudo apt install net-tools -y"
	print_subtopic_and_run "Installing htop" "sudo apt install htop -y"
	print_subtopic_and_run "Installing 7zip" "sudo apt-get install p7zip-full"
	
	if ask_user_yn "install slack (optional)";then
		print_subtopic_and_run "Installing slack" "sudo snap install slack --classic"
	fi
fi

print_topic "create development directories"
if [[ $run_all =~ "y" ]] || ask_user_yn "make development folders"; then
	create_folder_if_not_exists "/home/$USER/lib"
	create_folder_if_not_exists "/home/$USER/code"
	create_folder_if_not_exists "/home/$USER/code/python"
	create_folder_if_not_exists "/home/$USER/code/cpp"
	create_folder_if_not_exists "/home/$USER/code/ros_ws"
	create_folder_if_not_exists "/home/$USER/code/shell"
	if not_exists "/home/$USER/code/shell/ubuntu-setup-scripts"; then
		cd /home/$USER/code/shell/
		git clone https://github.com/Zartris/ubuntu-setup-scripts
	fi
fi
print_topic "setup development variables"
if [[ $run_all =~ "y" ]] || ask_user_yn "add git alias (status=st)";then
	print_subtopic_and_run "setting git alias" "git config --global alias.st status"
fi


echo ""
echo ""
echo ""
echo ""
echo "Done with the setup script, to complete apply settings please reboot"
if ask_user_yn "reboot now"; then
	reboot
fi
