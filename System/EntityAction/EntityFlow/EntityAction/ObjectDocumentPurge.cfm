
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityDocument
		 WHERE DocumentId = '#URL.ID2#'
</cfquery>

<script>
	 <cfoutput>
		 window.location = "ObjectDocument.cfm?EntityCode=#URL.EntityCode#&type=#URL.type#"
	 </cfoutput> 
</script>	