
<cfparam name="url.PositionNo" 	 default="">
<cfparam name="url.CompetenceId" default="">
<cfparam name="url.Action" 		 default="">

<cfif url.action eq "true">

	<cfquery name="get" 
	 datasource="AppsEmployee" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	SELECT * FROM  PositionCompetence
		WHERE  PositionNo = '#URL.PositionNo#' 
		AND    CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
	 <cfif get.recordcount eq "0">

		 <cfquery name="AddCompetence" 
		 datasource="AppsEmployee" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">	 
		 
		 	INSERT INTO PositionCompetence
			VALUES (
				'#URL.PositionNo#',
				'#URL.Competenceid#',
				'#SESSION.Acc#',
				'#SESSION.First#',
				'#SESSION.Last#',
				GETDATE()
			)
		 
		 </cfquery>
	 
	 </cfif>

<cfelseif URL.Action eq "false">

	<cfquery name="DeleteCompetence" 
	 datasource="AppsEmployee" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	DELETE FROM  PositionCompetence
		WHERE  PositionNo = '#URL.PositionNo#' AND CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
</cfif>

<font color="0080FF">
	<b>Saved</b>
</font>