
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
	<cfajaximport tags="cfform,cfwindow,cfdiv,CFINPUT-DATEFIELD,CFINPUT-AUTOSUGGEST">
</cfif>

<style>

	table.rpthighLight {
		BACKGROUND-COLOR: #f9f9f9;		
		border-top : 1px solid silver;
		border-right : 1px solid silver;
		border-left : 1px solid silver;
		border-bottom : 1px solid silver;
	}
	table.rptnormal {
		BACKGROUND-COLOR: #ffffff;
		border-top : 1px solid white;
		border-right : 1px solid white;
		border-left : 1px solid white;
		border-bottom : 1px solid white;
	}
	
</style>

<cfif uniqueheader eq "">
	<cf_submenuLogo module="#url.id#" selection="Reports">
</cfif>

<!--- script file --->
<cfinclude template="SubmenuReportScript.cfm">

<!--- menu listing if authorised --->
<cfinclude template="SubmenuReportList.cfm">


