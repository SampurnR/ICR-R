# Program: 
# Created by: Sampurn Rattan 
# Purpose: Test tesseract capabilities
# Version : 0.1  
# Date: 2016-12-15  
# Dependencies: 
#      1. R (>3.0)
#      2. R Packages - tesseract
#	   3. Debian (or equivalent) packages - tesseract-ocr, tesseract-ocr-eng, libtesseract-dev, libleptonica-dev
#
# Modification History:
#
#  When  |   Who    |    What
# ----------------------------------------------------------------------------------
#  
# ----------------------------------------------------------------------------------
# 
# Usage: 
#		
# Parameters: 
#		
#


# if tesseract package is not installed, then install it.
if (!is.element("tesseract", installed.packages()[,1])){
	install.packages("tesseract")
}




library(tesseract)
tes <- tesseract(language = "neelam", options = list(tessedit_dump_choices = "1", textord_heavy_nr = "1"))
text <- ocr("/home/sampurn/projects/ICR-R/training/cursive.neelam.exp5.png", engine = tes)
print(text)

#text2 <- ocr("~/sample_image.png")
#print(text2)

## output -------------------------------------------------
#> source('/home/sampurn/projects/ICR-R/icr-using-tesseract.R')
#[1] "This is a lot of 12 point text to test the\ncor code and see if it works on all types\nof file format.\n\nThe quick brown dog jumped over the\nlazy fox. The quick brown dog jumped\nover the lazy fox. The quick brown dog\njumped over the lazy fox. The quick\nbrown dog jumped over the lazy fox.\n\n"