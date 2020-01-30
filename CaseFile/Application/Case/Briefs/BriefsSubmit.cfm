
<cfparam name="Form.PersonNo"        default="">
<cfparam name="Form.OrgUnitClaimant" default="">

 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE Claim
		 SET    ClaimMemo     = '#Form.ClaimMemo#'
		 WHERE  ClaimId = '#URL.ClaimID#' 
	     </cfquery>
			
	<cfoutput>
		<script>	
			#ajaxLink('../Briefs/Briefs.cfm?claimid=#url.claimid#')#					
		</script>	
	</cfoutput>			
	