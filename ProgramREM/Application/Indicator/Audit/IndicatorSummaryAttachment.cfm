
<table width="100%" height="100%" cellspacing="0" cellpadding="0"><tr><td>

<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfparam name="URL.Row" default="1">

<cfquery name="Org"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
SELECT OrgUnit 
 FROM  Organization.dbo.Organization 
 WHERE Mission    = '#URL.Mission#'
  AND  MandateNo  = '#URL.Mandate#'
  AND  HierarchyCode >= '#HStart#' 
  AND  HierarchyCode < '#HEnd#'
</cfquery>						  

<cfinvoke component="Service.Access"
	Method="organization"
	OrgUnit="#Org.OrgUnit#"
	Period="#URL.Period#"
	Role="ProgramManager"
	ReturnVariable="AttachmentAccess">	

<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
SELECT * 
FROM   Parameter
</cfquery>

<cfif AttachmentAccess eq "NONE">

	<cf_filelibraryN
			DocumentPath = "#Parameter.DocumentLibrary#"
			SubDirectory = "#URL.Org#_#URL.Period#" 
			Filter       = ""
			rowheader    = "No"
			Insert       = "no"
			Remove       = "no"
			reload       = "true">	

<cfelse>

	<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#URL.Org#_#URL.Period#" 
			Filter=""
			Insert="yes"
			Remove="yes"
			reload="true">	
		
</cfif>		
</td></tr></table>