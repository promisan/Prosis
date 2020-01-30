
<cfparam name="url.FunctionId" 	 default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.CompetenceId" default="">
<cfparam name="url.Action" 		 default="">

<cfif url.action eq "insert">

	 <cfquery name="AddCompetence" 
	 datasource="AppsSelection" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	INSERT INTO FunctionOrganizationCompetence
		VALUES (
			'#URL.FunctionId#',
			'#URL.CompetenceId#',
			'#SESSION.Acc#',
			'#SESSION.First#',
			'#SESSION.Last#',
			GETDATE()
		)
	 
	 </cfquery>

<cfelseif URL.Action eq "delete">

	<cfquery name="DeleteCompetence" 
	 datasource="AppsSelection" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	DELETE FROM  FunctionOrganizationCompetence
		WHERE  FunctionId = '#URL.FunctionId#' AND CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
</cfif>

<font color="0080FF">
	<b>Saved</b>
</font>