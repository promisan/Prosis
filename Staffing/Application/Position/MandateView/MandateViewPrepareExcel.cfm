
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<title>Export to Excel</title>

<cfset URL.table1   = "#SESSION.acc#Staffing">
 			
<cfquery name="Layout" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT    ControlId
	FROM      Ref_ReportControl R
    WHERE     FunctionName = 'Facttable: Staffing Table'
	AND       TemplateSQL = 'Application'
</cfquery>

<cfif Layout.recordcount eq "1">
	
	<cfset context       = "application">	
	<cfset URL.ControlId = "#Layout.ControlId#">
	<cfinclude template="../../../../Tools/CFReport/ExcelFormat/FormatExcel.cfm">  

<cfelse>

    <cf_message message = "Export has not been configured ('Staffing'). Operation aborted." 
	            return = "">
    <cfabort>
	
</cfif>
	
	
	
