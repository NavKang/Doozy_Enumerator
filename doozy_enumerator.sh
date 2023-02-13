#!/usr/bin/env bash

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
    
function run_nmap
{
    echo
    echo -e "${red}====================================================================================================${clear}"
    echo
    echo -e "${green}..........Starting nmap scan..........${clear}"
    echo
    # run the first nmap scan and store the results
    ports=$(nmap -p- --min-rate=1000 -T4 "$target" | grep ^[0-9] | cut -d '/' -f 1 | tr '\n' ',' | sed s/,$//)

    # display the results of the first nmap scan
    echo -e "${blue}These are the open ports for the host: $ports ${clear}"
    echo -e "${yellow}-------------------------------------------------------------------------${clear}"
    # run the second nmap scan with the specified options
    nmap -p$ports -sV -sC $target | tee  nmap_results.txt

    echo
    echo -e "${red}====================================================================================================${clear}"
    echo
}

function run_gobuster_ffuf
{
    echo -e "${green}..........Starting gobuster scan..........${clear}"
    echo
    gobuster dir -u "$target" -w /usr/share/wordlists/dirb/common.txt | grep "Status: 200\|Status: 301\|Status: 302"
    echo
    echo
    echo -e "${green}Please note you may need to run additional gobuster scans: see below${clear}"
    echo "gobuster dir -u $target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt | grep "Status: 200\|Status: 301\|Status: 302 "
    echo
    echo -e "${red}====================================================================================================${clear}"
    
    echo
    echo -e "${green}..........Starting ffuf virtual host scan..........${clear}"
    echo
    ffuf -c -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -u http://$target -H "Host: FUZZ.$target"
    echo
    echo -e "${green}Try: ffuf -c -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-10000.txt -u http://$target -H "Host: FUZZ.$target"${clear}"
    echo -e "${red}====================================================================================================${clear}"
    
    echo
    echo -e "${green}..........Starting gobuster scan with extensions .php, .zip, .txt..........${clear}"
    echo
    gobuster dir -u "$target" -w /usr/share/wordlists/dirb/big.txt -x .php, .txt, .zip | grep "Status: 200\|Status: 301\|Status: 302"
    echo
    echo
    echo -e "${green}Always try other wordlists, just copy and paste the below for further scans${clear}"
    echo -e "${green}Also try adding further extensions${clear}"
    echo "gobuster dir -u $target -w /usr/share/wordlists/dirb/common.txt -x .php, .txt, .zip"
    echo "gobuster dir -u $target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-small.txt -x .php, .txt, .zip"
    echo
    #echo -e "${green}..........DNS Mode Gobuster with IPs..........${clear}"
    #echo
    #gobuster -m dns -u $target -t 100 -w /usr/share/wordlists/dirb/common.txt -i
    #echo
}

function run_nikto
{
    echo -e "${green}..........Starting nikto scan..........${clear}"
    echo
    echo -e "${green}Please note the Nikto scan can take some time - you can press CTRL c to exit the scan${clear}"
    echo
    nikto -host "$target"
    echo
    echo "If you find HTTP running on more ports, ensure you run Nikto against them too"
    echo -e "${red}====================================================================================================${clear}"
    echo
    echo "Scans complete,thank you for using The Doozy Enumerator"

    echo -e "${red}====================================================================================================${clear}"
    echo
    echo -e "${red}WARNING: Please ensure you have the correct permissions to use this tool against your target. Otherwise it can land you in big trouble!${clear}"

}
function main
{
    run_nmap
    run_gobuster_ffuf
    run_nikto
}

# check there is one argument
if [ $# -ne 1 ]
  then
    echo "No arguments supplied"
    echo "Please supply a target"
    echo "Example: ./doozy_enumerator.sh -t=127.0.0.1"
    exit 1
fi

# check -t argument was supplied
if [[ "$1" != "-t="* ]] && [[ "$1" != "--target="* ]]
  then
    echo "Please supply a target"
    echo "Example: ./doozy_enumerator.sh -t="
    exit 1
fi


for i in "$@"
do
    case $i in
        -t=*|--target=*)
        target="${i#*=}"
        shift
        ;;
    esac
done

main "$target"
