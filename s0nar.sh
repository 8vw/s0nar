#!/bin/bash
# Description: S0nar is a very simple (and kinda noisy) information gathering tool written to automate the most utilized steps to get info about external web applications.
# Author:      Murilo Monteiro, send-me some @ at https://twitter.com/8vw
# Current      Version: 1.0 (Initial Version)
# Depedences:  To properly run S0nar you need: Curl, xdg-open, python, wafw00f, Nmap and Fierce installed.
# Warning      I will not respond by YOUR ACTS and Every tool used here have they LEGAL warnings and "copyright" stuff, so... read the manuals and OBEY.
# Thanks to:   Miguel Targa, all you guys who keep writing awesome tools.


### Start the Magic Stuff

	
#Print a nice banner.
banner(){ 
echo -e "\033[36m
   /   _     / _   _  
    / (_) |\/ (_\ |    
          |	  v1.0 beta - @8vw
\033[0m"
}

banner

#Check the user external IP Address FYI..."

echo " [*] Getting your external IP Address, FYI..."

curl ifconfig.me

echo  -e " [*] ⇈ This is you. It's always good to know."

#Get the target.

recebeAlvo(){

echo -e "\e[33;1m [-] Please Sir, tell me the target \n (without http(s)://www.) for example: \e[m \n \033[1m\033[31m target.com \e[33;1m"	

read alvo 

}

recebeAlvo

#Validate the target.

if [[ $alvo =~ ^(http|https):// ]]; then

banner

echo -e "\033[1m\033[31m [-] \e[33;1m Don't use http(s)://. \e[m \n"

recebeAlvo

else

  echo -e "\e[33;1m [*] We are good to go! \e[m"
 
fi

#Unleash the tools against the target.

echo -e "\e[33;1m [*] Running Wafw00f to find Web Application Firewall, if we find something, you will be warned. \e[m" 

./wafw00f.py $alvo | 2>&1 grep "is behind a \n"

echo -e "\e[33;1m [*] Google Dorking \e[m" $alvo "\e[33;1m Go check your Browser! \e[m"

#Best known Google Dorks

{

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"ext:php"+"OR"+"ext:asp"+"OR"+"ext:aspx"+"OR"+"ext:jsp" 

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"ext:xml"+"OR"+"ext:txt"+"OR"+"ext:shtml"+"OR"+"ext:cfm"+"OR"+"cgi"+"OR"+"ext:do"+"OR"+"ext:swf"+"OR"+"ext:stm"+"OR"+"phtml"+"OR"+"ext:ph3"+"OR"+"ext:fcgi"+"OR"+"stm"+"OR"+"ext:jhtml"+"OR"+"ext:story" #Search others files to try Sqli, RE SWF and others

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"intitle:index.of"+"OR"+"parent directory"+"OR"+"index of" #Search for Directory Indexing

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"(more information | not found) (error | warning)" #Try find errors on aplication

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"inurl:temp | inurl:tmp | inurl:backup | inurl:bak |" #Searck for backup's

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"intranet | help.desk" #Nice to find intranet and Help Desk interfaces

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"inurl:ip-address-lookup"+"OR"+"inurl:domaintool" #Usefeull to find subdomains

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"intext:@$alvo" #Search E-mails

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.$alvo"+"filetype:xls | filetype:xlsx | filetype:csv | filetype:txt | filetype:doc | filetype:docx | filetype:ppt | filetype:pptx | filetype:pdf" #Search Office files

#Others Useful Online Check-Tools.

xdg-open "http://sitecheck.sucuri.net/results/"$alvo

xdg-open "http://www.shodanhq.com/search?q=$alvo"

xdg-open "https://www.xssposed.org/search/?search=$alvo&type=host"

xdg-open "http://www.zone-h.org/archive/filter=1/fulltext=1/domain=$alvo"

xdg-open "https://pastebin.com/search?q=$alvo"

xdg-open "https://www.google.com.br/safebrowsing/diagnostic?site="$alvo

xdg-open "https://www.google.com/search?q=$alvo%20site:.pastie.org"

xdg-open "https://www.google.com.br/search?hl=pt&q=site:.codepad.org"+"$alvo"

} &> /dev/null # Hide browser errors on terminal

echo -e '\e[33;1m [*] Nmaping... \e[m' $alvo

sudo nmap -A -sS -n -Pn $alvo 

echo -e '\e[33;1m [*] Slow searching subdomains with subbrute on:' $alvo 'this gonna take a while'

./subbrute.py $alvo

echo -e '\e[33;1m [-] ) ) ) S0nar is over.'

notify-send ') ) ) S0nar is over.' 



