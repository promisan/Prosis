
<table width="100%">
	
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
						   Pe.ContractNo,
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
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	
	</td></tr>
	
	<cfoutput>
	
	<tr class="labelmedium">
		<td style="width:100px;padding-left:20px"><cf_tl id="Event">:</td>
		<td colspan="2"><font color="0080C0">#Event.Mission# #Event.Description#</td>
	</tr>
	
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Date">:</td>
		<td colspan="2">#dateformat(Event.DateEvent,client.dateformatshow)#</td>
	</tr>
	
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Due date">:</td>
		<td colspan="2">
		<cfif Event.actionStatus lt "3">
			<cfif now() gte Event.DateEventDue>
				<font color="FF0000"><b>#dateformat(Event.DateEventDue,client.dateformatshow)#</font>
			<cfelse>
				#dateformat(Event.DateEventDue,client.dateformatshow)#	
			</cfif>
		<cfelse>
			#dateformat(Event.DateEventDue,client.dateformatshow)#
		</cfif>
		</td>
	</tr>
	
	<cfif event.PositionNo neq "">
	
		<tr class="labelmedium">
			<td style="padding-left:20px"><cf_tl id="Position">:</td>
			<td colspan="2">#Event.PositionNo#</td>			
		</tr>
		
		<tr><td></td><td colspan="2" style="padding-left:1px;padding-right:30px">
		
			<cfset url.positionno = event.PositionNo>
			<cfinclude template="getAssignment.cfm">
		
		</td></tr>
		
	</cfif>
	
	<cfif event.ActionDateEffective neq "">
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Effective">:</td>
		<td colspan="2">#dateformat(Event.ActionDateEffective,client.dateformatshow)# - #dateformat(Event.ActionDateExpiration,client.dateformatshow)#</td>			
	</tr>	
	</cfif>
	
	<tr class="labelmedium">
		<td valign="top" style="padding-top:5px;padding-left:20px"><cf_tl id="Memo">:</td>
		<td colspan="2" valign="top" style="padding-top:5px">#Event.Remarks#</td>
	</tr>
	
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
	
	</cfoutput>

</table>

