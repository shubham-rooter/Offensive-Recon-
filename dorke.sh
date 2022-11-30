#!/bin/bash


version="v1"								
updatedate="Nov 20,2022"				    
example_domain="example.com "
sleeptime=6									
domain=$1 									
browser='Mozilla'	
gsite="site:$domain" 						

## Login pages
lpadmin="inurl:admin"
lplogin="inurl:login"
lpadminlogin="inurl:adminlogin"
lpcplogin="inurl:cplogin"
lpweblogin="inurl:weblogin"
lpquicklogin="inurl:quicklogin"
lpwp1="inurl:wp-admin"
lpwp2="inurl:wp-login"
lpportal="inurl:portal"
lpuserportal="inurl:userportal"
lploginpanel="inurl:loginpanel"
lpmemberlogin="inurl:memberlogin"
lpremote="inurl:remote"
lpdashboard="inurl:dashboard"
lpauth="inurl:auth"
lpexc="inurl:exchange"
lpfp="inurl:ForgotPassword"
lptest="inurl:test"
loginpagearray=($lpadmin $lplogin $lpadminlogin $lpcplogin $lpweblogin $lpquicklogin $lpwp1 $lpwp2 $lpportal $lpuserportal $lploginpanel $memberlogin $lpremote $lpdashboard $lpauth $lpexc $lpfp $lptest)

## Filetypes
ftdoc="filetype:doc"						
ftdocx="filetype:docx"						
ftxls="filetype:xls"						
ftxlsx="filetype:xlsx"						
ftppt="filetype:ppt"						
ftpptx="filetype:pptx"						
ftmdb="filetype:mdb"						
ftpdf="filetype:pdf"						
ftsql="filetype:sql"						
fttxt="filetype:txt"						
ftrtf="filetype:rtf"						
ftcsv="filetype:csv"						
ftxml="filetype:xml"						
ftconf="filetype:conf"						
ftini="filetype:ini"						
ftdat="filetype:dat"						
ftlog="filetype:log"						
ftidrsa="index%20of:id_rsa%20id_rsa.pub"	
filetypesarray=($ftdoc $ftdocx $ftxls $ftxlsx $ftppt $ftpptx $ftmdb $ftpdf $ftsql $fttxt $ftrtf $ftcsv $ftxml $ftconf $ftdat $ftini $ftlog $ftidrsa)

## Directory traversal
dtparent='intitle:%22index%20of%22%20%22parent%20directory%22' 	
dtdcim='intitle:%22index%20of%22%20%22DCIM%22' 					
dtftp='intitle:%22index%20of%22%20%22ftp%22' 					
dtbackup='intitle:%22index%20of%22%20%22backup%22'				dtmail='intitle:%22index%20of%22%20%22mail%22'					
dtpassword='intitle:%22index%20of%22%20%22password%22'			
dtpub='intitle:%22index%20of%22%20%22pub%22'					
dirtravarray=($dtparent $dtdcim $dtftp $dtbackup $dtmail $dtpassword $dtpub)

# Header
echo -e "\n\e[00;33m#########################################################\e[00m"
echo -e "\e[00;33m#                                                       #\e[00m" 
echo -e "\e[00;33m#\e[00m" "\e[01;32m               InfoSecWarrior Google Dorks Scan                \e[00m" "\e[00;33m#\e[00m"
echo -e "\e[00;33m#                                                       #\e[00m" 
echo -e "\e[00;33m#########################################################\e[00m"
echo -e ""

# Check domain
	if [ -z "$domain" ] 
	then
		echo -e "\e[00;33m# Usage example:\e[00m" "\e[01;31m$0 $example_domain \e[00m\n"
		exit
	else
			echo -e "\e[00;33m# Get information about:   \e[00m" "\e[01;31m$domain\e[00m"
			echo -e "\e[00;33m# Delay between queries:   \e[00m" "\e[01;31m$sleeptime\e[00m" "\e[00;33msec\e[00m\n"
	fi

### Function to get information about site ### START
function Query {
		result="";
		for start in `seq 0 10 40`; ##### Last number - quantity of possible answers
			do
				query=$(echo; curl -sS -b "CONSENT=YES+srp.gws-20211028-0-RC2.es+FX+330" -A $browser "https://www.google.com/search?q=$gsite%20$1&start=$start&client=firefox-b-e")

				checkban=$(echo $query | grep -io "https://www.google.com/sorry/index")
				if [ "$checkban" == "https://www.google.com/sorry/index" ]
				then 
					echo -e "Google thinks you are the robot and has banned you;) How dare he? So, you have to wait some time to unban or change your ip!"; 
					exit;
				fi
				
				checkdata=$(echo $query | grep -Eo "(http|https)://[a-zA-Z0-9./?=_~-]*$domain/[a-zA-Z0-9./?=_~-]*")
				if [ -z "$checkdata" ]
					then
						sleep $sleeptime; # Sleep to prevent banning
						break; # Exit the loop
					else
						result+="$checkdata ";
						sleep $sleeptime; # Sleep to prevent banning
				fi
			done

		### Echo results
		if [ -z "$result" ] 
			then
				echo -e "\e[00;33m[\e[00m\e[01;31m-\e[00m\e[00;33m]\e[00m No results"
			else
				IFS=$'\n' sorted=($(sort -u <<<"${result[@]}" | tr " " "\n")) # Sort the results with unique key
				echo -e " "
				for each in "${sorted[@]}"; do echo -e "     \e[00;33m[\e[00m\e[01;32m+\e[00m\e[00;33m]\e[00m $each"; done
		fi

		### Unset variables
		unset IFS sorted result checkdata checkban query
}
### Function to get information about site ### END


### Function to print the results ### START
function PrintTheResults {
	for dirtrav in $@; 
		do echo -en "\e[00;33m[\e[00m\e[01;31m*\e[00m\e[00;33m]\e[00m" Checking $(echo $dirtrav | cut -d ":" -f 2 | tr '[:lower:]' '[:upper:]' | sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b") "\t" 
		Query $dirtrav 
	done
echo " "
}
### Function to print the results ### END

# Exploit
echo -e "\e[01;32mChecking Login Page:\e[00m"; PrintTheResults "${loginpagearray[@]}";
echo -e "\e[01;32mChecking specific files:\e[00m"; PrintTheResults "${filetypesarray[@]}";
echo -e "\e[01;32mChecking path traversal:\e[00m"; PrintTheResults "${dirtravarray[@]}";

