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
<cfquery name="Event" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT *
		FROM   SystemEvent
		WHERE  EventId = '#url.drillid#'	
</cfquery>

<cfform name="notificationform" onsubmit="return false">

	<cfoutput>
	
	<table cellspacing="0" width="92%" align="center" class="formpadding formspacing">
		
		<tr height="15"><td colspan="2"></td></tr>
			
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Title" var="tltitle">#tltitle#:
			</td>
			<td class="labelmedium2">
				<cfinput type="text" class="regularxl" name="title" id="title" value="#Event.Title#" size="20" maxLength="20">
			</td>
		</tr> 
	
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Show" var="tlshow">
				#tlshow#:
			</td>
			<td>
				<cfselect required="yes" class="regularxxl" name="authenticationrequired" message="#tlshow# box must be defined">
					<option value="0" <cfif Event.AuthenticationRequired eq 0>selected</cfif>>
						Before Loggin in
					</option>
					<option value="1" <cfif Event.AuthenticationRequired eq 1>selected</cfif>>
						After Loggin in
					</option>
				</cfselect>
			</td>
		</tr>
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Message Display Layout" class="message" var="tlmessagedisplay">
				#tlmessagedisplay#:
			</td>
			<td>
				<cfselect class="regularxxl" required="yes" name="messagedisplay" message="#tlmessagedisplay# must be defined">
					<option value="top" <cfif Event.Layout eq "top">selected</cfif>>Top Marquee</option>
					<option value="modal" <cfif Event.Layout eq "modal"> selected</cfif>>Modal window</option>
				</cfselect>
			</td>
		</tr>
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Effective Date/Hour" var="tleffective">
				#tleffective#:
			</td>
			<td>
			
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td class="labelmedium2">
							<cfset date = dateformat(now()+1,CLIENT.DateFormatShow)>
	
							<cf_intelliCalendarDate9
								FieldName="dateeffectivestart" 					
								class="regularxxl"		
								Default = "#DateFormat(Event.EventDateEffective,CLIENT.DateFormatShow)#"
								AllowBlank="False">	
						</td>
						<td style="padding-left:5px">
							<cfset vlist = "0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23">
							
							<cfselect name="dateeffectivestarttime" class="regularxl" required="yes" message="Please select a Start time">
								<cfloop list="#vlist#" index="i">											
									<option value="#i#" <cfif i eq TimeFormat(Event.EventDateEffective,'H')>selected</cfif> >#i#:00</option>														
								</cfloop>
							</cfselect>
							
						</td>
					</tr>
				</table>
			
			</td>										
		</tr>
		
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Expiration Date/Hour" var="tlexpiration">
				#tlexpiration#:
			</td>
			<td>
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<cfset date = dateformat(now()+1,CLIENT.DateFormatShow)>

							<cf_intelliCalendarDate9
								FieldName="dateeffectiveend" 					
								class="regularxxl"	
								Default = "#DateFormat(Event.EventDateExpiration,CLIENT.DateFormatShow)#"
								AllowBlank="False">	
						</td>
						<td style="padding-left:5px">											
							<cfselect name="dateeffectiveendtime" class="regularxl" required="yes" message="Please select a End time">
								<cfloop list="#vlist#" index="i">											
									<option value="#i#" <cfif i eq TimeFormat(Event.EventDateExpiration,'H')>selected</cfif>>#i#:00</option>														
								</cfloop>
							</cfselect>
						</td>
					</tr>

				</table>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Display notification" var="tlshownoti">
				#tlshownoti#:
			</td>
			<td>
					
				<cfset display = Event.EventDisplayDuration>
				<cfset checked = "hours">
				
				<cfif Event.EventDisplayDuration gt 168> <!--- weeks --->
					<cfset display = display/168>
					<cfset checked = "weeks">
				<cfelseif Event.EventDisplayDuration gt 24> <!--- days --->
					<cfset display = display/24>
					<cfset checked = "days">
				</cfif>
				
				<cfset display = NumberFormat(display,'_')>
				
			
				<table>
					<tr>
						<td>
							<cfinput type="text" style="text-align:center;width:30px" class="regularxl" value="#display#" name="notificationduration" required="yes" message="#tlshownoti# box must be defined">
						</td>
						<td class="labelmedium2">
							<input type="radio" 
								   value="hours" 
								   name="uom" <cfif checked eq "hours">checked="checked"</cfif>> Hours<br>
								   
							<input type="radio" 
								   value="days" 
								   name="uom" <cfif checked eq "days">checked="checked"</cfif>> Days<br>
								   
							<input type="radio" 
								   value="weeks" 
								   name="uom" <cfif checked eq "weeks">checked="checked"</cfif>> Weeks
						</td>
						<td class="labelmedium2" style="padding-left:3px">
							&nbsp;&nbsp;before #tleffective#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Remove after User views the message" class="message" var="tlremoveafter">
				#tlremoveafter#:
			</td>
			<td class="labelmedium2">
				<cfselect required="yes" class="regularxxl" name="removeafter" message="#tlremoveafter# must be defined">
					<option value="0" <cfif Event.Persistent eq 0>selected</cfif>>Yes</option>
					<option value="1" <cfif Event.Persistent eq 1>selected</cfif>>No</option>
				</cfselect>
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Message Type" var="tlMessagetype">
				#tlMessagetype#:
			</td>
			<td class="labelmedium2">
				<cfselect required="yes" class="regularxxl"
						  name="messagetype" 
						  message="#tlMessagetype# must be defined" 
						  <!---onchange="if(this.value == 'warning' || this.value == 'urgent'){document.getElementById('notititle').style.display = 'block'} else {document.getElementById('notititle').style.display = 'none'}"--->
						  >
					<option value="scheduled" <cfif Event.Type eq "scheduled">selected</cfif>>Scheduled Maintenance</option>
					<option value="unscheduled" <cfif Event.Type eq "unscheduled">selected</cfif>>Unscheduled Maintenance</option>
					<option value="warning" <cfif Event.Type eq "warning">selected</cfif>>Warning</option>
					<option value="urgent" <cfif Event.Type eq "urgent">selected</cfif>>Urgent</option>
				</cfselect>
			</td>
		</tr>
		<!---
		<tr style="display:none;" id="notititle">
			<td class="labelmedium2">
				<cf_tl id="Title">
			</td>
			<td>
				<cfinput type="text" style="width:250px" required="no" name="title">
			</td>
		</tr>
		--->
		<tr>
			<td class="labelmedium2">
				<cf_tl id="Select Application Server(s)" class="message"> :
			</td>
			<td>
			
				<cfquery datasource="AppsInit" name="AppServers">
					SELECT P.HostName, S.HostName AS Checked
					FROM   Parameter.dbo.Parameter P		
					LEFT   JOIN System.dbo.SystemEventServer S ON P.HostName = S.HostName AND S.EventId = '#url.drillid#'
					WHERE  Operational = 1					
				</cfquery>
				
				<table cellpadding="0" cellspacing="0">
					<cfset cnt = "0">
					<cfloop query="AppServers">
					<cfset cnt = cnt+1>
					<cfif cnt eq "1">
					<tr>
					</cfif>
						<td class="labelmedium2">
						    <table><tr><td>
							<cfset c="No">
							<cfif checked neq "">
								<cfset c="Yes">
							</cfif>
							<cfinput class="radiol" required="yes" type="checkbox" value="#Hostname#" id="appserver" name="appserver" checked="#c#">
							</td>
							<td style="padding-left:1px" class="labelmedium2">#Hostname#</td>
							</tr>
							</table>
						</td>
					<cfif cnt eq "2">
					</tr>
					<cfset cnt="0">
					</cfif>
					</cfloop>
				</table>
				
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium2" style="height:25px">
				<cf_tl id="User Message" var="tlmessage">
				#tlmessage#:
			</td>
		</tr>
		<tr>	
			<td colspan="2" style="padding-left:10px;padding-top:3px">
				<cf_textarea required="yes" style="padding:3px;font-size:13px;width:99%; height:70px; border-radius:5px;border:1px solid silver" name="message" message="#tlmessage# must be defined">#Event.Description#</cf_textarea>
			</td>
		</tr>
		
		<tr><td colspan="2"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
						
		<tr>
			<td align="center" colspan="2" height="32">
				<cfif Event.EventId neq "">
					<input  type="hidden" name="EventId" value="#Event.EventId#">					
					<input  type="button" onclick="deleteRecord()" value="Remove" name="Delete" class="button10g" width="130">
					<input  type="button" onclick="validate()" value="Save" name="Update" class="button10g" width="130">
				<cfelse>
					<input  type="button" onclick="validate()" value="Enable" name="Create" class="button10g" width="130">
				</cfif>
			</td>
		</tr>
	</table>
	</cfoutput>
	
</cfform>