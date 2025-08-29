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
<cfparam name="URL.Id" default="">

<cfif URL.id eq "">
	<cfinclude template="WorkClusterPrepare.cfm">
</cfif>	

<cfoutput>
	<input type="hidden" id="RouteId" name="RouteId" value="#URL.ID#">
	<input type="hidden" id="Step"    name="Step"    value="#URL.Step#">
</cfoutput>



<cfquery name="qScope"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT COUNT(1) as Total
    FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
	WHERE  Date = #dts#
	AND    Branch = '0'
</cfquery>


<cfquery name="qPending"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT COUNT(1) as Total
     FROM  stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
	 WHERE Date = #dts#
	 AND   ActionStatus = '0'
	 AND   Branch       ='0'
</cfquery>

<cfif URL.step neq "final">

			
	<cfquery name="qScheduled"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT COUNT(1) as Total
	    FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		WHERE  Date = #dts#
		AND    ActionStatus in ('1','1a')
		AND    Branch = '0'
	</cfquery>
	
	<cfquery name="qPendingOwners"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT COUNT(1) as Total
	     FROM  stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		 WHERE Date = #dts#
		 AND   ActionStatus = '0'
		 AND   Branch       ='1'
	</cfquery>

	
	<cfquery name="qSettings"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
	    FROM   stWorkPlanSettings_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		WHERE  Date = #dts#
	</cfquery>

	<cfquery name="qHistoryDrivers"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     stWorkPlanSummaryDrivers_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL#
		WHERE    Date = #dts#
		ORDER BY TotalUsedPercentage DESC
	</cfquery>

</cfif>

<cfoutput>

	<table height="100%" width="100%">
			<tr>
				<td colspan="3">
					<table width="100%">
					<tr>	
					
					    <td width="10%" class="labelmedium">
					    	<a href="javascript:planning()"><font color="0080C0">
								<img src="#SESSION.root#/images/back.png" 
									 id="id_number_datenext" 
									 alt="" 
									 border="0">
					    	</a>
					    </td>
						<td class="labelmedium" width="30%" style="padding-left:20px">Status of processing:</td>
						<td class="labellarge" width="40%">	
							<b>#qScope.total#</b>
							(
							<cfset proc = qScope.total - qPending.total>
							<font color="008040">#Proc#</font> | #qPending.total#
							)
						</td>
											
												
					</tr>
					</table>	
				</td>						
			</tr>
			
			<cfif url.step neq "final">
			<tr>
				<td colspan="3" style="padding:5px">
				<table width="100%" class="formpadding">

						<cfset c = 0>	
								
						<tr class="line">					
							
							<td id="datecheck" class="hide" width="5%"></td>
							
							<td style="padding-right:3px" align="left">
									<cfif qSettings.TotalDriversManual neq "">
										<cfset vTotalDrivers = qSettings.TotalDriversManual> 
									<cfelse>
										<cfset vTotalDrivers = qHistoryDrivers.TotalDrivers>
									</cfif>	
									<table width="100%" class="formpadding">
									<tr>
									<td class="labelmedium"><cf_tl id="WorkPlan"></td>
									<td style="padding-left:4px" class="labelmedium">#URL.STEP#</td>
									<td style="padding-left:4px" class="labelmedium">of</td>
									<td style="padding-left:4px"><input type="text" id="id_number" name="id_number" value="#vTotalDrivers#" style="font-size:15px;height:25px;text-align:center;width:30px" class="regularxl"></td>
																		
									<td style="padding-left:2px;padding-top:3px;padding-bottom:3px" aligh="left" width="55%">		
										
										<table border="0" cellspacing="0" style="border:1px solid silver;height:25" cellpadding="0" bgcolor="e7e7e7">
										
											<tr id="id_number_date_datenext_tr">
											
												<td align="center" style="height:12px;padding-top:0px;padding-bottom:0px;border-radius:3px;border-bottom:1px solid silver;padding-left:6px;cursor:pointer;padding-right:6px;" 
												onclick="ColdFusion.navigate('Planner/DSS/WorkClusterSetNumber.cfm?name=id_number&value='+document.getElementById('id_number').value+'&increment=1&date=#url.date#','id_number_box')">
																	
													<img src="#SESSION.root#/images/up6.png" 
														 id="id_number_datenext" 
														 width="8" 
														 height="11" 
														 alt="" 
														 border="0">
														 
												</td>
											</tr>
											<tr id="id_number_date_dateprior_tr">
												<td align="center" style="height:12px;padding-left:6px;padding-top:0px;padding-bottom:0px;cursor:pointer;padding-right:6px;"
												 onclick="ColdFusion.navigate('Planner/DSS/WorkClusterSetNumber.cfm?name=id_number&value='+document.getElementById('id_number').value+'&increment=-1&date=#url.date#','id_number_box')">
													<img src="#SESSION.root#/images/down6.png" 
														id="id_number_dateprior" 
														width="8" 
														height="11" 			
														border="0">					
												</td>
											</tr>
										</table>
									</td>
									
									<td width="50%" align="right" class="labelmedium"  style="padding-left:10px;padding-top:1px" colspan="3">
									Capacity : #qSettings.CapacityPerDriver#
									</td>
									</tr>
									
									</table>
									
							</td>
														
						</tr>
						
						<tr valign="top">
							<td colspan="2">
								<table width="100%">
									
								<cfquery name="qPerson"
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">									
										SELECT PE.PersonNo,PE.FullName
										FROM Person PE INNER JOIN PersonAssignment PA
										ON PE.PersonNo = PA.PersonNo
										WHERE PA.DateEffective<=GETDATE() 
										AND PA.DateExpiration>=GETDATE()
										AND PA.AssignmentStatus in (0,1)
										ORDER BY FirstName ASC
									</cfquery>	 									
									
									<cfloop query="qMaster">
										<cfif c lt max_lookup>
											<cfset vhours = NumberFormat((qMaster.Duration)/60/60,"__.__") >
											<tr>
												<td class="labellarge" style="font-size:35px;padding-left:2px" width="70%">
													<select name="sPersonNo" style="font-size:28px;height:35px" id="sPersonNo" class="regularxl" onchange="javascript:setPlanDriver(this.value,'#URL.id#','#url.date#','#URL.Step#')">
													    <cfloop query="qPerson">
															<option value="#qPerson.PersonNo#" <cfif qPerson.PersonNo eq qMaster.PersonNo>selected</cfif>>#qPerson.FullName#</option>
														</cfloop>
													</select>
												</td>
												<td class="labellarge" align="right" style="font-size:35px;padding-right:3px" width="10%">#Deliveries#</td>												
											</tr>
										</cfif>
										<cfset c = c + 1>	
									</cfloop>							
								</table>
							</td>
						</tr>		
				</table>
				</td>
			</tr>			
							
			<tr class="xxxhide"><td id="id_number_box" name="id_number_box"></td></tr>

			</cfif>		

			<tr>
				<td colspan="3" valign="top" height="100%" style="padding-left:10px;padding-right:15px;padding:7px" width="100%">
				
					<cfdiv bind="url:#client.root#/WorkOrder/Application/Delivery/Planner/DSS/WorkClusterListing.cfm?mission=#url.mission#&id=#URL.id#&date=#url.date#&Step=#URL.Step#" ID="dss_node"/>
				
				</td>
			</tr>	
	</table>
</cfoutput>

<cfif url.loadmode eq "refresh">
	<cfset AjaxOnLoad("reloadMap")>
</cfif>	
