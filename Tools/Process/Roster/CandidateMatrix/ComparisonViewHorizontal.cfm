<cfif attributes.hidePerson eq "Yes">
    <cfset cols = "3">
<cfelse>
	<cfset cols = "4">
</cfif>

<table width="100%" align="center" style="border:0px dotted silver">

	<cfoutput>
	
    <tr><td colspan="#cols#" class="line"></td></tr>
	
	<tr>
	
		<cfif attributes.hidePerson eq "No">
		<td width="160" style="padding:4px;border-right:1px dotted silver" class="labelit">Candidate</td>
		</cfif>
		<td width="12%" bgcolor="E6F2FF" class="labelit" style="padding:4px;border-right:0px dotted silver"><cf_tl id="Languages"></td>
		<td width="32%" bgcolor="ffffcf" style="padding:4px;border-right:1px dotted silver" class="labelit">Academic Classifications</td>
		<td width="40%" bgcolor="FAE7AB" class="labelit" style="padding:4px;border-right:1px dotted silver">Work Experience</td>
		
	</tr>
	<tr><td colspan="#cols#" class="line"></td></tr>
	
	</cfoutput>
	
	<cfoutput query="getCandidates">
			
		<cfset url.PersonNo  = PersonNo>		
	
		<tr>		
			<cfif attributes.hidePerson eq "No">
			<td valign="top" style="padding:4px;border-right:1px dotted silver"><cfinclude template="ComparisonPerson.cfm"></td>				
			</cfif>
			
			<td valign="top" style="padding:4px;border-right:0px dotted silver;">
				<cfinclude template="ComparisonLanguage.cfm">
			</td>	
			
			<td valign="top" style="padding:4px;border-right:0px dotted silver;;height:#attributes.height#">
				<cf_divscroll style="padding:right:6px">
				<cfinclude template="ComparisonEducation.cfm">
				</cf_divscroll>
			</td>
			
			<td valign="top" style="padding:4px;border-right:0px dotted silver;height:#attributes.height#">
				<cf_divscroll style="padding:right:6px">
				<cfinclude template="ComparisonExperience.cfm">
				</cf_divscroll>			
			</td>		

		</tr>
		
		<cfparam name="SubmissionId" default="">
				
		<cfif SubmissionId neq "" and attributes.attachment eq "Yes">
		
		<tr><td></td></tr>
						
		<tr><td colspan="#cols#" class="line"></td></tr>
		
		<tr><td colspan="#cols#">
		
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
		
		<tr><td></td></tr>
						
		<tr><td colspan="#cols#" class="line"></td></tr>
		
		</cfif>
			
	
	</cfoutput>

</table>