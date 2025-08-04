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

<!--- Determine Applicant PersonNo --->

<cfquery name="getApplicant" 
	datasource="AppsSelection">
	
		SELECT   TOP 1 *
		FROM     Applicant		
		WHERE    IndexNo = (SELECT IndexNo 
		                    FROM   Employee.dbo.Person 
							WHERE  PersonNo = '#url.personNo#')							
		AND      Source IN (SELECT PHPSource FROM Parameter)
		ORDER BY Created DESC
				
</cfquery>

<cfif getApplicant.RecordCount gt 0>

	<!--- Determine ApplicantSubmission --->
	<cfquery name="getApplicantSubmission" 
		datasource="AppsSelection">
		
			SELECT *
			FROM   ApplicantSubmission AS ASub
			INNER JOIN (
							SELECT PersonNo, MAX(SubmissionDate) AS MaxSubmissionDate
							FROM   ApplicantSubmission Submission
							WHERE  PersonNo = '#getApplicant.PersonNo#'
							AND    Source IN (SELECT PHPSource FROM Parameter)
							<!--- Look for the submission with background records --->							
							AND    EXISTS ( SELECT 'X'
											FROM   ApplicantBackground AB
											WHERE  Submission.ApplicantNo = AB.ApplicantNo
											AND    AB.Status IN ('0','1')
											AND    AB.ExperienceCategory IN (#preserveSingleQuotes(url.categories)#)  )
							GROUP  BY PersonNo
			) AS ASubLatest
				ON ASub.PersonNo = ASubLatest.PersonNo AND ASub.SubmissionDate = ASubLatest.MaxSubmissionDate
				
	</cfquery>
	
	<cfquery name="getPersonBackground" 
		datasource="AppsSelection">
			SELECT DISTINCT  
					AB.ExperienceCategory,
					AB.ExperienceDescription,
					AB.ExperienceStart,
					AB.ExperienceEnd,
					AB.OrganizationName,
					AB.OrganizationCountry,
					N.Name as OrganizationCountryName
			FROM	ApplicantBackground AB
						LEFT OUTER JOIN System.dbo.Ref_Nation N
						ON AB.OrganizationCountry = N.Code
			WHERE	AB.Status IN ('0','1')
			AND		AB.ApplicantNo = '#getApplicantSubmission.ApplicantNo#'
			AND		AB.ExperienceCategory IN (#preserveSingleQuotes(url.categories)#)
			ORDER BY AB.ExperienceStart DESC, AB.ExperienceEnd DESC
	</cfquery>
	
	<!--- Determine ApplicantSubmission validation --->
	<cfquery name="getApplicantSubmission" 
		datasource="AppsSelection">
			SELECT *
			FROM   ApplicantSubmission AS ASub
			INNER JOIN (
				SELECT PersonNo, MAX(SubmissionDate) AS MaxSubmissionDate
				FROM   ApplicantSubmission Submission
				WHERE  PersonNo = '#getApplicant.PersonNo#'
				AND    Source IN (SELECT PHPSource FROM Parameter)
				<!--- Look for the submission with background records --->
				AND    EXISTS (
							SELECT 'X'
							FROM   ApplicantBackground AB
							WHERE  Submission.ApplicantNo = AB.ApplicantNo
							AND    AB.Status IN ('0','1')
							AND    AB.ExperienceCategory IN (#preserveSingleQuotes(url.categoriesValidation)#)
					   )
				GROUP  BY PersonNo
			) AS ASubLatest
				ON ASub.PersonNo = ASubLatest.PersonNo AND ASub.SubmissionDate = ASubLatest.MaxSubmissionDate
	</cfquery>
	
	<cfquery name="getPersonBackgroundValidation" 
		datasource="AppsSelection">
			SELECT  *
			FROM	ApplicantBackground
			WHERE	Status IN ('0','1')
			AND		ApplicantNo = '#getApplicantSubmission.ApplicantNo#'
			AND		ExperienceCategory IN (#preserveSingleQuotes(url.categoriesValidation)#)
	</cfquery>
	
	<cfoutput>
	
		<cfset vColClass = "col-lg-6">
		<cfif getPersonBackgroundValidation.recordCount eq 0 or url.isComplementAuthorized eq 0>
			<cfset vColClass = "col-lg-12">
		</cfif>
	
		<cf_mobileCell class="#vColClass#">
			<cf_mobilePanel
				bodyStyle="background-color:##F4F3EE;">
				
					<cf_tl id="#url.title#" var="1">
					<i class="#url.icon# pull-left" style="font-size:500%; padding-right:10px;"></i>
					<h3 class="m-xs text-success" style="color:##005B9A; padding-top:10px;">#ucase(lt_text)#</h3>
					<br>
					<div style="font-size:130%; text-align:left; width:100%;">
						<ul>
							<cfloop query="getPersonBackground">
								<li style="padding-bottom:5px;">
									<!--- <b><cfif ExperienceStart neq "">#year(ExperienceStart)#</cfif> <cfif ExperienceEnd neq "">- #year(ExperienceEnd)#: </cfif></b> --->
									#ExperienceDescription#.
									<br>
									<span style="color:##919191;">#OrganizationName#<cfif OrganizationCountry neq ""> (#OrganizationCountryName#)</cfif>.</span>
								</li>
							</cfloop>
						</ul>
					</div>
						
			</cf_mobilePanel>
		</cf_mobileCell>
	
	</cfoutput>
	
</cfif>
