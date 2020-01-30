
<cfif url.checked eq "true">
	
	<cfquery name="TextAreaList"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT TextAreaCode
		FROM   Ref_SubmissionEditionProfile
		WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
		AND    ActionId = '#url.ActionId#' 
		AND    ActionStatus = '0'
	</cfquery>
	
	<cfif TextAreaList.RecordCount eq 0>
	
		<cfquery name="TextAreaList"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			SELECT Code AS TextAreaCode
			FROM   Ref_TextArea
			WHERE  TextAreaDomain = 'Edition'
			
		</cfquery>
	
	</cfif>
	
	
	<cfloop query = "TextAreaList">
	
		<cfquery name="InsertLanguage"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_SubmissionEditionProfile
				(SubmissionEdition,
				LanguageCode,
				TextAreaCode,
				ActionId,
				ActionStatus,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName)
			VALUES('#url.submissionEdition#'
	     		   ,'#url.language#'
	     		   ,'#TextAreaList.TextAreaCode#'
	      		   ,'#url.ActionId#'
				   ,'0'
	      		   ,'#SESSION.Acc#'
	      		   ,'#SESSION.Last#' 
	      		   ,'#SESSION.First#')
		</cfquery>
	
	</cfloop>

<cfelse>

	<cfquery name="DeleteLanguage"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM  Ref_SubmissionEditionProfile
		WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
		AND    ActionId = '#url.ActionId#' 
		AND    LanguageCode = '#url.language#'
	</cfquery>

</cfif>

<cfinclude template="PublishText.cfm">