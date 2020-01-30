
<cf_screentop height="100%" scroll="Yes" html="No" ValidateSession="No">

<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Laster update installed</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is part of the application framework and defines the menu to be presented to the user accessing the inquiry section of the Module travel Claim
</td></tr>
</table>
</proInfo>

</cfsilent>

<cfset heading = "Travel Claim Inquiry">
<cfset module = "'TravelClaim'">
<cfset selection = "'Inquiry'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/submenu.cfm">
<cfinclude template="../../Tools/submenuFooter.cfm">
