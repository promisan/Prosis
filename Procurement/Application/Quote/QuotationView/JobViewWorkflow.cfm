
<cfoutput>

<cfquery name="Job" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  J.*, R.Description as JobCategoryDescription
	   FROM    Job J LEFT OUTER JOIN Ref_JobCategory R ON  J.JobCategory = R.Code
	   WHERE   J.JobNo = '#url.ajaxid#'	 
</cfquery>

<cfset link = "Procurement/Application/Quote/QuotationView/JobViewGeneral.cfm?Period=#Job.Period#&ID1=#Job.JobNo#">

<!--- if status eq "9", do not initiate a workflow --->

<cfif Job.ActionStatus eq "9">
 <cfset hide = "Yes">
<cfelse>
 <cfset hide = "No">
</cfif> 
				   			   				
<cf_ActionListing 
    EntityCode       = "ProcJob"
	EntityClass      = "#Job.OrderClass#"
	EntityGroup      = "#Job.JobCategory#"
	EnforceWorkflow  = "No"
	EntityStatus     = ""	
	Mission          = "#Job.Mission#"
	OrgUnit          = ""
	HideCurrent      = "#hide#"
	ObjectReference  = "#Job.Description#"
	ObjectReference2 = "#Job.CaseNo#"
	ObjectKey1       = "#Job.Jobno#"	
  	ObjectURL        = "#link#"
	AjaxId           = "#URL.AjaxId#"
	Show             = "Yes"
	ActionMail       = "Yes"
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "99%"
	DocumentStatus   = "0">

</cfoutput>