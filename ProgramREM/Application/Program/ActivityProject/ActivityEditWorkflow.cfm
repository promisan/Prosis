
<cfquery name="Activity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramActivity
	WHERE   ActivityId = '#url.activityid#'	
</cfquery>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program P,
	        ProgramPeriod Pe
	WHERE   P.ProgramCode = Pe.ProgramCode
	AND     Pe.Period      = '#url.Period#'
	AND     P.ProgramCode = '#url.programCode#'	
</cfquery>

<cfset link = "ProgramREM/Application/Program/ActivityProject/ActivityView.cfm?activityid=#URL.ActivityId#">

<cf_ActionListing 
    EntityCode       = "EntProgramAction"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	AjaxId           = "#url.activityid#"
	Mission          = "#Program.Mission#"
	OrgUnit          = "#Program.OrgUnit#"
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Program.Reference#"
    ObjectKey1       = "#Program.ProgramCode#"
	ObjectKey2       = "#Program.Period#"
	ObjectKey3       = "#Activity.ActivityId#"
	ObjectURL        = "#link#">