		<cf_divscroll style="height:100%">
		
		<cfset x = url.id>			
		
		<cfquery name="CheckReview" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT B.ExperienceId
			FROM   ApplicantBackground B INNER JOIN ApplicantBackgroundField BF ON B.ExperienceId = BF.ExperienceId 
						INNER JOIN Ref_Experience E ON E.ExperienceFieldId = BF.ExperienceFieldId
			WHERE  B.ApplicantNo         = '#url.id#'
			AND    B.ExperienceCategory  = 'Employment'
			AND    B.Status IN ('0','1')
			AND    EXISTS (SELECT 'X' FROM ApplicantReviewBackground ARB 
					WHERE ARB.ExperienceId = B.ExperienceId)
	   </cfquery>			
	
		<cfif CheckReview.recordcount neq 0>
			<cfset vHideTopics		  = "No">
			<cfset vExperienceReviewed = "Yes">
		<cfelse>
			<cfset vHideTopics		  = "Yes">
			<cfset vExperienceReviewed = "No">
		</cfif>

		<cf_ComparisonView applicantno="#url.id#" 
			    hideperson			= "Yes" 
				attachment			= "No" 
				Layout				= "Vertical" 
				HideTopics			= "#vHideTopics#"
				ExperienceReviewed 	= "#vExperienceReviewed#" 
				Owner			    = "#URL.Owner#"
				label				= "Candidate Profile"
				IDFunction          = "#URL.IDFunction#">			
							
		<cfset url.id = x>			
		
		</cf_divscroll>