#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages

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
TOOLTIP=" $TEXT  updates\n"
TOOLTIP+=" $(stringToLen "PkgName" 30) $(stringToLen "Prev Ver." 15) $(stringToLen "Next Ver." 15)\n"
[ "$TEXT" -eq 0 ] && TEXT="" || TEXT=" "

for i in "${UPDATES[@]}"; do
  UPDATE="$(stringToLen "$(echo "$i" | awk '{print $1}')" 30)"
  PREV="$(stringToLen "$(echo "$i" | awk '{print $2}')" 15)"
  NEXT="$(stringToLen "$(echo "$i" | awk '{print $4}')" 15)" # skipping '->' string
  TOOLTIP+=" $UPDATE $PREV $NEXT\n"
done
TOOLTIP=${TOOLTIP::-2}

if [ ${#UPDATES[@]} -ne 0 ]; then
    echo -e "\e[32m\n The following updates are available:\e[0m"
    echo -e "${TOOLTIP}"
    # for line in $(yay -Qu); do
    #     echo -e "\t${line}"
    # done
    if gum confirm "Update ${COUNT} system packages"; then
        yay -Syu --noconfirm

        # Offer to reboot if the kernel has been changed
        if [ "$(uname -r | sed 's/-arch/\.arch/')" != "$(pacman -Q linux | awk '{print $2}')" ]; then
            gum confirm "Linux kernel has been updated. Reboot?" && sudo reboot now
        fi
    else
        echo -e "\e[32m\n Updates canceled\e[0m"
    fi
else
    echo -e "\e[32m\n No updates available\e[0m"
fi
show-done.sh
