<cfparam name="URL.PositionNo" default="0">
<cfparam name="URL.PublishMode" default="">
<cfparam name="URL.SubmissionEdition" default="">

<cfquery name="setSelection"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SubmissionEditionPosition
		SET    PublishMode = '#PublishMode#'
		WHERE  SubmissionEdition = '#url.SubmissionEdition#'
		AND    PositionNo        = '#url.Positionno#'			
</cfquery>
