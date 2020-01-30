
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityActionParent
		 WHERE Code = '#URL.ID2#'
		 AND EntityCode = '#URL.EntityCode#'
		 AND  Owner = '#url.owner#'
</cfquery>

<script>
	 <cfoutput>
		 window.location = "ActionParent.cfm?EntityCode=#URL.EntityCode#"
	 </cfoutput> 
</script>	