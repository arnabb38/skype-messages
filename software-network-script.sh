#!/bin/bash


echo "Hello There! Please Wait...."


# SoftwareService
#-------------------------------------------------------------

# extracting softwareService group from main json file to 'software.json'

jq -r '.[] | select(.group == "SoftwareServices")' skype-messages.json > software.json


# getting only name and message time from the json file to another CSV file

jq '.messages[] | "\(.displayName) \(.originalarrivaltime)"' -r software.json | column -t -s';' | tr ';' ',' > testagain001.csv


# column separating 

cat testagain001.csv | sed -Ee 's/(.*)post_id/\1page ID post I/' -e 's/,[ ]/,/' -e 's/ /,/' > testagain002.csv 


# date formatting

cut -d 'T' -f1 testagain002.csv |tr -d '"' | column -t > testagain003.csv


# getting specific date range (Only APRIL month here)

perl -ne "print if ( m/2020-04-30/ .. m/2020-04-01/ )" testagain003.csv > testagain004.csv


# use AWK to generate table and count value correspondingly

awk -F, -v OFS='\t' 'NR>1 {k=$(NF-1); d=$2; keys[k]; dates[d]; a[k,d]++}
                        END {line="Name/Date"; 
                             for(d in dates) line = line OFS d; 
                             print line; 
                             for(k in keys) 
                               {{line=k; 
                                 for(d in dates) line=line OFS a[k,d]} 
                                print line}}' testagain004.csv > software-table.xlsx


# remove unnecessary files

rm -rf software.json testagain001.csv testagain002.csv testagain003.csv  testagain004.csv



#ActiveNetwork
#-------------------------------------------------------------

# extracting 'Active Network' group from main json file to 'activenet.json'

jq -r '.[] | select(.group == "ActiveNetwork")' skype-messages.json > activenet.json


# getting only name and message time from the json file to another CSV file

jq '.messages[] | "\(.displayName), \(.originalarrivaltime)"' -r activenet.json | column -t -s';' | tr ';' ',' > net001.csv


# date formatting

cut -d 'T' -f1 net001.csv > net002.csv


# removing unnecessary spaces/ special character/ tabs

sed '/^[<spc><tab>]*$/d' net002.csv > net003.csv


# getting specific date range (only APRIL month here)

perl -ne "print if ( m/2020-04-30/ .. m/2020-04-01/ )" net003.csv > net004.csv 


# use AWK to generate table and count value correspondingly

awk -F, -v OFS='\t' 'NR>1 {k=$(NF-1); d=$2; keys[k]; dates[d]; a[k,d]++}
                        END {line="Name/Date"; 
                             for(d in dates) line = line OFS d; 
                             print line; 
                             for(k in keys) 
                               {{line=k; 
                                 for(d in dates) line=line OFS a[k,d]} 
                                print line}}' net004.csv > network-table.xlsx


# removing unnecessary files

rm -rf activenet.json net001.csv net002.csv net003.csv net004.csv


echo "Thanks for your patience. You are ready to go!!"

