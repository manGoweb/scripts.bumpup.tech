#!/bin/sh

RED='\033[0;31m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear

EXAMPLE="Example: ${RED}bash <(curl -sSL 'goo.gl/wghTYC')${NC}"

printf "${RED}Starting BumpUp! installation${NC}"
echo ""

API_KEY=$1

if [ -z "$API_KEY" ]; then
   echo "API key can not be empty"
   echo -e $EXAMPLE
   exit
fi

PLIST_PATH=$2

if [ -z "$PLIST_PATH" ]; then
   echo "Path to the a plist file needs to be set"
   echo -e $EXAMPLE
   exit
fi


echo "Downloading code: "
CODE="$(curl --request POST -sSL 'http://localhost/bumpup.tech/scripts/xcode/template.txt')"
printf "Done"
echo "\n"


FILE="./BupmpUp.sh"

rm -rf $FILE
echo $CODE >> $FILE

echo "BumpUp! has been installed. Please use ./build.sh XXXX-XXXXX-XXXXX ./Info.plist to update your version number"
echo ""

exit