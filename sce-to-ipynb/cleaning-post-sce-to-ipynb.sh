# DO NOT EXECUTE THIS FILE. THIS IS JUST A CHEATSHEET

for each in `find all-tbc-lee-books/ -mindepth 2 -maxdepth 2 -type d`; do if [ `ls -1 $each | wc -l` -lt "2" ]; then rm -v $each/*.ipynb; fi; done
find all-tbc-lee-books/ -mindepth 3 -maxdepth 3 -type f -iname  \*.sce | xargs rm
find all-tbc-lee-books/ -mindepth 3 -maxdepth 3 -type f -iname  \*.sci | xargs rm
rm -r all-tbc-lee-books/A_Brief_Introduction_to_Fluid_Mechanics_by_D_F_Young/
for each in `find all-tbc-lee-books/ -mindepth 3 -maxdepth 3 -type f -iname  \*.ipynb`; do mv -v $each $(echo $each | cut -d '/' -f -2)/; done
find all-tbc-lee-books/ -mindepth 2 -maxdepth 2 -type d | xargs rm -r
