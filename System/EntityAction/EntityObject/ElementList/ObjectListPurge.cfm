
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityDocumentItem
		 WHERE DocumentId = '#URL.DocumentId#'
		 AND DocumentItem = '#URL.ID2#'
</cfquery>

<cfinclude template="ObjectList.cfm">
