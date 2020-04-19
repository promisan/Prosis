
<!--- validate --->

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DOB#" SQLLimit="Yes">
<cfset DOBdate = dateValue>

<cfparam name="Form.Nationality" default="">

<cfif form.dob eq "" or form.lastname eq "" or form.firstname eq "" or form.nationality eq "">
	 <cfabort>
</cfif>

<!--- verify is candidate applicant record exist --->

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Applicant 
	WHERE  LastName          = '#form.LastName#' 
	AND    LEFT(FirstName,1) = '#left(form.FirstName,1)#'
	AND    DOB               = #DOBDate#
	AND    Nationality       = '#form.Nationality#'
</cfquery>

<cfoutput>
 		
<cfif Candidate.recordcount gt 1>

<!--- we should take action --->
<cf_message message="This candidate is duplicated in the database. Please check with your assigned focal point.">

<cfelseif Candidate.recordcount eq 1>
																
			<cfquery name="Source" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Source, Description
				FROM   Ref_Source
				WHERE  Operational = 1 AND AllowEdit = 1 
				AND    Source NOT IN 
					(
						SELECT Source
						FROM   ApplicantSubmission S
						WHERE  S.PersonNo  = '#Candidate.PersonNo#'						
					)
			</cfquery>		
			
			<cfif source.recordcount eq "0">
			
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td align="center" class="labelmedium">
					<font color="FF0000">
						<cf_tl id="Profile exists">
					</font>
				</td></tr></table>
			
			<cfelse>							
								
				<cfquery name="Submission" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   ApplicantSubmission
				    WHERE  PersonNo = '#Candidate.PersonNo#' 
				</cfquery>
				
				<cfquery name="SubmissionEdition" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   Ref_SubmissionEdition
				    WHERE  SubmissionEdition = '#Submission.SubmissionEdition#' 
				</cfquery>

				<table border="0" cellpadding="0" cellspacing="0" width="98%" align="center" class="formpadding">
				
					<tr>
					<td class="labellarge" style="height:50px;padding-left:4px">
						<font color="6688aa"><cf_tl id="Person has existing profiles, select one"></font>
					</td>
					</tr>
						
				    <tr><td style="padding-left:20px">
							 
							 <table border="0" cellpadding="0" cellspacing="0" width="100%">
							
							  <TR class="labelmedium line">
							      <td style="width:30px"></td>
								  <td height="19"><cf_tl id="Date submission"></td>
								  <TD><cf_tl id="Application No"></TD>
								  <TD><cf_tl id="Source"></TD>
							      <TD><cf_tl id="Edition"></TD>
								  <TD><cf_tl id="Origin"></TD>
								  <TD><cf_tl id="Status"></TD>
							  	  <TD><cf_tl id="eMail"></TD>
								  <TD><cf_tl id="Officer"></TD>
								  <TD><cf_tl id="Entered"></TD>
						      </TR>
							  
							  <cfloop query="Submission">
							  
							  <cfswitch expression="#URL.Next#"> 
							  
								  <cfcase value="Default">								  
								     <cfset link = "ptoken.location('#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?id=#PersonNo#&source=#source#&submissionedition=#url.submissionedition#')">							  
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
								  
								      <cfset link = "ptoken.location('#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntryBucket.cfm?id=#PersonNo#&source=#source#&submissionedition=#url.submissionedition#')">
							  
								 </cfdefaultcase>
							  
							  </cfswitch>
							  								  
								  <tr class="labelmedium line">
								      <td style="padding-top:4px"><cf_img icon="select" onclick="#link#"></td>
									  <TD>#DateFormat(SubmissionDate, CLIENT.DateFormatShow)#</TD>
									  <TD>#ApplicantNo#</TD>
									  <TD>#Source#</TD>
									  <TD>#SubmissionEdition#</TD>
									  <TD>#SourceOrigin#</TD>
									  <TD>#ActionStatus#</TD>
									  <TD>#eMailAddress#</TD>
									  <TD>#OfficerFirstName# #OfficerLastName#</TD>
								  	  <TD>#DateFormat(Created, CLIENT.DateFormatShow)#</TD>
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
									  
									  	<cfif session.isAdministrator eq "Yes" or findNoCase(SubmissionEdition.Owner,SESSION.isOwnerAdministrator) or  Own.recordcount gte "1"> 
										
										 <TR>
									 
										  <td colspan="8" style="padding-top:1px;padding-left:20px;padding-bottom:1px">		
										 
										 <cf_filelibraryN
											DocumentPath="Submission"
											SubDirectory="#submissionid#" 	
											Filter=""		
											Insert="yes"
											loadscript="No"
											Box="attach_#ApplicantNo#"
											Remove="yes"
											ShowSize="yes">	
											
											 </td>		
						 
								 		  </TR>
											
										<cfelse>
										
										 <TR>
									 
										  <td colspan="8" style="padding-top:1px;padding-left:20px;padding-bottom:1px">
										
										 <cf_filelibraryN
											DocumentPath="Submission"
											SubDirectory="#submissionid#"
											Filter=""	 			
											Insert="no"
											Box="attach_#ApplicantNo#"
											Remove="no"
											loadscript="No"
											ShowSize="yes">	
											
											 </td>		
						 
								 		  </TR>
										
										</cfif>	
															 
							  </cfloop>
							 
							 </table>
					</td></tr>
						 	      	   
						
					
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
					
					<tr><td class="line"></td></tr>							
							
				</table>
			
			</cfif>
						
<cfelseif Candidate.recordcount eq 0>	

		<cfquery name="Source" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT Source, Description
				FROM   Ref_Source
				WHERE  Operational = 1 
				AND    AllowEdit   = 1 				
				AND    Description != ''
		</cfquery>	
		
		<table width="100%" cellspacing="0" cellpadding="0">
				
				<tr class="labelmedium"><td align="left" style="padding-left:38px"><font color="6688aa">New individual, set Profile source and edition</td></tr>					
				<tr>
				<td align="center" class="labelmedium" style="padding-left:38px">										
				<cfinclude template="ApplicantEntrySubmission.cfm">				
				</td>
				</tr>			
				
		</table>			
					
</cfif>

</cfoutput>

