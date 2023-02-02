#!/bin/bash

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'


echo -e "\033[1;31m
    ,---,                                                 
  .'  .' \`\\                                               
,---.'     \\    ,---.     ,---.         ,----,            
|   |  .\`\\  |  '   ,'\\   '   ,'\\      .'   .\`|            
:   : |  '  | /   /   | /   /   |  .'   .'  .'      .--,  
|   ' '  ;  :.   ; ,. :.   ; ,. :,---, '   ./     /_ ./|  
'   | ;  .  |'   | |: :'   | |: :;   | .'  /   , ' , ' :  
|   | :  |  ''   | .; :'   | .; :\`---' /  ;--,/___/ \\: |  
'   : | /  ; |   :    ||   :    |  /  /  / .\`| .  \\  ' |  
|   | '\` ,/   \\   \\  /  \\   \\  / ./__;     .'   \\  ;   :  
;   :  .'      \`----'    \`----'  ;   |  .'       \\  \\  ;  
|   ,.'                          \`---'            :  \\  \\ 
'---'                                              \\  ' ; 
                                                    \`--\`  
\033[0m"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "   Enumeration made easier with the Doozy Enumerator"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo -e "${green}For cheatsheets and more: https://navkang.github.io/Doozy${clear}"
echo
echo -e "${red}====================================================================================================${clear}"
echo

echo -e "${yellow}Enter the target URL or IP address:${clear} "
read target
echo
echo -e "${red}====================================================================================================${clear}"
echo
echo -e "${green}..........Starting nmap scan..........${clear}"
echo
# run the first nmap scan and store the results
ports=$(nmap -p- --min-rate=1000 -T4 $target | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//) 

# display the results of the first nmap scan
echo -e "${blue}These are the open ports for the host: $ports ${clear}"
echo -e "${yellow}-------------------------------------------------------------------------${clear}"
# run the second nmap scan with the specified options
nmap -p$ports -sV -sC $target > nmap_results.txt

cat nmap_results.txt
echo
echo -e "${red}====================================================================================================${clear}"
echo

echo -e "${green}..........Starting gobuster scan..........${clear}"
echo
gobuster dir -u $target -w /usr/share/wordlists/dirb/common.txt | grep "Status: 200\|Status: 301\|Status: 302"
echo
echo
echo -e "${green}Please note you may need to run additional gobuster scans: see below${clear}"
echo "gobuster dir -u $target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-lowercase-2.3-small.txt"
echo -e "${green}Also consider using -x to search for extensions (ie .txt .php)${clear}"
echo
echo -e "${red}====================================================================================================${clear}"
echo
echo -e "${green}..........Starting gobuster virtual host scan..........${clear}"
echo
gobuster vhost -u $target -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
echo
echo -e "${green}You may need to use -size flag to remove unwanted results${clear}"
echo -e "${red}====================================================================================================${clear}"
echo
echo -e "${green}..........Starting nikto scan..........${clear}"
echo
echo -e "${green}Please note the Nikto scan can take some time - you can press CTRL c to exit the scan${clear}"
echo
nikto -host $target
echo
echo -e "${red}====================================================================================================${clear}"
echo
echo "Scans complete,thank you for using The Doozy Enumerator"

echo -e "${red}====================================================================================================${clear}"
echo
echo -e "${red}WARNING: Please ensure you have the correct permissions to use this tool against your target. Otherwise it can land you in big trouble!${clear}"
