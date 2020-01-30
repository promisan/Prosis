
<cf_submenutop>

<cf_submenuLogo module="TravelClaim" selection="Maintenance">

<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>Laster update installed</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template is part of the application framework and defines the menu to be presented to the user accessing the maintenance section of the Module travel Claim
</td></tr>
</table>
</proInfo>

</cfsilent>

<cfset heading = "Travel Claim Maintenance">
<cfset module = "'TravelClaim'">
<cfset selection = "'Maintain'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/submenu.cfm">

<cfset heading = "Lookup reference">
<cfset module = "'TravelClaim'">
<cfset selection = "'Reference'">
<cfset class = "'Main'">

<cfinclude template="../../Tools/submenu.cfm">

