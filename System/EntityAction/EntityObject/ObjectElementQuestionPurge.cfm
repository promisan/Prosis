<cfquery name="verifyDelete"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM	OrganizationObjectQuestion
	WHERE 	questionId = '#URL.ID2#'
</cfquery>
<cfif verifyDelete.recordCount eq 0>

	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_EntityDocumentQuestion
		WHERE 	documentId = '#URL.ID1#'
		AND 	questionId = '#URL.ID2#'
	</cfquery>
	
</cfif>

<cfoutput>
<script language="JavaScript">   
   ColdFusion.navigate('objectElementQuestionList.cfm?entityCode=#URL.entityCode#&code=#URL.code#&type=#URL.type#','questionListing')            
</script>
</cfoutput>