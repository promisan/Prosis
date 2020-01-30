<cfquery name="Claim" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Claim
		WHERE ClaimId = '#URL.ajaxid#'	
	</cfquery>
	
	 <cfquery name="ClaimTypeClass" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Ref_ClaimTypeClass
			WHERE   ClaimType = '#Claim.ClaimType#'	
			AND     Code      = '#Claim.ClaimTypeClass#'
	  </cfquery>
	
	<cfif claim.recordcount eq "1">
	
		<cfset link = "CaseFile/Application/Claim/CaseView/CaseView.cfm?claimid=#Claim.claimId#">
	
		<cf_tl id="Detail" var="1">
		 
		<cf_ActionListing 
			EntityCode       = "Clm#Claim.ClaimType#"
			EntityClass      = "#ClaimTypeClass.EntityClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			Mission          = "#claim.mission#"
			OrgUnit          = "#claim.orgunit#"
			PersonNo         = "" 
			PersonEMail      = "#Claim.ClaimantEmail#"
			ObjectReference  = "#lt_text#: #Claim.DocumentNo#"
			ObjectReference2 = ""
			ObjectKey4       = "#Claim.ClaimId#"
			ObjectURL        = "#link#"
			Show             = "Yes"
			AjaxId           = "#Claim.ClaimId#"
			Toolbar          = "#tool#"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "No"
			CompleteCurrent  = "No">
					
	</cfif>	
