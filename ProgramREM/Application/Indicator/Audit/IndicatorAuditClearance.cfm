<HTML><HEAD>
	<TITLE>Indicators</TITLE>
</HEAD>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="5" topmargin="5" rightmargin="2">

Work in Progress : Facility for evaluation

<!---

<!--- headers and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset #CLIENT.Verbose# = #URL.Verbose#>
<cfset Caller = "IndicatorAuditClearance.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&SubPeriod=#URL.SubPeriod#">

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Program
WHERE ProgramCode = '#URL.ProgramCode#'
</cfquery>

<body leftmargin="5" topmargin="5" rightmargin="3">

<table width="100%" border="1" bordercolor="#C0C0C0" rules="rows"><tr><td>

<cfif #Check.ProgramClass# eq 'Program'>
	<cfinclude template="../../Program/ProgramViewHeader.cfm">
<cfelse>
	<cfinclude template="../../Program/ComponentViewHeader.cfm">
</cfif>

<cf_dialogREMProgram>

<cfset link = "http://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>

<cf_ActionListing 
    EntityCode      = "EntIndicator"
	EntityClass     = "Standard"
	OrgUnit         = "#Program.OrgUnit#"
    ObjectReference = "#Program.ProgramName#"
    ObjectKey1      = "#Program.ProgramCode#"
	ObjectKey2      = "#Program.Period#"
	ObjectKey3      = "#URL.SubPeriod#"
	ObjectURL       = "#link#">

	--->
	
</BODY></HTML>