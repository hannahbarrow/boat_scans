# NCCS Marine Survey Data Entry App
by Hannah Barrow - 2026

I made this data collection app for NCCS (BC Whales) to use on their marine survey 
transects. Therefore, it is consistent with their data entry. 

Now, you will see that in the docs folder, there is also an app titled "boat_entry_app_v1.R". 
This is the original pilot app. I am including it still to keep track of the development 
process and still have record of the original app and original issues that needed 
to be trouble shot. After doing a pilot run in Lewis (raw data from that survey is 
included here with the complications in entering), we saw that there are some important 
changes that need to be made to make it more functional when being put into practice 
because, although you have to do data entry manually later, pen and paper is very 
reliable and easy to use during these surveys. 

**The app that you actually want to run is "boat_entry_app_v2.R".** But there are 
a few things to keep in mind when using the app... 

First, when you run the app on certain devices you may see an error that says 
"Error: argument is of length zero". These are no biggy, they just appear when there 
are inputs that rely on the input of others in order to display. For example, the 
first one that you run into is for the "Trail Name" input that automatically generates 
based on the system date, the "Area" input and the "Survey #" input. But once you 
select your options it will appear. The same goes for "Glare" and for you actual 
sighting inputs on the next page. 

The second thing to keep in mind is that there are a few inputs that are automatic, 
like "Trail Name" that I just mentioned. For these, you will not have to input 
anything at all. The others are "Line" and "Group Size Best Guess". 

Third, there are a few items that appear on both the conditions and the sightings 
input pages. These are meant to make the entry more helpful since the info is split 
between two pages. But again, these are some customization specifically for NCCS 
which could easily be moved/added/removed to customize for your flow. 

There are a few more little things that you will also see messages for in the app its self. 
- The info that you enter will stay the same until you change it, *unless* it is 
one of the inputs that is dependent on another. For example, most of the sightings 
inputs will change if you change the species/vessel type. So remember to change 
the "Species" input first to not lose anything. 
- There is a save button on both the conditions and the sightings pages. Both save 
buttons will save all information into a single row. So you only want to hit the save 
button if you want all of the information to be entered (this is also where some of 
the inputs that appear on both pages are helpful). This also means that if you change 
anything on either page, both save buttons will catch all of it and you do not have 
double anything. 

Alsooooo, the app its self is using the "marine_data.csv" to store the entries in 
real time. After the Lewis pilot run, I renamed the files to the trail names from 
the surveys (eg: 20260915_LP_04.csv) because those are unique to each survey. The 
20260915_LP_04.csv data shows the collection from the first version, when problems 
were run into. 20261001_OTNS_04.csv was data collected after the first use of the second 
version of the app on the Otter/Nepean area. 

I think everything else should be intuitive but I will give it a go and see if there 
is anything else folks should be aware before they use it.

Happy collecting!
