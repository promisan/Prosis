
<cfquery name="Delete" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM PositionParentEdition
		 WHERE PositionParentId = '#URL.ID#' and SubmissionEdition = '#URL.ID1#'
</cfquery>

<script>
	 <cfoutput>
	 #ajaxLink('../Edition/Edition.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	