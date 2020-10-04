
<table width="100%" class="formspacing">
	
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
						  <!--- Pe.ContractNo, --->
				           R.Description, 
						   Pe.DateEvent, 
						   Pe.DateEventDue,
						   Pe.ActionDateEffective,
						   Pe.ActionDateExpiration,
						   Pe.ActionStatus,
						   Pe.Remarks
				FROM       PersonEvent Pe LEFT OUTER JOIN
			               Ref_PersonEvent R ON Pe.EventCode = R.Code
				WHERE      Pe.EventId = '#url.id#'
		</cfquery>	
		
		<cfset url.id = event.PersonNo>	
		<cfset url.mode = "workflow">
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	
	</td></tr>
	
	<cfoutput>
	
	<cfquery name="Reason" 
		    datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       Ref_PersonGroupList
				WHERE      GroupCode = '#event.ReasonCode#'
				AND        GroupListCode = '#event.ReasonListCode#'
		</cfquery>	
	
	
	<tr class="labelmedium">
		<td style="width:100px;padding-left:20px"><cf_tl id="Event">:</td>
		<td colspan="2" style="font-size:15px">#Event.Mission# #Event.Description# #Reason.Description#</td>
	</tr>
	
	<cfif event.ActionDateEffective neq "">
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Effective">:</td>
		<td colspan="2" style="font-size:15px">#dateformat(Event.ActionDateEffective,client.dateformatshow)# <cfif Event.ActionDateExpiration gte Event.ActionDateEffective>- #dateformat(Event.ActionDateExpiration,client.dateformatshow)#</cfif></td>			
	</tr>	
	</cfif>
	
	
	
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Due date">:</td>
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
			<td style="padding-left:20px"><cf_tl id="Position">:</td>
			<td colspan="2" style="font-size:15px"><cfif Position.SourcePostNumber neq "">#Position.SourcePostNumber#<cfelse>#Position.ParentPositionId#</cfif></td>			
		</tr>
		
		<tr><td></td><td colspan="2" style="padding-right:30px">
		
			<cfset url.positionno = event.PositionNo>
			<cfinclude template="getAssignment.cfm">
		
		</td></tr>
		
	</cfif>
	
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Requested">:</td>
		<td colspan="2" style="font-size:15px">#dateformat(Event.DateEvent,client.dateformatshow)# #Event.OfficerFirstName# #Event.OfficerLastName#</td>
	</tr>
	
	<cfif event.remarks neq "">
	
	<tr class="labelmedium">
		<td valign="top" style="padding-top:5px;padding-left:20px"><cf_tl id="Memo">:</td>
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

