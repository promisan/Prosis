		 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE Claim
		 SET    
          ActionStatus='#Form.Status#'
	     WHERE  ClaimId = '#URL.ClaimID#'
	     </cfquery>


<cfoutput>
<script>
  #ajaxLink('#SESSION.root#/CaseFile/Application/Case/ControlEmployee/ClaimWorkflow.cfm?AjaxId=#URL.ClaimId#')#

</script>			
</cfoutput>