#!/bin/bash

# URL of the first page (there are total 1700+ results in multiple pages)
url='http://www.studyg**e*d*a.**m/Colleges/default.asp?Course=****'

# Bad practice(while true), but it will look for next page until it exists
while true
    do  
        # The below command will trap the portion of the html source which 
        # contains links of MCA colleges in that page

        # grep -A1000 -> this will select 1000 lines after the matched string
        # (<table align="center" width="99%">)

        # grep -m1 -B1000 -> this will find first occurence(-m1) of 
        # matched string (</table>) and select 1000 lines above it

        # Piping the output from grep -A1000 to grep -B1000 will lead to 
        # guaranteed trap of our desired <table> tag and its content which
        # is nothing but our college URLs in that page
        allURLs=$(w3m -no-cookie -dump_source $url \
                | grep '<table align="center" width="99%"' -A1500\
                | grep -m1 '</table>' -B1500 | grep -w Details | cut -d '"' -f2)
        # So now allURLs contain all MCA college URLs 
        for each in $allURLs
            do 
                echo $each
				w3m -no-cookie -dump_source  $each | grep  -m1 -A200 "College Name" > tmpHtml
                # Similarly trapping the section of College detail,
                # not with -dump_source but with -dump(text equivalent of html)

                # All these sed's and translates(tr) is to format the details
                # of college provided by below grep command
                # grep -m1 -A30 "College Name"| grep -m1 "E-Mail" -B30

                # This could have been done better in one line if processed
                # properly using regex

               ##  Next 6 statements will generate a csv file with all fields
               # echo $(w3m -no-cookie -dump $each \
               #      | grep -m1 -A30 "College Name"| grep -m1 "E-Mail" -B30\
               #      | sed 's/ /_/g' | sed 's/_\+_/ /g' | sed 's/_\+,/,/g'\
               #      | sed 's/,\+_/,/g' | tr '\n' ';' | sed 's/\;\;/\n/g' \
               #      | sed 's/\; /,/g'| awk '{print $2}' | tr '\n' ';')\
               #      >> mca.csv
			   
			   # College name
			   cat tmpHtml | grep -A5 'College Name' | grep "<strong>"  \
			   | awk -F '<strong>' '{print $2}' | awk -F '</strong>' '{print $1}'>>1.txt

			   # Address 
               cat tmpHtml | grep -A30 'START jOINING ADDRESS' | grep -B30 'END jOINING ADDRESS'\
               | tail -n +2 | head -n -1 | sed s/\<br\>//g |  sed -e 's/^[ \t]*//'>>1.txt

			   # Phone number
			   cat tmpHtml | grep -A30 "Phone" | grep -m1 -A5 '<td align="left">'\
               | grep -B5 '</td>' | head -n2 | tail -1 |  sed -e 's/^[ \t]*//'>>1.txt

			   echo "

-----------------------------------------------------------

               ">>1.txt
            done
        # Explanation of last command ( url=$(w3m -no-cookie ...)    
        # In the first run it will take the first page's URL(available in the 
        # variable url at the top this script) and find link
        # of 'next' button

        # grep -w -> will print the line containing the maching word
        # grep -o -> will select the portion of line maching the exact string

        # The below command will set 'url' variable with the next page URL,
        # which essentially contains 40+ MCA college entries which is taken
        # care by 'for' loop above
        url=$(w3m -no-cookie -dump_source $url \
            | grep -w "class='link'>Next" \
            | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]'\
            | tail -n1 | cut -d "'" -f 2)
    done
 	 rm tmpHtml
	 # This will split 1.txt in two files so that `pr` command make 2 page layout
	 split -l 14000 1.txt
     # This will make it 2 column, see man pr for more details, the only issue is ^M chars	
	 pr -c -t -T -m -w 100 xaa xab > mca-college-addr-2-column.txt
