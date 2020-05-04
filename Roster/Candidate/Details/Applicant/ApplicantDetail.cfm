
<cf_UserProfilePictureContainer>

<cfparam name="url.drillid" default="">

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  		SELECT   A.*, 
		         R.Description, 
				 R.Scope
  		FROM     Applicant A LEFT OUTER JOIN Ref_ApplicantClass R ON A.ApplicantClass = R.ApplicantClassId
        WHERE    PersonNo = '#URL.ID#'
</cfquery>

<cfquery name="Employee" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT PersonNo
	FROM   Person
	<cfif Candidate.IndexNo neq "">
	WHERE  IndexNo = '#Candidate.IndexNo#'     
	<cfelse>
	WHERE  1 = 0     
	</cfif>
</cfquery>

<cfif Candidate.recordcount neq "1">

	<table align="center"><tr><td class="labelmedium"><cf_tl id="Problem record cound not be found in database"></td></tr></table>
	
<cfelse>	

<table width="100%"><tr><td style="padding:10px">

<table width="100%" style="border:1px solid dadada" align="center" bgcolor="eaeaea">
		
   	<tr>
		<td valign="top">
		
    			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			
				<cfset own = "">
			
				<cfquery name="OwnerCheck" 
					   datasource="AppsSelection" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   	SELECT DISTINCT TOP 1 R.Owner
						FROM   RosterAccessAuthorization A INNER JOIN
        	    	           FunctionOrganization FO ON A.FunctionId = FO.FunctionId INNER JOIN
    	            	       Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition
						WHERE  A.UserAccount = '#SESSION.acc#' 
  		  		</cfquery>
						
				<cfif OwnerCheck.Owner eq "">
				
					<cfquery name="User" 
						   datasource="AppsSystem" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   	SELECT *
							FROM   UserNames
							WHERE  Account = '#SESSION.acc#' 
  		  					</cfquery>	
				
					<cfset own = User.AccountOwner>
					
				<cfelse>
				
					<cfset own = OwnerCheck.Owner>
					
				</cfif>	
				
				<cfif own neq "">
				
						<cfinvoke component = "Service.Process.Applicant.Vacancy"  
						   method           = "Candidacy" 
						   Owner            = "#own#"							   
						   PersonNo         = "#PersonNo#"	
						   Status           = ""   
						   returnvariable   = "Selection">	 						
											 
						<cfif Selection.recordcount gte "0">	 	
      																							
	      					<tr>
	      						<td colspan="3">
																																														   
	      						    <cfset PersonNo = "#URL.ID#">
	      							<table width="100%" align="center">										   
	      							    <cfinclude template="../Functions/ApplicantFunctionSelection.cfm">
	      							</table>
									
	      						</td>
	      					</tr>
						
						</cfif>	
				
				</cfif>		
				
				<cfoutput query="Candidate"> 		
				
 				<tr>
				
					<td valign="top" id="picturebox" style="width:5%;padding-top:8px;padding-right:3px;padding-left:3px">  
					
					<cfinvoke component="Service.Access"  
					   method="roster" 
					   returnvariable="AccessRoster"
					   role="'AdminRoster','CandidateProfile'">		
		
					<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">
												    
							<cf_PictureView documentpath="Applicant"
				                subdirectory="#PersonNo#"
								filter="Picture_" 							
								width="120" 
								height="150" 
								mode="edit">	
													
					<cfelse>
						
							<cf_PictureView documentpath="Applicant"
				                subdirectory="#PersonNo#"
								filter="Picture_" 							
								width="120" 
								height="150" 
								mode="view">					
						
					</cfif>		
									
			 		</td>
				
 					<td id="details" style="padding-left:10px" width="45%">
					
 					<table border="0" cellpadding="0" cellspacing="0" width="100%">
 							<tr>
 								<td width="35%" valign="top" style="padding-top:7px">
								
 										<table width="100%" cellspacing="0" cellpadding="0" class="formPadding">													
 												
 												<tr class="labelmedium" style="height:22px"> 																								   
		  										<td colspan="2" style="min-width:480px" class="labelmedium">																								
												<table>
												<tr>																																																
												<td class="labelmedium" style="font-size:21px">												
												<cfif AccessRoster neq "NONE" and url.drillid neq "">												
													<a href="javascript:ShowCandidate('#Candidate.PersonNo#')">
														#Candidate.LastName#, #Candidate.LastName2# #Candidate.FirstName# #Candidate.MiddleName#&nbsp;<font size="3">#Candidate.PersonNo#</font> 
													</a>													
												<cfelse>																								
													#Candidate.LastName#, #Candidate.LastName2# #Candidate.FirstName# #Candidate.MiddleName#&nbsp;<font size="3">#Candidate.PersonNo#</font> 													
												</cfif>																									
												</td>													
												<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">												
													<td valign="top" style="padding-top:6px;padding-left:4px;padding-right:5px"><cf_img icon="edit" onclick="EditApplicant('#Candidate.PersonNo#')"></td>													
												</cfif>									   					   																								
												</tr>
												
										</table>
																						
									</td>
								</tr>
								
								<cfif DocumentReference neq "" and ApplicantClass eq "4"> 	
													
								    <!--- special provision for patient file reference --->											
									<tr class="labelmedium" style="height:22px">
									<td width="19%"><font color="808080"><cf_tl id="Document Reference">:</td>	 													
									<td>#DocumentReference#</td>
									</tr>
								
								</cfif> 		
																												
								<tr class="labelmedium" style="height:22px">
									<td width="19%" style="min-width:100px"><font color="808080">#client.indexNoName#:</td>
									<td width="70%" colspan="1">   
									  															
										<cfif Employee.PersonNo neq "">
									
											<A title="Employee profile" href="javascript:EditPerson('#Employee.PersonNo#')">
											
											<cfif Candidate.IndexNo eq "">
											    <cf_tl id="Not available">
											<cfelse>
												#Candidate.IndexNo#
											</cfif>																
											
											</a>
											
										<cfelse>
							
											<cfif Candidate.IndexNo eq "">
												<cf_tl id="Not available">
											<cfelse>
											#Candidate.IndexNo# <!--- (not verified!) --->
											</cfif>
								
										</cfif>
						
									</td>
								</tr>
									
								<tr class="labelmedium" style="height:22px">
									<td><font color="808080"><cf_tl id="Gender">:</td>
									<td><cfif Candidate.Gender eq "M"><cf_tl id="Male"><cfelse><cf_tl id="Female"></cfif></td>
								</tr>
									
								<tr class="labelmedium" style="height:22px">
										<td><font color="808080"><cf_tl id="DOB">:</td>
										<td>#Dateformat(Candidate.DOB, CLIENT.DateFormatShow)# (#INT(dateDiff('m', Candidate.DOB, now())/12.0)#)</td>
								</tr>
									
								<tr class="labelmedium" style="height:22px">
										<td><font color="808080"><cf_tl id="Nationality">:</td>
										<td>
																																		
										<cfquery name="Nation" 
									     datasource="AppsSystem" 
									  	 username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     SELECT   *
										 FROM     Ref_Nation
										 WHERE    Code = '#Nationality#'		
										</cfquery>										
										#Nation.Name#</td>
									
								</tr>
								
								<cfif NationalityAdditional neq "">
								
								<tr class="labelmedium" style="height:22px">
										<td><font color="808080"><cf_tl id="Nationality">:</td>
										<td>
																																		
										<cfquery name="Nation" 
									     datasource="AppsSystem" 
									  	 username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     SELECT   *
										 FROM     Ref_Nation
										 WHERE    Code = '#NationalityAdditional#'		
										</cfquery>										
										#Nation.Name#</td>
									
								</tr>
								
								</cfif>
								
								<tr class="labelmedium" style="height:22px">
										<td><font color="808080"><cf_tl id="Status">:</td>
										<td>
																																		
										<cfif CandidateStatus eq "0">
										<font color="FF0000"><cf_tl id="Pending"></font>
										<cfelse>
										<cf_tl id="Cleared">
										</cfif>
									
								</tr>
									
									<!--- deactiveate 6/2/2016
									    													
									<cfif CLIENT.Submission neq "Skill">
									
									<cfelse>
										<td class="labelmedium"><cf_tl id="Profile">:</td>
										<td>
										   <input type="submit" name="Save" value="Submit my profile" class="buttonFlat" onClick="submitPHP('#Candidate.PersonNo#')">
										</td>
									</cfif>
									
									--->
									
 							</table>
 						</td>
		
 						<td width="45%" valign="top" style="padding-left:20px">
 							<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
							<tr><td height="37"></td></tr>
			
							<tr class="labelmedium" style="height:22px">
 									<td class="labelmedium" width="140"><font color="808080"><cf_space spaces="40"><cf_tl id="Birth City">:</td>
 									<td class="labelmedium"><cfif birthcity eq "">N/A<cfelse>#BirthCity#</cfif></td>
 							</tr>
				
							<tr class="labelmedium" style="height:22px">
 									<td class="labelmedium"><font color="808080"><cf_tl id="eMail">:</td>
 									<td class="labelmedium"><cfif Candidate.EMailAddress eq ""><cf_tl id="N/A">
								  	<cfelse>
										<a href="javascript:email('#Candidate.EMailAddress#','','','','Applicant','#Candidate.PersonNo#')">
											<font color="0080C0">#Candidate.EMailAddress#</font>
										</a>
									</cfif>
 									</td>
 							</tr>
							
							<tr class="labelmedium" style="height:22px">
 									<td class="labelmedium"><font color="808080"><cf_tl id="Mobile">:</td>
 									<td class="labelmedium"><cfif Candidate.MobileNumber eq ""><cf_tl id="N/A">
								  	<cfelse>#Candidate.MobileNumber#</cfif>
 									</td>
 							</tr>
 							
							<cfquery name="User" 
						    datasource="AppsSystem" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							   SELECT   *
								FROM    UserNames
								WHERE   ApplicantNo IN (SELECT ApplicantNo 
								                        FROM   Applicant.dbo.ApplicantSubmission 
														WHERE  PersonNo = '#PersonNo#')		
								AND     Disabled = 0						
							   ORDER BY Created DESC															
	  					    </cfquery>		
				
						<tr class="labelmedium" style="height:22px">
							<td><font color="808080"><cf_tl id ="User account">:</td>
							<td>
							
							<cfif User.Account neq "">		
								<table cellspacing="0" cellpadding="0">
							    <cfloop query="User">											
								<tr><td><a href="javascript:ShowUser('#User.account#')">#User.Account#</a><cfif user.recordcount gt "1">;</cfif></td></tr>		
								</cfloop>
								</table>
								
							    <cfelse>
								     <!--- can be removed was for UN galaxy --->
								     <cfif LoginAccount eq "">N/A<cfelse>#LoginAccount#</cfif>
									 
								</cfif>
 							</td>
 						</tr>
 										
						<tr class="labelmedium" style="height:22px">
						<td><font color="808080"><cf_tl id="Marital Status">:</td>
 						<td>
						
						<cfquery name = "qMarital" 
						  datasource = "AppsSelection">
							SELECT * FROM Ref_MaritalStatus
							WHERE Code = '#MaritalStatus#'
						</cfquery>	
						
						<cfif qMarital.recordcount eq "0">N/A<cfelse>											
						#qMarital.Description#
						</cfif>	
						
						</td>
						</tr>		
						
						<tr class="labelmedium" style="height:22px">
						<td><font color="808080"><cf_tl id="Last Viewed">:</td>
 						<td>
						
						<cfquery name = "qLast" 
						  datasource = "AppsSelection">
							SELECT    TOP 1 *
							FROM      ApplicantInquiryLog
							WHERE     PersonNo = '#PersonNo#'
							ORDER BY  ActionTimeStamp DESC		
						</cfquery>	
						
						<cfif qLast.recordcount eq "0">N/A<cfelse>											
						#dateformat(qLast.ActionTimeStamp,client.dateformatshow)# #timeformat(qLast.ActionTimeStamp,"HH:MM")#
						</cfif>	
						
						</td>
						</tr>		
						
						<cfquery name="Last" 
                             datasource="AppsSelection" 
                             username="#SESSION.login#" 
                             password="#SESSION.dbpw#"> 
                                SELECT   TOP 1 A.RecordUpdated as Updated 
                                FROM     ApplicantBackground A INNER JOIN 
                                         ApplicantSubmission S ON A.ApplicantNo = S.ApplicantNo 
                                WHERE    A.Status <> '9' 
                                AND      PersonNo = '#URL.ID#' 
                                ORDER BY A.RecordUpdated DESC
                         </cfquery>   
						 
						 <cfif Last.Updated neq "">                              
													
							<tr class="labelmedium" style="height:22px">
	 								<td><font color="808080"><cf_tl id="Profile Updated">:</td>
	 								<td><cfif Last.Updated neq "">
								     #dateformat(Last.Updated,CLIENT.DateFormatShow)#
								    <cfelse>N/A
									</cfif>
								</td>
							</tr>
						
						</cfif>
					
					</table>
			</td>
						
			<td valign="top" width="29%" style="padding-right:12px">
										
			    <!--- pending the definition of being able to view --->
				
				<table cellpadding="0" width="100%" class="formpadding">
				
	  				<tr><td height="5"></td></tr>
						
						<cfquery name="StatusAssessment" 
					       datasource="AppsSelection" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							SELECT    R.Created, R.Description, R.InterfaceColor, A.Owner
							FROM      ApplicantAssessment A INNER JOIN
					                  Ref_PersonStatus R ON A.PersonStatus = R.Code
							WHERE     A.PersonNo = '#URL.ID#'										
						</cfquery>
						
						<cfloop query="StatusAssessment">
						
							<cfinvoke component="Service.Access"  
							   method="CandidateClear"
							   Owner="#owner#" 
							   returnvariable="AccessClear">		
						
							<cfif AccessClear eq "EDIT" or AccessClear eq "READ" or AccessClear eq "ALL">
							
							<tr>
	 							<td class="labelmedium" width="20%">#Owner#:</td>
	  							<td class="labelmedium" bgcolor="#interfacecolor#">#Description# (#dateformat(created,CLIENT.DateFormatShow)#)</td>
							</tr>
							
							</cfif>
												
						</cfloop>
				
				</table>			
			
			</td>
			
			</cfoutput>
		 	</tr>
		
			</table>
		</td>
	</tr>	
		
	<cfif candidate.scope neq "CaseFile">
					
	   	<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	   		SELECT *
			FROM   Ref_Entity
	   		WHERE  EntityCode = 'Candidate'
	   	</cfquery>
				
		<cfset url.ajaxid = URL.ID>
													
		<cfif Candidate.CandidateStatus eq "0" and check.operational is "1">
								
			<cfoutput>		
			
			   <input type="hidden" 
				   name="workflowlink_#URL.ajaxid#" 
				   id="workflowlink_#URL.ajaxid#" 				   
				   value="#session.root#/Roster/Candidate/Details/Applicant/ApplicantDetailWorkflow.cfm">					
				   								
			   <tr>
				  <td id="#URL.ajaxid#" colspan="3">										  					 
				    <cfinclude template="ApplicantDetailWorkflow.cfm">					    				 
				  </td>
			   </tr>

			</cfoutput>
											
		</cfif>
	
	</cfif>
		
	<cfif Candidate.ApplicantClass neq "4">
					
		<tr><td colspan="3"><cfinclude template="../References/Relatives.cfm"></td></tr>	
		<tr><td colspan="3"><cf_DocumentCandidateReview PersonNo="#URL.ID#" color="transparent"></td></tr>
	
	</cfif>

	<cfif Candidate.ApplicantClass eq "4">
	
		<cftry>
			
			<cfif url.drillid eq "">		
				<cfquery name="get" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  TOP 1 *, 
								C.PersonNo      as CustomerPersonNo, 
							 	WL.ActionStatus as BillingStatus
						FROM    WorkOrderLine WL INNER JOIN
					         	WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
					         	Customer C ON W.CustomerId = C.CustomerId
						WHERE   C.PersonNo = '#URL.ID#'		
						AND     WL.Operational  = 1
				</cfquery>
			<cfelse>
				<cfquery name="get" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *, 
								 C.PersonNo      as CustomerPersonNo, 
								 WL.ActionStatus as BillingStatus
						FROM     WorkOrderLine WL INNER JOIN
						         WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
						         Customer C ON W.CustomerId = C.CustomerId
						WHERE    WorkOrderLineId = '#url.drillid#'		
						AND      WL.Operational  = 1
				</cfquery>	
			</cfif>					
			<!----
			<tr><td colspan="3"><cfinclude template="../../../../WorkOrder/Application/Medical/ServiceDetails/WorkOrderLine/WorkOrderPayer.cfm"></td></tr>
			----->
			<tr><td colspan="3">
			
					<cfset url.id      = "#Candidate.PersonNo#">
					<cfset url.section = "general">
					<cfset url.topic   = "recapitulation">
					<cfset url.source  = "">
					<cfset url.area    = "medical">
					<cfset url.attachment  = "1">
					
					<cfset url.personno = url.id>
					<cfinclude template="../../../PHP/PHPEntry/Topic/TopicRecapitulation.cfm">								
								
			</td></tr>		
			
		<cfcatch>
		
				<tr><td colspan="3">Invalid Context!</td></tr>
				
		</cfcatch>		
		</cftry>	
	</cfif>	
	
	<tr><td height="5"></td></tr>
	
</table>

</td></tr></table>

</cfif>	