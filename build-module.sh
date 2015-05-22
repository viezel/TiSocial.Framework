##
## Build an Appcelerator iOS Module
## Then copy it to the default module directory
##
## (c) Napp AS
## Mads Møller
##


## How to run the script
## Execute the following command inside terminal from the root folder of your project:
## bash ./build-module.sh
##
##


## clean build folder
find ./build -mindepth 1 -delete

## compile the module
./build.py

## where is manifest
FILENAME='./manifest'


## FIND MODULE ID
MODULE_ID=$(grep 'moduleid' $FILENAME -m 1)
MODULE_ID=${MODULE_ID#*: } # Remove everything up to a colon and space

## FIND MODULE VERSION
MODULE_VERSION=$(grep 'version' $FILENAME -m 1) ## only one match
MODULE_VERSION=${MODULE_VERSION#*: } # Remove everything up to a colon and space

## Delete the old build if existing
rm -rf /Users/$USER/Library/Application\ Support/Titanium/modules/iphone/$MODULE_ID/$MODULE_VERSION/*

## unzip compiled module
unzip -o ./$MODULE_ID-iphone-$MODULE_VERSION.zip -d /Users/$USER/Library/Application\ Support/Titanium


## Optional: You could run a app now - using your new module
PROJECT_PATH='/Titanium/TiSocialTester'
cd $PROJECT_PATH
titanium clean
titanium build -p iphone -T simulator