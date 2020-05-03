#!/bin/bash


echo "Hello There! Please Wait...."


# SoftwareService
#-------------------------------------------------------------

jq -r '.[] | select(.group == "SoftwareServices")' skype-messages.json > software.json

jq '.messages[] | "\(.displayName) \(.originalarrivaltime)"' -r software.json | column -t -s';' | tr ';' ',' > testagain001.csv

cat testagain001.csv | sed -Ee 's/(.*)post_id/\1page ID post I/' -e 's/,[ ]/,/' -e 's/ /,/' > testagain002.csv 

cut -d 'T' -f1 testagain002.csv |tr -d '"' | column -t > testagain003.csv

perl -ne "print if ( m/2020-04-30/ .. m/2020-04-01/ )" testagain003.csv > testagain004.csv

awk -F, -v OFS='\t' 'NR>1 {k=$(NF-1); d=$2; keys[k]; dates[d]; a[k,d]++}
                        END {line="Name/Date"; 
                             for(d in dates) line = line OFS d; 
                             print line; 
                             for(k in keys) 
                               {{line=k; 
                                 for(d in dates) line=line OFS a[k,d]} 
                                print line}}' testagain004.csv > software-table.xlsx



rm -rf software.json testagain001.csv testagain002.csv testagain003.csv  testagain004.csv



#ActiveNetwork
#-------------------------------------------------------------

jq -r '.[] | select(.group == "ActiveNetwork")' skype-messages.json > activenet.json

jq '.messages[] | "\(.displayName), \(.originalarrivaltime)"' -r activenet.json | column -t -s';' | tr ';' ',' > net001.csv

cut -d 'T' -f1 net001.csv > net002.csv

sed '/^[<spc><tab>]*$/d' net002.csv > net003.csv

perl -ne "print if ( m/2020-04-30/ .. m/2020-04-01/ )" net003.csv > net004.csv 

awk -F, -v OFS='\t' 'NR>1 {k=$(NF-1); d=$2; keys[k]; dates[d]; a[k,d]++}
                        END {line="Name/Date"; 
                             for(d in dates) line = line OFS d; 
                             print line; 
                             for(k in keys) 
                               {{line=k; 
                                 for(d in dates) line=line OFS a[k,d]} 
                                print line}}' net004.csv > network-table.xlsx



rm -rf activenet.json net001.csv net002.csv net003.csv net004.csv

echo "Thanks for your patience. You are ready to go!!"

