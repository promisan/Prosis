<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.action" default="">
<cfparam name="url.mode"  default="view">

<cfif url.event eq "Inquiry">

	<cfset url.scope = "inquiry">

<cfelse>

    <cfset url.scope = "personal">

</cfif>

<cfquery name="Event" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEvent
		WHERE  Code    = '#URL.event#'		
</cfquery>		

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission	
		WHERE  	PersonEvent	= '#URL.event#'	
		AND		Mission = '#url.mission#'						
</cfquery>

 <cfquery name="OnBoard" 
 datasource="AppsEmployee"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   P.*
	 FROM     PersonAssignment PA, Position P
	 WHERE    PersonNo           = '#URL.id#'
	 AND      PA.PositionNo      = P.PositionNo
	 AND      PA.DateEffective   <= getdate()	 
	 <!--- limit access by mission --->		 
	 <!---
	 AND      PA.DateExpiration  >= getDate()
	 --->
	 AND      PA.AssignmentStatus IN ('0','1')
	 <!---
	 AND      PA.AssignmentClass = 'Regular'
	 --->
	 AND      PA.AssignmentType  = 'Actual'
	 ORDER BY Incumbency DESC						
 </cfquery>  

<cfif url.event eq "inquiry">
    <cfset scope = "Inquiry">
<cfelse>
    <cfset scope = "Personal">
</cfif>

 <cf_divscroll>
		
