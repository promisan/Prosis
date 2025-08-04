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

<cfparam name="URL.ID" 			default="">
<cfparam name="URL.PersonNo" 	default="">
<cfparam name="URL.PositionNo" 	default="">
<cfparam name="URL.Mission" 	default="">
<cfparam name="URL.OrgUnit" 	default="">

<cfparam name="URL.Portal" 	    default="0">
<cfparam name="URL.Scope" 	    default="">
<cfparam name="URL.box"			default="">

<cfparam name="URL.Trigger" 	default="">
<cfparam name="URL.Code"    	default="">

<cfparam name="URL.pmission" 	default="">
<cfparam name="URL.ptrigger" 	default="">
<cfparam name="URL.pevent" 		default="">
<cfparam name="URL.preason" 	default="">

<script>	
    _cf_loadingtexthtml='';	
	Prosis.busy('no');
</script>

<cfif URL.ID neq "">

	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  EventId='#URL.Id#'
	</cfquery>		
	
	<cfset url.mission = qEvent.Mission> 

<cfelse>

	<cfquery name="qEvent" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   PersonEvent
			 WHERE  1=0
	</cfquery>		
</cfif>	

<cf_divscroll>

<cfform method="POST" name="eventform">

<cfoutput>

	<input type="hidden" id="pevent" 	name="pevent" 		value="#URL.pevent#">
	<input type="hidden" id="preason" 	name="preason" 		value="#URL.preason#">
	<input type="hidden" id="portal" 	name="portal" 		value="#URL.portal#">
	<input type="hidden" id="scope" 	name="scope" 		value="#URL.scope#">
	<input type="hidden" id="conditiongroupcode" name="conditiongroupcode" value="">
</cfoutput>

