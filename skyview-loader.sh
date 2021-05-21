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












##
# Color  Variables
##
green='\x1B[32m'
blue='\x1B[34m'
clear='\x1B[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
Dynon Skyview 
$(ColorGreen '1)') Backup USB Drive
$(ColorGreen '2)') Sectionals Update
$(ColorGreen '3)') All Charts Update
$(ColorGreen '4)') Dynon Software Update
$(ColorGreen '5)') Check All
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) backup_usb_drive ; menu ;;
	        2) cpu_check ; menu ;;
	        3) tcp_check ; menu ;;
	        4) kernel_check ; menu ;;
	        5) all_checks ; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
