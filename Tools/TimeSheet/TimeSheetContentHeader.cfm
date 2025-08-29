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
<cfquery name="getThisOrgUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Organization
		WHERE 	OrgUnit = '#url.orgunit#'
</cfquery>

<cfoutput>
						
		<table width="100%" class="navigation_table">
								
			<tr style="border-top:1px solid silver;">
			
				<td rowspan="2" align="right" style="border-bottom:1px solid silver;min-width:344px;padding-left:4px;width:100%">
					
					<table width="100%" border="0">
					
					<cfif session.timesheet["presentation"] eq "month">
								
						<tr class="labelmedium">
						  <td colspan="5">
						  	<table width="100%">
								<tr>
									<td style="height:35px;font-weight:410;padding-left:5px;font-size:18px" width="90%">#MonthAsString(Month(Date))# #Year(Date)#</td>
									<td align="right">
										<cfinvoke component = "Service.Presentation.TableFilter"  
										   method           = "tablefilterfield" 
										   filtermode       = "enter"
										   name             = "filtersearch"
										   style            = "font:14px;height:25;width:80"
										   rowclass         = "clsTimesheetPersonRow"
										   rowfields        = "ccontent">
									</td>
								</tr>
							</table>
						  </td>
						</tr>
						
						<tr style="background-color:f4f4f4">						  
						   
							<cfset prev_date=DateAdd("m",-1,date)>
							<cfset prev_date = dateformat(prev_date,client.dateSQL)>
							<cfset next_date=DateAdd("m",1,date)>
							<cfset next_date = dateformat(next_date,client.dateSQL)>
																
							<td align="right" style="padding-left:5px;padding-right:6;font-weight:350;" class="labelmedium">			
							<a href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';timesheet('#prev_date#','#url.object#','#url.ObjectKeyValue1#','#url.ObjectKeyValue2#',document.getElementById('showdetail').checked,'#url.copyScheduleFunction#','#url.removeScheduleFunction#')">
							#MonthAsString(Month(Date-4))#
							</a>
							</td>
							<td>|</td>
							<td style="padding-left:6;font-weight:350;" class="labelmedium">
							<a href="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';timesheet('#next_date#','#url.object#','#url.ObjectKeyValue1#','#url.ObjectKeyValue2#',document.getElementById('showdetail').checked,'#url.copyScheduleFunction#','#url.removeScheduleFunction#')">
							#MonthAsString(Month(Date+31))#
							</a>
							</td>
							
							<td height="36" align="right" style="padding-left:10" class="labelmedium">	
							<input type="checkbox" id="showdetail" value="1" <cfif url.detail eq "true">checked</cfif> onclick="Prosis.busy('yes');timesheet('#dateformat(date,client.dateSQL)#','#url.object#','#url.ObjectKeyValue1#','#url.ObjectKeyValue2#',this.checked,'#url.copyScheduleFunction#','#url.removeScheduleFunction#')">		
							</td>
							<td style="padding-left:5px;font-weight:350;" class="labelmedium"><cf_tl id="Leave requests">
							</td>		
								
						</tr>									
									
					<cfelse>
								
						<tr class="labelmedium">
						  <td colspan="2" style="height:25px;font-weight:410;padding-left:5px;font-size:18px">
						  #dateformat(session.timesheet["DateStart"],"DDD")# #dateformat(session.timesheet["DateStart"],client.dateformatshow)# - #dateformat(session.timesheet["DateEnd"],"DDD")# #dateformat(session.timesheet["DateEnd"],client.dateformatshow)# 																  
						  </td>
						</tr>	
																				
						<tr class="labelmedium">
						
						   <td colspan="1" style="padding-left:10;font-weight:350;" class="labelmedium">	
							<input type="checkbox" id="showdetail" value="1" <cfif url.detail eq "true">checked</cfif> onclick="Prosis.busy('yes');timesheet('#dateformat(date,client.dateSQL)#','#url.object#','#url.ObjectKeyValue1#','#url.ObjectKeyValue2#',this.checked,'#url.copyScheduleFunction#','#url.removeScheduleFunction#')">		
						   </td>
							<td>
								<table width="100%">
									<tr>
										<td style="padding-left:5px;font-weight:350;" class="labelmedium" width="90%"><cf_tl id="Leave requests"></td>
										<td align="right">
											<cfinvoke component = "Service.Presentation.TableFilter"  
											   method           = "tablefilterfield" 
											   filtermode       = "enter"
											   name             = "filtersearch"
											   style            = "font:14px;height:25;width:80"
											   rowclass         = "clsTimesheetPersonRow"
											   rowfields        = "ccontent">
										</td>
									</tr>
								</table>
							</td>		
								
						</tr>					
					
					</cfif>
					
					</table>
				  								
				</td>		
			
				<cfloop index="X" from="#str#" to="#end#">  
				
					<cfif session.timesheet["presentation"] eq "month">
						<cfset datecur = Createdate(year(session.timesheet["DateStart"]),month(session.timesheet["DateStart"]),x)>
					<cfelse>
				    	<cfset datecur = dateAdd("d",x,date)>
					</cfif>	
				
					<cfset dow = DayOfWeek(datecur)>
				
				    <cfif dow eq "1" or dow eq "7">
					<td align="center" style="min-width:#cwd#px;border:1px solid silver;height:35px" bgcolor="EAFBFD">#left(dayofweekasstring(dow),1)#</td>
					<cfelse>
					<td align="center" style="min-width:#cwd#px;border:1px solid silver;height:35px">#left(dayofweekasstring(dow),1)#</td>
					</cfif>
				
				</cfloop>
				
				<cfif getThisOrgUnit.WorkSchema eq 1>
																						
			    <td align="center" style="height:100%;border:1px solid silver;padding:1px">
				
				<table style="height:100%">
					<tr style="height:100%">
						
						<td align="center" style="min-width:108;border-right:1px solid silver"><cf_tl id="Contract"></td>
						<td align="center" style="min-width:70;border-right:1px solid silver"><cf_tl id="Overtime"></td>												
						<td align="center" style="min-width:35px"><cf_tl id="Com"></td>						
					</tr>
				</table>
								
				</td>
				
				</cfif>
				
			</tr>
			
			<!--- row of the day numbers --->
				
            <tr>	
																																						
				<cfloop index="X" from="#str#" to="#end#">
				
				<cfif session.timesheet["presentation"] eq "month">
					<cfset datecur = Createdate(year(session.timesheet["DateStart"]),month(session.timesheet["DateStart"]),x)>
				<cfelse>
			    	<cfset datecur = dateAdd("d",x,date)>
				</cfif>	
			
				<cfset dow = DayOfWeek(datecur)>
								 					  
				   <td style="border:1px solid silver;padding:1px;border:1px solid silver" align="center">#day(datecur)#</td>							
				 			
				</cfloop>
				
				<cfif getThisOrgUnit.WorkSchema eq 1>
				
				<td style="border:1px solid silver;height:24px">
																															
					<table style="height:100%">
					<tr style="height:100%" class="labelmedium">
						
							<td align="center" style="padding-right:2px;background-color:##e1e1e1;border-right:1px solid silver;min-width:36px"><cf_tl id="Hrs"></td>
							<td align="center" style="padding-right:2px;background-color:##FFFF00;border-right:1px solid silver;min-width:36px"><cf_tl id="Lve"></td>
							<td align="center" style="padding-right:2px;background-color:##CFE2E9;border-right:1px solid silver;min-width:36px"><cf_tl id="Day"></td>
							<td align="center" style="padding-right:2px;background-color:##ffffff;border-right:1px solid silver;min-width:36px"><cf_tl id="Pay"></td>
							<td align="center" style="padding-right:2px;background-color:##ffffff;border-right:1px solid silver;min-width:36px"><cf_tl id="Tme"></td>						
						<td align="center" style="padding-right:2px;background-color:##40004080;min-width:36px"><cf_tl id="ND"></td>	
										
					</tr>
					</table>
				
				</td>
				
				</cfif>	
				
			</tr>						
								
	</table>				
					
</cfoutput>