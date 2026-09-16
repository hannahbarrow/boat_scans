# NCCS Marine Survey Data Entry App
by Hannah Barrow - 2026

You will see that in the docs folder, there is also an app titled "pilot_boat_entry_app.R". 
This is the original pilot app. I am including it still to keep track of the development 
process and still have record of the original app and original issues that needed 
to be trouble shot. After doing a pilot run in Lewis (raw data from that survey 
with the complications in entering), we saw that there are some important changes 
that need to be made to make it more functional when being put into practice because, 
although you have to do data entry manually later, pen and paper is very reliable 
and easy to use during these surveys. 

**The app that you actually want to run is "boat_entry_app_v2.R".** But there are a few 
things to keep in mind when using the app... 

First, when you run the app you will see error that say "Error: argument is of length zero". 
These are no biggy, they just appear when there are inputs that rely on the input 
of othersin order to display. For example, the first one that you run into is for 
the "Trail Name" input that automatically generates based on the system date, the 
"Area" input and the "Survey #" input. But once you select your options it will 
appear. The same goes for "Glare" and for you actual sighting inputs on the next page. 

The second thing to keep in mind is that there are a few inputs that are automatic, 
like "Trail Name" that I just mentioned. For these, you will not have to input 
anything at all. The others are "Line" and "Group Size Best Guess". 

There are a few more little things that you will also see messages for in the app its self. 
- the info that you enter will stay the same until you change it, *unless* it is 
one of the inputs that is dependent on another. For example, most of the sightings 
inputs will change if you change the species/vessel type. So remember to change 
the "Species" input first to not lose anything. 
- there is only one save button, so if you change anything of either of he pages, 
they single save button will save all of it, don't you worry. 

I think everything else should be intuitive but I will give it a go and see if there 
is anything else folks should be aware of that want to use it.

Happy collecting!
