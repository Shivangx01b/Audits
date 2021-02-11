#!/bin/bash


installations() {

	echo "[+] Echo intalling esentials"
	sudo apt-get -y update
	sudo apt-get install -y libcurl4-openssl-dev
	sudo apt-get install -y libssl-dev
	sudo apt-get install -y jq
	sudo apt-get install -y ruby-full
	sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
	sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
	sudo apt-get install -y python-setuptools
	sudo apt-get install -y libldns-dev
	sudo apt-get install -y python3-pip
	sudo apt-get install -y python-pip
	sudo apt-get install -y python-dnspython
	sudo apt-get install -y git
	sudo apt-get install -y rename
	sudo apt-get install -y xargs
	curl https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

	echo "[+] Installing aquatone"
	go get -u -v github.com/michenriksen/aquatone

	echo "[+] Installing assetfinder"
	go get -u  -v github.com/tomnomnom/assetfinder

	go get -u -v github.com/cgboal/sonarsearch/crobat

	go get -v github.com/dwisiswant0/go-stare

	go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

	go get -u github.com/tomnomnom/httprobe

	go get -v -u github.com/mzfr/takeover

	go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns

	go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
	
	go get -u -v github.com/lukasikic/subzy



}


fetch_resolvers() {

	wget https://raw.githubusercontent.com/Shivangx01b/Fresh-Dns/main/resolvers.txt -O /home/ubuntu/Recon/$1/resolvers.txt
}

Passive_Subdomain_Enumerations () {

	amass enum -passive -silent -d  $1 -o "/tmp/amass_$1.txt"
	assetfinder -subs-only $1 >> "/tmp/assetfinder_$1.txt"
	crobat -s $1 >> "/tmp/crobat_$1.txt"
	subfinder -d $1  -silent -o "/tmp/subfinder_$1.txt"
	bash /home/ubuntu/subs.sh $1
	cat "/tmp/amass_$1.txt" "/tmp/assetfinder_$1.txt" "/tmp/subfinder_$1.txt"  "/tmp/crobat_$1.txt" "/tmp/all_others_$1.txt" | sort -u  >> "/home/ubuntu/Recon/$1/$1_passive.txt"
	rm "/tmp/amass_$1.txt" 
	rm "/tmp/assetfinder_$1.txt" 
	rm "/tmp/subfinder_$1.txt"  
	rm "/tmp/crobat_$1.txt" 
	rm "/tmp/all_others_$1.txt"
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Passive Enumeration for $1 is done"
}

resolve_subs() {

	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Running subdomain resolvers"
	echo "$1"
	shuffledns -d $1 -list "/home/ubuntu/Recon/$1/$1_passive.txt" -r "/home/ubuntu/Recon/$1/resolvers.txt" -silent -o "/home/ubuntu/Recon/$1/$1_subdomains.txt"
	rm "/home/ubuntu/Recon/$1/$1_passive.txt"
	count=$(cat "/home/ubuntu/Recon/$1/$1_subdomains.txt" | wc -l) 
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Found $count domains for $1 in passive mode"
}


takeover_checks() {

	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Running checks for subdomain takeover"
	takeover -l /home/ubuntu/Recon/$1/$1_subdomains.txt -p /home/ubuntu/go/src/github.com/mzfr/takeover/providers.json -t 80 >> "/home/ubuntu/Recon/$1/$1_sustakeover.txt"
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Finished subdomain takeover checks"
}

httprobes() {

	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Running probes for http/https"
	cat "/home/ubuntu/Recon/$1/$1_subdomains.txt" | httprobe -c 80 -p 80,443,8443,8043,8080,8081,8089 >> "/home/ubuntu/Recon/$1/$1_httprobe.txt"
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Finished httprobes"
}

nuclei_checks() {

	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Running nuclei checks"
	for i in $(cat "/home/ubuntu/tests.txt"); do nuclei -l "/home/ubuntu/Recon/$1/$1_subdomains.txt" -t /home/ubuntu/nuclei-templates/$i -silent >> "/home/ubuntu/Recon/$1/$1_nuclei.txt"; done
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Finished nuclei checks"
}



screenshots() {

	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Taking screenshots for $1"
	cat "/home/ubuntu/Recon/$1/$1_httprobe.txt" | go-stare -o "/home/ubuntu/Recon/$1/$1_screenshots"
	tar cvf "/home/ubuntu/Recon/$1/$1_screenshots.tar" /home/ubuntu/Recon/$1/$1_screenshots
	rm -rf "/home/ubuntu/Recon/$1/$1_screenshots"
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Screenshots finished for $1"
}


runner() {

	$1=$(echo $start)
	mkdir ~/Recon/$1
	fetch_resolvers $1
	sleep 3
	Passive_Subdomain_Enumerations $1
	resolve_subs $1
	takeover_checks  $1
	httprobes $1
	nuclei_checks $1
	screenshots $1
	curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=================================================="

}

 
curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Starting ReconDelta"
#installations
for start in $(cat '/home/ubuntu/targets.txt'); do runner $start; done
curl -s -X GET "https://api.telegram.org/bot1348630881:AAHkrJqzeux3uU42opMCKGv78ilGfsUBO64/sendMessage?chat_id=-415374781&parse_mode=Markdown&text=Finished ReconDelta"


