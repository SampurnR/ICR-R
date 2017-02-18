#!/bin/bash
# Program: installations.sh 
# Created by: Sampurn Rattan 
# Purpose: Install tesseract 3.04 (with its training tools), along with its dependencies
# Version : 1.0  
# Date: 2016-12-24  
# Dependencies: 
#      1. R (>3.0)
#	   2. All other dependencies are being installed here
#
# Modification History:
#
#  When  |   Who    |    What
# ----------------------------------------------------------------------------------
#  
# ----------------------------------------------------------------------------------
# 
# Usage: 
#		sh installations.sh
# Parameters: 
#		
#

echo "Running apt-get update..."
sudo apt-get -qq update -y

echo "Installing Leptopnica and Tesseract dependencies..."
sudo apt-get -qq install -y libpng12-dev libjpeg62-dev libtiff4-dev zlib1g-dev
sudo apt-get -qq install -y libicu-dev libpango1.0-dev libcairo2-dev
sudo apt-get -qq install -y gcc g++
sudo apt-get -qq install -y autotools-dev autoconf automake libtool checkinstall build-essential

echo "Fetching and compiling Leptonica..." && sleep 3
cd /tmp
wget http://www.leptonica.org/source/leptonica-1.72.tar.gz
tar -xvf leptonica-1.72.tar.gz
cd leptonica-1.72
./configure
make
sudo make install

echo "Installing Tesseract with training tools..." && sleep 3
cd /tmp
wget https://github.com/tesseract-ocr/tesseract/archive/3.04.00.tar.gz
tar -xvf 3.04.00.tar.gz
cd tesseract-3.04.00
./autogen.sh
./configure
make
sudo make install
make training
sudo make training-install
sudo ldconfig

echo "Fetching English (eng) trained data..."
cd /usr/local/share/tessdata
sudo wget https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata
sudo apt-get -qq install -y 

echo "Installing the R package..." && sleep 3
sudo su - -c "R -e \"install.packages('tesseract', repos='http://cran.rstudio.com/')\""

echo "Downloading jTessBoxEditor..."
sudo wget "http://downloads.sourceforge.net/project/vietocr/jTessBoxEditor/jTessBoxEditor-1.0.zip?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fvietocr%2Ffiles%2FjTessBoxEditor%2F&ts=1482783057&use_mirror=excellmedia"

# TODOs:
# install opencpu

echo "Installations complete!"

