#!/bin/bash
OUTPUT_DIR=./dynon
CHARTDATA_DIR=$OUTPUT_DIR/ChartData
TMP_DIR=./tmp
mkdir -p $TMP_DIR


function backup_usb_drive() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -r 
	echo ""
}

function sectional_update() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -r 
	echo ""
}

function all_charts_update() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -r 
	echo ""
}

function dynon_software_update() {
    echo ""
	echo "Backing up USB Drive to local folder (dynon: "
    rsync -r 
	echo ""
}

function all_above() {
    echo ""
	echo "Backup, update sectional, IFR charts, Dynon Software "
    backup_usb_drive
    sectional_update
    all_charts_update
    dynon_software_update
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
$(ColorGreen '4)') Dynon Software Update
$(ColorGreen '5)') All Above
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) backup_usb_drive ; menu ;;
	        2) sectional_update ; menu ;;
	        3) all_charts_update ; menu ;;
	        4) dynon_software_update ; menu ;;
	        5) all_above ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
