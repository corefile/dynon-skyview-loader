#!/bin/bash
PRIMARY_FD_USB=/Volumes/SKYVIEWPFD
SECONDARY_FD_USB=/Volumes/SKYVIEWSFD
OUTPUT_DIR=./dynon
CHARTDATA_DIR=$OUTPUT_DIR/ChartData
TMP_DIR=./tmp
mkdir -p $TMP_DIR


function backup_usb_drive() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -Pavn $PRIMARY_FD_USB/* dynon/
	echo ""
}

function sectional_update() {
  echo "Enter this month's prefix number (4 digits): "
read PREFIX

echo "Enter this month's password: "
read PASSWORD

wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.SEC.MultiDiskImg.zip
}

function all_charts_update() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -r 
	echo ""
}

function dynon_aviation_obstacles_db() {
echo "Downloading Dynon Aviation and Obstacles Databases..."
software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
wget -P $TMP_DIR --no-clobber $software_ten_uri
}

function skyview_software_update() {
echo "Downloading latest Skyview software updates..."
software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
wget -P $TMP_DIR --no-clobber $software_ten_uri
}

function all_above() {
    echo ""
	echo "Backup, update sectional, IFR charts, Dynon Software "
    backup_usb_drive
    sectional_update
    all_charts_update
    dynon_aviation_obstacles_db
    skyview_software_update
}

##
# Color  Variables
##
green='\x1B[32m'
blue='\x1B[34m'
clear='\x1B[0m'
bold=$(tput bold)
##
# Color Functions
##

ColorGreen(){
	echo $green$1$clear
}
ColorBlue(){
	echo $blue$1$clear
}
BoldTitle (){
	echo $bold$1$clear
}
menu(){
echo "
$(BoldTitle 'Dynon Skyview') 
$(ColorGreen '1)') Backup USB Drive
$(ColorGreen '2)') Sectionals Update
$(ColorGreen '3)') All Charts Update
$(ColorGreen '4)') Dynon Aviation & Obstacles DB
$(ColorGreen '5)') Skyview Software Update
$(ColorGreen '6)') All Above
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) backup_usb_drive ; menu ;;
	        2) sectional_update ; menu ;;
	        3) all_charts_update ; menu ;;
		4) dynon_aviation_obstacles_db ; menu ;;
	        5) skyview_software_update ; menu ;;
	        6) all_above ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
