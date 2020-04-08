
<cfquery name="Submission" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT APPS.*,
	       RS.EntityClass
    FROM   ApplicantSubmission AS APPS
		   INNER JOIN Ref_SubmissionEdition RS
		   		ON APPS.SubmissionEdition = RS.SubmissionEdition
    WHERE  PersonNo = '#URL.ID#' AND Source = '#url.source#'
</cfquery>


<cfquery name="SubmissionEdition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Ref_SubmissionEdition
    WHERE  SubmissionEdition = '#Submission.SubmissionEdition#' 
</cfquery>

<table border="0" width="98%" align="center">
		
     <tr><td>
			 
			 <table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
			
			  <TR class="labelmedium line">
			  	  <td></td>
				  <td height="19" ><cf_tl id="Date submission"></td>
				  <TD><cf_tl id="Application No"></TD>
				  <TD><cf_tl id="Source"></TD>
			      <TD><cf_tl id="Edition"></TD>
				  <TD><cf_tl id="Origin"></TD>
				  <TD><cf_tl id="Status"></TD>
			  	  <TD><cf_tl id="eMail"></TD>
				  <TD><cf_tl id="Officer"></TD>
				  <TD><cf_tl id="Entered"></TD>
		      </TR>
			  
			  <cfoutput query="Submission">			  
				 
				  <tr class="labelmedium navigation_row">
				  	  <td>

					   <cfif EntityClass neq "" >
					   
				   			<cf_wfactive entityCode="CanSubmission" ObjectKeyValue1="#ApplicantNo#">

							<cfset iconStatus = "open">
							
							<cfif wfstatus eq "closed">
								<cfset iconStatus = "">
							</cfif>
							
							<cf_img icon="expand" toggle="Yes" onclick="workflowdrill('#applicantno#','box_#applicantno#')" state="#iconstatus#">
						
					  <cfelse>
					  
					  	<cfset wfstatus = "">
					  	
				   	  </cfif>
					  
					  </td>
					  <TD style="height:23px;padding-left:3px">#DateFormat(SubmissionDate, CLIENT.DateFormatShow)#</TD>
					  <TD>#ApplicantNo#</TD>
					  <TD>
					  
						  <cfquery name="Submission" 
								datasource="AppsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT ApplicantNo 
	  							FROM   ApplicantBackGround A 
								WHERE  ApplicantNo = '#applicantNo#' 
								AND    Status < '9'
						  </cfquery>
						  
						  <cfif submission.recordcount gte "1">
						  
						  <cf_RosterPHP 
								DisplayType = "HLink"
								Image       = "#SESSION.root#/Images/pdf_small.gif"
								DisplayText = "#Source#"
								style       = "height:14;width:16"
								Script      = "#currentrow#"
								RosterList  = "#ApplicantNo#"
								Format      = "Document">	
						  
						  <cfelse>
						  
						  	#ApplicantNo#
						  
						  </cfif>
					 					  
					  </TD>
					  <TD>#SubmissionEdition#</TD>
					  <TD>#SourceOrigin#</TD>
					  <TD>#ActionStatus#</TD>
					  <TD>#eMailAddress#</TD>
					  <TD>#OfficerFirstName# #OfficerLastName#</TD>
				  	  <TD>#DateFormat(Created, CLIENT.DateFormatShow)#</TD>
				  </tr>
				  
				 <input type	= "hidden" 
				   	name 	= "workflowlink_#applicantno#" 
				   	id   	= "workflowlink_#applicantno#"
				   	value	= "#client.root#/Roster/Candidate/Details/Applicant/ApplicantSubmissionWorkflow.cfm">	
				
				  <cfif wfstatus neq "closed">
					  <tr id="box_#applicantno#">
						<td colspan="10" style="padding-left:25px;"  id="#applicantno#">								   
							<cfdiv id="#applicantno#" bind="url:Applicant/ApplicantSubmissionWorkflow.cfm?ajaxid=#applicantno#"/>       															
						</td>
					  </tr>	
				  <cfelse>
				 	 <tr id="box_#applicantno#" class="hide"> 
						<td colspan="10" id="#applicantno#"></td>	
					</tr>
				  </cfif>
				  
				  <!--- nery I would show here the result of the submission record in more details --->
				  
				  <cfif EntityClass eq "">
				  				  
				  	<cfquery name="Own" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      OrganizationAuthorization
							WHERE     UserAccount = '#SESSION.acc#' 
							AND       Role IN ('AdminRoster','RosterClear')
							AND       ClassParameter = '#SubmissionEdition.Owner#'													 
						</cfquery>			
				  				  
					  <cfif session.isAdministrator eq "Yes" or 
								findNoCase(SubmissionEdition.Owner,SESSION.isOwnerAdministrator) or 
								Own.recordcount gte "1"> 
								
								 <TR>
					 
								  <td colspan="10" style="padding-top:4px;padding-right:10px">		
								 
							 		<cf_filelibraryN
										DocumentPath="Submission"
										SubDirectory="#submissionid#" 	
										Filter=""		
										Insert="yes"
										loadscript="No"
										Box="mysubmission"
										Remove="yes"
										ShowSize="yes">		
																				
								</td>
						
								</tr>											
										
						</cfif>								
				  
				  <cfelse>
				  
					   <cfquery name="getObject" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT TOP 1 ObjectId
							FROM   OrganizationObject
							WHERE  EntityCode      = 'CanSubmission'
							AND    ObjectKeyValue1 = '#ApplicantNo#'
							AND    Operational     = 1							
					   </cfquery>			
					   
					   <cfif getObject.recordcount eq "1"> 
					  				  
						   <cfquery name="getQuestion" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								  SELECT   R.QuestionLabel, 
								           OQ.QuestionId, 
										   OQ.OfficerFirstName,
										   OQ.OfficerLastName,
										   OQ.QuestionScore, 
										   R.InputMode,
										   R.InputValuePass
								  FROM     OrganizationObjectQuestion OQ INNER JOIN
					                       Ref_EntityDocumentQuestion R ON OQ.QuestionId = R.QuestionId AND (OQ.QuestionScore <> R.InputValuePass OR
					                       R.InputValuePass IS NULL)
								  WHERE    OQ.ObjectId = '#getObject.ObjectId#' 
								  ORDER BY ListingOrder
						   </cfquery>
						   
						   <TR>
					 
								  <td colspan="10" style="padding-left:25px">	
								  
								  <table width="90%"  cellspacing="0" cellpadding="0">
								  <cfloop query="getQuestion">
									  <tr class="labelmedium navigation_row">
									     <td width="10" style="padding-left:4px">-</td>
									     <td width="80%">#QuestionLabel#</td>
										 <td>#OfficerFirstName# #OfficerLastName#</td>
										 <td>
										 <cfif InputMode eq "YesNo" or InputMode eq "YesNoNA"> 
										 <cfif QuestionScore eq "0">No<cfelseif QuestionScore eq "1">Yes<cfelse>N/A</cfif>
										 <cfelse>
										 #QuestionScore#
										 </cfif>
										 </td>
										 <td style="padding-left:6px;padding-right:4px">
										 <cfif QuestionScore eq InputValuePass>									 
											 <table><tr><td bgcolor="green" style="color:green;height:10;width:10;border:1px solid gray"></td></tr></table>
										 <cfelseif QuestionScore eq "9">
										 	<table><tr><td bgcolor="yellow" style="color:yellow;height:10;width:10;border:1px solid gray"></td></tr></table>	 
										 <cfelse>
										 	<table><tr><td bgcolor="red" style="color:red;height:10;width:10;border:1px solid gray"></td></tr></table>	
										 </cfif>										 
										 </td>
									  </tr>								  
								  </cfloop>
								  </table>
								  
								  </td>
								  
							</tr>	  
				  			  				  
						</cfif> 		  
				 							
					</cfif>	
						
						<tr><td class="line" colspan="8"></td></tr>
				 
			  </cfoutput>
			 
			 </table>
	 </td></tr>
			 	      	   
</table>

<cfset ajaxonload("doHighlight")>
		 