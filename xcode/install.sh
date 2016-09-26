#!/bin/sh

RED='\033[0;31m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear

EXAMPLE="Example: ${RED}bash <(curl -sSL 'goo.gl/wghTYC') ./Info.plist XXXX-API-KEY-XXXXX-XXXX${NC}"

printf "${RED}Starting BumpUp! installation${NC}"
echo ""

PLIST_PATH=$1

if [ -z "$PLIST_PATH" ]; then
   echo "Path to the a plist file needs to be set"
   echo -e $EXAMPLE
   exit
fi


API_KEY=$2

if [ -z "$API_KEY" ]; then
   CPAR_FORMAT="plain=1"
   API_KEY="$(curl --request POST -sSL 'http://www.bumpup.tech/api/token' --data $CPAR_FORMAT)"
   printf "Using newly generated API key: "
   echo $API_KEY
fi

printf "Downloading code: "
CODE="$(curl --request GET -H 'Cache-Control: no-cache' -sSL 'https://raw.githubusercontent.com/manGoweb/scripts.bumpup.tech/master/xcode/template.sh')"
echo "Done"
echo ""


FILE="./bumpup.sh"

rm -rf $FILE
CODE=$(echo "$CODE" | sed "s/--API_KEY--/$API_KEY/g")
CODE=$(echo "$CODE" | sed 's#--PLIST--#'$PLIST_PATH'#g')
echo -e "$CODE" >> $FILE

printf "Making file executable: "
chmod +x $FILE
echo "Done"
echo ""


echo -e "${RED}BumpUp!${NC} has been ${RED}installed${NC}. Please ${RED}use${NC} your newly generated ${RED}./bumpup.sh${NC} to bump up the version from now on. It holds both, your API key as well as the path to your Info.plist file."
echo ""

exit