<table width="96%" class="formpadding" align="center">

	<cfoutput>
		
		<cfif URL.Id eq "">
			<cf_assignid>
			<cfset eventid   = rowguid>
			<cfset personno  = url.personno>
			<input type="hidden" id="personno" 	name="personno" 	value="#URL.PersonNo#">
			<input type="hidden" id="eventid" 	name="eventid" 		value="#rowguid#">						
		<cfelse>
		    <cfset eventid   = url.id>
			<cfset personno  = qEvent.PersonNo>
			<input type="hidden" id="personno" 	name="personno" 	value="#qEvent.PersonNo#">
			<input type="hidden" id="eventid" 	name="eventid" 		value="#URL.Id#">			
		</cfif>
		
		<cfquery name="qMission" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				
			<cfif getAdministrator('*') eq "1" and url.portal eq "0" and url.mission eq "">
												
					SELECT Mission 
					FROM   Organization.dbo.Ref_Mission
					WHERE  Mission IN (SELECT Mission 
					                   FROM   Organization.dbo.Ref_EntityMission  
									   WHERE  EntityCode      = 'PersonEvent' 
									   AND    WorkflowEnabled = 1)
						
					AND  Operational = 1	
					AND     Mission IN (SELECT Mission FROM Ref_PersonEventMission)	 
					
				<cfelseif url.mission neq "">  
												
					 SELECT   DISTINCT P.MissionOperational as Mission
					 FROM     PersonAssignment PA INNER JOIN Position P ON PA.PositionNo      = P.PositionNo
					 WHERE    PersonNo           = '#PersonNo#'
					
					 AND      PA.DateExpiration  > getDate()-90
										 
					 AND      PA.AssignmentStatus IN ('0','1')					 
					 AND      PA.AssignmentType  = 'Actual'
								
				<cfelse>				
				
					<!--- Officer has access to mission --->
					SELECT  DISTINCT Mission 
					FROM    Organization.dbo.OrganizationAuthorization
					WHERE   UserAccount = '#SESSION.acc#' 
					AND     Mission IS NOT NULL
					AND     Mission IN (SELECT Mission 
					                    FROM   Organization.dbo.Ref_EntityMission  
					                    WHERE  EntityCode  = 'PersonEvent' 
									    AND    WorkflowEnabled = 1)
					UNION
					
					<!--- Employee has had assignments or contracts in missions... --->
					
					SELECT DISTINCT MissionOperational 
					FROM   Employee.dbo.Position 
					WHERE  PositionNo IN (SELECT DISTINCT PositionNo 
										  FROM   Employee.dbo.PersonAssignment
										  WHERE  PersonNo = '#URL.PersonNo#' )
					AND    Mission IN (SELECT Mission 
			                           FROM   Organization.dbo.Ref_EntityMission  
									   WHERE  EntityCode = 'PersonEvent' 
									   AND    WorkflowEnabled = 1)
									   						
					UNION	
					
					SELECT DISTINCT Mission 
					FROM   Employee.dbo.PersonContract
					WHERE  PersonNo = '#URL.PersonNo#'
					AND    Mission IN (SELECT Mission 
					                   FROM   Organization.dbo.Ref_EntityMission  
									   WHERE  EntityCode = 'PersonEvent' 
									   AND    WorkflowEnabled=1)
							
					ORDER BY Mission		
				</cfif>
					
		</cfquery>
		
		<cfif qMission.recordcount eq "1" and qMission.Mission eq url.mission>
		    <cfset cl = "hide">
		<cfelse>		
			<cfset cl = "">
		</cfif>
		
		<tr><td style="height:5px"></td></tr>	
		<tr class="labelmedium2 <cfoutput>#cl#</cfoutput>">
			
			<td width="20%"><cf_tl id="Entity">:</td>
			<td style="padding-left:0px">
			
				<table>
				<tr><td>
			
				 
				 <cfif url.positionNo eq ""> 	
				 
					  <cfquery name="OnBoard" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   P.*
						 FROM     PersonAssignment PA, Position P
						 WHERE    PersonNo           = '#URL.PersonNo#'
						 AND      PA.PositionNo      = P.PositionNo
						 AND      PA.DateEffective   < getdate()
						
						 AND      PA.DateExpiration  > getDate()
											 
						 AND      PA.AssignmentStatus IN ('0','1')					 
						 AND      PA.AssignmentType  = 'Actual'
						 ORDER BY DateExpiration DESC, Incumbency DESC						
					 </cfquery>  
					 
					 <cfif Onboard.recordcount eq "0">		
						 
					 
						  <cfquery name="OnBoard" 
						 datasource="AppsEmployee"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   P.*
							 FROM     PersonAssignment PA, Position P
							 WHERE    PersonNo           = '#URL.PersonNo#'
							 AND      PA.PositionNo      = P.PositionNo
							 AND      PA.DateEffective   < getdate()																	 
							 AND      PA.AssignmentStatus IN ('0','1')					 
							 AND      PA.AssignmentType  = 'Actual'
							 ORDER BY DateExpiration DESC, Incumbency DESC					
						 </cfquery>    
						 
						 
					 
					 </cfif>  
					 
					<select name="mission" id="mission" class="regularxxl">
					
						<cfloop query="qMission">					
						
						   <cfquery name="check" 
							 datasource="AppsEmployee" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_PersonEventMission	
								WHERE  Mission = '#mission#'			
						   </cfquery>	
						   
						   <cfif check.recordcount gte "1">			
						
								<option value="#Mission#" <cfif Mission eq OnBoard.Mission OR Mission eq qEvent.Mission OR Mission eq URL.pmission>selected</cfif>>#Mission#</option>
							
							</cfif>
							
						</cfloop>
						
					</select>
				
				<cfelse>
								
				  <cfquery name="Position" 
					 datasource="AppsEmployee"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   P.*
						 FROM     Position P
						 WHERE    PositionNo  = '#URL.PositionNo#'					 			
					 </cfquery>  	
				 
					<select name="mission" id="mission" class="regularxxl">														
						<option value="#Position.MissionOperational#">#Position.MissionOperational#</option>											
					</select>
								
				</cfif>
				
				</td>
							
				<td style="padding-left:5px" align="right">
				
					<cf_space spaces="38">	
						
					<cfif URL.Id eq "">
						<cfset vDate = "#now()#">
					<cfelse>
						<cfset vDate = qEvent.DateEvent>
					</cfif>	
									
					<cf_intelliCalendarDate9
						FieldName="DateEvent" 
						Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
						AllowBlank="False"
						Class="regularxxl">
				</td>
				
				</tr>
				</table>												
				
			</td>			
			</tr>
			
			<tr><td height="4"></td></tr>
			
			<tr><td height="1" colspan="2" class="line"></td></tr>
			
			<tr class="labelmedium2 hide" id="unitbox">
			
				<td width="20%" style="padding-left:3px"><cf_tl id="Unit">:</td>								
				<td>	
				
				<cfif qEvent.orgunit neq "">												
					<cf_securediv id="myunitbox" bind="url:#session.root#/staffing/application/Employee/Events/getOrganization.cfm?scope=#url.scope#&personno=#url.personno#&selected=#qEvent.orgunit#&mission={mission}"/>							
				<cfelseif url.orgunit neq "">									
					<cf_securediv id="myunitbox" bind="url:#session.root#/staffing/application/Employee/Events/getOrganization.cfm?scope=#url.scope#&personno=#url.personno#&selected=#url.orgunit#&mission={mission}"/>											
				<cfelse>					
				    <cfparam name="Position.OrgUnitOperational" default="">
				   	<cf_securediv id="myunitbox" bind="url:#session.root#/staffing/application/Employee/Events/getOrganization.cfm?scope=#url.scope#&personno=#url.personno#&selected=#Position.OrgUnitOperational#&mission={mission}"/>											
				</cfif>	
				</td>				
			</tr>		
			
			<cfif url.trigger eq "" or qMission.recordcount gt "1" and url.scope neq "unit"> <!--- the trigger is not preset, in the teams portal the trigger is preset an we show relevant titles ---> 
			
			<tr class="labelmedium2">
				
				<td  style="padding-left:3px" width="20%"><cf_tl id="Category">:</td>
			    <td style="padding-left:0px;font-size:16px">	
												    			
					<cf_securediv id="mynaturebox" bind="url:#session.root#/staffing/Application/Employee/Events/getTrigger.cfm?personno=#url.personno#&eventid=#URL.id#&mission={mission}&Positionno=#url.positionno#&scope=#url.scope#&portal=#url.portal#&ptrigger=#url.ptrigger#&preason=#url.preason#&pevent=#url.pevent#&event=#url.code#">						
					
				</td> 
				
			</tr>	
			
			<cfelse>
			
				<cfquery name="get" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT * 
					 FROM Ref_EventTrigger
					 WHERE Code = '#url.trigger#'							
				</cfquery>	
			
				<input type="hidden" name="triggercode" id="triggercode" value="<cfoutput>#url.trigger#</cfoutput>"> 						
				
			</cfif>							
			
			<tr class="labelmedium2" id="positionbox">
			
				<td width="20%" style="padding-left:3px"><cf_tl id="Position">:</td>				
				<td>
		
				<table width="100%" style="z-index:3;">
					<tr><td width="95%"> 
					
						 <cfquery name="qEvent" 
							 datasource="AppsEmployee" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT *
								 FROM   PersonEvent 
								 WHERE  EventId = '#eventId#'
						 </cfquery>		
					
					     <cfif url.positionno eq "">
					
							<cfquery name="Position" 
								 datasource="AppsEmployee" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
									 SELECT *
									 FROM   Position P 
									 <cfif qEvent.PositionNo neq "">
									 WHERE  PositionNo  = '#qEvent.PositionNo#'
									 <cfelse>
									 WHERE   1=0
									 </cfif>
							</cfquery>		 
				
							<input type="hidden" name="positionNo" id="positionNo" value="#qEvent.PositionNo#">
							
						  	<input type= "text" 
							 name      = "positionselect" 
							 class     = "regularxxl"
							 id        = "positionselect"	
							 value     = "#trim(Position.SourcePostNumber)# #trim(Position.FunctionDescription)# #trim(Position.PostGrade)#"
							 style     = "padding-left:6px;padding-top:1px;width:100%;font-size:16px; z-index:3;"  readonly>
							 
					    <cfelse>
						
							<cfquery name="Position" 
								 datasource="AppsEmployee" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
									 SELECT *
									 FROM   Position  
									 WHERE  PositionNo = '#url.positionNo#'
							</cfquery>		 
					
							<input type="hidden" name="positionNo" id="positionNo" value="#url.PositionNo#">
							
						  	<input type= "text" 
							 name      = "positionselect" 
							 class     = "regularxxl"
							 id        = "positionselect"	
							 value     = "#trim(Position.SourcePostNumber)# #trim(Position.FunctionDescription)# #trim(Position.PostGrade)#"
							 style     = "padding-left:6px;padding-top:2px;width:100%;font-size:16px; z-index:3; <cfif url.positionno neq ''>background-color:eaeaea</cfif>" readonly>
												
						</cfif>	 
				
					  </td>
					  
					  <cfif url.positionno eq "">
					
						  <td style="padding-left:12px;border:0px solid gray">
												  
					  		<cfset link = "#SESSION.root#/Staffing/Application/Employee/Events/getPosition.cfm?event=1">
							
					  		<cf_selectlookup
							    box          = "positionbox_detail"
								title        = "Position Search"
								icon         = "search.png"
								link		 = "#link#"
								des1		 = "PositionNo"
								filter1      = "Mission"
								filter1Value = "{mission}"
								button       = "No"
								style        = "width:28px;height:28px"
								close        = "Yes"			
								datasource	 = "AppsEmployee"		
								class        = "PositionSingle">	
					
						  </td>
					  
					  </cfif>
					  
					  <td id="positionbox_detail" name="positionbox_detail">						 
						 
					  </td>	  
					  
					</tr>
					
				</table>

				</td>						
			</tr>
			
			<!--- obtain a relevant JO No --->
			
			<cfquery name="qTrack" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">			
		     		SELECT    TOP (1) FO.DocumentNo, FO.ReferenceNo
	                FROM      Vacancy.dbo.[Document] AS D INNER JOIN
	                          Applicant.dbo.FunctionOrganization AS FO ON D.FunctionId = FO.FunctionId
	                WHERE     D.DocumentNo IN
	                             (SELECT     TOP (1) SourceId
	                               FROM      PersonAssignment
	                               WHERE     PersonNo = '#url.PersonNo#' 
								   <!--- made this process a bit more leniet as it did not always work for Giorgia 
								   AND       PositionNo IN (
								   
															    SELECT      DP.PositionNo
																FROM        Vacancy.dbo.DocumentPost AS DP INNER JOIN
																            Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
																            Position AS PP ON P.PositionParentId = PP.PositionParentId
																WHERE       PP.PositionNo = '#url.positionno#'
																
															)	
															--->
												
	                 			   AND       Source = 'VAC'
	                               ORDER BY DateEffective DESC)							  							   
			</cfquery>	
			
			<cfif qEvent.DocumentNo neq "">					   
			
				<tr name="VacCandidate" id="documentbox" class="hide">
					<td style="padding-left:3px" width="20%">
						<cf_tl id="Recruitment JO No">:
					</td>				
					<td>				
					<cfinput type="text" mask="999999" id="documentno" name="DocumentNo" value="#qEvent.DocumentNo#" style="width:90" class="regularxxl">											  
			  		</td>						
				</tr>				
			
			<cfelse>
										
				<tr name="VacCandidate" id="documentbox" class="hide">
					<td style="padding-left:3px" width="20%">
						<cf_tl id="Recruitment JO No">:
					</td>				
					<td>				
					<cfinput type="text" mask="999999" id="documentno" name="DocumentNo" value="#qTrack.ReferenceNo#" style="width:90" class="regularxxl">											  
			  		</td>						
				</tr>	
						
			</cfif>

			<tr name="Requisition" id="requisitionbox" class="hide">
				<td style="padding-left:3px" width="20%">
					<cf_tl id="Requisition No">:
				</td>				
				<td>				
				<cfinput type="text" mask="9999999999" id="requisitionNo" name="requisitionNo" value="#qEvent.RequisitionNo#" style="width:90" class="regularxxl">											  
		  		</td>						
			</tr>				

			<tr class="labelmedium2">				
				<td  style="padding-left:3px" width="20%">
				<cfif url.scope eq "Inquiry">
				<cf_tl id="Topic">:
				<cfelse>
				<cf_tl id="Requested action">:
				</cfif></td>
			    <td style="padding-left:0px" id="dEvent"></td> 								
			</tr>
			
			<cfif URL.ID neq "">
						
			     <tr class="hide"><td colspan="2" style="padding-left:16x;padding-right:6px" id="myinstruction"></td></tr>				
			
			<cfelse>
			
			     <tr><td colspan="2" style="padding-left:16x;padding-right:6px" id="myinstruction"></td></tr>	
			
			</cfif>				

			<tr id="reasonbox" class="labelmedium2 hide">				
				<td style="padding-left:3px" width="20%"><cf_tl id="Reason">:</td>
			    <td style="padding-left:0px" id="dReason"></td> 								
			</tr>			
								
			<tr class="hide"><td colspan="2" id="assignmentbox" style="padding-left:30px;padding-right:30px">
				<cf_securediv bind="url:#session.root#/staffing/Application/Employee/Events/getAssignment.cfm?positionno=#qEvent.PositionNo#">															
			</td></tr>
			
			<tr id="conditionbox" class="labelmedium2 hide">				
				<td style="padding-left:3px" width="20%"><cf_tl id="Condition">:</td>
			    <td style="padding-left:0px" id="dCondition"></td> 								
			</tr>	
			
			
			<cfif url.scope neq "inquiry">		
									
			<tr class="labelmedium2" id="effectivebox">
				
				<td style="padding-left:3px" width="20%"><span id="actiondatelabeleffective"></span><cf_tl id="Effective">:</td>
				<td style="padding-left:0px">				
																	
					<cf_space spaces="38">	
						
					<cfif URL.Id eq "">
						<cfset vDate = "">												
					<cfelse>					
						<cfset vDate = qEvent.ActionDateEffective>
					</cfif>	
													
					<cf_intelliCalendarDate9
						FieldName="ActionDateEffective" 
						Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
						AllowBlank="True"
						Class="regularxxl">
						
				</td>
				  
			</tr>
			
			<cfelse>
			
				<tr class="hide" id="effectivebox"><td>			
				<span id="actiondatelabeleffective"></span>
				<input type="hidden" name="ActionDateEffective" id="ActionDateEffective" value="#DateFormat(now(),'#CLIENT.DateFormatShow#')#">
				</td></tr>	
			
			</cfif>
			
			<tr id="expirybox" class="hide">
				
				<td style="padding-left:3px" width="20%"><span id="actiondatelabelexpiration"></span><cf_tl id="Expiration">:</td>
				<td style="padding-left:0px">						
							
					<cf_space spaces="38">	
						
					<cfif URL.Id eq "">
						<cfset vDate = "">						
					<cfelse>
						<cfset vDate = qEvent.ActionDateExpiration>
					</cfif>	
									
					<cf_intelliCalendarDate9
						FieldName="ActionDateExpiration" 
						Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
						AllowBlank="True"
						Class="regularxxl">
						
				</td>
				  
			</tr>
			
			<cfif url.portal eq "0" or url.scope eq "inquiry">
						
				<tr class="labelmedium2" id="boxremarks">
				
					<td valign="top" style="padding-left:3px;padding-top:5px" width="20%">
					<table style="height:100%">
					   <tr><td class="fixlength" valign="top"><cf_tl id="Details of the request">:</td></tr>
					   <tr><td valign="bottom" align="right" id="memcount_remarks"></td></tr>
					</table>
					</td>
				    <td class="labelmedium2" colspan="5" style="padding-left:0px;height:20px">	
					 <!---  onkeyup="return ismaxlength(this)" --->
							<textarea type="text" id="remarks" name="remarks" totlength="600"  
							 maxlength="600"
							 onKeyUp="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=remarks&size=600','memcount_remarks','','','POST','eventform')"											 												
							style="width:95%;height:60px;font-size:15px;padding:3px" class="regular">#qEvent.Remarks#</textarea> 
				    </td>
			    
				</tr>	
				
				<tr class="labelmedium2" id="boxpriority">
	            <td style="padding-left:3px" >
					<cfif url.scope eq "Inquiry">
					<cf_tl id="Priority">:
					<cfelse>
					<cf_tl id="Priority">:
					</cfif></td>      
				<td>	
				<table style="border:1px solid silver;width:96%"><tr class="labelmedium2" style="height:34px">  
		
		             <cfloop index="itm" list="High">
		             <td id="priority1" style="<cfif qEvent.EventPriority eq 'High'>background-color:FFB164</cfif>;padding-left:5px;padding-right:5px">
					 <input type="checkbox" class="radiol" onclick="javascript:_cf_loadingtexthtml='';ptoken.navigate('#session.root#/staffing/application/employee/events/getPriority.cfm?eventid=#eventid#&priority='+this.checked,'prioritybox')" class="radiol" name="EventPriority" id="EventPriority" value="#itm#" <cfif itm eq qEvent.EventPriority>checked</cfif>>
					 </td>
					 <td id="priority2" style="padding-top:3px;min-width:60px;font-size:16px;padding-right:10px;padding-left:3px;<cfif qEvent.EventPriority eq 'High'>background-color:FFB164</cfif>" class="labelmedium">#itm#</td>	
					 </cfloop>		
					 <td style="width:100%" id="prioritybox" style="background-color:f1f1f1">
					 <cfif qEvent.EventPriority eq "High">
					 <input title="Reason for high priority" maxlength="80" class="regularxxl" style="background-color:ffffcf;width:99%;border:0px" value="#qevent.eventprioritymemo#" name="EventPriorityMemo" id="EventPriorityMemo"></td>
					 </cfif>
					 </td>
					 					
					 </tr>
				 </table> 
		
		       </td>
			    </tr>
				
				<cfif url.portal eq "0">
										
					<tr class="labelmedium2">
						
						<td style="padding-left:3px" width="20%">
						<cfif url.scope eq "Inquiry">
						<cf_tl id="Request due">:
						<cfelse>
						<cf_tl id="Preparation due">:
						</cfif></td>
						<td style="padding-left:0px">
						
							<cf_space spaces="38">
								
							<cfif URL.Id eq "">
								<cfset vDate = "#now()#">
							<cfelse>
							    <cfif qEvent.DateEventDue eq "">
								    <cfset vDate = qEvent.ActionDateEffective> 
								<cfelse>
									<cfset vDate = qEvent.DateEventDue>
								</cfif>	
							</cfif>										
												
							<cf_intelliCalendarDate9
								FieldName="DateEventDue" 
								Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
								AllowBlank="False"
								Class="regularxxl">
								
						</td>
						  
					</tr>		
					
				 <cfelse>
				 
				 		<cfif URL.Id eq "">
							<cfset vDate = "#now()+7#">							
						<cfelse>
						    <cfif qEvent.DateEventDue eq "">
							    <cfset vDate = "#now()+7#"> 								
							<cfelse>
								<cfset vDate = qEvent.DateEventDue>								
							</cfif>	
						</cfif>		
							
						<input type="hidden" name="DateEventDue" id="DateEventDue" value="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#">
				 
				
				 </cfif>					
										
				<tr id="boxattachment" ><td colspan="2">
			
					<cfquery name="qCheck" 
							 datasource="AppsSystem" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 SELECT *
							 FROM  Ref_Attachment
							 WHERE  DocumentPathName = 'PersonEvent'
					</cfquery>	
	
					<cfif qCheck.DocumentServer neq "">
									
						<cfset CLIENT.DocumentServerPath = "">
						
						<cf_filelibraryN
							box = "documentserver"
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#"
							attachdialog   = "cfwindow"
							DocumentServer = "Anonymous"	
							showsize="0"
							Insert="yes"
							Remove="yes"
							Listing="yes">
							
					<cfelse>
	
						<cf_filelibraryN
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#"
							attachdialog = "cfwindow"
							Insert="yes"
							showsize="0"
							Remove="yes"
							Listing="yes">
	
					</cfif>	
				</td>		
				</tr>		
				
			<cfelse>
			
				<cfset vDate = "#now()#">
				 <tr><td class="hide">			
				<input type="hidden" name="DateEventDue" id="DateEventDue" value="#DateFormat(vDate,CLIENT.DateFormatShow)#">	
				</td></tr>			
							
			</cfif>
				
			<tr><td colspan="2" class="line"></td></tr>			
			
			<tr>				
				
				<td colspan="2" align="center">
				  <table class="formspacing">
				  
				  	<tr>				  
					<td>		
					
						<cf_tl id="Close" var="1">		
						<input type="button"
						   name="Close" 
						   id="close"
						   value="#lt_text#" 
						   style="width:140;height:25px" 
						   class="button10g" 
						   onclick="try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}">
						   
					</td>
					
					<td id="submitform">
					
					 <cfif url.portal eq "0">
						 <cf_tl id="Submit" var="1">
					 <cfelseif url.scope eq "Inquiry">	
					      <cf_tl id="Submit" var="1">
					 <cfelse>
					      <cf_tl id="Initiate" var="1">
					 </cfif>	   
										
					 <input type="button"
					   name="Submit" 						   
					   value="#lt_text#" 
					   style="width:140;height:25px" 
					   class="button10g" 
					   onclick="javascript:eventsubmit('#URL.Id#','#url.box#','#url.portal#','#url.scope#')">						
					   
					</td>	
					</tr>
					
				  </table>
				</td>
							
			</tr>		
				
	 </cfoutput>
	 
	 <tr class="hide"><td id="process"></td></tr>
 
</table>
</cfform>

</cf_divscroll>

<cfset AjaxOnLoad("doCalendar")>

<!--- we wiggled this option of an on --->
<cfif url.trigger neq "">
	<cfset AjaxOnLoad("checkevent")>
</cfif>

