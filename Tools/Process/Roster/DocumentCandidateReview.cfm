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

<cfparam name="Attributes.PersonNo" default="">
<cfparam name="Attributes.Trigger" default="">
<cfparam name="Attributes.Color" default="ffffff">
<cfparam name="Attributes.Owner" default="">
<cfparam name="Attributes.DocumentNo" default="">

	<cfquery name="Parameter" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Parameter	
	</cfquery>	

	<cfquery name="Class" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ReviewClass
	WHERE   Operational = '1' 
	</cfquery>	
		
	<cfquery name="Offer" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    stOffer O, Document D
	WHERE   O.DocumentNo = D.DocumentNo
	AND     PersonNo = '#Attributes.PersonNo#'
	AND     OfferRejected = 1
	</cfquery>
	
	<cfset name = "">
					
	<cfset detail = 0>				
	<cfset h = 0>				
					
	<table width="100%" align="center" bgcolor="<cfoutput>#attributes.color#</cfoutput>" cellspacing="0" cellpadding="0">
	
		<cfif class.recordcount gt "0">
				
			<tr>		
		
			<td height="15" width="80%" style="cursor:pointer"
			  onclick="try {document.getElementById('<cfoutput>#attributes.personNo#</cfoutput>_review').className='regular'} catch(e) {}">
			  
			  <table><tr class="labelmedium">
						
			<cfoutput query="class">
						
				<cfquery name="Review" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  A.Status, count(*) as Total
					FROM    ApplicantReview A
					WHERE   A.PersonNo = '#Attributes.PersonNo#' 
					AND     A.ReviewCode = '#Code#'
					
					<cfif Parameter.ReviewOwnerAccess eq "1">
					
						<cfif SESSION.isAdministrator eq "No">
							<cfif attributes.owner neq "">
							AND     A.Owner    = '#Attributes.Owner#'
							<cfelse>
							AND     A.Owner    IN (
							
												SELECT    DISTINCT ClassParameter
												FROM      Organization.dbo.OrganizationAuthorization
												WHERE     UserAccount = '#SESSION.acc#' 
												AND       Role IN ('AdminRoster', 'RosterClear')
												AND       ClassParameter IN (SELECT Owner 
												                             FROM   Applicant.dbo.Ref_ParameterOwner 
																			 WHERE  Operational = 1)
												
												)
										
							
							</cfif>
						</cfif>	
						
					</cfif>
					GROUP BY Status		
					ORDER BY Status DESC	
				</cfquery>
				
				<td style="padding-left:6px;padding-right:10">#Description#:</td>
				
				<td style="padding-right:10px">
				
				<cfif Review.recordcount eq "0">
				
				    <table><tr class="labelmediium"><td>
					<font color="gray"><cf_tl id="Not Initiated"></font>
					</td>
					
					<cfif attributes.trigger eq "Review">
					
						<td style="padding-left:2px">
					        <cf_img icon="add" onclick="review('#attributes.personno#','#code#')">
							
							<!---					
							<img src="#SESSION.root#/Images/gohere.gif" 
								alt="Request #Description# Review"
								style="cursor: pointer;"
								border="0" 
								align="absmiddle"
								onclick="review('#attributes.personno#','#code#')">								
								--->
								
							</td>	
							
					</cfif>
					
					</td></tr></table>
										
				<cfelse>
				
					<cfloop query="Review">
					
						<cfset detail = 1>
					
						<cfswitch expression="#Status#">
						<cfcase value="0">
						   <font color="gray"><cf_tl id="Pending"> (#Total#);&nbsp;</font>																
						</cfcase>
						<cfcase value="1">
							<cf_tl id="Completed"> (#Total#);&nbsp;
						</cfcase>
						<cfcase value="9">
							<font color="FF0000"><cf_tl id="Corroborated"> (#Total#)</font>
						</cfcase>
						</cfswitch>
					
					</cfloop>	
														
				</cfif>
				
				</td>
										
			</cfoutput>	
			
			</tr></table>
						
			</td>
		</tr>
					
	<cfelse>
		
		<td></td>
		</tr>
		
	</cfif>	

	<cfif detail eq "1">
	
		<cfquery name="Review" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    ApplicantReview A, Ref_ReviewClass R
				WHERE   A.PersonNo = '#Attributes.PersonNo#' 
				<cfif Parameter.ReviewOwnerAccess eq "1">
				
					<cfif SESSION.isAdministrator eq "No">
					
						<cfif attributes.owner neq "">
						AND     A.Owner    = '#Attributes.Owner#'
						<cfelse>
						AND     A.Owner    IN (
				
									SELECT    DISTINCT ClassParameter
									FROM      Organization.dbo.OrganizationAuthorization
									WHERE     UserAccount = '#SESSION.acc#' 
									AND       Role IN ('AdminRoster', 'RosterClear')
									AND       ClassParameter IN (SELECT Owner FROM Applicant.dbo.Ref_ParameterOwner WHERE Operational = 1)
									
									)
				
						</cfif>	
						
					</cfif>
					
				</cfif>	
				AND     A.ReviewCode = R.Code
				AND R.Operational = 1
				ORDER BY Status DESC	
		</cfquery>
		
		<tr><td class="hide"
			    id="<cfoutput>#attributes.personNo#</cfoutput>_review"
			    style="width:95%;padding-left:10px;border: 0px solid silver;">
		
			<table width="99%" align="center">
						
			<tr class="labelmedium line fixlengthlist">
			    <td><cf_tl id="Description"></td>
				<td><cf_tl id="Owner"></td>
				<td><cf_tl id="Priority"></td>
				<td><cf_tl id="Status"></td>
				<td><cf_tl id="Initiated by"></td>
				<td><cf_tl id="Date"></td>
				<td></td>
			</tr>
						
			<cfoutput query="review">
			<tr class="labelmedium line fixlengthlist" style="height:18px">
			<td>#Description#</td>
			<td>#Owner#</td>
			<td>#PriorityCode#</td>
			<td>
					<cfswitch expression="#Status#">
							<cfcase value="0"> <font color="blue">Pending</font></cfcase>
							<cfcase value="9"><font color="FF0000">Denied</font></cfcase>
							<cfcase value="1">Cleared</cfcase>
					</cfswitch>
			</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#DateFormat(Created,CLIENT.DateFormatShow)#</td>
			</tr>	
			
			<cfquery name="Detail" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    B.ExperienceCategory, B.ExperienceDescription, B.ExperienceStart, B.ExperienceEnd, B.OrganizationName
			FROM      ApplicantReviewBackground ARB INNER JOIN
	                  ApplicantBackground B ON ARB.ExperienceId = B.ExperienceId
			WHERE     ReviewId = '#ReviewId#'		
			</cfquery>	
					
			<cfloop query="Detail">
				<tr bgcolor="F4FBFD" class="labelmedium fixlengthlist" style="height:18px">
				<td style="padding-left:20px" colspan="3">#ExperienceDescription#</td>
				<td colspan="2">#OrganizationName#</td>
				<td>#Dateformat(ExperienceStart,CLIENT.DateFormatShow)# - #Dateformat(ExperienceEnd,CLIENT.DateFormatShow)#</td>		
				</tr>			
			</cfloop>			
			
			</cfoutput>
							
			</table>
				
		</td></tr>
			
	</cfif>
	
	<cfif offer.recordcount gte "1">
		
	<TR class="labelmedium">
		<td colspan="2"><b><cf_tl id="Declined offers">:</b></td>
	</TR>

	<tr><td colspan="2">
			
		<table width="99%" align="center" class="formpadding">
			
			<TR class="labelmedium line fixlengthlist">
				<TD><cf_tl id="Track"></TD>
			    <TD><cf_tl id="Mission"></TD>
				<TD><cf_tl id="Function"></TD>
				<TD><cf_tl id="Date"></TD>
			    <TD><cf_tl id="Location"></TD>
				<TD><cf_tl id="Officer"></TD>
			</TR>
							
			<cfoutput query="Offer">
								
				<tr class="labelmedium fixlengthlist" style="height:20px">
				<TD>
				<cfif documentNo eq attributes.DocumentNo><b><font color="0080FF">This track</b><cfelse>
					<A HREF ="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#DocumentNo#</a>
				</cfif>
				</TD>
				<TD>#Mission#</TD>
				<TD>#FunctionalTitle#</TD>
				<TD>#DateFormat(EntryDate,CLIENT.DateFormatShow)#</a></TD>
				<TD>#RecruitmentCountry# #RecruitmentCity#</a></TD>
				<TD>#EntryFirstName# #EntryLastName#</a></TD>
				</TR>
				
			</CFOUTPUT>
			
		</table>
		
	</td>
	
	</tr>
			
	</cfif>	
	
	<cfif review.recordcount gt 0 or offer.recordcount gt "0">
	   <CFSET Caller.rev = 1>	
	<cfelse>
	   <cfset caller.rev = 0>
	</cfif>		
			
	</table>