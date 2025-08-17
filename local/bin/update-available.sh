#!/bin/bash
stringToLen() {
  STRING="$1"
  LEN="$2"
  if [ ${#STRING} -gt "$LEN" ]; then
    echo "${STRING:0:$((LEN - 2))}.."
  else
    printf "%-${LEN}s" "$STRING"
  fi
}

mapfile -t UPDATES < <(yay -Qu)
TEXT=${#UPDATES[@]}
TOOLTIP="<b>$TEXT  updates </b>\n"
COUNT=`yay -Qu | wc -l`
TOOLTIP+=" <b>$(stringToLen "PkgName" 30) $(stringToLen "Prev Ver." 15) $(stringToLen "Next Ver." 15)</b>\n"
[ "$TEXT" -eq 0 ] && TEXT="" || TEXT=" "

for i in "${UPDATES[@]}"; do
  # shellcheck disable=2046
  UPDATE="$(stringToLen $(echo "$i" | awk '{print $1}') 30)"
  # shellcheck disable=2046
  PREV="$(stringToLen $(echo "$i" | awk '{print $2}') 15)"
  # shellcheck disable=2046
  NEXT="$(stringToLen $(echo "$i" | awk '{print $4}') 15)" # skipping '->' string
  TOOLTIP+="<b> $UPDATE </b>$PREV $NEXT\n"
done
TOOLTIP=${TOOLTIP::-2}

cat <<EOF
{ "text":"$TEXT", "tooltip":"$TOOLTIP"}
EOF
