
<!--- submit edition position --->

<cfif url.action eq "delete">
	
	<cfquery name="getLanguage" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_SubmissionEditionPosition
		SET    RecordStatus        = '9',
			   RecordStatusOfficer = '#session.acc#',
			   RecordStatusDate    = getDate()			
		WHERE  SubmissionEdition   = '#URL.SubmissionEdition#'
		AND    PositionNo          = '#URL.PositionNo#' 		
	</cfquery>
		
<cfelseif url.action eq "update">
		
	<!--- update title --->
	
	<cf_LanguageInput
		TableCode       = "EditionFunctionTitle" 
		Mode            = "save"
		Name1           = "FunctionDescription"
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
	
	<!--- update competences --->
	
	<cfparam name="Form.CompetenceId" default="">
	
	<cfquery name="DeleteCompetence" 
		 datasource="AppsSelection" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">	 
		 	UPDATE Ref_SubmissionEditionPositionCompetence
			SET    Operational = 0
			WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
			AND    PositionNo        = '#URL.PositionNo#' 
			
	</cfquery>
	
	<cfloop index="itm" list="#form.CompetenceId#">
	
		<cfquery name="check" 
		 datasource="AppsSelection" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">	 
		 	SELECT *
			FROM   Ref_SubmissionEditionPositionCompetence		
			WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
			AND    PositionNo        = '#URL.PositionNo#' 
			AND    CompetenceId      = '#itm#'
		</cfquery>
		
		<cfif check.recordcount eq "1">
							
			<cfquery name="DeleteCompetence" 
				 datasource="AppsSelection" 
				 username="#SESSION.Login#" 
				 password="#SESSION.dbpw#">	 
				 UPDATE Ref_SubmissionEditionPositionCompetence
				 SET    Operational       = 1
				 WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
				 AND    PositionNo        = '#URL.PositionNo#' 
				 AND    CompetenceId      = '#itm#'
			</cfquery>
				
		<cfelse>
	
			 <cfquery name="AddCompetence" 
				 datasource="AppsSelection" 
				 username="#SESSION.Login#" 
				 password="#SESSION.dbpw#">	 
				 
				 	INSERT INTO Ref_SubmissionEditionPositionCompetence
					(SubmissionEdition,PositionNo,CompetenceId,OfficerUserId,OfficerLastName,OfficerFirstName)
					VALUES ('#URL.SubmissionEdition#',
							'#URL.PositionNo#',
							'#itm#',
							'#SESSION.Acc#',
							'#SESSION.First#',
							'#SESSION.Last#')
				 
			 </cfquery>
		 
		 </cfif>
	
	</cfloop>
	
</cfif>	

<cfoutput>
<script>    
    parent.reloadPosition('#url.PositionNo#','#url.submissionEdition#')
	parent.ProsisUI.closeWindow('EditEditionPosition');
</script>
</cfoutput>