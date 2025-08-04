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
<cfif attributes.hidePerson eq "Yes">
    <cfset cols = "3">
<cfelse>
	<cfset cols = "4">
</cfif>

<table align="center" style="height:100%;width:100%;border:1px solid silver">

	<cfoutput>

	<tr class="line labelmedium">
	
		<cfif attributes.hidePerson eq "No">
		<td align="center" width="160" style="padding:4px;border-right:1px dotted silver"><cf_tl id="Candidate"></td>
		</cfif>
		<td align="center" width="32%" bgcolor="ffffcf" style="padding:4px;border-right:1px solid silver"><cf_tl id="Academic Classifications"></td>
		<td align="center" width="40%" bgcolor="FAE7AB" style="padding:4px;border-right:1px solid silver"><cf_tl id="Work Experience"></td>		
		<td align="center" width="12%" bgcolor="E6F2FF" style="padding:4px;border-right:1px solid silver"><cf_tl id="Languages"></td>
		
	</tr>
		
	</cfoutput>
		
	<cfoutput query="getCandidates">
				
		<cfset url.PersonNo  = PersonNo>		
	
		<tr>		
			<cfif attributes.hidePerson eq "No">
			<td valign="top" style="padding:4px;border-right:1px dotted silver"><cfinclude template="ComparisonPerson.cfm"></td>				
			</cfif>
						
			<td valign="top" style="padding:4px;border-right:1px solid silver;height:100%">
				<cf_divscroll>
				<cfinclude template="ComparisonEducation.cfm">
				</cf_divscroll>
			</td>
			
			<td valign="top" style="padding:4px;border-right:1px solid silver;height:100%">						
				<cf_divscroll>						
				<cfinclude template="ComparisonExperience.cfm">
				</cf_divscroll>							
			</td>	
			
			<td valign="top" style="padding:4px;border-right:1px solid silver;">
				<cfinclude template="ComparisonLanguage.cfm">
			</td>		

		</tr>
		
		<cfparam name="SubmissionId" default="">
				
		<cfif SubmissionId neq "" and attributes.attachment eq "Yes">
								
		<tr><td colspan="#cols#" class="line"></td></tr>
		
		<tr class="line"><td colspan="#cols#">
		
				<cfquery name="Edition" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_SubmissionEdition
						WHERE     SubmissionEdition = '#SubmissionEdition#'													 
				</cfquery>						
		
	 			<cfquery name="Own" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      OrganizationAuthorization
						WHERE     UserAccount = '#SESSION.acc#' 
						AND       Role IN ('AdminRoster', 'RosterClear')
						AND       ClassParameter = '#Edition.Owner#'													 
				</cfquery>				  
				  
				<cfif session.isAdministrator eq "Yes" or Own.recordcount gte "1"> 
					 
					 <cf_filelibraryN
						DocumentPath="Submission"
						SubDirectory="#submissionid#" 	
						Filter=""		
						Insert="yes"
						loadscript="No"
						Box="mysubmission"
						Remove="yes"
						ShowSize="yes">	
						
				<cfelse>
					
					 <cf_filelibraryN
						DocumentPath="Submission"
						SubDirectory="#submissionid#"
						Filter=""	 			
						Insert="no"
						Box="mysubmission"
						Remove="no"
						loadscript="No"
						ShowSize="yes">	
					
				</cfif>	
				
		</td></tr>
				
		</cfif>			
	
	</cfoutput>

</table>