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

<cf_screentop html="no" jquery="yes">

<cf_param name="CLIENT.ApplicantNo" default="" 						type="string">
<cf_param name="url.ApplicantNo"    default="#CLIENT.ApplicantNo#" 	type="string">
<cf_param name="URL.entryScope"     default="portal" 				type="string">
<cf_param name="URL.id"     		default="" 			type="string">
<cf_param name="URL.owner"     		default="" 			type="string">
<cf_param name="URL.systemfunctionid"	default="" 		type="string">

<!--- hardcoded source of a person --->
<cfparam name="URL.Source"         default="'Inspira','Galaxy','Compendium'">
<cfparam name="URL.Owner"          default="">

<cfparam name="URL.Alias"          default="appsSelection">
<cfparam name="URL.Object"         default="Applicant">

<cfquery name="qProcess" 
	datasource="AppsSystem">
		SELECT 	Max(Created) as StartDate
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Process'
		AND		Operational		= 1
</cfquery>

<cfset StartDate = qProcess.StartDate>

<cfif url.source eq "">
	<cfset url.source = "'Inspira','Galaxy','Compendium'">
</cfif>

<!-- obtain valid profiles, it is better to obtain this from the applications file
- owner - submission - application -> valid submission used for an application of this owner but
then we do not show inspira data yet, so we keep this for now -->

