#!/bin/sh

printers="manjaro-printer"

echo "- Installing printer support"
sudo pacman -Syu "$printers"
echo "- Adding your user to sys group"
sudo gpasswd -a "$USER" sys
echo "- Enabling printer service"
sudo systemctl enable --now org.cups.cupsd.service
echo -e "All done, you can now go to http://localhost:631/"
echo "In the Administration tab you can add and manage local or networked printers and jobs.\n"

echo "Done."
