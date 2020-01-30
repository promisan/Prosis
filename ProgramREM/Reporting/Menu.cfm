
<cf_submenutop>

<cfset attributes.selection = "Inquiry">

<cfif attributes.selection eq "Inquiry">
	<cf_submenuLogo module="Program" selection="Inquiry">
<cfelseif attributes.selection eq "Reports">
	<cf_submenuLogo module="Program" selection="Reports">
</cfif>

<cf_tl id="Inquiry" var="lblInquiry">
<cfset heading   = "#lblInquiry#">
<cfset module = "'Program'">
<cfset selection = "'Graph','Listing'">
<cfset class = "'Main'">
<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Supporting Functions" var="lblSupporting">
<cfset heading   = "#lblSupporting#">
<cfset selection = "'Function'">
<cfinclude template="../../Tools/Submenu.cfm">


<cf_tl id="Summary" var="lblSummary">
<cfset heading   = "#lblSummary#">
<cfset selection = "'Inquiry'">
<cfinclude template="../../Tools/Submenu.cfm">


<cf_tl id="Standard Views" var="lblViews">
<cfset heading   = "#lblViews#">
<cfset selection = "">
<cfset class = "'Builder'">
<cfinclude template="../../Tools/Submenu.cfm">

<cf_tl id="Extended Search (Collection)" var="lblExtended">
<cfset heading = "#lblExtended#">
<cfset selection = "'Search','Listing'">
<cfset class = "'Collection'">
<cfinclude template="../../Tools/Submenu.cfm">

