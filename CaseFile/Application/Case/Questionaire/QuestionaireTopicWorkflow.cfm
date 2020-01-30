<cfoutput>
	
	<cfquery name="check" datasource="AppsCaseFile">
		SELECT *
		FROM   stQuestionaireContent
		WHERE  TopicId = '#url.ajaxid#'		
	</cfquery>	
	
	<cfquery name="Claim" 
	datasource="AppsCaseFile">
		SELECT    *
		FROM     Claim
		WHERE    ClaimId = '#check.topicid#' 
	</cfquery>
	
	<cfset wflink = "CaseFile/Application/Case/Attachment/ClaimDocumentWorkflow.cfm?topicid=#url.ajaxid#">
				
	<cf_ActionListing 
		EntityCode       = "ClmNoticasDocument"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#claim.mission#"
		OrgUnit          = "#claim.orgunit#"
		PersonNo         = "#Claim.Personno#" 
		PersonEMail      = "#Claim.ClaimantEmail#"
		ObjectReference  = "Document : #Claim.CaseNo#"
		ObjectReference2 = ""						
		ObjectKey4       = "#url.ajaxid#"
		ObjectURL        = "#wflink#"
		Show             = "Yes"
		ToolBar          = "No"
		AjaxId           = "#url.ajaxid#"
		CompleteFirst    = "No"
		CompleteCurrent  = "No">
					

</cfoutput>