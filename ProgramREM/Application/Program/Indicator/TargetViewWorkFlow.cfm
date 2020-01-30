
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program P,ProgramPeriod Pe
	WHERE   P.ProgramCode = Pe.ProgramCode
	AND     Pe.ProgramId = '#url.ajaxid#'   	
</cfquery>

<cfif CGI.HTTPS eq "off">
    <cfset protocol = "http">
<cfelse> 
  	<cfset protocol = "https">
</cfif>

<cfset link = "ProgramREM/Application/Program/Indicator/TargetView.cfm?id=#URL.Ajaxid#">

<cf_ActionListing 
    EntityCode      = "EntProgram"
	EntityClass     = "Standard"
	EntityGroup     = ""
	EntityStatus    = ""
	AjaxId          = "#url.ajaxid#"
	Mission         = "#Program.Mission#"
	OrgUnit         = "#Program.OrgUnit#"
	ObjectReference = "#Program.ProgramName#"
    ObjectKey1      = "#Program.ProgramCode#"
	ObjectKey2      = "#Program.Period#"
	ObjectURL       = "#link#">