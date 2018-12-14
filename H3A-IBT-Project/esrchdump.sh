#!/bin/bash

esearchdump() {
mkdir -p input output tempo
file1="output/count.txt tempo/*.txt count2.txt count1.txt"
qrmk() {
	for f
	  do
	    [ -e "$f" ] && rm "$f"
        done
       }
qrmk $file1
sleep 2

echo 	"""
	Your search summary: Search word(s): $@
			         Search tag: AFFL (affiliation)
	"""
sleep 2

for i in $@
do
	if 
		[ ! -e input/"$i.all" ]
	then
		echo "Fetching papers for $i Please wait..."
        	sleep 3

        	j=$(esearch -db pubmed -query "\""$i"\"[AFFL]" | efetch -format uid | wc -l)
        	printf '%-15s\t%d\n' "$i" "$j" >> output/count.txt
        	esearch -db pubmed -query "\""$i"\"[AFFL]" |
        	efetch -format xml >> input/$i.all
	else
		echo "$i.all exists! Skipping download for $i"
	fi
	echo "$i" | sed 's/=/ /g' > tempo/$i.gre
done

# Extract PMIDS from all papers with first author affiliation containing corresponding country
echo -e "Done downloading all papers affiliated to input countries!\n"
sleep 3

# Extract PMIDs of papers affiliated to institutions in node countries
echo "Now extracting PMIDs for downloaded papers. Please wait..."
for i in $@
do
	if 
		[ ! -e input/"$i.ids" ]
	then
		
		xtract -input input/$i.all -pattern PubmedArticle -sep "\t" -PMID MedlineCitation/PMID \
        		-block Author -position first -sep "\t" \
        		-element "&PMID" LastName,Initials Affiliation |
        		grep -f tempo/"$i.gre" >> input/all$i.txt
        		cut -f1 input/all$i.txt > input/$i.ids
			echo "Extracting PMIDs for "$i""
	else
		echo "PMIDs already extracted for "$i""
	fi
done

echo -e "Done extracting PMIDs of all papers with first author affiliation to input countries\n"
sleep 3

# Fetch (download) the papers using the previously fetched pmids
echo "Now downloading papers for PMIDs supplied. Please wait..."
sleep 2
for i in $@
do 
	if 
		[ ! -e output/"$i.paps" ]
	then
		for id in `cat input/$i.ids`
		do
			echo Downloading papers for $i
        		efetch -db pubmed -id "$id" -format xml >> output/$i.paps
		done
	else
		echo "Papers already downloaded for "$i""
	fi
done
sleep 3
echo -e "\nAll processes are now completed!"
rm tempo/*
}

