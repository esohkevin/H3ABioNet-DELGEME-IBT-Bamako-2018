#!/bin/bash

# Create a directory in your home directory to install the application in
filed="H3A-IBT-2018"
createH3A() {
for f
     do 
	[ -e "$f" ] && mkdir -p "$f" $HOME/
done
}
createH3A $filed

# Place the function in your home directory where bash can find it easily.
myfunc=".myfunctions"
mvFunc() {
for func
do
	[ -e "$func" ] && mv "$func" $HOME

done
}
mvFunc $myfunc

# Add a line of code into you bashrc file to have bash always activate your
# function once bash is started interactively
echo "source $HOME/.myfunctions" >> $HOME/.bashrc

