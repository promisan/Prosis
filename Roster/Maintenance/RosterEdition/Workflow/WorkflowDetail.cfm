<!--- workflow --->  
<cfquery name="getEdition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Ref_SubmissionEdition
	 WHERE SubmissionEdition = '#URL.ajaxid#'	 
</cfquery>

<cfset link = "Roster/RosterSpecial/RosterView/RosterView.cfm?edition=#url.ajaxid#">			

<cf_ActionListing 
    EntityCode       = "RosterEdition"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	tablewidth       = "100%"
	Owner            = "#getEdition.Owner#"		
	ObjectReference  = "Roster Edition"
	ObjectReference2 = "#getEdition.EditionDescription#" 	
    ObjectKey1       = "#url.ajaxid#"	
	AjaxId           = "#URL.ajaxId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	HideCurrent      = "No">