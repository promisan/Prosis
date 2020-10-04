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
	AND      R.Operational = 1 
	 
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
		
		  <cf_message message = "You are required to attach a document under: <br><span style='color:red;font-size:20px'>#DocumentDescription#</b>" return="false">
		  <cfabort>
	
	</cfif>
	
</cfoutput>
		