
<cfset link = "ProgramREM/Application/Program/Donor/Contribution/ContributionWorkflow.cfm?AjaxId=#URL.ajaxid#">
	
<cf_ActionListing 
	EntityCode       = "EntDonor"	
	EntityGroup      = "" 
	EntityStatus     = "0"			
	ObjectKey4       = "#URL.ajaxid#"
	ObjectURL        = "#link#"
	AjaxId           = "#URL.ajaxid#"
	Show             = "Yes" 
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "Yes">

