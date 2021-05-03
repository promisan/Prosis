
<cftransaction>

	<cfquery name="get" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_SubmissionEditionPosition
		WHERE   PositionNo        = '#FORM.Key1#'
		AND     SubmissionEdition = '#FORM.EditionSelect#'
	</cfquery>
	
	<cfif get.recordstatus eq "9">
		
		<cfquery name="reset" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE  Ref_SubmissionEditionPosition
			SET     RecordStatus = '1',
				    RecordStatusOfficer = '#session.acc#',
				    RecordStatusDate    = getDate()	
			WHERE   PositionNo        = '#FORM.Key1#'
		    AND     SubmissionEdition = '#FORM.EditionSelect#'
		</cfquery>
	
	<cfelse>
		
		<cfquery name="clear" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE  Ref_SubmissionEditionPosition
			WHERE   PositionNo        = '#FORM.Key1#'
			AND     SubmissionEdition = '#FORM.EditionSelect#'
		</cfquery>
		
		<cfquery name="Position" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT P.* 
			FROM   Employee.dbo.Position P 
			WHERE  PositionNo = '#FORM.Key1#'
		</cfquery>
		
		<!---- insert--->
		<cfquery name="get" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_SubmissionEditionPosition(
					SubmissionEdition, 
					PositionNo,
					FunctionNo,
					PublishMode,
					EntityClass,
					Reference,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES (
					'#FORM.EditionSelect#',
					'#FORM.Key1#',
					'#Position.FunctionNo#',
					'#FORM.ModeSelect#',
					NULL,
					NULL,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
					)			
		</cfquery>
		
		<!--- --------------- --->
		<!--- populate titles --->
		<!--- --------------- --->
		
		<cfquery name="getLanguage" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   System.dbo.Ref_SystemLanguage
			WHERE  SystemDefault = '1'	
		</cfquery>
		
		<cfquery name="TitleNames" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				<cfif getLanguage.recordcount eq "1">
					SELECT FunctionDescription, '#getLanguage.code#' as Code
					FROM   FunctionTitle
					WHERE  FunctionNo = '#Position.FunctionNo#'
					UNION
				</cfif>
				SELECT FunctionDescription, LanguageCode as Code
				FROM   FunctionTitle_Language
				WHERE  FunctionNo = '#Position.FunctionNo#'				
		</cfquery>
		
		<cfloop query="TitleNames">
		
			<cfquery name="addline" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SubmissionEditionPosition_Language(
						SubmissionEdition, 
						PositionNo,
						FunctionDescription,			
						LanguageCode,
						OfficerUserId,
						Created )
				VALUES ('#FORM.EditionSelect#',
						'#FORM.Key1#',
						'#FunctionDescription#',	
						'#Code#',		
						'#SESSION.acc#',
						getdate()
						)			
			</cfquery>
		
		</cfloop>
				
		<!--- --------------------------------------------------- --->	
		<!--- populate where needed the parent position profile - --->
		<!--- --------------------------------------------------- --->
		
		<cfquery name="getProfile" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Employee.dbo.PositionParentProfile
				WHERE  PositionParentId = '#Position.PositionParentId#'			
		</cfquery>
		
		<cfif getProfile.recordcount eq "0">
		
		    <!--- obtain this from the chain --->
		
			<cfquery name="Insert" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Employee.dbo.PositionParentProfile
				       (PositionParentId, LanguageCode, TextAreaCode, JobNotes, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
			
				SELECT  '#Position.PositionParentId#',
				        LanguageCode, 
						TextAreaCode, 
						JobNotes, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName, 
						getdate()
				FROM    Employee.dbo.PositionParentProfile
				WHERE   PositionParentId IN
	                             (SELECT     PositionParentId
	                               FROM      Employee.dbo.Position
	                               WHERE     PositionNo IN (SELECT   SourcePositionNo
	                                                        FROM     Employee.dbo.Position
	                                                        WHERE    PositionNo = '#Position.PositionNo#')
								 )
			
			</cfquery>
		
		</cfif>
					
		<!--- -------------------- --->	
		<!--- populate competence- --->
		<!--- -------------------- --->
		
		<cfquery name="competence" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Employee.dbo.PositionCompetence
			WHERE  PositionNo = '#FORM.Key1#'
		</cfquery>
		
		<cfloop query="competence">
			
			<cfquery name="addline" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SubmissionEditionPositionCompetence(
						SubmissionEdition, 
						PositionNo,
						CompetenceId,			
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
				VALUES ('#FORM.EditionSelect#',
						'#FORM.Key1#',
						'#competenceid#',			
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
						)			
			</cfquery>
		
		</cfloop>
		
	</cfif>	

</cftransaction>
