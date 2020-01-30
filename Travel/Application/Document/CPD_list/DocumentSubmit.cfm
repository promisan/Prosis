<!--- 
	Travel/Application/Document/CPD_List/DocumentSubmit.cfm
	
	Processing for for CPD List view form
	
	Called by: 	Travel/Application/Document/CPD_List/Document.cfm
	
--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Generate CPD Deployment Tracking</title>
</head>

<body onLoad="window.focus()">

<!---
<cfset actionform = 'cpdlist'>

<cfquery name="FormAction"  datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM  FlowActionForm
	WHERE   ActionForm = 'CPD_list'
</cfquery>
--->

<!--- redisplay form --->
<cfoutput>
<script language="JavaScript">
	window.location = "document.cfm?ID=#Form.documentno#" 
</script>
</cfoutput>
 
<!--- Create Request Fax doc on the file server  --->
<cfquery name="Parameter" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter WHERE Identifier = 'A'
</cfquery>

<cfquery name="Report" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT *  FROM FlowActionReport
	WHERE ActionForm = 'CPD_list'
	AND ReportName = 'CPD_list'
</cfquery>

<cfoutput>
<cfset URL.ID = #form.documentno#>

<cfsavecontent variable="Test">
  <cfinclude template="Templates/#report.ReportTemplate#">
</cfsavecontent>

<!--- ---------------------------------------------------------------------- --->	
<!--- ---------------------------------------------------------------------- --->
<!--- ---------------------------------------------------------------------- --->	
	
<cfif DirectoryExists("\\secap852\Document\travel\#form.documentno#\")>
		
        <!--- skip--->
				
<cfelse>  	
						  
      <cfdirectory 
			  action   = "CREATE" 
		      directory= "\\secap852\Document\travel\#form.documentno#\">
				  
</cfif>		

<cfif form.flag EQ "3">
	<cffile action="WRITE" file="\\secap852\document\travel\#form.documentno#\C309_#Report.OutputName#" output="#Test#" addnewline="Yes">
<cfelse>
	<cffile action="WRITE" file="\\secap852\document\travel\#form.documentno#\C409_#Report.OutputName#" output="#Test#" addnewline="Yes">
</cfif>
</cfoutput>

<!---
<cfoutput>
<cflocation url = "#CLIENT.root#Travel/Application/Document/CPD_list/Document.cfm?ID=#form.documentno#">
</cfoutput>
--->

</body>
</html>