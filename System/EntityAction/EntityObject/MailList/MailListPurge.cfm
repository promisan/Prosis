
<cfquery name="Delete" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_EntityDocumentRecipient
		 WHERE DocumentId = '#URL.DocumentId#'
		 AND RecipientId = '#URL.ID2#'
</cfquery>

<cfinclude template="MailList.cfm">
