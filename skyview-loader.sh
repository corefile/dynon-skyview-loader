#!/bin/bash
## Need to figure out how to use 'diskutil list external' to auto populate usb drive volume names ##
PRIMARY_FD_USB=/Volumes/SKYVIEWPFD
SECONDARY_FD_USB=/Volumes/SKYVIEWSFD
OUTPUT_DIR=./dynon
CHARTDATA_DIR=$OUTPUT_DIR/ChartData
TMP_DIR=./tmp
mkdir -p $TMP_DIR

####################################
##        MENU FUNCTIONS          ##
## I've used 'curl' instead of    ##
## 'wget' as macOS does not come  ##
## with wget instaled by default. ##
## No additiona software required ##
####################################

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
cd $TMP_DIR
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX"/"$PREFIX".Plates1024.PNG.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX"/"$PREFIX".Plates.GEO.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX"/"$PREFIX".FG1024.PNG.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX"/"$PREFIX".FG.GEO.zip
cd -
}


fiftysix_day() {
     echo "Enter this month's prefix number 56 day cycle (4 digits): "
       read -r PREFIX2
     echo "Enter this month's password: "
       read -r PASSWORD2
cd $TMP_DIR       
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".ScannedCharts.sqlite.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".LO.MultiDiskImg.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".HI.MultiDiskImg.zip
curl -LOg http://data.seattleavionics.com/OEM/Generic/"$PREFIX2"/"$PREFIX2".SEC.MultiDiskImg.zip
cd -
}

dynon_aviation_obstacles_db() {
     echo "Downloading Dynon Aviation and Obstacles Databases..."
      aviation_obstacles_path=$(curl -s https://www.dynoncertified.com/us-aviation-obstacle-data.php | grep -m 1 software\/data\/.*\.duc | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
      aviation_obstacles_filename=$(echo $aviation_obstacles_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
      aviation_obstacles_uri=$(echo "https://www.dynoncertified.com/$aviation_obstacles_path")
cd $TMP_DIR
     curl -LOg $aviation_obstacles_uri
cd -
}


all_charts_update() {
    echo ""
  echo "All Charts update (28 and 56 day cycles), and Dynon aviation and Obstacles "
    twentyeight_day
    fiftysix_day
    dynon_aviation_obstacles_db
}


skyview_software_update() {
     echo "Downloading latest Skyview software updates..."
       software_ten_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX1100 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
       software_ten_filename=$(echo $software_ten_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
       software_ten_uri=$(echo "https://www.dynoncertified.com/$software_ten_path")
cd $TMP_DIR
     curl -LOg $software_ten_uri
cd -

## If you cheaped out and only have a 7 inch HDX ;-) then comment out the above and uncomment the block below ##
# software_seven_path=$(curl -s https://www.dynoncertified.com/software-updates-single.php | grep -m 1 HDX800 | sed -n 's/^.*href="\(.*.duc\)".*$/\1/p')
# software_seven_filename=$(echo $software_seven_path | sed -n 's/^.*\/\(.*.duc\)$/\1/p')
# software_seven_uri=$(echo "https://www.dynoncertified.com/$software_seven_path")
#cd $TMP_DIR
#     curl -LOg $software_seven_uri
#cd -
}


all_downloads() {
    echo ""
  echo "Downloading all VFR sections, Aviation/Obstacles DB, GEO reveferenced, IFR charts, Dynon Software"
    all_charts_update
    dynon_aviation_obstacles_db
    skyview_software_update
}

load_to_usb () {
## work in progress - need to move the USB drive logic and make it a menue iteam 
echo "move all new content to USB, data and software, will check USB and only move new files"
## rsync new data or software - but don't blow away old logs, etc ## 
}


full_monty () {
echo "This will backup the USB, download all updates (data and softward), and load to USB drive an only copy new data to USB drive"
all_above
load_to_usb
}


####################
## USB Drive Prep ## 
####################

## need to fix this section for rsync vs original disk image output ##

#echo "Removing old data"
### removing this line to keep engine logs ###
## rm -rf $OUTPUT_DIR
###
#mkdir -p $OUTPUT_DIR
#mkdir -p $CHARTDATA_DIR

#echo "Extracting databases"
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates $TMP_DIR/$PREFIX.Plates.GEO.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/Plates/US $TMP_DIR/$PREFIX.Plates1024.PNG.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG $TMP_DIR/$PREFIX.FG.GEO.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR/FG/US $TMP_DIR/$PREFIX.FG1024.PNG.zip
#unzip -q -o              -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.ScannedCharts.sqlite.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.LO.MultiDiskImg.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.HI.MultiDiskImg.zip
#unzip -q -o -P $PASSWORD -d ./$CHARTDATA_DIR $TMP_DIR/$PREFIX.SEC.MultiDiskImg.zip

#echo "Staging Skyview updates"
#cp $TMP_DIR/$aviation_obstacles_filename $OUTPUT_DIR/
#cp $TMP_DIR/$software_ten_filename $OUTPUT_DIR/
#cp $TMP_DIR/$software_seven_filename $OUTPUT_DIR/


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
$(ColorGreen '4)') Dynon Aviation & Obstacles DB
$(ColorGreen '5)') All Data Updates (Charts, Plates, Diagrams, Obsticals, Sectionals)
$(ColorGreen '6)') Skyview Software Update
$(ColorGreen '7)') All Above
$(ColorGreen '8)') Load to USB
$(ColorGreen '9)') The Full Monty (backup, all updatetes, load to USB)
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
          1) backup_primary_usb_drive ; menu ;;
          2) twentyeight_day ; menu ;;
          3) fiftysix_day ; menu ;;
          4) dynon_aviation_obstacles_db ; menu ;;
          5) all_charts_update ; menu ;;
          6) skyview_software_update ; menu ;;
          7) all_above ; menu ;;
          8) load_to_usb ; menu ;;
          9) full_monty ; menu ;;
          0) exit 0 ;;
          *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

## Call the menu function ##
menu
