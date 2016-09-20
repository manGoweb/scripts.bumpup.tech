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
CODE="$(curl --request GET -H 'Cache-Control: no-cache' -sSL 'https://raw.githubusercontent.com/manGoweb/scripts.bumpup.tech/master/xcode/template.txt?aa')"
printf "Done"
echo ""
echo ""


FILE="./BumpUp.sh"

rm -rf $FILE
CODE=$(echo "$CODE" | sed "s/--API_KEY--/$API_KEY/g")
CODE=$(echo "$CODE" | sed 's#--PLIST--#'$PLIST_PATH'#g')
echo -e "$CODE" >> $FILE

echo -e "${RED}BumpUp!${NC} has been ${RED}installed${NC}. Please ${RED}use${NC} ${RED}./BumpUp.sh${NC} to bump up the version from now on. It holds both, your API key as well as the path to your Info.plist file."
echo ""

exit