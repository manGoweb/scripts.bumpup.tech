#!/bin/sh

RED='\033[0;31m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear

printf "${RED}Starting BumpUp.tech update${NC}"
echo ""

API_KEY="--API_KEY--"

if [ -z "$API_KEY" ]; then
   echo "API key can not be empty"
   echo -e $EXAMPLE
   exit
fi

PLIST_PATH="--PLIST--"

if [ -z "$PLIST_PATH" ]; then
   echo "Path to the a plist file needs to be set"
   echo -e $EXAMPLE
   exit
fi

echo "to update CFBundleVersion in:"
echo $PLIST_PATH
echo ""

echo "Using API key:"
echo $API_KEY
echo ""


BUILD_NO="$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $PLIST_PATH)"
printf "Local build number is: "
echo $BUILD_NO
echo ""

PRODUCT_BUNDLE_IDENTIFIER="$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $PLIST_PATH)"
echo "Bundle identifier:"
echo $PRODUCT_BUNDLE_IDENTIFIER
echo ""

echo "Loading latest version from BumpUp.tech"
CPAR_BUILD_NO="build=$BUILD_NO"
CPAR_API_KEY="token=$API_KEY"
CPAR_PRODUCT_BUNDLE_IDENTIFIER="bundle=$PRODUCT_BUNDLE_IDENTIFIER"
CPAR_FORMAT="plain=1"
NEW_BUILD_NO="$(curl --request POST -sSL 'http://www.bumpup.tech/api/build' --data $CPAR_BUILD_NO --data $CPAR_API_KEY --data $CPAR_PRODUCT_BUNDLE_IDENTIFIER --data $CPAR_FORMAT)"
if [ -z "$NEW_BUILD_NO" ]; then
   echo "You are not connected to the internet. Your build number has been only modified locally\n"
   NEW_BUILD_NO=$(($BUILD_NO + 1))
fi

printf "New build number is: ${RED}"
echo $NEW_BUILD_NO
echo "${NC}"


SET_OUTPUT="$(/usr/libexec/PlistBuddy -c 'Set CFBundleVersion '$NEW_BUILD_NO $PLIST_PATH)"
echo "Plist has been updated"
echo ""

exit