			
	<cfquery 
	name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim C, ClaimLine CL, Ref_ClaimCategory R
		WHERE C.ClaimId = CL.ClaimId
		AND   CL.ClaimCategory = R.Code
		AND   CL.ClaimLineId = '#URL.ajaxid#'	
	</cfquery>
	
	<cfif claim.recordcount eq "1">
	
	<cfset link = "CaseFile/Application/Claim/CaseView/ClaimView.cfm?claimid=#Claim.claimId#">
						
	<cf_ActionListing 
		EntityCode       = "Clm#Claim.ClaimType#Line"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		Mission          = "#claim.mission#"
		OrgUnit          = "#claim.orgunit#"
		PersonNo         = "" 
		PersonEMail      = "#Claim.ClaimantEmail#"
		ObjectReference  = "Insurance Claim Line: #Claim.Description#"
		ObjectReference2 = ""
		ObjectKey4       = "#Claim.ClaimLineId#"
		ObjectURL        = "#link#"
		Show             = "Yes"
		AjaxId           = "#URL.ajaxId#"
		Toolbar          = "No"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "No"
		CompleteCurrent  = "No">
		
	</cfif>	
		