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

<cfoutput>
				
		<cfset code = "Delivery">
		
		<!--- Action fields --->
		<cfquery name="Action" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     WorkOrderLineAction
			WHERE    WorkOrderId   = '#url.workorderid#'		  
			AND      WorkOrderLine = '#url.workorderline#'	
			AND      ActionClass   = '#Code#'					  
			ORDER BY Created DESC			
		</cfquery>		
		
		<tr>
		
			<!--- <td valign="top" style="padding-top:3px"><cf_tl id="Delivery Date"></td>	--->
			<td>			
						
			    <cfif url.mode eq "View">
				
				    <!--- order has been confirmed --->				
					<cfoutput>
						#dateformat(Action.DateTimePlanning,client.dateformatshow)#	
					</cfoutput>
				
				<cfelse>
				
					<cfoutput>
							
					<cf_getLocalTime Mission="#url.mission#">
					
					<cfset act = action.DateTimePlanning>
					
					<table width="600" cellspacing="1" cellpadding="1">
					
						<tr>
						
						<cfset lk = "#session.root#/workorder/application/workorder/create/shiporder/DocumentFormDeliveryMode.cfm">
											
						<cfif Action.recordcount eq "0">
												
							<!--- new entry --->
					
							    <!--- we show today as option only before 15:00 local time --->												    
															
								<cfif hour(localtime) lt "15">										  
									<td><input type="radio" name="action_#code#" class="enterastab" value="today" style="height:19px;width:19px" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=today','boxaction_#code#')"></td>
									<td style="font-size:16">
									<cf_tl id="today"> <font size="2">(#dateformat(localtime,client.dateformatshow)#)</font>
									</td>								
								</cfif>
																														
								<!--- we show tomorrow only if the current time is before 17:00 it is also defaulted  --->	
																							
															
								<cfif hour(localtime) lt "17">	
									<td style="padding-left:6px"><input type="radio" class="enterastab" name="action_#code#" style="height:19px;width:19px" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=tomorrow','boxaction_#code#')" checked value="tomorrow"  <cfif hour(localtime) lt "17">checked</cfif>></td>
									<td style="font-size:16"><cf_tl id="tomorrow">&nbsp;<cfoutput>#dateformat(localtime+1,client.dateformatshow)#</cfoutput></td>
								</cfif>
																								
								<!--- other date after tomorrow --->						
							
								<td style="padding-left:6px;width:30px"><input type="radio" class="enterastab" name="action_#code#" style="height:19px;width:19px" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=other','boxaction_#code#')" value="other" <cfif hour(localtime) gte "17">checked</cfif>></td>
								<td>
								<cf_setCalendarDate name="dateaction_#code#" future="yes"
								    datevalidstart="#dateformat(localtime+2,client.dateformatshow)#" 
									value="#dateformat(localtime+2,client.dateformatshow)#">
								</td>
																
						  <cfelse>
						  
						  	<!--- delivery was already recorded and thus we show the edit mode and also the time even it this already passed --->
								
						    <cfif dateformat(act,client.dateformatshow) eq dateformat(localtime,client.dateformatshow) or hour(localtime) lte "17">
															
								<td>
								<input type="radio" name="action_#code#" class="enterastab" style="height:19px;width:19px" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=today','boxaction_#code#')" value="today" <cfif dateformat(act,client.dateformatshow) eq dateformat(localtime,client.dateformatshow)>checked</cfif>>
								</td>
								<td style="font-size:16"><cf_tl id="today">&nbsp;<cfoutput>#dateformat(localtime,client.dateformatshow)#</cfoutput></td>
																
							</cfif>	
																													
								<td style="padding-left:6px"><input name="action_#code#" class="enterastab" style="height:19px;width:19px" type="radio" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=tomorrow','boxaction_#code#')" value="tomorrow" <cfif dateformat(act,client.dateformatshow) eq dateformat(localtime+1,client.dateformatshow)>checked</cfif>></td>
								<td style="font-size:16"><cf_tl id="tomorrow">&nbsp;<cfoutput>#dateformat(localtime+1,client.dateformatshow)#</cfoutput></td>
														
							<!--- other date --->	
														
								<td style="padding-left:6px"><input type="radio" class="enterastab" style="height:19px;width:19px" name="action_#code#" onclick="ColdFusion.navigate('#lk#?mission=#url.mission#&serviceitem=#url.serviceitem#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&action=#code#&selected=other','boxaction_#code#')" name="action_#code#" value="other" <cfif dateformat(act,client.dateformatshow) gt dateformat(localtime+1,client.dateformatshow)>checked</cfif>></td>
								<td>
								<cf_setCalendarDate name="dateaction_#code#" future="yes" 
								    datevalidstart="#dateformat(localtime+2,client.dateformatshow)#" 
									value="#dateformat(act,client.dateformatshow)#">
								</td>
														  
						  </cfif>		
						  
						</tr>  
						
						<tr><td colspan="6" id="boxaction_#code#"></td></tr>
						
						</cfoutput>
										
					</table>
					
				</cfif>	
								
			</td>
		
		</tr>	
			
</cfoutput>		