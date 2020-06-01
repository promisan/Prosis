<!--- To be reviewed by Kristhian --->

<cfif attributes.banner eq "blank">
	<cfset bg = "">
<cfelseif attributes.banner eq "yellow">
	<cfset bg = "BGV7.jpg">
<cfelseif attributes.banner eq "blue">
	<cfset bg = "BGV6.jpg">	
<cfelseif attributes.banner eq "bluedark">
	<cfset bg = "BGV11.jpg">
<cfelseif attributes.banner eq "gradient">
	<cfset bg = "BGV8.jpg">
<cfelseif attributes.banner eq "gray">
	<cfset bg = "BGV9.jpg">
<cfelse>
	<cfset bg = "BGV7.jpg">
</cfif>