
<!--- get --->

<cfquery name="get" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_SubmissionEditionPosition				
		WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
		AND    PositionNo = '#URL.PositionNo#' 
		AND    RecordStatus = '1'
</cfquery>

<cfif get.recordcount eq "0">

	<font color="FF0000">Revoked</font>

<cfelse>
	
	<cf_LanguageInput
		TableCode       = "EditionFunctionTitle" 
		Mode            = "get"
		Name            = "FunctionDescription"
		Operational     = "1"
		Label           = "Yes"
		Key1Value       = "#url.SubmissionEdition#"
		Key2Value       = "#url.Positionno#"
		Type            = "Input"
		Required        = "Yes"
		Message         = "Please enter a functional title"
		MaxLength       = "80"
		Size            = "60"
		Class           = "regularxl">	
		
	<cfoutput>#lt_content#</cfoutput>	

</cfif>