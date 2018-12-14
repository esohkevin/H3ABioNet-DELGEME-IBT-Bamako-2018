# Details on the function
This function queries the PubMed database and returns total count of articles affiliated 
to various institutions in H3ABioNet Node countries and others.

The function is named **esearchdump** 

## Breakdown of parts of the function
```
mkdir -p input output tempo
```

This first part creates three subdirectories in the current working directory which 
will contain input files that will be retained at the end of the analysis, temporary files 
that will be removed after analysis, and final result files.

```
file1="output/count.txt tempo/*.txt count2.txt count1.txt"
qrmk() {
	for f
	  do
	    [ -e "$f" ] && rm "$f"
        done
       }
qrmk $file1
```
This funtion checks and deletes all text files in the subdirectories so that results do no get
appended to already existing files with the same name as new files.

## Typing a query
This function takes 9 variables at a time;
* The first variable ```$1``` is reserved for the search **tag**
> A search tag is the argument that is usually placed in squared brackets in a search strategy.
e.g. In ```Malaria[keyword]```, **keyword** is the tag. In ```Kenya[affiliation]```, **affiliation** is 
the tag. 

You can check out NCBI EUtilities/EDIRECT for more on search strategies, tags and short forms of tags.
e.g. short form for affiliation is AFFL (which is the tag used in this project).

* The 2nd to the 9th variables are reserved for the search words. In this project, they would be the 
H3ABioNet node countries; Sudan, Egypt, Tunisia, Morocco, Mali, Niger, Ghana, Nigeria, Uganda, Kenya, 
Tanzania, Malawi, Botswana, South Africa, and Mauritius.

### Therefore, a typical search using the function would look like this
```
esearchdump AFFL Sudan Egypt Tunisia Morocco Mali Niger Ghana NIgeria

OR

esearchdump affiliation Uganda Tanzania Kenya Malawi Botswana Mauritius South=Africa
```
> **NB:** Note that an equal (=) sign is introduced to make the shell read the two words as one.
Otherwise, South would be one word and Africa a separate word that would be searched separately. The important
point to note is that PubMed treats South=Africa as "South Africa". So either way returns same result.

The next part of the function searches PubMed for papers affiliated to UNiversities/Institutions in each
of the countries. The xml format of the papers is retrieved, and a file of the PMIDs, all authors affiliated
to Kenyan institutions and the respective affiliations is created from information parsed from the xml files.

The PMIDs column (1st column) of the file is then extracted into a new file for each country, and this is 
used to fetch only the papers with author affiliations to institutions of the respective countries.

### Download papers
```
s=$(echo "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9")

for i in $s
do
     	j=$(esearch -db pubmed -query "\"$i\"["$1"]" | efetch -format uid | wc -l)
     	printf '%-15s\t%d\n' "$i" "$j" >> output/count.txt
     	esearch -db pubmed -query "\"$i\"["$1"]" |
     	efetch -format xml >> input/$i.txt
done
```

### Extract PMIDs of papars with affiliation to institutions in the respective countries
```
xtract -input input/$i.txt -pattern PubmedArticle -sep "\t" -PMID MedlineCitation/PMID \
	-block Author -position first -sep "\t" \
	-element "&PMID" LastName,Initials Affiliation | 
	grep "$i" >> input/all$i.txt
	cut -f1 input/all$i.txt > input/pmids$i.txt
```

### Fetch (download) the papers using the previously fetched pmids
```
for ID in `cat input/pmids$i.txt`
do
	efetch -db pubmed -id "$ID" -format xml >> output/pap$i.txt
done
```


