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
<cfset eventtrigger = Object.EntityClass>

<cfoutput>
<input name="eventtrigger" type="hidden"        value="#eventtrigger#">
</cfoutput>

<cfquery name="qDocument" 
	 datasource="AppsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Document
	 WHERE  DocumentNo = '#Object.ObjectKeyValue1#'
</cfquery>

<cfquery name="qEvent" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   PersonEvent
	 WHERE  EventId='#Object.ObjectId#'
</cfquery>		 

<table width="94%" class="formpadding" align="center">

	<cfoutput>
	
			<tr><td height="10"></td></tr></tr>
					
			<tr class="labelmedium">
				
				<td  style="padding-left:3px" width="20%"><cf_tl id="Action">:</td>
			    <td style="padding-left:0px" id="dEvent">
													
				<cfquery name="qEvents" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT Code,
						       Description
						FROM   Ref_PersonEvent RPE 
						WHERE  Code IN (SELECT EventCode 
						                FROM   Ref_PersonEventTrigger 
										WHERE  EventTrigger = '#eventtrigger#')
						AND    Code IN (SELECT PersonEvent 
							            FROM   Ref_PersonEventMission 
										WHERE  Mission  = '#Object.mission#')						
						ORDER BY ListingOrder		
				</cfquery>
	
				<select name="eventcode" 
				    id="eventcode" 
					class="regularxl" 
					style="width:300px" 
					onchange="ColdFusion.navigate('#session.root#/Vactrack/Application/Workflow/Event/setReason.cfm?mission=#Object.Mission#&triggercode=#eventtrigger#&eventcode='+this.value+'&reasonlistcode=#qEvent.ReasonListCode#','dReason')">					
					<cfloop query="qEvents">
						<option value="#Code#" <cfif Code eq qEvent.EventCode>selected</cfif>>#Description#</option>
					</cfloop>
				<select>				
								
				</td> 				
				
			</tr>

			<tr id="reasonbox" class="labelmedium">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Reason">:</td>
			    <td style="padding-left:0px" id="dReason">
				
				<cfdiv bind="url:#session.root#/Vactrack/Application/Workflow/Event/setReason.cfm?mission=#Object.Mission#&triggercode=#eventtrigger#&eventcode=#qEvent.EventCode#&reasonlistcode=#qEvent.ReasonListCode#">	
				
				</td> 				
				
			</tr>
									
			<tr class="labelmedium">
				
				<td style="padding-left:3px" width="20%"><cf_tl id="Contract">/<cf_tl id="Assignment"> <cf_tl id="Effective">:</td>
				<td style="padding-left:0px">
				
					<table><tr class="labelmedium"><td>
				
					<cf_space spaces="38">	
						
					<cfset vDate = qEvent.ActionDateEffective>
														
					<cf_intelliCalendarDate9
						FieldName="ActionDateEffective" 
						Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
						AllowBlank="True"
						Class="regularxl">
						
					</td>
					
					<td style="padding-left:3px"><cf_tl id="Expiration">:</td>
					<td style="padding-left:10px">
					
						<cf_space spaces="38">	
							
						<cfset vDate = qEvent.ActionDateExpiration>
														
						<cf_intelliCalendarDate9
							FieldName="ActionDateExpiration" 
							Default="#DateFormat(vDate,'#CLIENT.DateFormatShow#')#"
							AllowBlank="True"
							Class="regularxl">
							
					</td>
					
					</tr></table>	
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
											
				    <cfif qDocument.DueDate neq "">
					    <cfset vDate = qDocument.DueDate> 
					<cfelse>
						<cfset vDate = qEvent.DateEventDue>
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
			<input type="text" name="Remarks" value="#qEvent.Remarks#" style="width:100%" class="regularxl" style="width:99%">									
		    </td>
		    
			</tr>		
										
			<tr><td class="labelmedium" valign="top" style="padding-left:3px;padding-top:4px" width="20%"><cf_tl id="Attachment">:</td>
			<td>
		
				<cf_filelibraryN
					DocumentPath="PersonEvent"
					SubDirectory="#qEvent.PersonNo#" 
					Filter="#left(Object.ObjectId,8)#"
					attachdialog = "cfwindow"
					Insert="yes"
					Remove="yes"
					Listing="yes">
			</td>		
			</tr>		
			
			<tr><td></td></tr>						
				
	 </cfoutput>
 
</table>

<cfset AjaxOnLoad("doCalendar")>

<cfoutput> 
<input name="savecustom" type="hidden"  value="Vactrack/Application/Workflow/Event/DocumentSubmit.cfm">
<input name="ObjectId" type="hidden"    value="#Object.ObjectId#">
<input name="Key1" type="hidden"        value="#Object.ObjectKeyValue1#">
<input name="Key2" type="hidden"        value="#Object.ObjectKeyValue2#">
</cfoutput>
 