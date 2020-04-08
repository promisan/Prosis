
<cfparam name="MenuClass" default="'Main'">
<cfparam name="Heading" default="">
<cfparam name="url.id" default="">
<cfparam name="uniqueheader" default="">

<cfquery name="Parameter" 
datasource="AppsSystem">
	SELECT   *
	FROM     Parameter
</cfquery>

<cfif uniqueheader eq "">

	<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes">
	<cfajaximport tags="cfform,cfwindow,cfdiv">
</cfif>

<style>

	table.rpthighLight {
		BACKGROUND-COLOR: #f3f3f3;		
		border : 1px solid white;
	}
	table.rptnormal {
		BACKGROUND-COLOR: #ffffff;
		border : 1px solid white;
	}
	
</style>

<cfif uniqueheader eq "">
	<cf_submenuLogo module="#url.id#" selection="Reports">
</cfif>

<!--- script file --->
<cfinclude template="SubmenuReportScript.cfm">

<!--- menu listing if authorised --->
<cfinclude template="SubmenuReportList.cfm">


