
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program P,
	        ProgramPeriod Pe, 
			ProgramPeriodReview R
	WHERE   P.ProgramCode = Pe.ProgramCode
	AND     R.ProgramCode = Pe.ProgramCode
	AND     R.Period      = Pe.Period
	AND     R.ReviewId = '#url.ajaxid#'   	
</cfquery>

<cfquery name="Cycle" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ReviewCycle
	WHERE     CycleId = '#Program.ReviewCycleId#'  
</cfquery>	

<cfset link = "ProgramREM/Application/Program/ReviewCycle/ReviewCycleView.cfm?reviewid=#URL.Ajaxid#">

<cf_ActionListing 
    EntityCode       = "EntProgramReview"
	EntityClass      = "#Cycle.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	AjaxId           = "#url.ajaxid#"	
	OrgUnit          = "#Program.OrgUnit#"
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Program.Reference#"
    ObjectKey1       = "#Program.ProgramCode#"
	ObjectKey2       = "#Program.Period#"
	ObjectKey4       = "#url.ajaxid#"
	ObjectURL        = "#link#">