#!/bin/sh
# Program: training.sh 
# Created by: Sampurn Rattan 
# Purpose: train tesseract with the popsies cursive font
# Version : 0.1  
# Date: 2016-12-25  
# Dependencies: 
#      1. tesseract (=3.04)
#
# Modification History:
#
#  When  |   Who    |    What
# ----------------------------------------------------------------------------------
#  
# ----------------------------------------------------------------------------------
# 
# Usage: 
#		sh training.sh
# Parameters: 
#		
#

################################################################
# TODOs:
# Add two parameters: file_type, and file_path
# file_type: 'trained' - if you already have trained data, use it to directly add engine to system.
# file_type: 'rawpdf' - otherwise, provide raw pdf file that contains text in font you desire.
# file_path: fully qualified path of file (depends on file_type) 

ask_user() {
	printf "Continue [Y/n/q]: ";
	read choice

	if [ "$choice" = "Y" ]; then
	    return 0
	elif [ "$choice" = "n" ]; then
	    sleep 3 && ask_user
	elif [ "$choice" = "q" ]; then
	    exit 1
	else
	    echo "Please select Y, n, or q." && sleep 3
	    ask_user
	fi
}

# create a pdf file containing the training fonts
echo "Ensure that the training pdf you provide is updated..."
TRAINING_FILE='/home/sampurn/projects/ICR-R/training/cursive.sumi.exp6.pdf'
lang_type="neelam"
training_dir=$(dirname "$TRAINING_FILE")
filename=$(basename "$TRAINING_FILE")
filename="${filename%.*}"
tif_extension='.tif'
png_extension='.png'
box_extension='.box'
tr_extension='.tr'
tif_file="$filename$tif_extension"
png_file="$filename$png_extension"
box_file="$filename$box_extension"
tr_file="$filename$tr_extension"

cd $training_dir
echo "Converting pdf to tif..."
gs -dNOPAUSE -q -r500 -sDEVICE=tiffg4 -dBATCH -sOutputFile=$tif_file $TRAINING_FILE

echo "Converting pdf to png..."
convert -density 500 $TRAINING_FILE -quality 100 $png_file

echo "Deducing box file from tif file..."
tesseract $tif_file $filename batch.nochop makebox

# WARNING: Manual step
echo "Please verify the box file; and make corrections if necessary..." && sleep 3
ask_user

echo "Compiling trained data..."
tesseract $png_file $filename nobatch box.train
unicharset_extractor $box_file

## font name <italic> <bold> <fixed> <serif> <fraktur>
echo "popsies 0 0 0 0 0" > font_properties
shapeclustering -F font_properties -U unicharset $tr_file
mftraining -F font_properties -U unicharset -O "$lang_type.unicharset" $tr_file
cntraining $tr_file
#

## prefix "relevant" files with our language code
mv inttemp "$lang_type.inttemp"
mv normproto "$lang_type.normproto"
mv pffmtable "$lang_type.pffmtable"
mv shapetable "$lang_type.shapetable"
combine_tessdata "$lang_type."

## copy the created "$lang_type.traineddata to the tessdata folder
## so tesseract is able to find it
sudo cp "$lang_type.traineddata" /usr/local/share/tessdata/
sudo apt-get -qq install -y 