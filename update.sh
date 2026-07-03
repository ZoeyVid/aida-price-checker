#!/usr/bin/env sh

if [ -z "$TZ" ] || ! echo "$TZ" | grep -q "^[A-Za-z/]\+$"; then
    echo "TZ is unset or invalid."
    sleep inf
fi

if [ -z "$CI" ] ||! echo "$CI" | grep -q "^[0-9]\+[smhd]\?$"; then
    echo "CI is unset or invalid, it needs to be a number which can be followed by one of the chars s, m, h or d."
    sleep inf
fi

if [ -z "$AIDs" ] || ! echo "$AIDs" | grep -q "^[A-Z0-9 ]\+$"; then
    echo "AIDs is unset or invalid, it can consist of upper letters A-Z, numbers 0-9 and spaces."
    sleep inf
fi

if [ -z "$AAK" ] || ! echo "$AAK" | grep -q "^[A-Za-z0-9]\+$"; then
    echo "AAK is unset or invalid, it can consist of upper letters A-Z, lower letters a-z and numbers 0-9."
    sleep inf
fi

if [ -z "$AA" ] || ! echo "$AA" | grep -q "^[0-9]\+$"; then
    echo "AA is unset or invalid, it can consist of numbers 0-9."
    sleep inf
fi

if [ -z "$AJ" ] || ! echo "$AJ" | grep -q "^[0-9]\+$"; then
    echo "AJ is unset or invalid, it can consist of numbers 0-9."
    sleep inf
fi

if [ -z "$AC" ] || ! echo "$AC" | grep -q "^[0-9]\+$"; then
    echo "AC is unset or invalid, it can consist of numbers 0-9."
    sleep inf
fi

if [ -z "$CUA" ] || ! echo "$CUA" | grep -q "^[A-Za-z0-9/().;: -]\+$"; then
    echo "CUA is unset or invalid, it can consist of upper letters A-Z, lower letters a-z, numbers 0-9, /().;:- and spaces."
    sleep inf
fi

if [ -z "$ACIDs" ] && [ -z "$ACAIIDs" ]; then
    echo "ACIDs and ACAIIDs are both unset."
    sleep inf
fi

if [ -n "$ACIDs" ] && ! echo "$ACIDs" | grep -q "^[A-Z ]\+$"; then
    echo "ACIDs is invalid, it can consist of upper letters A-Z and spaces."
    sleep inf
fi

if [ -n "$ACAIIDs" ] && ! echo "$ACAIIDs" | grep -q "^[A-Z ]\+$"; then
    echo "ACAIIDs is invalid, it can consist of upper letters A-Z and spaces."
    sleep inf
fi

if [ -z "$TBT" ] || ! echo "$TBT" | grep -q "^[A-Za-z0-9:]\+$"; then
    echo "TBT is unset or invalid, it can consist of upper letters A-Z, lower letters a-z numbers 0-9 and colons."
    sleep inf
fi

if [ -z "$TCIDs" ] || ! echo "$TCIDs" | grep -q "^[0-9 ]\+$"; then
    echo "TCIDs is unset or invalid, it can consist of numbers 0-9 and spaces."
    sleep inf
fi


while true; do
for AID in $(echo "$AIDs" | tr " " "\n"); do

message="\
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID" -A "$CUA" -H "x-api-key: $AAK" | jq -r .itinerary[].name) \
ab \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID" -A "$CUA" -H "x-api-key: $AAK" | jq -r .startDate) \
bis \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID" -A "$CUA" -H "x-api-key: $AAK" | jq -r .endDate) \
($(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID" -A "$CUA" -H "x-api-key: $AAK" | jq -r .duration) Tage) \n\
${AA}x Erwachsen, ${AJ}x Jugendlich und ${AC}x Kind \
"
export message


if [ -n "$ACIDs" ]; then

message="${message}\n\nohne All inclusive:"

for ACID in $(echo "$ACIDs" | tr " " "\n"); do
if [ "$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIO%2CPREMIUM" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACID"'") | .available')" = "true" ]; then

message="${message}\n\
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIO%2CPREMIUM" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACID"'") | .priceModel') \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIO%2CPREMIUM" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACID"'") | .head') \
($ACID): \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIO%2CPREMIUM" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACID"'") | .price')€ \
"
export message

else

message="${message}\nKabinenkategorie $ACID ist nicht verfügbar."
export message

fi
done
fi


if [ -n "$ACAIIDs" ]; then

message="${message}\n\nmit All inclusive:"
export message

for ACAIID in $(echo "$ACAIIDs" | tr " " "\n"); do
if [ "$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIOAI%2CPREMIUMAI" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACAIID"'") | .available')" = "true" ]; then

message="${message}\n\
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIOAI%2CPREMIUMAI" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACAIID"'") | .priceModel') \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIOAI%2CPREMIUMAI" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACAIID"'") | .head'): \
($ACAIID): \
$(curl -sSL "https://iris.cruise-api.aida.de/cruises/$AID?adults=$AA&juveniles=$AJ&children=$AC&priceModels=VARIOAI%2CPREMIUMAI" -A "$CUA" -H "x-api-key: $AAK" | jq -r '.cabinCategories[] | select(.id == "'"$ACAIID"'") | .price')€ \
"
export message

else

message="${message}\nKabinenkategorie $ACAIID ist mit All inclusive nicht verfügbar."
export message

fi
done
fi


echo "$message"
    for TCID in $(echo "$TCIDs" | tr " " "\n"); do
        curl -POST \
         -sH 'Content-Type: application/json' \
         -d '{"chat_id": "'"$TCID"'", "text": "'"$message"'", "disable_notification": true}' \
        https://api.telegram.org/bot"$TBT"/sendMessage
    done

done
sleep "$CI"
done
