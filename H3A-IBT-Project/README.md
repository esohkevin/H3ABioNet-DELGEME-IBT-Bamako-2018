# H3ABioNet IBT 2018 Collaborative Project
The project plan and objectives are being updated...

## In this directory
* ```.myfunctions```: This file is basically a mirror of the ```esrchdump.sh``` file. 
* ```esrchdump.sh```: This is the initial script that contains the ***esearchdump*** function.
* ```Setup.sh```: This is the setup file for the application. It exports ```.myfunctions``` to 
your path so that it can be sourced each time shell starts interactively or as login shell.

When ```bash Setup.sh``` is run, the function ```esearchdump``` is activated.

> This assumes that you are running a bash shell. If you are not sure which shell you are 
running, type ```echo $SHELL```. For a bash shell, this will return ```/bin/bash```.
Put the shell you are running in place of *bash* in ```bash Setup.sh```

## What the esearchdump function does

This function queries the pubmed database with country names that one provides and returns the total count of articles affiliated to the various countries.

In brief, the function creates three subdirectories:

_***input***_, ***_output_*** and ***_tempo_***

* ***_tempo_*** will be used to temporarily store all the files that will be created when
the function is run.

* ***_input_*** will store files that will be used as input for downstream processes.

* ***_output_*** will contain all final result files

* The function then clears the tempo directory of any text files since some downstream processes
involve appending or concatenating files together. We wouldn't want to append the contents of
our new file with an already existing file in an event where the file already exists.

* The function then searches the PubMed database for all publications that are affiliated to the
country or countries specified. It counts the uniq PubMed IDs (PMIDs) and makes a file with two
columns (Check file names and content below).

* The function creates a couple of files in the ***_tempo_*** subdirectory and later moves them to 
their corresponding paths based on whether they are result files or input files for further 
steps.

## File names and content
This section is being updated...

---
Please refer to the file ***_esrchdump.sh_*** for the code
