
<cfparam name="url.editionid" default="0">

<!--- based on the defined funds and the enabled OE codes for the class we show a list of OE and
allow the user to submit a date until which the budget will need to be release per plan target 



then based on the submission we loop through the requirements and set the AmountAllotment based on the date

if no detail the based on the date
if details based on the pro-rata
if the current amount is higher we do not touch it

--->

