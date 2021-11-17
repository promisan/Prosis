<cfparam name="URL.IDFunction" default="">

<cf_divscroll style="height:100%">

<cfif attributes.hidePerson eq "Yes">
    <cfset cols = "3">
<cfelse>
	<cfset cols = "4">
</cfif>

<table height="100%" width="96%">

	<cfif Attributes.HideTitle eq "No">
	
	<cfoutput>
	
	<tr><td style="height:30px" class="labellarge">

		<table width="100%" class="navigation_table">
	
		<tr>
		
			<td style="font-size:24px;font-weight:300" class="labellarge">
				<cfif URL.IDFunction eq "">
					<cf_tl id="Candidate History">	
				<cfelse>
					<cf_tl id="Submitted Profile">						
				</cfif>
				
			</td>
			<td align="right">
		
				<table width="100%" align="center" >
			   
			    <tr>
			   	  
				  <td align="right" valign="top" class="noprint">
				
						<table cellspacing="0" cellpadding="0" align="right">
						<tr>
						<td align="right" style="padding-left:6px;padding-right:4px" class="labelit">
							<cfoutput>
							<a href="##" onclick="ptoken.open('#session.root#/Roster/PHP/PHPEntry/PHPProfile.cfm?scope=backoffice&owner=#attributes.owner#&personno=#getCandidates.PersonNo#&applicantno=#URL.ID#');">
							   Edit
							</a>
							</cfoutput>
						</td>				
						
						<td style="padding-right:4px">|</td>
						
						<td style="width:50" class="labelit" align="center">
						 
						 	<cf_tl id="PHP" var="1">
							
						    <cf_RosterPHP DisplayText="#lt_text#" 
					        	       	  RosterList="#getCandidates.PersonNo#"
									      DisplayType="Button"
										  Image="#SESSION.root#/Images/pdf.png"
								    	  Class = "Button10g"
										  style="width:50px;height:20px"
								    	  IDFunction = "#URL.IDFunction#">
					    </td>
										
					   </tr>			   
					   </table>
			   	   </td>
				</tr>
			</table>
		
		</td>
		</tr>
		</table>
		
	</td></tr>
	<tr><td class="line"></td></tr>
	
	</cfoutput>
	</cfif>
	
	<cfoutput query="getCandidates">
			
		<cfset url.PersonNo  = PersonNo>		
					
			<cfif attributes.hidePerson eq "No">
			<tr>
			<td valign="top" style="padding:4px;border-right:1px dotted silver"><cfinclude template="ComparisonPerson.cfm"></td>				
			</tr>
			</cfif>
			
			<cfif attributes.hideLanguage eq "No">			
				<tr><td height="4"></td></tr>		
				<tr>
				<td align="center" bgcolor="f1f1f1" class="labelmedium" style="height:20px;-moz-border-radius: 2px;border-radius: 2px;padding:4px;border:1px solid silver"><cf_tl id="Languages"></td>
				</tr>			
	
				<tr>
				<td valign="top" style="padding:4px;">
					<cfinclude template="ComparisonLanguage.cfm">
				</td>	
				</tr>
			</cfif>
			
			<cfif attributes.hideEducation eq "No">			
				<tr><td height="4"></td></tr>
				<tr>
				<td bgcolor="f1f1f1" align="center" style="height:20px;-moz-border-radius: 2px;border-radius: 2px;padding:4px;border:1px solid silver" class="labelmedium"><cf_tl id="Academic Classifications"></td>	
				</tr>
				<tr>
				<td valign="top" style="padding:4px;border-right:0px dotted silver;">				
					<cfinclude template="ComparisonEducation.cfm"> 				
				</td>
				</tr>
			</cfif>
				<tr><td height="4"></td></tr>
			<cfif attributes.hideTopics eq "No">
				<tr><td height="4"></td></tr>
				<tr>
				<td valign="top" style="padding:4px;border-right:0px dotted silver;">				
					<cf_TopicView 
						ApplicantNo = "#URL.ID#"
						Owner       = "#Attributes.Owner#"
						Title       = "Summary of Topics:"
						Mode        = "Read" >    
				</td>
				</tr>
				<tr><td height="4"></td></tr>
			
			</cfif>
					
			<tr><td height="4" </td></tr>
			<tr>
			<td bgcolor="f1f1f1" align="center" class="labelmedium" style="height:20px;-moz-border-radius: 2px;padding:4px;border:1px solid silver"><cf_tl id="Work Experience"></td>
			</tr>
			<tr>
			<td valign="top" style="padding:4px;border-right:0px dotted silver">				
				<cfset URL.Status   = Attributes.ExperienceStatus>
				<cfset URL.Reviewed = Attributes.ExperienceReviewed>
				<cfinclude template="ComparisonExperience.cfm">				
			</td>		
			</tr>

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
					
		
		</cfif>
			
	
	</cfoutput>

</table>

</cf_divscroll>

<cfset ajaxOnLoad("doHighlight")>