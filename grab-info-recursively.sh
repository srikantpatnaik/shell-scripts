#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# This program is intended to write/copy images to any media or drive. The
# only dependency to this script is 'zenity'. In most of the GNOME based
# desktops zenity will present, for other desktop environments you need to 
# install it using your package manager. 

## This script can download all relevant information from linked web pages 
## recursively till the end of the content. I used it to download college
## addresses and stored them in a csv file


# URL of the first page (there are total 1700+ results in multiple pages)
url='http://some-URL.html/'

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
                | grep '<table align="center" width="99%"' -A1000\
                | grep -m1 '</table>' -B1000 | grep -w href | cut -d '"' -f2)
        # So now allURLs contain all MCA college URLs 
        for each in $allURLs
            do 
                echo $each
                # Similarly trapping the section of College detail,
                # not with -dump_source but with -dump(text equivalent of html)

                # All these sed's and translates(tr) is to format the details
                # of college provided by below grep command
                # grep -m1 -A30 "College Name"| grep -m1 "E-Mail" -B30

                # This could have been done better in one line if processed
                # properly using regex
                echo $(w3m -no-cookie -dump $each \
                     | grep -m1 -A30 "College Name"| grep -m1 "E-Mail" -B30\
                     | sed 's/ /_/g' | sed 's/_\+_/ /g' | sed 's/_\+,/,/g'\
                     | sed 's/,\+_/,/g' | tr '\n' ';' | sed 's/\;\;/\n/g' \
                     | sed 's/\; /,/g'| awk '{print $2}' | tr '\n' ';')\
                     >> all-address.csv
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

