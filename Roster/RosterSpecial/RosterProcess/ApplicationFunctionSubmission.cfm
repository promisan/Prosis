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

<!---For now only employment 
,'University','Training','School'
--->
					
<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   S.PersonNo, A.*
	FROM     ApplicantSubmission S, 
	         ApplicantFunctionSubmission A
	WHERE    A.ApplicantNo = '#URL.ApplicantNo#'	
	<!--- only the source as it was selected --->	
	AND      A.FunctionId   = '#url.FunctionId#'	   	
	AND      S.ApplicantNo = A.ApplicantNo		
	
	ORDER BY ISNULL(ExperienceEnd, '9999-12-31') DESC,
	         A.ExperienceStart DESC 
	        			 	 		
</cfquery>


<cfif detail.recordcount eq "0">

	<table align="center"><tr><td align="center" class="labelmedium" style="padding-top:15px"><cf_tl id="Profile is not available"></td></tr></table>

<cfelse>
		
	<cfquery name="Function" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   R.Owner
		FROM     FunctionOrganization FO INNER JOIN
	             Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition
		WHERE    FunctionId = '#Detail.FunctionId#'			        			 	 		
	</cfquery>
	
	<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Applicant 	
		WHERE    PersonNo = '#Detail.PersonNo#'		
	</cfquery>
	
	<cfset prioryear = "0">
	<cfset row = "0">
	<!--  <cfform method="POST" name="submissionform"> -->
	
	<table width="100%" class="navigation_table">
			
	<cfoutput query="Detail">
		
	   <cfif ExperienceEnd neq "">
		  <cfset yr = year(ExperienceEnd)>
	   <cfelse>
		  <cfset yr = year(now())>
	   </cfif>	
		  
	   <cfif yr neq prioryear>  	  
	   
	   	  <cfset prioryear = yr>
		 	 
		  <tr><td colspan="8" style="font-size:34px;padding-top:5px" class="labellarge">#Yr#</td></tr>
		  
	   </cfif>
			
		<cfif Status neq "9">
		    <tr bgcolor="ffffff" class="navigation_row">
		<cfelse>	
		    <tr bgcolor="red" class="navigation_row">
		</cfif>
		
		<cfset row = row + 1>
		
		<td colspan="8" style="padding-left:5px">
		
		   <table class="labelmedium">
		   
		   <tr>
		   
		   <td class="labelit" valign="top" style="padding-top:4px">#Row#.</td>	   
		   <td colspan="2"></td>			  	   
		   <td class="labelmedium" style="padding-left:10px">
		   
		   	 <font color="8000FF"><u><b><cf_tl id="#ExperienceCategory#">:</b></u></font>
		   
			 #ExperienceDescription#
			 
			 <cfif ExperienceCategory eq "Employment">
				
						<cfquery name="moreDetails" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT R.*, D.TopicValue
							FROM   ApplicantFunctionSubmissionDetail D, Ref_Topic R
							WHERE  D.SubmissionId = '#SubmissionId#'
							AND    R.Topic = D.Topic
							AND    R.Operational = 1
						</cfquery>		
						
						<cfif moredetails.recordcount gte "1">				
							<a href="javascript:maximizeit('#CurrentRow#','Exp')"><font size="2" color="0080C0"><cf_tl id="More details">...</font></a>										
						</cfif>
							      
				</cfif>
			 
		   </td>
		
			</tr>
			</table>
			 
		</td>
		
		<!---
		<td colspan="3" valign="bottom" align="right" class="labelmedium" style="height:21px;padding-right:15px;padding-bottom:2px">
		<cfif SalaryCurrency neq "">
		    <cf_tl id="Salary">: #SalaryCurrency# &nbsp;#NumberFormat(SalaryStart,'_,_')# - &nbsp;#NumberFormat(SalaryEnd,'_,_')#
		</cfif>
		</td>
		--->
		</tr>
		
		<tr class="navigation_row_child labelmedium">
			<td width="5%" align="left"></td>	
			<td colspan="4">#OrganizationClass#: #OrganizationName# <cfif OrganizationCity neq "">#OrganizationCity# <cfif OrganizationCountry neq "">(#OrganizationCountry#)</cfif></cfif>	</td>
			<td colspan="2" width="20%" style="padding-right:10px">
			<cf_space spaces="50">
			#DateFormat(ExperienceStart,CLIENT.DateFormatShow)#
			- 
			<cfif ExperienceEnd gte now()><cf_tl id="Todate"><cfelse>#DateFormat(ExperienceEnd,CLIENT.DateFormatShow)#</cfif></td>
			
		</tr>
			
		<cfif len(OrganizationAddress) gte "10">
			<tr class="navigation_row_child">			
				<td></td>
				<td colspan="7" class="labelmedium">#OrganizationAddress#</td>
			</tr>
		</cfif>
		
		<cfif OrganizationCivil eq "1" or OrganizationRelated eq "1">
			<tr class="navigation_row_child">			
				<td></td>
				<td colspan="7" class="labelmedium"><font color="FF0080"><cf_tl id="Government Position"> <cfif OrganizationRelated eq "1">/<cf_tl id="In common system"></cfif></font></td>
			</tr>		
		</cfif>
	
	
		<cfif SupervisorName neq "">
				
			<tr class="navigation_row_child labelmedium">		
				<td></td>
				<td colspan="6">
				<font color="808080"><i><cf_tl id="Supervisor"></i></font>:&nbsp;#SupervisorName# #OrganizationTelephone# <cfif OrganizationEMail neq "">
				<a href="javascript:email('#OrganizationEMail#','#Candidate.FirstName# #Candidate.LastName#','','','','')">
				<font color="0080C0"><u>#OrganizationEMail#</u></font>
				</a>
				</cfif>
				</td>
			</tr>
		
		</cfif>
	
		<cfif StaffSupervised neq "">
				
			<tr class="navigation_row_child labelmedium">		
				<td></td>
				<td colspan="6">
				<font color="808080"><i><cf_tl id="Supervised"></i></font>:&nbsp;#StaffSupervised#
				</td>
			</tr>
		
		</cfif>
		
		
		<!--- ------------------------------------------------------- --->
		<!--- detected requests for validation of the work experience --->
		<!--- ------------------------------------------------------- 
		
		<cfif url.entryscope eq "backoffice">
		
			<cfif review gte "1">
						
					<cfquery name="Checking" 
							datasource="appsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  *
							FROM    ApplicantReview A, 
							        Ref_ReviewClass R
							WHERE   A.ReviewCode = R.Code
							AND     A.Reviewid IN (SELECT ReviewId 
							                       FROM ApplicantReviewBackGround 
												   WHERE ExperienceId = '#experienceid#')
		
							<cfif Parameter.ReviewOwnerAccess eq "0">
												   
							    <cfif SESSION.isAdministrator eq "No" and SESSION.isOwnerAdministrator eq "No">
								
									AND     A.Owner    IN (
							
												SELECT    DISTINCT ClassParameter
												FROM      Organization.dbo.OrganizationAuthorization
												WHERE     UserAccount = '#SESSION.acc#' 
												AND       Role IN ('AdminRoster', 'RosterClear')
												AND       ClassParameter IN (SELECT Owner FROM Applicant.dbo.Ref_ParameterOwner WHERE Operational = 1)
												
												)
							
														
								</cfif>						   
							
							</cfif>					   
												   
							AND     R.Operational = 1
							ORDER BY Status DESC	
					</cfquery>
								
					<cfif checking.recordcount gte "1">
						
						<tr class="navigation_row_child"><td colspan="8" align="center" style="padding-top:8px;padding-right:8px;padding-bottom:8px;padding-left:35px">
										
							<table width="90%" style="border:1px solid gray;border-radius:6px" align="center" class="formpadding" cellspacing="0" cellpadding="0" bgcolor="ffffcf">
								
								<tr class="linedotted labelit" bgcolor="ffffef">
								    <td style="padding-left:4px"><cf_tl id="Review type"></td>
									<td><cf_tl id="Owner"></td>
									<td><cf_tl id="Priority"></td>
									<td><cf_tl id="Status"></td>
									<td><cf_tl id="Initiated"></td>
									<td><cf_tl id="Date"></td>
									<td></td>
								</tr>
														
								<cfloop query="checking">
								
									<tr>
									<td class="labelit" style="padding-left:4px">#Description#</td>
									<td class="labelit">#Owner#</td>
									<td class="labelit">#PriorityCode#</td>
									<td class="labelit">
											<cfswitch expression="#Status#">
													<cfcase value="0"> <font color="blue">Pending</font></cfcase>
													<cfcase value="9"><font color="FF0000">Denied</font></cfcase>
													<cfcase value="1">Cleared</cfcase>
											</cfswitch>
									</td>
									<td class="labelit">#OfficerLastName#</td>
									<td class="labelit">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
									<td></td>
									</tr>	
																						
								</cfloop>
														
							</table>
								
							</td>
						</tr>
					
					</cfif>	
									
			</cfif>
		
		</cfif>
		
		--->
									
		<cfif ExperienceCategory eq "Employment" and moredetails.recordcount gte "1">
							  				
			<tr id="#currentrow#" class="hide">
								
			<td colspan="8" style="padding-top:2px;padding-left:37px;padding-right:10px">
			
			<table width="100%" style="border:0px dotted 0080C0" border="0" cellspacing="0" cellpadding="0" align="center">
						
				<tr><td>
					
					<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					
					<cfloop query="moreDetails">
					
					    <tr><td style="padding-left:0px; padding-top:4px" class="labellarge"><font color="808080">#Description#</font></td></tr>
						<tr><td class="labelmedium" style="padding-top:5px;padding-left:5px">#TopicValue#</td></tr>
										
					</cfloop>
					
					</table>
					
				</td></tr>
				<tr><td height="4"></td></tr>
			</table>
			
			</td>
			</tr>
							
		</cfif>			
		
		 <cfif ExperienceCategory eq "Employment">
			   
			<cfset cl = "regular">
			
			<!---
			
			<cfif CurrentAssigned eq "">
				<cfset cl = "hide">
			<cfelse>
			    <cfset cl = "regular">
			</cfif>
			
			--->
			
			<tr class="navigation_row_child labelmedium #cl#" id="experience#currentRow#">
			
			       <td></td>
				   <td colspan="7" style="padding-left:0px">
				   
				   <cfset url.box       = "box#currentrow#">			   			   
			       <cfset url.owner     = Function.Owner>  <!--- filter the class to show just relevant classes --->
				   <cfset url.id        = SubmissionId>
			       <cfset url.id1       = ExperienceCategory>
				   <cfset url.php       = "Submission">
			       <cfset url.candidate = 0>
				   <cfset Group         = "'Experience','Region'">
				   <cfinclude template="../../Candidate/Details/Keyword/KeywordEntry.cfm"> 	
				   	
			</td>
			</tr>						
					   
		</cfif>
				
		<tr class="navigation_row_child" style="border-bottom:1px solid silver"><td colspan="10" height="10"></td></tr>
					
	</cfoutput>
	
	<tr><td colspan="10" style="padding:4px" align="center">
	  <cfoutput>
	  <input class="button10g"
	      type="button" 
		  name="Submit" 
		  style="width:250px" 
		  value="Submit Assessment" 
		  onclick="submitkeywords('#url.ApplicantNo#','#url.FunctionId#','#url.owner#')"></td>
	  </cfoutput>
	</tr>
	
	</table>
	
	<!-- </cfform> -->
	
</cfif>	

<cfset ajaxonLoad("doHighlight")>
	
	