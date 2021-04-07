
<!--- validate --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DOB#" SQLLimit="Yes">
<cfset DOBdate = dateValue>

<cfparam name="Form.Nationality" default="">

<cfif form.dob eq "" or form.lastname eq "" or form.firstname eq "" or form.nationality eq "">
	 <cfabort>
</cfif>

<!--- verify if candidate applicant record exist --->

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Applicant 
	WHERE   LastName          = '#form.LastName#' 
	AND     LEFT(FirstName,1) = '#left(form.FirstName,1)#'
	AND     DOB               = #DOBDate#
	AND     Nationality       = '#form.Nationality#'
</cfquery>

<cfoutput>
 		
<cfif Candidate.recordcount gte 1>
																
		<cfquery name="Source" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *,  (SELECT count(*)
					    FROM   ApplicantSubmission S
						WHERE  S.PersonNo  = '#Candidate.PersonNo#'
					    AND    S.Source = R.Source) as Exist				
			FROM   Ref_Source R
			WHERE  Operational = 1 				
		</cfquery>		
								
		<cfif source.recordcount eq "0">
		
			<table width="100%">
			<tr><td align="center" class="labelmedium2">
				<font color="000080">
					<cf_tl id="Attention"> : <cf_tl id="Not sources found, please contact your administrator">
				</font>
			</td></tr></table>
		
		<cfelse>		
				
			<cfquery name="SourceCheck" dbtype="query">
			    SELECT  *
			    FROM    Source
			    WHERE   Exist > 0
			</cfquery>

			<table width="98%" align="center" class="formpadding">
			
				<cfquery name="SourceReUse" dbtype="query">
				    SELECT  *
				    FROM    Source
				    WHERE   Exist > 0 and AllowEdit = 1
				</cfquery>						
			
				<cfif sourceReUse.recordcount gte "1">
							
				<tr>
				<td class="labellarge" style="height:33px;padding-left:20px;font-size:18px;color:0080FF">
				    <cfif sourceCheck.recordcount eq '1'>
					<cf_tl id="We found #sourceReuse.recordcount# profile which may be used to work with for this submission">:
					<cfelse>
					<cf_tl id="We found #sourceCheck.recordcount# profiles of which #sourceReuse.recordcount# may be used to work with for this submission">:
					</cfif>
				</td>
				</tr>
				
				</cfif>
					
			    <tr><td style="padding-left:20px">
						 
						 <table width="100%" class="navigation_table">
						
						  <TR class="labelmedium2 line">
						      <td style="width:30px"></td>
							  <td height="19"><cf_tl id="Date submission"></td>
							  <TD><cf_tl id="Application No"></TD>
							  <TD><cf_tl id="Source"></TD>
						      <TD><cf_tl id="Edition"></TD>
							  <TD><cf_tl id="PHP"></TD>
							  <!---
							  <TD><cf_tl id="Status"></TD>
							  --->
						  	  <TD><cf_tl id="eMail"></TD>
							  <TD><cf_tl id="Officer"></TD>
							  <TD><cf_tl id="Entered"></TD>
					      </TR>								  
						  
						  <cfloop query="SourceCheck">							  
						  						  
							  <cfswitch expression="#URL.Next#"> 
							  
								  <cfcase value="Default">								  
								     <cfset link = "ptoken.location('#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?id=#Candidate.PersonNo#&source=#source#&submissionedition=#url.submissionedition#')">							  
								  </cfcase>
								 										
								  <cfcase value="Patient">	
								  
								  	  <!--- create customer record ---> 		  
								  
									  <cfif url.mission neq "">
									  
									  		<cfquery name="get" 
										     datasource="AppsSelection" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#">
										  	  SELECT * 
											  FROM   WorkOrder.dbo.Customer
											  WHERE  PersonNo = '#personNo#'
											  AND    Mission = '#url.mission#'
											 </cfquery>
											 
											 <cfif get.recordcount eq "1">
	
											   <cfset customerid = get.CustomerId>
											   
											 <cfelse>
											 
											   <cf_assignid>
											   
											   <cfquery name="applicant" 
										     	datasource="AppsSelection" 
											     username="#SESSION.login#" 
											     password="#SESSION.dbpw#">
											  	  SELECT * FROM Applicant
												  WHERE  PersonNo = '#personNo#'									 
											   </cfquery>
										  
											   <cfquery name="InsertSubmission" 
											     datasource="AppsSelection" 
											     username="#SESSION.login#" 
											     password="#SESSION.dbpw#">
											  	   INSERT INTO WorkOrder.dbo.Customer
												         	(CustomerId,
															PersonNo,
														 	Mission,
															Reference,
												  		 	CustomerName, 					 		 	
														 	eMailAddress,					 	
													 	 	OfficerUserId,
														 	OfficerLastName,
														 	OfficerFirstName,	
														 	Created)
											      	VALUES ('#rowguid#',
														    '#PersonNo#',
													       	'#url.Mission#', 
															'#applicant.IndexNo#',
												           	'#applicant.firstname# #applicant.lastname#',				  		  	
															'#applicant.eMailAddress#',														  				
														  	'#SESSION.acc#',
												    	  	'#SESSION.last#',		  
													  	  	'#SESSION.first#',
														  	getDate())
											  </cfquery>
										  
										      <cfset customerid = rowguid>		
											  
											  </cfif>	
											  
											  <cfset link = "ptoken.location('#session.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?context=schedule&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&customerid=#customerid#')">									
									 
									  <cfelse>
									  
									  		<cfset link = "">						 
										  		  
									  </cfif>								  
									  
								  </cfcase>  
								
								 <cfdefaultcase>
								  
								      <cfset link = "ptoken.location('#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?id=#Candidate.PersonNo#&source=#source#&submissionedition=#url.submissionedition#')">
							  
								 </cfdefaultcase>
							  
							  </cfswitch>
							  
							  <cfquery name="Submission" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
									SELECT *, (SELECT count(*) 
									           FROM ApplicantbackGround 
											   WHERE applicantNo = S.ApplicantNo
											   AND   Status != '9') as hasProfile
								    FROM   ApplicantSubmission S
								    WHERE  PersonNo = '#Candidate.PersonNo#' 
									AND    Source = '#source#' 
								</cfquery>
								
								<cfquery name="SubmissionEdition" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT  *
								    FROM    Ref_SubmissionEdition
								    WHERE   SubmissionEdition = '#Submission.SubmissionEdition#' 
								</cfquery>																				  								  
							  
							    <cfif allowEdit eq "1">
								  <tr class="labelmedium2 line navigation_row" style="background-color:white">
							      <td style="padding-top:1px"><cf_img icon="open" onclick="#link#"></td>
								<cfelse>
								  <tr class="labelmedium2 line navigation_row" style="background-color:f1f1f1">
								  <td></td>
								</cfif>
								  <TD>#DateFormat(Submission.SubmissionDate, CLIENT.DateFormatShow)#</TD>
								  <TD>#Submission.ApplicantNo#</TD>
								  <TD>#Submission.Source#</TD>
								  <TD>#Submission.SubmissionEdition#</TD>
								  <TD><cfif submission.hasProfile gte "1">Yes</cfif></TD>
								  <!---
								  <TD>#Submission.ActionStatus#</TD>
								  --->
								  <TD>#Submission.eMailAddress#</TD>
								  <TD>#Submission.OfficerFirstName# #Submission.OfficerLastName#</TD>
							  	  <TD>#DateFormat(Submission.Created, CLIENT.DateFormatShow)#</TD>
							    </tr>												 
								  
								  <cfquery name="Own" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    *
										FROM      OrganizationAuthorization
										WHERE     UserAccount = '#SESSION.acc#' 
										AND       Role IN ('AdminRoster', 'RosterClear')
										AND       ClassParameter = '#SubmissionEdition.Owner#'													 
									</cfquery>	
			  								  
								  	<cfif (session.isAdministrator eq "Yes" 
									     or  findNoCase(SubmissionEdition.Owner,SESSION.isOwnerAdministrator) 
										 or  Own.recordcount gte "1") and allowEdit eq "1"> 
									
									   <TR>
								 
									   <td colspan="8" style="padding-top:1px;padding-left:20px;padding-bottom:7px">		
									 
										 <cf_filelibraryN
											DocumentPath="Submission"
											SubDirectory="#Submission.submissionid#" 	
											Filter=""		
											Insert="yes"
											loadscript="No"
											Box="attach_#submission.ApplicantNo#"
											Remove="yes"
											ShowSize="yes">	
										
										 </td>		
					 
							 		   </TR>
										
									<cfelse>
									
										<cf_fileexist
											DocumentPath="Submission"
											SubDirectory="#Submission.submissionid#"
											Filter="">	
											
										<cfif files gte "1">	
										
										   <TR>
									 
										    <td colspan="8" style="padding-top:1px;padding-left:20px;padding-bottom:7px">
										
											 <cf_filelibraryN
												DocumentPath="Submission"
												SubDirectory="#Submission.submissionid#"
												Filter=""	 			
												Insert="no"
												Box="attach_#ApplicantNo#"
												Remove="no"
												loadscript="No"
												ShowSize="yes">	
											
											 </td>		
						 
								 		   </TR>
									   
									   </cfif>
									
									</cfif>	
														 
						  </cfloop>
						 
						 </table>
				</td></tr>
				
				<cfquery name="Source" dbtype="query">
				    SELECT  *
				    FROM    Source
				    WHERE   AllowEdit = 1
				</cfquery>
								
				<cfif source.recordcount gte "1">
				
					<tr>
					<td class="labellarge" style="padding-top:4px;padding-left:8px">
						<font color="gray"><u><b>OR</b></u> <cf_tl id="create a new profile"></font>
					</td>
					</tr>
												
					<tr>
					<td align="center">						
						<cfinclude template="ApplicantEntrySubmission.cfm">							
					</td>
					</tr>
				
				</cfif>
								
				<tr><td class="line"></td></tr>							
						
			</table>
		
		</cfif>
						
<cfelseif Candidate.recordcount eq 0>	

		<cfquery name="Source" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Source
				WHERE  Operational = 1 
				AND    AllowEdit   = 1 				
				AND    Description != ''
		</cfquery>	
		
		<table width="100%" cellspacing="0" cellpadding="0">
				
				<tr class="labelmedium"><td align="left" style="padding-left:38px">New individual, set Profile source and edition</td></tr>					
				<tr>
				<td align="center" class="labelmedium" style="padding-left:38px">										
				<cfinclude template="ApplicantEntrySubmission.cfm">				
				</td>
				</tr>			
				
		</table>			
					
</cfif>

</cfoutput>


<cfset ajaxonload("doHighlight")>

