#Reads the job description
#rm links_temp.txt links_temp_filtered.txt links.txt links1.txt filter.txt link2.txt listing.txt job.txt final.txt 
echo "Enter a job: "
read job
echo -e "\n"
#Scrapes the data from the given website and put it in main.html
wget -q -r -l5 -x  main.html https://naukri.com
#filters only the hyperlinks and stores in links_temp.txt
grep -Po '(?<=href=")[^"]*' main.html > links_temp.txt
#Filters the websites in the hyperlinks
grep "^http" links_temp.txt > links_temp_filtered.txt
#removes the duplicate websites 
sort -u links_temp_filtered.txt > links.txt
#Filters only jobs and removes courses and other
grep "job" links.txt > links1.txt
#echo "line 15"
#Filters the links based on your entered description
grep "$job" links1.txt > filter.txt
#echo "line 18"
#kill %1
a=`cat filter.txt`
echo "$a"
#Scrapes the data from each link in temp1.txt
for i in $a
do
	#echo "*"
	wget -q -r -l1 -O scrape.txt $i
done
#Same as line4
#echo "line 27"
grep -Pio '(?<=href=")[^"]*' scrape.txt > link2.txt
#echo "line 29"
grep -i "job-listings-" link2.txt > listing.txt
grep  "$job" listing.txt > job.txt
#echo "line 31"
#Edit the output to readable format
cut -f1 -d "?" job.txt | cut -f4 -d "/" | cut -f 3- -d "-" | rev | cut -f 6- -d "-" | rev | tr "-" " " > final.txt
#echo "line 34"

cat -n final.txt
echo -e "\n\n"

echo "Enter the place"
read place 

grep -i $place job.txt > fin.txt

#Edit the output to readable format
cut -f1 -d "?" fin.txt | cut -f4 -d "/" | cut -f 3- -d "-" | rev | cut -f 6- -d "-" | rev | tr "-" " " > final.txt
echo -e "\n"
cat -n final.txt 
echo -e "\n"
echo "Enter the job number whose description you want: "
read n
echo -e "\n"
count=1
a=`cat fin.txt`
#Traverses till the given job number 
for i in $a
do
	if [ $count -eq $n ]
		then
		break
	fi
	((count=count+1))
done
#Prints the link matching the job number
echo $i
#Entering into the link
wget -q -O link.txt $i
#Get the div.JD to get the job
cat link.txt | hxnormalize -x | hxselect -i "div.JD" | lynx -stdin -dump > final2.txt
cat final2.txt
echo -e "\n"