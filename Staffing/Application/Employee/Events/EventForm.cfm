<cfparam name="URL.ID" 			default="">
<cfparam name="URL.PersonNo" 	default="">
<cfparam name="URL.PositionNo" 	default="">


<script>	
	Prosis.busy('no');
</script>

<cfif URL.ID neq "">

	<cfquery name="qEvent" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM PersonEvent
			 WHERE EventId='#URL.Id#'
	</cfquery>		 

<cfelse>

	<cfquery name="qEvent" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM PersonEvent
			 WHERE 1=0
	</cfquery>		
</cfif>	

<cfform method="POST" name="eventform">

<table width="94%" class="formpadding" align="center">

	<cfoutput>
		
		<cfif URL.Id eq "">
			<cf_assignid>
			<cfset eventid   = rowguid>
			<cfset personno  = url.personno>
			<input type="hidden" id="personNo" 	name="personNo" 	value="#URL.PersonNo#">
			<input type="hidden" id="eventid" 	name="eventid" 		value="#rowguid#">						
		<cfelse>
		    <cfset eventid   = url.id>
			<cfset personno  = qEvent.PersonNo>
			<input type="hidden" id="personNo" 	name="personNo" 	value="#qEvent.PersonNo#">
			<input type="hidden" id="eventid" 	name="eventid" 		value="#URL.Id#">
		</cfif>
		
		<tr><td style="height:5px"></td></tr>	
		<tr class="labelmedium">
			
			<td width="20%"><cf_tl id="Entity">:</td>
			<td style="padding-left:0px">
			
				<table>
				<tr><td>
			
				<cfquery name="qMission" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					<cfif getAdministrator('*') eq "1">
					
						SELECT Mission 
						FROM  Organization.dbo.Ref_Mission
						WHERE Mission IN (SELECT Mission 
						                  FROM  Organization.dbo.Ref_EntityMission  
										  WHERE EntityCode='PersonEvent' 
										  AND   WorkflowEnabled=1)
					
					<cfelse>
					
						<!--- Officer has access to mission --->
						SELECT DISTINCT Mission 
						FROM   Organization.dbo.OrganizationAuthorization
						WHERE  UserAccount = '#SESSION.acc#' 
						AND    Mission IS NOT NULL
						AND    Mission IN (SELECT Mission 
						                   FROM   Organization.dbo.Ref_EntityMission  
						                   WHERE  EntityCode='PersonEvent' 
										   AND    WorkflowEnabled=1)
						UNION
						
						<!--- Employee has had assignments or contracts in missions... --->
						
						SELECT Distinct MissionOperational 
						FROM   Employee.dbo.Position 
						WHERE  PositionNo IN (
											SELECT DISTINCT PositionNo 
											FROM   Employee.dbo.PersonAssignment
											WHERE  PersonNo = '#URL.PersonNo#'
											)
						AND    Mission IN (SELECT Mission 
				                           FROM   Organization.dbo.Ref_EntityMission  
										   WHERE  EntityCode='PersonEvent' 
										   AND    WorkflowEnabled=1)
										   						
						UNION	
						
						SELECT DISTINCT Mission 
						FROM   Employee.dbo.PersonContract
						WHERE  PersonNo = '#URL.PersonNo#'
						AND    Mission IN (SELECT Mission 
						                   FROM   Organization.dbo.Ref_EntityMission  
										   WHERE  EntityCode='PersonEvent' 
										   AND    WorkflowEnabled=1)
								
								
					</cfif>
					
				</cfquery>				
														  	 	 
				
				 
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
						 <!---
						 AND      PA.DateExpiration  > getDate()
						 --->
						 AND      PA.AssignmentStatus IN ('0','1')					 
						 AND      PA.AssignmentType  = 'Actual'
						 ORDER BY Incumbency DESC						
					 </cfquery>    
					 
					<select name="mission" id="mission" class="regularxl">
					
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
						
								<option value="#Mission#" <cfif Mission eq OnBoard.Mission OR Mission eq qEvent.Mission>selected</cfif>>#Mission#</option>
							
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
				 
					<select name="mission" id="mission" class="regularxl">														
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
						Class="regularxl">
				</td>
				
				</tr>
				</table>
								
				
			</td>
			
			</tr>
			
			<tr><td height="4"></td></tr>
			
			<tr><td height="1" colspan="2" class="line"></td></tr>
			
			<tr class="labelmedium">
				
				<td  style="padding-left:3px" width="20%"><cf_tl id="Nature">:</td>
			    <td style="padding-left:0px">						
					<cfdiv bind="url:#session.root#/staffing/Application/Employee/Events/getTrigger.cfm?eventid=#URL.id#&mission={mission}&Positionno=#url.positionno#"></cfdiv>						
				</td> 
				
			</tr>		
			
			<tr name="VacCandidate" id="documentbox" class="hide">
				<td style="padding-left:3px" width="20%">
					<cf_tl id="Recruitment JO No">:
				</td>				
				<td>
				
				<cfinput type="text" mask="999999" id="documentno" name="DocumentNo" value="#qEvent.DocumentNo#" 
				style="width:90" class="regularxl">									
		  
		  		</td>						
			</tr>				


			<tr name="Requisition" id="requisitionbox" class="hide">
				<td style="padding-left:3px" width="20%">
					<cf_tl id="Requisition No">:
				</td>				
				<td>
				
				<cfinput type="text" mask="9999999999" id="requisitionNo" name="requisitionNo" value="#qEvent.RequisitionNo#" 
				style="width:90" class="regularxl">									
		  
		  		</td>						
			</tr>				


			<tr class="labelmedium">
				
				<td  style="padding-left:3px" width="20%"><cf_tl id="Action">:</td>
			    <td style="padding-left:0px" id="dEvent">				
				</td> 				
				
			</tr>

			<tr id="reasonbox" class="labelmedium">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Reason">:</td>
			    <td style="padding-left:0px" id="dReason"></td> 				
				
			</tr>
			
			<tr class="labelmedium" id="unitbox">
			
				<td width="20%" style="padding-left:3px"><cf_tl id="Unit">:</td>								
				<td>	
				<cfif url.positionNo eq "">			
					<cfdiv bind="url:#session.root#/staffing/application/Employee/Events/getOrganization.cfm?selected=#qEvent.orgunit#&mission={mission}">							
				<cfelse>
				   	<cfdiv bind="url:#session.root#/staffing/application/Employee/Events/getOrganization.cfm?selected=#Position.OrgUnitOperational#&mission={mission}">											
				</cfif>	
				</td>				
			</tr>					
			
			<tr class="labelmedium" id="positionbox">
			
				<td width="20%" style="padding-left:3px"><cf_tl id="Position">:</td>				
				<td>
		
				<table width="100%" cellspacing="0" cellpadding="0" style="z-index:3;">
					<tr><td width="100"> 
					
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
							 class     = "regularxl"
							 id        = "positionselect"	
							 value     = "#trim(Position.SourcePostNumber)# #trim(Position.FunctionDescription)# #trim(Position.PostGrade)#"
							 style     = "padding-left:3px;padding-top:1px;width:400;font-size:16px; z-index:3;">
							 
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
							 class     = "regularxl"
							 id        = "positionselect"	
							 value     = "#trim(Position.SourcePostNumber)# #trim(Position.FunctionDescription)# #trim(Position.PostGrade)#"
							 style     = "padding-left:3px;padding-top:1px;width:400;font-size:16px; z-index:3;">
												
						</cfif>	 
				
					  </td>
					
					  <td style="padding-left:2px;border:0px solid gray">
											  
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
							style        = "width:28;height:25"
							close        = "Yes"			
							datasource	 = "AppsEmployee"		
							class        = "PositionSingle">	
				
					  </td>
					  
					  <td id="positionbox_detail" name="positionbox_detail">						 
						 
					  </td>	  
					  
					</tr>
					
				</table>

				</td>						
			</tr>
			
			<tr class="hide"><td colspan="2" id="assignmentbox" style="padding-left:30px;padding-right:30px">
				<cfdiv bind="url:#session.root#/staffing/Application/Employee/Events/getAssignment.cfm?positionno=#qEvent.PositionNo#"></cfdiv>															
			</td></tr>
			
			<tr name="PersonContract" class="hide">
				
				<td  style="padding-left:3px" width="20%" style="padding-left:3px"><cf_tl id="ePas">:</td>
			    <td style="padding-left:0px">		
				
				<select type="text" id="ContractNo" name="ContractNo"
				style="width:90" class="regularxl">		
				
					<option value="N/A" <cfif qEvent.ContractNo eq "N/A" or qEvent.ContractNo eq "">selected</cfif>>N/A</option>				
					<option value="YES" <cfif qEvent.ContractNo eq "YES">selected</cfif>><cf_tl id="Yes"></option>
					<option value="NO"  <cfif qEvent.ContractNo eq "NO">selected</cfif>><cf_tl id="No"></option>
					
				</select>
						
				</td> 				
				
			</tr>
						
			<tr class="labelmedium">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Action Effective">:</td>
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
						Class="regularxl">
				</td>
				  
			</tr>
			
			<tr id="expirybox" class="hide">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Action Expiration">:</td>
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
						Class="regularxl">
						
				</td>
				  
			</tr>
			
			<tr><td height="4"></td></tr>
						
			<tr><td colspan="2" class="labellarge" style="padding-left:3px;font-size:18px"><font color="0080C0"><cf_tl id="Instructions"></td></tr>
						
			<tr class="labelmedium">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Preparation due">:
				
				<cf_space spaces="42">
				</td>
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
						Class="regularxl">
				</td>
				  
			</tr>
			
			<tr class="labelmedium">
			
			<td valign="top" style="padding-left:3px;padding-top:4px" width="20%"><cf_tl id="Remarks">:</td>
		    <td class="labelmedium" colspan="5" style="padding-left:0px;height:20px">			  
			
			<textarea type="text" name="Remarks" totlength="400" onkeyup="return ismaxlength(this)" style="width:100%;height:50px;font-size:14px;padding:3px" class="regular">#qEvent.Remarks#</textarea> 
		    </td>
		    
			</tr>		
										
			<tr><td class="labelmedium" valign="top" style="padding-left:3px;padding-top:4px" width="20%"><cf_tl id="Attachment">:</td>
			<td>
		
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
						attachdialog = "cfwindow"
						DocumentServer = "Anonymous"	
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
						Remove="yes"
						Listing="yes">

				</cfif>	
			</td>		
			</tr>		
			
			<tr><td></td></tr>	
			
			<tr><td colspan="2" class="line"></td></tr>
			
			<tr><td></td></tr>		

			<tr>				
				
				<td colspan="2" align="center">
				  <table class="formspacing">
				  	<tr>				  
					<td>				
						  <input type="button"
						   name="Close" 
						   value="Close" 
						   style="width:140;height:25px" 
						   class="button10g" 
						   onclick="try { ProsisUI.closeWindow('evdialog',true) } catch(e) {}">
					</td>
					<td>
						  <input type="button"
						   name="Submit" 
						   value="Save" 
						   style="width:140;height:25px" 
						   class="button10g" 
						   onclick="javascript:eventsubmit('#URL.Id#')">						
					</td>	
				  </table>
				</td>
							
			</tr>		
				
	 </cfoutput>
	 
	 <tr><td id="process"></td></tr>
 
</table>
</cfform>

<cfset AjaxOnLoad("doCalendar")>
