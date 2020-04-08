
<cfparam name="URL.showdivision" default="no">
<cfset thisGendermodule = "#url.id#">

<cfinclude template="determineMission.cfm">	

<cfset vTemplate 			= "#getMParam.Template#">
<cfif getMParam.showDivision eq "1">
	<cfset url.showDivision 	= "yes">
<cfelse>
	<cfset url.showDivision 	= "no">
</cfif>
<cfset url.currentmenu 		= "#getMParam.Gendermodule#">

<cfif url.id neq "Disclosure">
	<cfinclude template="filters.cfm">
</cfif>

<div id="statsDetail">
	<cfinclude template="#vTemplate#">
</div>	 