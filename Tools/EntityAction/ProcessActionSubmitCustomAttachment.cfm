<!--- validate enforce custom attachment to be 
provided which are explicityly enabled for this Step in the workflow (aka custom field --->

<cfquery name="Attachment" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	SELECT   R.*
	FROM     Ref_EntityActionPublishDocument AS W INNER JOIN
             Ref_EntityDocument AS R ON W.DocumentId = R.DocumentId
	WHERE    W.ActionPublishNo = '#Object.ActionPublishNo#' 
	AND      W.ActionCode = '#Action.ActionCode#' 
	AND      R.DocumentType = 'Attach' 
	AND      R.FieldRequired = '1'
	 
</cfquery>	 
	
<cfoutput query="Attachment">

	<!--- perform the validation --->
	
	<cfquery name="Check" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	
		SELECT       *
		FROM         Attachment
		WHERE        Reference = '#Object.Objectid#' 
		AND          FileStatus <> '9' AND FileName LIKE '#DocumentCode#%'
		
	</cfquery>	
			
	<cfif check.recordcount eq "0">
		
		  <cf_message message = "You need to upload an attachment for: #DocumentDescription#">
		  <cfabort>
	
	</cfif>
	
</cfoutput>
		