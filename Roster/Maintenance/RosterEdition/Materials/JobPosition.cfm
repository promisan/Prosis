<cfquery name="qTextArea"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT T.Code, 
			<cfif language.code neq "ENG">
				L.Description
			<cfelse>
				T.Description 	
			</cfif>	
	FROM Ref_TextArea T 
		<cfif language.code neq "ENG">
			INNER JOIN Ref_TextArea_Language L ON L.Code = T.Code
				AND L.LanguageCode = '#language.code#'
		</cfif>
	WHERE TextAreaDomain = 'Position'
	ORDER BY ListingOrder
</cfquery>


<cfloop query="qJOs">	
	
	<cfset Session.status = Session.Status + step>
	<cfset Session.message = "Processing #qJOs.Reference# in #Language.LanguageName#">
	
	<cfquery name="qParentPosts"
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT PositionParentId, 
				(
					SELECT SUM(1)
					FROM Employee.dbo.PositionParentProfile 
					WHERE PositionParentId = P.PositionParentId			
					AND LanguageCode = '#language.languagecode#'
					AND JobNotes IS NOT NULL
					AND Datalength(JobNotes)>0				
				) as Total
			FROM Employee.dbo.Position P
			WHERE 
				EXISTS
				(
					 SELECT 'X'
						FROM  Ref_SubmissionEditionPosition REP
						WHERE SubmissionEdition = '#url.submissionedition#'
						AND   Reference         = '#qJOs.Reference#'
						AND   PositionNo        = P.PositionNo
				)	
			AND EXISTS 
				(
					SELECT 'X'
					FROM Employee.dbo.PositionParentProfile 
					WHERE PositionParentId = P.PositionParentId			
					AND JobNotes IS NOT NULL
					AND LanguageCode = '#language.languagecode#'					
					AND Datalength(JobNotes)>0					
				)
		</cfquery>				
	
		<cfquery name="Parent" dbtype="query">
			SELECT PositionParentId
			FROM   qParentPosts
			ORDER BY Total Desc
		</cfquery>
		
		<cfif Parent.PositionParentId neq "">
		
			<cfif qJOs.Reference neq "">
				<cfinclude template="JobPositionText.cfm">
			</cfif>	
			
		</cfif>	
		
</cfloop>