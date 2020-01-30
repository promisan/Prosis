
<cfset wflink = "ProgramREM/Application/Program/Events/EventsView.cfm?eventid=#url.ajaxid#">
				
<cfquery name="Event" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    ProgramEvent M,
	        ProgramEventAction P, Ref_ProgramEvent R
	WHERE   P.ProgramEvent = R.Code
	AND     M.ProgramCode  = P.ProgramCode
	AND     M.ProgramEvent = P.ProgramEvent
	AND     P.EventId      = '#url.ajaxid#'	
</cfquery>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Program
	WHERE   ProgramCode = '#event.programcode#'	
</cfquery>
	
<cf_ActionListing 
    EntityCode       = "EntProjectEvent"
	EntityClass      = "#Event.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Program.Mission#"	
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Event.Description#"	
    ObjectKey1       = "#Event.ProgramCode#"
	ObjectKey2       = "#Event.ProgramEvent#"
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "No"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No">



			