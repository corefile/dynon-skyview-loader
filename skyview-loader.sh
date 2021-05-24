#!/bin/bash
## Need to figure out how to use 'diskutil list external' to auto populate usb drive volume names ##
PRIMARY_FD_USB=/Volumes/SKYVIEWPFD
SECONDARY_FD_USB=/Volumes/SKYVIEWSFD
OUTPUT_DIR=./dynon
CHARTDATA_DIR=$OUTPUT_DIR/ChartData
TMP_DIR=./tmp
mkdir -p $TMP_DIR

####################
## MENU FUNCTIONS ## 
####################

backup_primary_usb_drive() {
     echo ""
  echo "Backing up USB Drive to local folder (dynon): "
     rsync -Pavn $PRIMARY_FD_USB/* $OUTPUT_DIR/PFD/
     echo ""
}


twentyeight_day() {
     echo "Enter this month's prefix number 28 day cycle (4 digits): "
       read PREFIX
     echo "Enter this month's password: "
       read PASSWORD
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates1024.PNG.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.Plates.GEO.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG1024.PNG.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/$PREFIX/$PREFIX.FG.GEO.zip
}


fiftysix_day() {
     echo "Enter this month's prefix number 56 day cycle (4 digits): "
       read -r PREFIX2
     echo "Enter this month's password: "
       read -r PASSWORD2
wget -P "$TMP_DIR" --no-clobber http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".ScannedCharts.sqlite.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".LO.MultiDiskImg.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".HI.MultiDiskImg.zip
wget -P $TMP_DIR --no-clobber http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".SEC.MultiDiskImg.zip 
}


all_charts_update() {
    echo ""
  echo "All Charts update (28 and 56 day cycles) "
    twentyeight_day
    fiftysix_day
}


dynon_aviation_obstacles_db() {
     echo "Downloading Dynon Aviation and Obstacles Databases..."
       software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
       software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
       software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
     wget -P $TMP_DIR --no-clobber $software_ten_uri
}


skyview_software_update() {
     echo "Downloading latest Skyview software updates..."
       software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
       software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
       software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
     wget -P $TMP_DIR --no-clobber $software_ten_uri
}


all_above() {
    echo ""
  echo "Backup, update sectional, IFR charts, Dynon Software "
    backup_usb_drive
    all_charts_update
    dynon_aviation_obstacles_db
    skyview_software_update
}


####################
## USB Drive Prep ## 
####################

echo "Removing old data"
### removing this line to keep engine logs ###
## rm -rf $OUTPUT_DIR
###
mkdir -p $OUTPUT_DIR
mkdir -p $CHARTDATA_DIR

echo "Extracting databases"
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates $TMP_DIR/$PREFIX.Plates.GEO.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates/US $TMP_DIR/$PREFIX.Plates1024.PNG.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG $TMP_DIR/$PREFIX.FG.GEO.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG/US $TMP_DIR/$PREFIX.FG1024.PNG.zip
unzip -q -o              -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.ScannedCharts.sqlite.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.LO.MultiDiskImg.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.HI.MultiDiskImg.zip
unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.SEC.MultiDiskImg.zip

echo "Staging Skyview updates"
cp $TMP_DIR/$aviation_obstacles_filename $OUTPUT_DIR/
cp $TMP_DIR/$software_ten_filename $OUTPUT_DIR/
cp $TMP_DIR/$software_seven_filename $OUTPUT_DIR/


#################
## MENU CONFIG ## 
#################

## Color  Variables ##

green='\x1B[32m'
blue='\x1B[34m'
clear='\x1B[0m'  
bold=$(tput bold)

## Color Functions ##

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
cat << "EOF"
88888888ba,  8b        d8  888b      88    ,ad8888ba,    888b      88  
88      `"8b  Y8,    ,8P   8888b     88   d8"'    `"8b   8888b     88  
88        `8b  Y8,  ,8P    88 `8b    88  d8'        `8b  88 `8b    88  
88         88   "8aa8"     88  `8b   88  88          88  88  `8b   88  
88         88    `88'      88   `8b  88  88          88  88   `8b  88  
88         8P     88       88    `8b 88  Y8,        ,8P  88    `8b 88  
88      .a8P      88       88     `8888   Y8a.    .a8P   88     `8888  
88888888Y"'       88       88      `888    `"Y8888Y"'    88      `888 
EOF
echo "
$(ColorGreen '1)') Backup USB Drive
$(ColorGreen '2)') IFR Plates, Airport & Fligh Guide Diag, SA Airport Geo (28 day)
$(ColorGreen '3)') VFR Sec, IFR Low/High Charts, Scanned Charts DB (56 day)
$(ColorGreen '4)') All Charts Update
$(ColorGreen '5)') Dynon Aviation & Obstacles DB
$(ColorGreen '6)') Skyview Software Update
$(ColorGreen '7)') All Above
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
          1) backup_primary_usb_drive ; menu ;;
          2) twentyeight_day ; menu ;;
          3) fiftysix_day ; menu ;;
          4) all_charts_update ; menu ;;
          5) dynon_aviation_obstacles_db ; menu ;;
          6) skyview_software_update ; menu ;;
          7) all_above ; menu ;;
          0) exit 0 ;;
          *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

## Call the menu function ##
menu
