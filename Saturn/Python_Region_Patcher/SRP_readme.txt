===================================================================
SRP (Saturn Region Patcher) v3.0 Gold Edition © Madroms - 2004-2009
===================================================================

=======================================================
http://madroms.satakore.com -=- http://www.satakore.com
=======================================================

This tool is a Saturn Region Patcher (SRP) for Sega Saturn images.

What you must know about it:

- Works only on Windows
- Developed in VB.NET so you need the .NET Framework v1.1 installed
- Virtually works with all formats of image files. If you find one that doesn't work, please let me know
- You can patch your image with any area codes, despite Sega only use JTU after some times to determine the country
- Area codes will always be patched in this order: J-T-U-B-K-A-E-L to be compliant with the rule (so if you want U & J for your image, it will be patched to JU & not UJ)
- There is a limit for the number of area codes you want to put on an image. This limit is written in the "maximum" box. When you have checked a number of checkboxes equal to the limit, all the other checkboxes become disabled. To enable them again, just uncheck one checkbox.
- This limit is due to the fact that there are some data just after the last area code in the 2nd sector (where they are in format like "For JAPAN"). The limit avoids the replacement of those data with extra area codes.

If you like it, post it everywhere you can :)

If you find any bugs or have any improvements you want me to add, feel free to e-mail me at madroms<at>free<dot>fr (feedbacks are also welcomed).



===========
What's new:
===========

v3.0 Gold Edition (2009-08-23):
-------------------------------
SRP now works under Windows Vista.
SRP now reconstructs the EDC and ECC fields automatically for RAW Mode images. So no need to use CDmage anymore.
SRP allows direct drag and drop for CD images.
SRP lets you change the header for first and third party. It is only useful for people that own a Sega Saturn boot disc.
SRP links to 2 different databases: the old tech db (that has been migrated from madroms.free.fr to madroms.satakore.com) and the satakore.com games and demos database. I continue to work on each database (the project is NOT over) but I didn't updated the online db yet (at the date of the release of SRP v3.0GE).



v2.1a (2006-08-04):
-------------------
Added 2 internal controls for:
- CDs burnt/mounted with DCP flags
- RAW patched image mounted to a virtual drive



v2.1:
-----
Just modified a little bit the proposed filename when exporting to text file.



V2.0:
-----
1) Ability to check your Saturn CD directly from a CD/DVD Drive.

2) Full Header is now view-able

3) Cd Label is also view-able

4) Number of Tracks is view-able from a Saturn CD (not from a Saturn Image, but check the Hint at point 5)

5) Ability to export information to a text file. Three type of exports are possible:
- Standard Export: Only the most useful information
- Extended Export: Standard export + Full Header
- Full Export: Extended Export + Table of Content
The Full Export is only available when reading header directly from a Saturn CD.

Hint: to get the Full Export available for Saturn image, just mount your image on a virtual drive and re-open SRP => The virtual drive will be available from the list of CD/DVD Drive ;)

For future use or if you plan to send to me the exported TXT file, they are 2 things to do:
- Every time, use the Full Export option
- Don't forget to fill the 2 blank records: "CD Made in" & "Matrix Information"
"CD Made in": just fill in the country/area where the CD has been made. Where to look for such a thing ? => just look at your CD, on the cover art side. You will probably see something like "MADE IN USA" or "EU" or "JAPAN" or "IRELAND"... This is what I need. If this information is not available on the CD, just fill the line with "Unknown".
"Matrix Information" = Numbers & Letters written on the inner serial of the CD. All characters and space are very important (for example, thin space must be reported as little as it is, but multi-space could be trim to one space only).
Here are some example of Matrix Information:
T-6802GP-00759-P1C V IFPI L231 [2do Arukotoha Sand-R JPN]
T-21301GP-00744 1M1 C 63 IFPI L223 [3x3 Eyes ~Kyuusei Kousyu~ S CD1 JPN]
*17S* T-9705H IFPI L433 EA [Area 51 USA]
IFPI L238 SATURNT5703H P3H 13 [Bases Loaded '96 - Double Header USA]
T-12305HP-01630 A 12345 [Actua Soccer Club Edition EUR]

For more information about the Matrix, just read the Help file of my Database (http://madroms.Free.fr/db/db.php).


6) Ability to check my Database at http://madroms.free.fr/db/db.php directly from SRP: you can check if I already have the information for the game you test on my Database.
Also, you can easily check if you have a converted image: with the direct link to my Database, you could have 2 cases:
- Some entries found => just compare the area codes on SRP with the ones filled on the Database for each entry found
- No entry found => perform a search on the Database with the title of your tested game and check for the area codes for each entry found, then compare them with the ones on your image.
In this second case, if I have some missing information, you can't directly know if your image has been converted. So you can export to TXT file all the information and send them to me (at my e-mail or post on my forum at http://daiichi.free.fr/forum/); or you could wait I will update my Database with new entries filled.

7) Corrected some minor issues and changed some captions.



V1.1 (2005-01-08):
------------------
Adding some filters in the open dialog box with some common CD Image extensions.
If you want me to add some other ones, just e-mail me.








Thanks goes to all the great guys at saturntorrents, satakore.com & segakore forums & IRC chans.


Special thanks to incrediblehark and Borisz for having tested my little proggy and let me improved it a little bit.