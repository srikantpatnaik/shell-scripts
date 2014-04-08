#!/bin/bash

for each in `cat emails_aakashlabs_competition_with_passwd1.csv`
	do
	# get password
	password=$(echo $each | cut -d ',' -f1)
	team_number=$(echo $each | cut -d ',' -f2)
	addr=$(echo $each | cut -d ',' -f3-)

	mailtxt="\n Dear participant,\n\n

		Hope you have completed your project. \n\n
		
		Please read the instructions given at http://aakashlabs.org/uploads/instructions.pdf \n
		Your team number is $team_number.\n
		Your password is $password.\n
		Use this link to fill the submission form. \n
		And, use this link to upload apk.\n\n\n
		
		Regards,\n
		Aakash team,\n
		IIT Bombay

		
         "
	echo -e $mailtxt > tmpfile
	mail -s "IMP: Submission instructions for aakashlab project" -S from="Aakash lab<info@aakashlabs.org>" $addr  <tmpfile
	echo "sending mail to $addr"
	sleep 1
    done 


