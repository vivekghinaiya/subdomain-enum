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
curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee 5.txt

#github-subdomains
github-subdomains -d $domain -t /root/tokens -k -o 6.txt

}

subdomain_enum

cat 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt | sort -u | tee uniqd.txt
cat uniqd.txt | httpx | tee live.txt
rm 1.txt 2.txt 3.txt 4.txt 5.txt 6.txt

echo ":::::::: FINISHED ::::::::"
