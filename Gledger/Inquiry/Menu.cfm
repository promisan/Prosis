
<cf_submenutop>

<cf_submenuLogo module="Accounting" selection="Inquiry">

<cfset heading   = "Statements">
<cfset module    = "'Accounting'">
<cfset selection = "'Reporting'">
<cfset class     = "'Main'">

<cfinclude template="../../Tools/Submenu.cfm">

<cfquery name="ClassList"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      DISTINCT MenuClass
	FROM        Ref_ModuleControl
	WHERE       SystemModule = 'Accounting' 
	AND         FunctionClass IN ('Inquiry', 'Reporting') 
	AND         Operational = 1 
	AND         MenuClass NOT IN ('Main','Journal', 'Payables', 'Receivables')
	ORDER BY MenuClass
</cfquery>

<cfoutput query="ClassList">
	
	<cfset heading = "#menuclass# Views">
	<cfset selection = "'Inquiry','Reporting'">
	<cfset class = "'#menuclass#'">		
	
	<cfinclude template="../../Tools/Submenu.cfm">

</cfoutput>


