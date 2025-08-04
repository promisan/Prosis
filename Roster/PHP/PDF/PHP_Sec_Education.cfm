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

<!--- EDUCATION --->
<!--- *************************************************************************** --->

<table width="100%" border="0" align="center" >
	<tr></tr>	
	<tr><td class="title">Education</td></tr>
	<tr><td bgcolor="333333"></td></tr>	

	<!--- UNIVERSITY --->
	<tr></tr>	
	<cfloop Index="EducationType" list = "University,School">
	<tr><td>

	<table width="95%" border="0" align="center" >
	<cfoutput>
	<cfif EducationType eq "University">
		<tr><td >List all university degrees or equivalent qualifications obtained.
		</td></tr>
	<cfelse>
		<tr><td>List all schools or other formal training or education from age 14 (e.g. high school, technical school and apprenticeship)
		</td></tr>
	</cfif>			
	</cfoutput>
	
	<tr></tr>
	

	<cfquery name="Uni" dbtype="query">
		SELECT * 
   		FROM  Experience
		WHERE ExperienceCategory = '#EducationType#'
	</cfquery>	

		
	<cfset Person = "#Applicant.ApplicantNo#">

	<cfloop query="Uni" startrow="1" endrow="20">
		
			<cfquery name="Uni_Country" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Name
			   	FROM  Ref_Nation
			   	WHERE Code = '#Uni.OrganizationCountry#'
			</cfquery>	
		
			<cfif prefix eq "">
			
				<cfquery name="Degree" 
				    datasource="AppsSelection" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT  R.Description
					FROM    ApplicantBackgroundField A, 
					        Ref_Experience R 
					WHERE  A.ApplicantNo  = '#Person#'
					AND    A.ExperienceId = '#Uni.ExperienceId#'
					AND    A.ExperienceFieldId = R.ExperienceFieldId	
					AND    R.ExperienceClass = 'Degree'
				</cfquery>		
				
				<cfquery name="FieldOfStudy" 
				    datasource="AppsSelection" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT  R.Description as Main, P.Description As Field
					FROM    ApplicantBackgroundField A, 
					        Ref_Experience R, 
							Ref_ExperienceClass P
					WHERE  A.ApplicantNo  = '#Person#'
					AND    A.ExperienceId = '#Uni.ExperienceId#'
					AND    A.ExperienceFieldId = R.ExperienceFieldId	
					AND    R.ExperienceClass = P.ExperienceClass
					AND    P.Parent = 'EDUCATION'
				</cfquery>	
		

			</cfif>
				
		<cfoutput>
		
		<tr><td>
	
		<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
	
		<tr><td>
	
		<table width="100%" border="0" align="center">
		
			<tr>
			
			<cfif EducationType eq "University">
				<td width="40%">University Name</td>
			<cfelse>
				<td width="40%">Name of School</td>
			</cfif>			
			<td width="35%">City, Country</td>
			<td width="25%">From - To</td>
			</tr>
			<tr>
			<td><b>#Uni.OrganizationName#</b></td>
			<td><b>#Uni.OrganizationCity# #Uni_Country.Name#</b></td>
			<td><b>#Trim(Dateformat(Uni.ExperienceStart, "mmm-yyyy")) & ' - ' & Dateformat(Uni.ExperienceEnd, "mmm-yyyy")#</b></td>
			</tr>
			
			<tr></tr>
	
			<cfif EducationType eq "University">
			
				<cfif prefix eq "">
					<tr>
					<td>Main Course of Study</td>
					<td>Field of Study</td>
					</tr>
					<tr>
					<td><b>#FieldOfStudy.Main#</b></td>
					<td><b>#FieldOfStudy.Field#</b></td>
					</tr>
			
					<tr></tr>
			
					<tr>
					<td>Degree Title or Equivalent</td>
					<td>Degree Type</td>
					</tr>
					<tr>
					<td><b>#Uni.ExperienceDescription#</b></td>
					<td><b>#Degree.Description#</b></td>
					</tr>
				</cfif>	
			<cfelse>
			
				<tr>
				<td colspan="2">Main Course of Study</td>
				<td>Certificate or Diploma</td>
				</tr>
				<tr>
				<td colspan="2" valign="top"><b>#Uni.Remarks#</b></td>
				<td valign="top"><b>#Uni.ExperienceDescription#</b></td>
				</tr>
				
			</cfif>			
		</table>
		<tr></tr>
		</table>
		<tr></tr>
		</cfoutput>		
		</td></tr>	
	</cfloop>
</table>		

	</td></tr>	
</cfloop>

</table>		

