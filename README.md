README
___

This is the README file for the my calendar app.

It was adapted from a Community College Tutorial I found on YouTube and I have made some changes to it.

The objecitve is to have a functional calendar that displays some useful information (besides the dates).

It should, for example, display in which days some holidays will fall on. It will also be possible to check out how many holidays tehre will be on other years.

To add a new city follow these instructions:
- Add all the holidays from this city to the database through db:seed
- Add a new radio button to the city.html.erb
- Check if this city celebrates Corpus Christi and update the calendar_helper
- Add the city to the city_array in the controller

Things to do in the future:
- Setup the code so that if the holiday names appear inside the calendar or under it
- Allow people to log in and chose some dates to add (their birthdays, appoitments, etc.)
