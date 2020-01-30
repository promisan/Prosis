
<cfparam name="url.functionno"        default="">
<cfparam name="url.submissionedition" default="">
<cfparam name="url.positionno"        default="0">

<cfquery name="setSelection"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SubmissionEditionPosition
		SET    FunctionNo = '#url.functionno#'
		WHERE  SubmissionEdition = '#url.submissionedition#'
		AND    PositionNo        = '#url.positionno#'			
</cfquery>

<cfquery name="getFunction"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   FunctionTitle
		WHERE  FunctionNo = '#url.functionno#'
</cfquery>
						
<cfoutput>
	<font color="0080C0">#getFunction.FunctionDescription#</font>
</cfoutput>						