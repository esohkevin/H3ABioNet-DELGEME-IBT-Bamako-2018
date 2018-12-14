#!/bin/bash

# Place the function in your home directory where bash can find it easily.
myfunc="esrchdump.sh"
mvFunc() {
for func
do [ -e "$func" ] && cp "$func" >> $HOME/.myfunction

done
}
mvFunc $myfunc

# Add a line of code into you bashrc file to have bash always activate your
# function once bash is started interactively
echo "source $HOME/.myfunctions" >> $HOME/.bashrc

