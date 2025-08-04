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
<cfparam name="url.action" default="">
<cfparam name="url.mode"  default="view">

<cfquery name="qEvents" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PersonEventMission				
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
 		
<table align="center" style="height:100%;width:99%" border="0">

	<tr>
	<td style="height:10px">
		<table width="100%">
			<tr>
			
			<td style="padding-left:10px;width:66px">
			<img src="../../../../Images/Logos/Staffing/action.png" height="62" alt="" border="0">			
			</td>
				    <td style="padding-left:6px;padding-right:10px;padding-top:10px;font-size:34px" class="labellarge" colspan="2">						
							<cf_tl id="Personnel"><cf_tl id="events"></b>						
					</td>
					
					<td align="right" style="padding-top:26px;padding-right:10px">
					    <!---
						<cfif qEvents.recordcount gt 0 and OnBoard.recordcount gt 0>
						--->
						<cfif qEvents.recordcount gt 0>
						
							  <cf_tl id="Add Personnel Event" var="1">		   
							  <cfoutput>
						    	<input type="button" 
									value="#lt_text#" 
									class="button10g" 
									style="width:190;height:25px" 
									onclick="javascript:eventadd('#URL.id#','person','','','');">
							</cfoutput>
							
						</cfif>
					</td>
			</tr>
		</table>
	</td>
	</tr>

	<tr><td style="padding-left:10px;padding-right:10px;height:100%">
	
		<cf_divscroll>	

		<table width="100%" align="center" class="formpadding navigation_table"">
					
		<TR class="line labelmedium2 fixrow fixlengthlist">
			<td></td>
			<td></td>
  		    <td><cf_tl id="Date"></td>
  		    <td><cf_tl id="Position"></td>  
		    <td><cf_tl id="Trigger">|<cf_tl id="Event Action"></td>  
			<td><font color="808080"></td>  			
			<td><font color="808080"><cf_tl id="Source"></td>
			<td align="right"><cf_tl id="Officer"></td>
			<td></td>			
		</TR>
		
		<!--- define mission --->
		
		<cfquery name="Mis" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT Mission			
			FROM   Ref_ParameterMission RM
			WHERE EXISTS(
				SELECT DISTINCT Mission
				FROM   PersonEvent PE
				WHERE  PersonNo = '#url.id#'
				AND    RM.Mission = PE.Mission
			)
		</cfquery>
		
		<cfoutput query="Mis">
		
			<!--- check if person has access to this mission to view --->
			
			<cfinvoke component = "Service.Access"  
			   method           = "staffing" 
			   mission          = "#Mission#" 			  			  
			   returnvariable   = "accessStaffing">	   
			
			<cfif accessStaffing neq "NONE">
			
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
						   PE.OfficerFirstName, 
						   PE.OfficerLastName, 
						   PE.ActionStatus,		
						   PE.EventCode,		  
						   PE.EventTrigger,
						   PE.Source,
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
				    ORDER BY PE.Created DESC		
				    	
				</cfquery>
			
				<cfif EventsAll.recordcount neq "0">
				
				    <tr class="fixrow2"><td colspan="9" style="padding-left:4px;height:40px;font-size:20px"><b>#Mission#</td></tr>
					 		 		
					<cfloop query="EventsAll">
					
					<TR class="labelmedium2 navigation_row fixlengthlist" style="height:20px">		 
					
					        <td style="max-width:20px;padding-top:0px">
						   
						   	<cfif EntityClass neq "">
						   			
						   		<cfif ActionStatus eq "0">
								    <cfset vMode = "selected">
		  						<cfelse>
		     						<cfset vMode = "">
		  						</cfif> 
						   		<cf_img icon="expand" toggle="Yes" 
								 onclick="workflowdrill('#eventid#','box_#eventid#')" mode="#vMode#">
									
						   	</cfif>
												   
						   </td>  
										
						   <td style="max-width:20px;padding-right:10px">
						   		<cfif ActionStatus eq "0" or ActionStatus eq "1">
								
							   		<cf_img icon="edit" 
			   							navigation="Yes" 
			   							onClick="eventedit('#eventid#','person','0')">
										
								<cfelseif ActionStatus eq "3">
									
									<!--- 							
								    <cfif getAdministrator("#mission#")>
									
									<cf_img icon="open" 
			   							navigation="Yes" 
			   							onClick="eventedit('#eventid#','person','0')">
										
									<cfelse>
									--->
									
									<img src="#session.root#/Images/check.png" style="cursor:hand" onclick="eventview('#eventid#','person','0')"
									   alt="" width="25" height="25" border="0">
									<!---   
									</cfif>   
									--->
									
							    </cfif>
						   </td>
						
						   <td>#dateformat(created,client.dateformatshow)#</td>
						   <td><a href="javascript:ViewPosition('#PositionNo#')"><cfif SourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionParentId#</cfif></a></td>
			               <TD colspan="2">
			               		<font color="808080">#TriggerDescription#:&nbsp;</font>#EventDescription#
			               		<cfif ReasonDescription neq "">
									&nbsp;-&nbsp;#ReasonDescription#									               			
			               		</cfif>	
								<cfif EntityCode eq "VacCandidate" and documentNo neq "0">
								<a href="javascript:showdocument('#documentno#')">(#DocumentNo#)</a></font>
								</cfif>
			               	</TD>
							<td>#source#</td>
							<td align="right">#officerLastName#</td>		               	
							<td>
			
								<cfinvoke component="Service.Access"  
							      method="org" 
								  mission="#Mission#" 
								  returnvariable="access">
								 
								<cfif access eq "ALL"> 
													
									<table>
										<tr>
											
											<cfif ActionStatus eq "0" or ActionStatus eq "1">
											
								   				<td style="padding-left:5px">
								   					<cf_img icon="delete" 					   						
								   						onClick="javascript:eventdelete('#eventid#','0','person')">
								   				</td>
												
								   			</cfif>
											
								   		</tr>
								   	</table>
								   
								</cfif>
			
							</td>	
		
					</TR>		
				
				    <cfif ActionDateEffective neq "" or ActionDateExpiration neq "" or remarks neq "">			
						<tr class="labelmedium2 line navigation_row_child" style="height:20px">
						    <td colspan="2"></td>
							<td colspan="7" style="background-color:##dadada50;padding-left:7px;font-size:12px">#remarks#</td>	
							
							<!---				
							<td style="padding-left:4px" valign="top">
								#dateformat(ActionDateEffective,client.dateformatshow)#	
							</td>				
							<td style="padding-left:4px" valign="top">
								<cfif actionDateExpiration gt ActionDateEffective>
								#dateformat(ActionDateExpiration,client.dateformatshow)#	
								</cfif>
							</td>
							--->	
							<td></td>			
							<td></td>
						</tr>	
					</cfif>
					
					<cf_filelibraryCheck
							DocumentPath="PersonEvent"
							SubDirectory="#PersonNo#" 
							Filter="#left(eventid,8)#">
							
					<cfif files gte "1">		
					
					<tr style="height:1px">
					    <td colspan="2"></td>
						<td colspan="6">
										
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
					
					<input type	= "hidden" 
						   	name 	= "workflowlink_#eventid#" 
						   	id   	= "workflowlink_#eventid#"
						   	value	= "#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm">	
										
					<cfif ActionStatus eq "0" and EntityClass neq "">
						
						<tr id="box_#eventid#">
						    <td></td>
							<td colspan="9">								   
								<cf_securediv id="#eventid#" bind="url:#client.root#/Staffing/Application/Employee/Events/EventWorkflow.cfm?ajaxid=#eventid#">
							</td>
						</tr>				
		
					<cfelse>
		
						<tr id="box_#eventid#" class="hide"> 
						    <td></td>
						   	<td colspan="9" id="#eventid#"></td>	
						</tr>
		
					</cfif>
					
					
							
					</cfloop>		
				
				</cfif>
						
			</cfif>
			
		</CFOUTPUT>
									
		</table>	
		
		</cf_divscroll>	

</td></tr>

</table>

<script>
	Prosis.busy('no')
</script>

<cfset ajaxonload("doHighlight")>
<cfset ajaxOnLoad("setSelected")>