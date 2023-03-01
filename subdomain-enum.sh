#!/bin/bash
#subdomain enumration

echo "subdomain collecting please wait :> " 

domain=$1

subdomain_enum()
{
#assetfinder
assetfinder --subs-only $domain | anew -q 1.txt

#amass
amass enum -d $domain -passive -o 2.txt

#subfinder 
subfinder -silent -d $domain -all -o 3.txt

#findomain
findomain -t $domain -u 4.txt 

#crt.sh
curl -s https://crt.sh/\?q\=%25.$domain \&output\=json | jq . | grep 'name_value' | awk '{print $2}' | sed -e 's/"//g'| sed -e 's/,//g' |  awk '{gsub(/\\n/,"\n")}1' | sort -u | tee 5.txt

#subscraper
python3 /home/tools/subscraper/subscraper.py $domain --all --censys-id 60788ad0-68b6-4928-b70a-3e370299f7f6 --censys-secret juLbVjGaElccDIERH8REnA6tOs3vgL4p -r 6.txt

#github-subdomains
github-subdomains -d $domain -t /root/tokens -k -o 7.txt 

}

subdomain_enum

cat 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt | sort -u | tee uniqd.txt 
cat uniqd.txt | httpx | tee lived.txt
rm 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt 7.txt

echo "FINISHED ::::::::"
