#!/bin/bash

# Create a directory in your home directory to install the application in

createH3A() {

f="H3A-IBT-2018"	
for f
     do [ -e "$f" ] && mkdir -p $f $HOME/
done
}
createH3A $f

# Place the function in your home directory where bash can find it easily
mv .myfunctions $HOME

# Add a line of code into you bashrc file to have bash always activate your
# function once bash is started interactively
echo "source $HOME/.myfunctions" >> $HOME/.bashrc

