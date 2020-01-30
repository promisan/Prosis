<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Generate Fax to PM</title>
</head>

<body onLoad="window.focus()">

<cfset actionform = 'Request'>

<cfquery name="FormAction"  datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM  FlowActionForm
	WHERE   ActionForm = 'Request'
</cfquery>

<!--- redisplay form with Request Fax at bottom of the page
<cfoutput>
<script language="JavaScript">
	window.location = "document.cfm?ID=#Form.documentno#"
<!---   window.location = "#FormAction.FormName#?ID=#Form.documentNo#"  --->
</script>
</cfoutput>
 --->
 
<!--- Create Request Fax doc on the file server  --->
<cfquery name="Parameter" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter WHERE Identifier = 'A'
</cfquery>

<cfquery name="Report" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT *  FROM FlowActionReport
	WHERE ActionForm = 'Request'
	AND ReportName = 'RequestToPM'
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

	<cffile action="WRITE" file="\\secap852\Document\travel\#form.documentno#\M102_#Report.OutputName#" output="#Test#" addnewline="Yes">
		
</cfoutput>

<script language="JavaScript">
   window.close()
</script>

<!---
<cfoutput>
<cflocation url = "#CLIENT.root#Travel/Application/Document/Request/Document.cfm?ID=#form.documentno#">
</cfoutput>
--->

<script language="JavaScript">
   opener.location.reload()
 </script>

</body>
</html>