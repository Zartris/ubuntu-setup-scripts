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
	start_subtopic $first_arg
	$run_script
	end_subtopic $first_arg
}

start_subtopic(){
	print_str=$1
	echo --------------------------------------------------------------
	echo \>\>\>\>\>\>\>\>\>\>\>\>\>\>\>\> $print_str
	echo --------------------------------------------------------------
}

end_subtopic(){
	print_str=$1
	echo -------------------- $print_str Done -------------------------
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



print_topic "setup locale to UTF-8:"
echo "Make sure you have a locale which supports UTF-8."
echo "If you are in a minimal environment (such as a docker container), the locale may be something minimal like POSIX." 
echo "We test with the following settings. However, it should be fine if you’re using a different UTF-8 supported locale."
echo " "
locale 
echo " "
if [[ $run_all =~ "y" ]] || ask_user_yn "setup locale to UTF-8 (check if all is already UTF-8, if not we can install it now)"; then
	print_subtopic_and_run "apt update" "sudo apt update"
	print_subtopic_and_run "apt install locales" "sudo apt install locales"
	print_subtopic_and_run "locale-gen en_US en_US.UTF-8" "sudo locale-gen en_US en_US.UTF-8"
	print_subtopic_and_run "update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8" "sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8"
	print_subtopic_and_run "export LANG=en_US.UTF-8" "export LANG=en_US.UTF-8"
	print_subtopic_and_run "print locale" "locale"
fi

print_topic "Setup Sources:"
echo "You will need to add the ROS 2 apt repositories to your system."
echo "To do so, first we need to authorize our GPG key with apt and then add the repository to list."
echo " "
if [[ $run_all =~ "y" ]] || ask_user_yn "setup source"; then
	start_subtopic "Authorizing our GPG key"
	echo "install dependencies (curl gnupg2 and lsb-release):"
	sudo apt update && sudo apt install curl gnupg2 lsb-release
	echo "saving keyring"
	sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
	end_subtopic "Authorizing our GPG key"
	start_subtopic "Adding the repository to your sources list"
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
	echo "echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu \$(source /etc/os-release && echo \$UBUNTU_CODENAME) main\" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null"
	end_subtopic "Adding the repository to your sources list"
fi


print_topic "Install ROS 2 packages:"
echo " "
if [[ $run_all =~ "y" ]] || ask_user_yn "install ROS 2 foxy now"; then
	start_subtopic "Installing ROS 2 foxy"
	echo "Update your apt repository caches after setting up the repositories."
	echo "sudo apt update:"
	sudo apt update
	echo "Done updating"
	echo " "
	echo "Chose version to install:"
	echo "1: Desktop Install (Recommended): ROS, RViz, demos, tutorials."
	echo "2: ROS-Base Install (Bare Bones): Communication libraries, message packages, command line tools. No GUI tools."
	echo " "
	echo " "
	echo -n "insert number to install? (1 or 2)?"
	read answer
	case $answer in
		1)
			echo "Installing Desktop Install"
			sudo apt install ros-foxy-desktop
			;;
		2)
			echo "Installing ROS-Base Install"
			sudo apt install ros-foxy-ros-base
			;;
		*)
			echo "$answer is not an option, not sure how to proceed so we will exit now."
			end_subtopic "Installing ROS 2 foxy"
			exit 1 # Error
			;;
	esac
	end_subtopic "Installing ROS 2 foxy"
	source /opt/ros/foxy/setup.bash
	if ask_user_yn "Do you want me to add it to bashrc"; then
		echo "#ROS 2 Foxy variables:" >> /home/$USER/.bashrc
		echo "source /opt/ros/foxy/setup.bash" >> /home/$USER/.bashrc
		echo " " >> /home/$USER/.bashrc
		echo " " >> /home/$USER/.bashrc
	fi
fi