<table align="left" style="height:100%;width:99%" border="0">

	<tr>
	<td>
		<table width="100%">
			<tr class="fixrow">
			
			    <td colspan="2" style="background-color:white;padding-top:5px;font-size:34px" class="fixlength labellarge" colspan="2">						
					<cf_tl id="#Event.Description#">						
				</td>
				
				<td align="right" style="background-color:white;padding-top:5px;padding-right:10px">
				    <!---
					<cfif qEvents.recordcount gt 0 and OnBoard.recordcount gt 0>
					--->
					<cfif qEvents.recordcount gt 0 and scope eq "Personal">				     
									
						  <cf_tl id="New Request" var="1">		   
						  <cfoutput>
					    	<input type="button" 
								value="#lt_text#" 
								class="button10g" 
								style="width:190;height:35px;font-size:17px;background-color:1A8CFF;color:white;" 
								onclick="javascript:eventadd('#URL.id#','#scope#','#url.mission#','','#url.event#');">
						</cfoutput>
						
					</cfif>
				</td>
			</tr>
			
			<!--- is like a sub menu to click immeidately on the trigger --->
			
			<cfif url.scope eq "inquiry" and url.event eq "inquiry">
			
			<tr>
			<td colspan="3" style="padding-bottom:8px;padding-top:13px;font-size:17px;"><cfoutput>Please select the subject that best matches your request</cfoutput></td>
			</tr>
			
			<tr>
			<td colspan="3" style="padding-top:4px;background-color:f4f4f4">						
						
				<cfquery name="qTriggers" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   Code,
						         Description,
						         ListingOrder,
						         OfficerUserId,
						         OfficerLastName,
						         OfficerFirstName,
						         Created
								 
						FROM     Ref_EventTrigger
						
						WHERE    Code IN (
								  	SELECT  EventTrigger
									FROM    Ref_PersonEventTrigger ET 
									        INNER JOIN Ref_PersonEvent PE         ON ET.EventCode=PE.Code 
											INNER JOIN Ref_PersonEventMission REM ON REM.PersonEvent=ET.EventCode
									WHERE   REM.Mission = '#url.mission#'
									<cfif url.portal eq "1">
									AND     PE.EnablePortal = 1
									</cfif>
									<!--- we filter for the inquiry personal portal --->					
									AND    ET.ActionImpact = 'inquiry'
											
						         )		 
						
						<cfif url.scope eq "portal">
						AND      Selfservice = 1
						</cfif>
						 
						ORDER BY ListingOrder
						
				</cfquery>
						
			<table style="width:100%">
			<cfset i = 0>
			<cfoutput query="qTriggers">
			   <cfset i = i+1> 
			   <cfif i eq "1">
			   <tr class="labelmedium2 fixlengthlist">
			   </cfif>
			      <td style="padding-left:20px;font-size:17px;font-weight:bold"><a href="javascript:eventadd('#URL.id#','#scope#','#url.mission#','#Code#','#url.event#');"><li>#Description#</li></a></td>
			   <cfif i eq "3"> 	  
 			    </tr> <cfset i = 0>
			   </cfif>	
		   </cfoutput>
			
			</table>
			</td>
			</tr>
					
			
			</cfif>
			
			<tr>
			<td colspan="3" style="padding:6px;padding-top:15px"><cfoutput>#qevents.Instruction#</cfoutput></td>
			</tr>
						
		</table>
	</td>
	</tr>

	<tr><td style="padding-left:10px;padding-right:10px;height:100%;padding-top:10px" valign="top">
	
		<table width="100%" align="center" class="formpadding navigation_table"">
					
		<TR class="line labelmedium fixrow fixlengthlist">
		    <td style="background-color:white;"><cf_tl id="Reference"></td>  
			<td style="background-color:white;min-width:60px;"></td>	
			<td style="background-color:white;min-width:60px;"></td>								    		     			
		    <td style="background-color:white;"><cf_tl id="Category">|<cf_tl id="Request"></td> 			
			<td style="background-color:white;"><cf_tl id="Requested"></td>
			<td style="background-color:white;"><cf_tl id="Priority"></td>	
			
			<td style="background-color:white;"><cf_tl id="Status"></td>  		
		</TR>
		
		<!--- define mission --->
		
		<cfquery name="Mis" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission			
			FROM   Ref_ParameterMission RM
			WHERE  EXISTS (
					SELECT DISTINCT Mission
					FROM   PersonEvent PE
					WHERE  PersonNo = '#url.id#'
					AND    RM.Mission = PE.Mission )
			<cfif trim(url.mission) neq "">
			AND 	Mission = '#url.mission#'
			</cfif>
		</cfquery>
		
		<cfoutput query="Mis">
		
			<!--- check if person has access to this mission to view --->
			
			<cfinvoke component = "Service.Access"  
			   method           = "staffing" 
			   mission          = "#Mission#" 			  			  
			   returnvariable   = "accessStaffing">	  
			   			
			<cfif accessStaffing neq "NONE" or accessStaffing eq "NONE">
								
				<cfquery name="EventsAll" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ET.Description    as TriggerDescription,
					       RefPE.Description as EventDescription, 
						   RefPE.ListingOrder, 
						   RefPE.EntityClass,
						   PE.PersonNo,
						   PE.EventId,
						   PE.EventSerialNo,
						   PE.Mission,
						   PE.PositionNo,
						    (   SELECT SourcePostNumber
							    FROM   Position
							    WHERE  PositionNo = Pe.PositionNo					   
						   ) as SourcePostNumber,	
						   (   SELECT PositionParentId
							    FROM   Position
							    WHERE  PositionNo = Pe.PositionNo					   
						   ) as PositionParentId,	
						   PE.DocumentNo,						  	
						   Pe.EventPriority,		  
						   PE.OfficerFirstName, 
						   PE.OfficerLastName, 
						   PE.ActionStatus,		
						   PE.EventCode,		  
						   PE.EventTrigger,
						   PE.ReasonCode,
						   PE.ReasonListCode,
						   (   SELECT GroupListCode+' '+Description 
							   FROM   Ref_PersonGroupList
							   WHERE  GroupCode = Pe.ReasonCode
							   AND    GroupListCode = Pe.ReasonListCode
						   ) as ReasonDescription,	
						   ET.EntityCode,			   			   
						   PE.Created, 
						   PE.DateEvent, 
						   PE.DateEventDue,
						   PE.ActionDateEffective,
						   PE.ActionDateExpiration,
						   PE.Remarks, 
						   PE.PersonNo as Selected
					FROM   PersonEvent PE 
						   INNER JOIN Ref_PersonEvent RefPE ON PE.EventCode = RefPE.Code 
				           INNER JOIN Ref_EventTrigger ET ON ET.Code = PE.EventTrigger
				    WHERE  PE.ActionStatus != 9			
					AND    PE.Mission = '#Mis.mission#' 
					AND    PE.Personno = '#URL.ID#'
					<!--- only his/her own --->
					AND    PE.OfficerUserId = '#session.acc#'
					
					<cfif url.event eq "Inquiry">
										
					    AND RefPE.Code IN (SELECT EventCode 
						                        FROM   Ref_PersonEventTrigger 
												WHERE  EventTrigger = PE.EventTrigger 
												AND    ActionImpact = 'Inquiry') 
					
					<cfelse>
					
						<cfif trim(url.trigger) neq "">
						AND 	ET.Code = '#url.trigger#'
						</cfif>
						<cfif trim(url.event) neq "">
						AND 	PE.EventCode = '#url.event#'
						</cfif>
						
					</cfif>	
					
				    ORDER BY PE.Created DESC		
				    	
				</cfquery>
				
											
				<cfif EventsAll.recordcount neq "0">
					 		 		
					<cfloop query="EventsAll">
					
					    <cfif actionStatus eq "3">
												
						   <cfset cl = "D6FEDF">
						
						<cfelse>
						
						   <cfset cl = "ffffff">
							
						</cfif>
					
						<TR class="labelmedium2 navigation_row line fixlengthlist" id="#eventid#_1" style="height:35px;background-color:#cl#">		   
							
								<td>#EventSerialNo#
							   <!--- <cfif ActionDateExpiration gte ActionDateEffective>#dateformat(ActionDateExpiration,client.dateformatshow)#</cfif> --->
							   </td>		
							   	
							   <td align="right" style="padding-left:6px;max-width:100px;min-width:110px;" id="status_#eventid#">
							   
							        <table><tr><td>
							   
							   		<cfif ActionStatus eq "0">
									
									<input type="button" value="Edit" style="width:45px" name="Edit" class="button10g" 
									   onClick="eventedit('#eventid#','#url.scope#','#url.portal#')">
																   													
									<cfelseif ActionStatus eq "3">
																	
									    <cfif getAdministrator("#mission#")>
																				
										<img src="#session.root#/Images/check.png"  title="Completed"
										   alt="" width="25" height="25" border="0">
																					
										<cfelse>
										
										<img src="#session.root#/Images/check.png" title="Completed" 
										   alt="" width="25" height="25" border="0">
										</cfif>   
										
									<!--- closed --->		
								    </cfif>
									
									<cfquery name="Mail" 
									 datasource="AppsOrganization"
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
										 SELECT TOP 1 * 
										 FROM  OrganizationObjectActionMail OA
										 WHERE ObjectId IN (SELECT ObjectId FROM OrganizationObject WHERE ObjectKeyValue4 = '#eventid#' and Operational = 1) 
										 AND   ActionStatus != '8' <!--- 8= preparation --->
								   </cfquery>	
								   
								   </td>
								   
								   <td style="max-width:50px;min-width:60px">
							   
								   <cfinvoke component="Service.Access"  
									      method="org" 
										  mission="#Mission#" 
										  returnvariable="access">
										 
										<cfif actionStatus eq "0"> 
														
												<cfif ActionStatus eq "0" or ActionStatus eq "1">		
													
													<input type="button" value="Cancel" style="width:55px" name="Cancel" class="button10g" onClick="eventdelete('#eventid#','','#url.scope#')">
									   															
									   			</cfif>
																					   
										</cfif>
							   
							       </td>
								   								   
								   </tr></table>			
								   
								</td>   
					
								<td align="center" valign="middle" style="width: auto; min-width: 20px;"> 
																	 
									<cfif Mail.recordcount eq "1">
									 										 	
									 	<img src="#SESSION.root#/Images/Mail-Check.png" title="Show EMail that was sent" 
							        	id="m#eventid#boxMax" 
										border="0"						
										width="32" 
										class="regular" 
										align="absmiddle" 
										style="cursor: pointer;"
										onClick="eventworkflowmail('m','#eventid#box','#mail.ObjectId#')">
															
										<img src="#SESSION.root#/Images/Mail-Open.png" 
										id="m#eventid#boxMin" 
										alt="Hide EMail" border="0" height="32"	width="32" align="absmiddle" 
										class="Hide" style="cursor: pointer;"
										onClick="eventworkflowmail('m','#eventid#box','#mail.ObjectId#')">
																
									</cfif>
							   </td>
							
							   
							   
							    <!---
							   	<cfif EntityClass neq "">
							   			
							   		<cfif ActionStatus eq "0">
									    <cfset vMode = "selected">
			  						<cfelse>
			     						<cfset vMode = "">
			  						</cfif> 
							   		<cf_img icon="expand" toggle="Yes" 
									 onclick="workflowdrill('#eventid#','box_#eventid#')" mode="#vMode#">
										
							   	</cfif>
								--->														   				   
							  							   
				               <TD colspan="1">
				               		<font color="808080">#TriggerDescription#:&nbsp;</font>#EventDescription#
				               		<cfif ReasonDescription neq "">
										&nbsp;-&nbsp;#ReasonDescription#									               			
				               		</cfif>	
									<cfif EntityCode eq "VacCandidate" and documentNo neq "0">
									<a href="javascript:showdocument('#documentno#')">(#DocumentNo#)</a></font>
									</cfif>
				               	</TD>
														   
								<td>#dateformat(created,client.dateformatshow)# #timeformat(created,"HH:MM")#</td>		               	
								
								<cfif eventpriority eq 'High'>
								<td align="center" style="background-color:<cfif eventpriority eq 'High'>FFB164</cfif>">#EventPriority#</td>
								<cfelse>
								<td><cf_tl id="Normal"></td>
								</cfif>
																
								 <td style="min-width:100px;padding-right:10px;min-width:120px">						   
							   
								   <cfif EntityClass neq "">
							
										<input type  	= "hidden" 
										       name 	= "workflowlink_#eventid#" 
										   	   id   	= "workflowlink_#eventid#"
										   	   value	= "#client.root#/Staffing/Portal/Events/EventBaseDialogWorkflow.cfm">	
										
										
										<input type     = "hidden" 
										       id       = "workflowlinkprocess_#eventid#" 
											   onclick  = "ptoken.navigate('#client.root#/Staffing/Portal/Events/EventBaseDialogStatus.cfm?id=#eventid#','status_#eventid#')"> 	
										
																									   
										<cf_securediv id="#eventid#" bind="url:#client.root#/Staffing/Portal/Events/EventBaseDialogWorkflow.cfm?ajaxid=#eventid#">       															
																																
									</cfif>				 						   
								   
							   </td>
			
						</TR>						
						
						<tr class="labelmedium line fixlengthlist" id="#eventid#_2">
							<td colspan="9">#remarks#</td>								
						</tr>		
										
										
					<cf_filelibraryCheck
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#">
							
					<cfif files gte "1">		
					
					<tr style="height:1px" id="#eventId#_3">
					   
						<td colspan="8">
										
						<cf_filelibraryN
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#"			
							box="eventview"		
							Insert="no"
							Remove="no"					
							Listing="yes">
							
						</td>			
						<td></td>			
					</tr>
					
					</cfif>									
							
					</cfloop>		
				
				</cfif>
						
			</cfif>
			
		</CFOUTPUT>
		
		<tr><td id="eventdetail"></td></tr>
									
		</table>	
			
		
</td></tr>

</table>

</cf_divscroll>

<script>
	Prosis.busy('no')
</script>

<cfset ajaxonload("doHighlight")>
<cfset ajaxOnLoad("setSelected")>