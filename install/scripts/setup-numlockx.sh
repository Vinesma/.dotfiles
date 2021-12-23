#!/usr/bin/env bash
#
# Setup numlockx

# -- ACT --
sudo sed -i -Ee 's/#?greeter-setup-script=.*/greeter-setup-script=\/usr\/bin\/numlockx on/' \
    /etc/lightdm/lightdm.conf