<cfquery name="submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission A, Ref_Source R
	WHERE    ApplicantNo = '#url.applicantNo#' 
	AND      A.Source    = R.Source
	AND      A.Source IN (#preserveSingleQuotes(url.source)#)
	ORDER BY A.Created
</cfquery>

<cfif submission.recordcount eq "0">

	<cfquery name="submission" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ApplicantSubmission A, Ref_Source R
		WHERE    PersonNo    = '#client.PersonNo#'
		AND      A.Source    = R.Source
		AND      A.Source IN (#preserveSingleQuotes(url.source)#)
		ORDER BY A.Created
	</cfquery>

	<cfset url.ApplicantNo = submission.applicantNo>

</cfif>

<cfquery name="get" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Applicant A, Ref_Source R
	WHERE    A.Source = R.Source	
	AND      PersonNo = '#submission.PersonNo#' 	
</cfquery>

<cfset client.ApplicantNo = url.applicantNo>

<cf_paneScript loadStyle="no">

<cfoutput>

<cf_tl id="Job Opening" var="job">

<cfajaximport tags="cfdiv">

<script>
	function reload(app) {	
	   Prosis.busy('yes')
	   _cf_loadingtexthtml='';	
	   window.location.href = '#session.root#/Roster/PHP/PHPEntry/HomeView.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#&owner=#url.owner#&applicantno='+app;
	}
	
	function loadva(id) {	
	    ptoken.open('#session.root#/Vactrack/Application/Announcement/Announcement.cfm?header=yes&id='+id,'va')
	 }
		
</script>

</cfoutput>

 <!--- we generate it --->
 <cf_ModuleInsertSubmit
		   SystemModule   = "Roster" 
		   FunctionClass  = "Window"
		   FunctionName   = "PHP Profile" 
		   MenuClass      = "Dialog"
		   MenuOrder      = "1"
		   MainMenuItem   = "0"
		   FunctionMemo   = "PHP Profile"
		   ScriptName     = ""> 
		   
<cfset url.systemfunctionid = rowguid>

<cfif get.recordcount eq "1">
	<cfset url.PersonNo = get.PersonNo>
</cfif>

<cfif submission.recordcount eq "0">

<table width="100%">
	<tr style="border-bottom:1px solid silver"><td colspan="2" height="25" style="background-color:#ffffff;">
		<cfinclude template="PHPIdentity.cfm">	
	</td></tr>
	<tr><td height="100%" style="font-size:28px;padding:15px; padding-top:60px;" class="labellarge" align="center">
		<font color="red"><cf_tl id="No profile on file, contact your focal point">
	</td>
	</tr>
</table>		

<cfelse>

	<table width="100%" height="100%">
	<tr style="border-bottom:1px solid silver"><td colspan="2" height="25" style="background-color:#ffffff;">
		<cfinclude template="PHPIdentity.cfm">	
	</td></tr>
	<tr><td style="padding:15px; padding-top:0px;">
		
		<table width="100%" height="100%">
		<tr><td height="2"></td></tr>
		<tr>
			
		    <cfif submission.PHPValidation eq "1">
			
				<td valign="top" style="height:100%;width:280;border-right:1px solid silver">
				
					<table width="100%" height="100%">
						<tr>
							<td class="labellarge" valign="top" style="padding:12px; padding-left:0px;">
								<table width="100%">
									<tr>
										<td width="1%" style="background-color:#5b92e5; color:#08579C;">
											<cfoutput>
												<div style="margin-top:-18px; margin-bottom:-15px; padding-left:15px;padding-right:15px">
													<img src="#session.root#/images/logos/person_blue.png">
												</div>
											</cfoutput>
										</td>
										<td style="padding-top:5px; padding-bottom:5px; background-color:#ffffff">
											<table width="100%">
												<tr><td class="labellarge" style="color:#103F69; padding-left:5px; font-size:20px;"><cf_tl id="Update #submission.source# Profile"></td></tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td height="100%" style="padding-top:10px;padding-left:20px;" valign="top">
						
						<cf_divscroll>
																	
							<cfinvoke component = "Service.Validation.Controller"  
							   method           = "Control" 
							   systemFunctionId = "#url.systemfunctionid#"
							   mission          = "" 
							   owner            = ""
							   object           = "Applicant"
							   objectKeyValue1  = "#url.ApplicantNo#"
							   objectKeyValue2  = "#url.PersonNo#"
							   objectKeyValue3  = "#url.owner#"
							   target           = "Summary">	
							   
							</cf_divscroll>     
						
						</td></tr>
					</table>	
					
					
				
				</td>
			
			</cfif>
			
			<td valign="top">
			
			<table width="100%" height="100%">
			
			  <tr>
			   	   <td class="labellarge" valign="top" style="height:80px;padding-left:8px;padding-right:8px;padding-top:2px;;font-size:25px">
				      <table border="0" width="100%" height="100%">
					  <tr>
						<td class="labellarge" valign="top" style="padding:10px; padding-left:0px;">
							<table width="100%">
								<tr>
									<td width="1%" style="background-color:#5b92e5; color:#08579C;">
										<cfoutput>
											<div style="margin-top:-18px; margin-bottom:-15px; padding-left:15px;padding-right:15px">
												<img src="#session.root#/images/logos/file_blue.png">
											</div>
										</cfoutput>
									</td>
									<td style="padding-top:5px; padding-bottom:5px; background-color:#ffffff;">
										<table width="100%">
											<tr><td class="labellarge" style="color:#103F69; padding-left:5px; font-size:23px;"><cf_tl id="Active Personal History Profile"></td></tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					  <tr>
							<td class="labellarge" style="padding:15px;height:90%" valign="top">												
							<cfinclude template="HomeListing.cfm">						
							</td>
					  </tr>
					  </table>
				   </td>
			   </tr>	
			   
			   <tr style="border-top:1px solid silver">
			   	   <td class="labellarge" valign="top" style="height:200px;padding:8px;font-size:25px">
				      <table border="0" width="100%" height="100%">
					  <tr>
						<td class="labellarge" valign="top" style="padding:8px; padding-left:0px;">
							<table width="100%">
								<tr>
									<td width="1%" style="background-color:#5b92e5; color:#08579C;">
										<cfoutput>
											<div style="margin-top:-18px; margin-bottom:-15px; padding-left:15px;padding-right:15px">
												<img src="#session.root#/images/logos/people_blue.png">
											</div>
										</cfoutput>
									</td>
									<td style="padding-top:5px; padding-bottom:5px; background-color:#ffffff;">
										<table width="100%">
											<tr><td class="labellarge" style="color:#103F69; padding-left:5px; font-size:23px;"><cf_tl id="Roster Membership Status"></td></tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					  <tr>
							<td class="labellarge" style="padding:15px;height:90%" valign="top">
							<cfinclude template="../Bucket/BucketView.cfm">
							</td>
					  </tr>
					  </table>
				   </td>
			   </tr>
			   
			   
			   <tr style="border-top:1px solid silver">
			   	   <td class="labellarge" valign="top" style="height:150px;padding:8px;font-size:25px">
				      <table border="0" width="100%" height="100%">
					  <tr>
						<td class="labellarge" valign="top" style="padding:8px; padding-left:0px;">
							<table width="100%">
								<tr>
									<td width="1%" style="background-color:#5b92e5; color:#08579C;">
										<cfoutput>
											<div style="margin-top:-18px; margin-bottom:-15px; padding-left:15px;padding-right:15px">
												<img src="#session.root#/images/logos/specials-personal-documents.png">
											</div>
										</cfoutput>
									</td>
									<td style="padding-top:5px; padding-bottom:5px; background-color:#ffffff;">
										<table width="100%">
											<tr><td class="labellarge" style="color:#103F69; padding-left:5px; font-size:23px;"><cf_tl id="Specialities and Documents"></td></tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>

					  <tr>
							<td class="labellarge" style="padding:4px;height:90%" valign="top">
							
							<table style="border:0px solid silver">
														
							<cfquery name="specialties" 
								datasource="appsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">										
								
								SELECT    LC.ListLabel
								FROM      ApplicantSubmissionTopic AS ST INNER JOIN
								          Ref_Topic AS R ON ST.Topic = R.Topic INNER JOIN
								          ApplicantSubmission AS S ON ST.ApplicantNo = S.ApplicantNo INNER JOIN
								          Ref_TopicList AS RL ON ST.Topic = RL.Code AND ST.ListCode = RL.ListCode INNER JOIN
								          Ref_TopicListCode AS LC ON RL.ListCode = LC.ListCode
								WHERE     S.PersonNo  = '#Submission.PersonNo#' 
								AND       R.Parent    = 'Skills' 
								AND       S.Source IN ('Inspira','Galaxy')
								AND       RL.ListValue <> 'n/a'
															
							</cfquery>	
							
						 <cfif client.languageId eq "ENG">	
						  <tr>
							  <td colspan="2" class="labelmedium" style="padding-top:2px;padding-left:5px">
							  You have <cfif specialties.recordcount eq "0">
							      <font color="red"><cf_portalTab mode="GoTo" id="#url.id#" functionname="Specialty" content="NO"></b></font>
								  <cfelse>
								  <b><font color="0080C0"><cf_portalTab mode="GoTo" id="#url.id#" functionname="Specialty" content="#specialties.recordcount#"></b></font></cfif> 
								  specialitie<cfif specialties.recordcount neq "1">s</cfif> recorded. Please update them at your convenience.				  
							  </td>
						  </tr>
						  
						  <cfquery name="total" dbtype="query">
						  	    SELECT    ListLabel, count(*) as Total
								FROM      specialties								
								GROUP BY  ListLabel
						  </cfquery>	

						  <tr>													  
						  <td colspan="2">
						  <table>
						  <tr class="labelmedium">
						  <cfoutput query="total">						  
							  <td style="color:258792;padding-left:15px;padding-right:10px">#ListLabel# : #total#</td>						  
						  </cfoutput>
						  </tr>
						  </table>
						  </tr>
						  
						  
						  <cfelseif client.languageId eq "FRA">
						  
						  <cfelse>
						   <tr>
							  <td class="labelmedium" style="padding-top:10px;padding-left:5px">
							  You have <b><font color="0080C0"><u><cf_portalTab mode="GoTo" id="#url.id#" functionname="ResToBroadCasts" content="#specialties.recordcount#"></u></b></font> specialities recorded. Please add or edit at your convenience.				  
							  </td>
						  </tr>
						  		  
						  </cfif>


							<cfquery name="qDocuments" 
								datasource="appsSelection" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">										
								SELECT DT.Description,AP.*
								FROM   ApplicantDocument AP INNER JOIN 
									Employee.dbo.Ref_DocumentType DT ON AP.DocumentType = DT.DocumentType
				   				WHERE  PersonNo = '#Submission.PersonNo#'
				   				AND DT.DocumentUsage in ('2','3')								
							</cfquery>	
							
						 <cfif client.languageId eq "ENG">	
						  <tr>
							  <td colspan="2" class="labelmedium" style="padding-top:2px;padding-left:5px">
							  You have <cfif qDocuments.recordcount eq "0">
							      <font color="red"><cf_portalTab mode="GoTo" id="#url.id#" functionname="Document" content="NO"></b></font>
								  <cfelse>
								  <b><font color="0080C0"><cf_portalTab mode="GoTo" id="#url.id#" functionname="Document" content="#qDocuments.recordcount#"></b></font></cfif> 
								  document<cfif qDocuments.recordcount neq "1">s</cfif> recorded. Please update them at your convenience.				  
							  </td>
						  </tr>
						  
						  <cfquery name="total" dbtype="query">
						  	    SELECT    Description, count(*) as Total
								FROM      qDocuments								
								GROUP BY  Description
						  </cfquery>	

						  <tr>													  
						  <td colspan="2">
						  <table>
						  <tr class="labelmedium">
						  <cfoutput query="total">						  
							  <td style="color:258792;padding-left:15px;padding-right:10px">#Description# : #total#</td>						  
						  </cfoutput>
						  </tr>
						  </table>
						  </tr>
						  
						  
						  <cfelseif client.languageId eq "FRA">
						  
						  <cfelse>
						   <tr>
							  <td class="labelmedium" style="padding-top:10px;padding-left:5px">
							  You have <b><font color="0080C0"><u><cf_portalTab mode="GoTo" id="#url.id#" functionname="ResToBroadCasts" content="#specialties.recordcount#"></u></b></font> documents recorded. Please add or edit at your convenience.				  
							  </td>
						  </tr>
						  		  
						  </cfif>
						
						  </table>
							
							
							</td>
					  </tr>
					  </table>
				   </td>
			   </tr>
			   
			   <tr style="border-top:1px solid silver">
			       <td height="30%" class="labellarge" valign="top" style="padding:8px;font-size:25px">
				   
				   <table width="100%">
					  <tr>
						<td class="labellarge" valign="top" style="padding:8px; padding-left:0px;">
							<table width="100%">
								<tr>
									<td width="1%" style="background-color:#5b92e5; color:#08579C;">
										<cfoutput>
											<div style="margin-top:-18px; margin-bottom:-15px; padding-left:15px;padding-right:15px">
												<img src="#session.root#/images/logos/bell_blue.png">
											</div>
										</cfoutput>
									</td>
									<td style="padding-top:5px; padding-bottom:5px; background-color:#ffffff;">
										<table width="100%">
											<tr><td class="labellarge" style="color:#103F69; padding-left:5px; font-size:23px;"><cf_tl id="Official Communication"></td></tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					  	
						<cfquery name="message" 
						datasource="appsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			  
				
						    SELECT *
							FROM (
							SELECT    M.*, 
							         (SELECT OfficerLastName FROM System.dbo.BroadCast WHERE BroadcastId = M.Functionid) as OfficerLastName,
									 (SELECT count(*)        FROM Organization.dbo.OrganizationObject O WHERE M.MailId = O.ObjectKeyValue4) as OpenMode
						    FROM     Applicant.dbo.ApplicantMail M 		 
							WHERE    M.PersonNo = '#Submission.PersonNo#'			
							AND      M.MailStatus = '1' ) as B
							WHERE 1=1	
							AND MailDateSent >= '#StartDate#'
						</cfquery>	
						
						<cfquery name="new" dbtype="query">					
							SELECT * FROM message 
							WHERE OpenMode = 0	
							AND MailDateSent >= '#StartDate#'
						</cfquery>		
						
						
					  <cfoutput>
					  
					  	  <cfif client.languageId eq "ENG">	
						  <tr>
							  <td class="labelmedium" style="padding-top:10px;padding-left:5px">
							  You have <b><font color="0080C0"><cf_portalTab mode="GoTo" id="#url.id#" functionname="ResToBroadCasts" content="#message.recordcount#"></b></font> official roster notifications. There <cfif new.recordcount eq "1">is<cfelse>are</cfif> notification<cfif new.recordcount gte "2">s</cfif> which you have not viewed yet. Please do so at your earliest convenience.				  
							  </td>
						  </tr>
						  <cfelseif client.languageId eq "FRA">
						  
						  <cfelse>
						   <tr>
							  <td class="labelmedium" style="padding-top:10px;padding-left:5px">
							  You have <b><font>#message.recordcount#</font></b> official roster notifications. There <cfif new.recordcount eq "1">is<cfelse>are</cfif> <b><font size="6" color="FF0000">#new.recordcount#</font></b> notification<cfif new.recordcount gte "2">s</cfif> which you have not viewed yet. Please do so at your earliest convenience.				  
							  </td>
						  </tr>					  
						  </cfif>
					  
					  </cfoutput>
				   
				   
				   </table>
				   
				   </td>
				   
			   </tr>
			</table>
			
			</td>		
		</tr>
		</table>
	
	</td></tr>
	</table>
	
</cfif>	

<script>
 Prosis.busy('no')
</script>
