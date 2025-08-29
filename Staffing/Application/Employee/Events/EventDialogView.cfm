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
<table border="0" width="100%" class="formpadding">
	
	<tr><td colspan="3">
		
		<cfquery name="Event" 
		    datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     Pe.EventId,
				           Pe.PersonNo,
				           Pe.Mission,
						   Pe.PositionNo,
						   Pe.DocumentNo,
						   Pe.OfficerFirstName,
						   Pe.OfficerLastName,
						   Pe.ReasonCode,
						   Pe.ReasonListCode,
						   Pe.EventTrigger,
						   Pe.EventCode,						  
				           R.Description, 
						   Pe.DateEvent, 
						   Pe.DateEventDue,
						   Pe.ActionDateEffective,
						   Pe.ActionDateExpiration,
						   Pe.ActionStatus,
						   Pe.Remarks,
						   Pe.EventPriority,
						   Pe.EventPriorityMemo
				FROM       PersonEvent Pe INNER JOIN
			               Ref_PersonEvent R ON Pe.EventCode = R.Code
				WHERE      Pe.EventId = '#url.id#'
		</cfquery>		
		
		<cfset url.id = event.PersonNo>	
		<cfset url.mode = "workflow">
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	
	</td></tr>
	
	<cfoutput>
	
	<cfquery name="Trigger" 
	    datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_PersonEventTrigger
			WHERE      EventTrigger = '#Event.EventTrigger#'
			AND        EventCode    = '#Event.EventCode#'
	</cfquery>	
	
	<cfquery name="Reason" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_PersonGroupList
			WHERE      GroupCode     = '#event.ReasonCode#'
			AND        GroupListCode = '#event.ReasonListCode#'
	</cfquery>	
	
	<tr class="labelmedium">
		<td style="width:100px;padding-left:20px;font-size:13px"><cf_tl id="Event">:</td>
		<cfif event.actionstatus eq "9">
		<td colspan="2" style="color:red;font-size:15px">#Event.Mission# #Event.Description# #Reason.Description# [<cf_tl id="Cancelled">]</td>
		<cfelse>
		<td colspan="2" style="font-size:15px">#Event.Mission# #Event.Description# #Reason.Description#</td>
		</cfif>
	</tr>
	
	<!--- show dates only for actions --->
	
	<cfif trigger.actionImpact eq "Action">
		<cfif event.ActionDateEffective neq "" and event.ActionDateEffective neq event.ActionDateExpiration>
		<tr class="labelmedium">
			<td style="padding-left:20px;font-size:13px"><cf_tl id="Effective">:</td>
			<td colspan="2" style="font-size:15px">#dateformat(Event.ActionDateEffective,client.dateformatshow)# <cfif Event.ActionDateExpiration gte Event.ActionDateEffective>- #dateformat(Event.ActionDateExpiration,client.dateformatshow)#</cfif></td>			
		</tr>	
		</cfif>	
	</cfif>
	
	<cfif Event.EventPriority neq "">
		
	    <cfif Event.EventPriority neq "High">
			<cfset cl = "transparent">
		<cfelse>
			<cfset cl = "FFB164">
		</cfif>
	
		<tr class="labelmedium">
			<td style="padding-left:20px;font-size:13px"><cf_tl id="Priority">:</td>
			<td colspan="2" style="font-size:16px"><span style="background-color:#cl#;padding-left:4px;padding-right:4px">#Event.EventPriority#</span> <font size="2">#Event.EventPriorityMemo#</td>
		</tr>
	
	<cfelse>
	
		<tr class="labelmedium">
			<td style="padding-left:20px;font-size:13px"><cf_tl id="Due date">:</td>
			<td colspan="2" style="font-size:16px">
			<cfif Event.actionStatus lt "3">
				<cfif now() gte Event.DateEventDue>
					<font color="FF0000">#dateformat(Event.DateEventDue,client.dateformatshow)#</font>
				<cfelse>
					#dateformat(Event.DateEventDue,client.dateformatshow)#	
				</cfif>
			<cfelse>
				#dateformat(Event.DateEventDue,client.dateformatshow)#
			</cfif>
			</td>
		</tr>
	
	</cfif>
	
	<cfif event.PositionNo neq "">
	
		<cfquery name="Position" 
		    datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       Position
				WHERE      PositionNo = '#event.Positionno#'
		</cfquery>	
	
		<tr class="labelmedium">
			<td style="padding-left:20px;font-size:13px"><cf_tl id="Position">:</td>
			<td colspan="2" style="font-size:15px"><cfif Position.SourcePostNumber neq "">#Position.SourcePostNumber#<cfelse>#Position.PositionParentId#</cfif></td>			
		</tr>
		
		<tr><td></td><td colspan="2" style="padding-right:30px">
		
			<cfset url.positionno = event.PositionNo>
			<cfinclude template="getAssignment.cfm">
		
		</td></tr>
		
	</cfif>
	
	<tr class="labelmedium">
		<td style="padding-left:20px;font-size:13px"><cf_tl id="Requested">:</td>
		<td colspan="2" style="font-size:15px">#dateformat(Event.DateEvent,client.dateformatshow)# #Event.OfficerFirstName# #Event.OfficerLastName#</td>
	</tr>
	
	<cfif event.remarks neq "">
	
		<tr class="labelmedium">
			<td valign="top" style="padding-top:5px;padding-left:20px;font-size:13px"><cf_tl id="Memo">:</td>
			<td colspan="2" valign="top" style="padding-top:5px">#Event.Remarks#</td>
		</tr>
	
	</cfif>
	
	<cf_fileExist
		DocumentPath="PersonEvent"
		SubDirectory="#Event.PersonNo#" 
		Filter="#left(Event.eventid,8)#">
		
	<cfif files	gte "1">
	
	<tr class="labelmedium">
	<td valign="top" style="padding-top:5px;padding-left:20px"><cf_tl id="Attachment">:</td>
	
			<td colspan="2" valign="top" style="padding-top:5px">
	
			<cf_filelibraryN
				DocumentPath="PersonEvent"
				SubDirectory="#Event.PersonNo#" 
				Filter="#left(Event.eventid,8)#"			
				box="eventview"		
				Insert="no"
				Remove="no"				
				Listing="yes">
				
			</td>						
	</tr>
	
	</cfif>
	
	</cfoutput>

</table>

