<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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