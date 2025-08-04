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

	<cfquery name="EventDetails" 
		datasource="AppsSystem">
		 SELECT * 
		 FROM SystemEvent
		 Where EventId = '#eventid#'
		 	
	</cfquery>
	
	<cfif EventDetails.Type eq "scheduled">
	
		<cfset image = "Images/maintenance.png">
		<cfset title = "Scheduled Maintenance for">
	<cfelseif EventDetails.Type eq "unscheduled">
	
		<cfset image = "images/unscheduledmaintenance.png">
		<cfset title = "Unscheduled Maintenance for">
	<cfelseif EventDetails.Type eq "warning">
	
		<cfset image = "images/attention3.gif">
		<cfif EventDetails.title neq "">
			<cfset title = EventDetails.title>
		<cfelse>
			<cfset title = "Warning message from">
		</cfif>
	<cfelseif EventDetails.Type eq "urgent">
	
		<cfset image = "images/urgent.png">
		<cfif EventDetails.title neq "">
			<cfset title = EventDetails.title>
		<cfelse>
			<cfset title = "Urgent message from">
		</cfif>
	<cfelse>
	
		<cfset image = "Images/information.png">
		<cfset title = "Message from">
	</cfif>
	
	
	<!--- creating the date and time to be show in the message --->
	<!---
	<cfset datestart = dateFormat(EventDetails.EventDateEffective,"dd/MMM/yyyy") >
	<cfset hourstart = timeFormat(EventDetails.EventDateEffective,"HH:mm")>
	
	<cfset dateend = dateFormat(EventDetails.EventDateExpiration,"dd/MMM/yyyy")>
	<cfset hourend = timeFormat(EventDetails.EventDateExpiration,"HH:mm")>
	--->
	<!--- Let's see if it fits. Otherwise use top code--->
	<cfset datestart = dateFormat(EventDetails.EventDateEffective,"dddd, mmmm d, yyyy") >
	<cfset hourstart = timeFormat(EventDetails.EventDateEffective,"HH:mm")>
	
	<cfset dateend = dateFormat(EventDetails.EventDateExpiration,"dddd, mmmm d, yyyy")>
	<cfset hourend = timeFormat(EventDetails.EventDateExpiration,"HH:mm")>
	
	
	<cfif EventDetails.Persistent eq "false" and SESSION.authent eq "1">
		<cfset updateuser = "ColdFusion.navigate('#SESSION.root#/tools/notification/NotificationViewUserUpdate.cfm?eventid=#EventDetails.EventId#','btnajaxupdate')">
		<cfset btnlabel = "OK, Dismiss">
	<cfelse>
		<cfset updateuser = "">
		<cfset btnlabel = "OK">
	</cfif>	
	
	<cfif EventDetails.layout eq "modal">
		<div <cfoutput>id="notiwrapper#cntx#"</cfoutput> class="notiwrapper" style="position:absolute; top:0x; left:0px; width:100%; height:100%; z-index:1000; display:none;">
		
			<div style="position:absolute; top:0px; left:0px; width:100%; height:100%; z-index:1001; background-color:#FFFFFF; opacity:0.7; filter:alpha(opacity=70);"></div>	
			
			<div style="z-index:1002; overflow-y:auto; width:800px; margin:0 auto; position:relative; top:35%;">
				<cf_tableround totalwidth="100%" mode="solidcolor" startcolor="ededed" endcolor="gray" padding="10px">
	
					<table style="width:100%">
						<tr>
							<td height="30px">
								<table style="width:100%; height:30px;">
									<tr>
										<td width="50px" style="padding-right:10px; padding-top:5px">
											<cfoutput>
											<img src="#SESSION.root#/#image#" style="display:block">
											</cfoutput>
										</td>
										<td valign="top" style="vertical-align:top">
											<table style="width:100%; ">
												<tr>
													<td style="font-family:Calibri, Trebuchet MS, Helvetica; font-size:26px; color:#0f59a4;" align="left">
														<cfoutput>#title# #SESSION.welcome#</cfoutput>
													</td>
												</tr>
												<tr>
													<td style="font-family:Calibri, Trebuchet MS, Helvetica; font-size:16px; color:#0f59a4;" align="left">
														<cfif datestart eq dateend>
															<cfset singledate = datestart>
														</cfif>
														<cfoutput>
															<cfif isDefined ("singledate")> 
																in effect for #singledate# from #hourstart# hours to #hourend# hours
															<cfelse>
																in effect from #datestart# #hourstart# hours until #dateend# #hourend# hours
															</cfif>
														</cfoutput>
													</td>
												</tr>
												<tr>
													<td style="font-family:Calibri, Trebuchet MS, Helvetica; font-size:16px; color:#454545; line-height:20px; padding-top:10px" align="left">
														<cfoutput>#EventDetails.Description#</cfoutput>
													</td>
												</tr>
												<tr>						
													<td align="center" style="padding-top:10px" id="btnajaxupdate">
														<input type="button" 
															style="height:25px; width:110px; border:1px solid silver; background-color:#ededed; color:#454545; font-family:Calibri, Trebuchet MS, Helvetica; font-size:14px;" 
															value="<cfoutput>#btnlabel#</cfoutput>" 
															onclick="$('#notiwrapper<cfoutput>#cntx#</cfoutput>').slideUp(500); <cfoutput>#updateuser#</cfoutput>">	
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
								 
							</td>
						</tr>
						
					</table>				
							
				</cf_tableround>
			</div>
			
		</div>
	
	<cfelseif EventDetails.layout eq "top">
	
		<div id="notiwrapper<cfoutput>#cntx#</cfoutput>" class="notiwrapper" style="position:absolute; width:100%; height:55px; top:0px; left:0px; z-index:1000; display:none;">
		
			<div style="position:absolute; 
						top:0px; 
						left:0px; 
						right:0px; 
						bottom:0px; 
						background-color:#efacac; 
						opacity:0.8; 
						filter:alpha(opacity=80) ; 
						border-bottom:3px dashed red;
						z-index:1000; 
						-webkit-box-shadow: 0px 0px 10px 1px #454545; 
						box-shadow: 0px 0px 10px 1px #454545;"></div>
		
			<div style="position:relative; z-index:1001; overflow-y:auto; width:950px; margin:0 auto; background-color:white; opacity:0.9; filter:alpha(opacity=90);">
				<table style="width:100%">
					<tr>
						<td width="50px" style="padding-right:10px; padding-left:10px">
							<cfoutput>
							<img src="#SESSION.root#/#image#" style="display:block; height:50px;">
							</cfoutput>
						</td>
						<td valign="top" style="vertical-align:top; height:40px">
							<table style="width:98%; height:40px;">
								<tr>
									<td style="font-family:Calibri, Trebuchet MS, Helvetica; font-size:16px; line-height:13px; color:#0f59a4;" align="left">
										<cfif datestart eq dateend>
											<cfset singledate = datestart>
										</cfif>
										<cfoutput>#title# for #SESSION.welcome# 
											<cfif isDefined ("singledate")> 
												on #singledate# from #hourstart# hours to #hourend# hours
											<cfelse>
												<span style="font-size:14px">(from #datestart# #hourstart# hours until #dateend# #hourend# hours)</span>
											</cfif>
										</cfoutput>
									</td>
								</tr>
								<tr>
									<td style="font-family:Calibri, Trebuchet MS, Helvetica; font-size:12px; color:#454545; line-height:13px; border-top:1px solid silver" align="left">
										<cfoutput>#EventDetails.Description#</cfoutput>
									</td>
								</tr>
							</table>
						</td>
						<td style="vertical-align:middle; padding-right:10px" id="btnajaxupdate">
							<input type="button" style="height:25px; width:110px; border:1px solid silver; background-color:#ededed; color:#454545; font-family:Calibri, Trebuchet MS, Helvetica; font-size:14px;" value="<cfoutput>#btnlabel#</cfoutput>" onclick="$('#notiwrapper<cfoutput>#cntx#</cfoutput>').slideUp(500); <cfoutput>#updateuser#</cfoutput>">
						</td>
					</tr>
				</table>
			</div>
		</div>
	
	</cfif>

