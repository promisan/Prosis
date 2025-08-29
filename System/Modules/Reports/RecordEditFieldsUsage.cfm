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
<cfquery name="Launched7days" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT COUNT(*) LaunchedCount
	FROM UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	AND PreparationStart >= getdate() - 7
</cfquery>

<cfquery name="Launched30days" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT COUNT(*) LaunchedCount
	FROM UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	AND PreparationStart >= getdate() - 30
</cfquery>

<cfquery name="LastLaunch" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 PreparationStart,OfficerUserId,OfficerLastName,OfficerFirstName
	FROM UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	ORDER BY PreparationStart DESC
</cfquery>

<cfquery name="AVGPreparationTime" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT avg(datediff(ss,PreparationStart , PreparationEnd)) as PreparationTime
	FROM UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	AND PreparationStart is not null
	AND PreparationEnd is not null
</cfquery>


<cfquery name="TopUsers" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT TOP 5 OfficerUserId,OfficerLastName,OfficerFirstName,count(1)
	FROM  UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	GROUP BY OfficerUserId,OfficerLastName,OfficerFirstName
	ORDER BY COUNT(1) DESC
</cfquery>

<cfquery name="ActiveSubscriptions" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT COUNT(DISTINCT account) as SubscriptionCount
    FROM Ref_ReportControl R,
		Ref_ReportControlLayout L,
		UserReport U
	WHERE R.ControlId = '#URL.ID#'
	AND L.ControlId =R.ControlId
	AND U.LayoutId = L.LayoutId
</cfquery>

<cfquery name="HostsUsed" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT distinct TOP 5 HostName,count(1)
	FROM  UserReportDistribution
	WHERE ControlId = '#URL.ID#'
	GROUP BY HostName
	ORDER BY count(1) desc
</cfquery>

<cfoutput>

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
				
		<tr><td height="7"></td></tr>
		<tr class="line"><td colspan="2" class="labelmedium" style="font-weight:200;height:40px;font-size:24px">Usage Statistics</td></tr>	
		
		<tr><td height="3" class="labelmedium">Launched in last 7 days:</td><td class="labelmedium" align="right">#Launched7days.LaunchedCount#</td></tr>	
		<tr><td height="3" class="labelmedium">Launched in last 30 days:</td><td class="labelmedium" align="right">#Launched30days.LaunchedCount#</td></tr>	
		<tr><td height="3" class="labelmedium">Last Launch:</td><td class="labelmedium" align="right">#LastLaunch.OfficerFirstName# #LastLaunch.OfficerLastName# - #DateFormat(LastLaunch.PreparationStart,"mmm d, yyyy")#</td></tr>	
		<tr><td height="1" colspan="2" class="linedotted"></td><tr>
		<tr><td height="3" class="labelmedium">Top 5 users:</td>
			<td>
				<table width="100%" align="center" border="0" celpadding="0" cellspacing="0">
					<cfloop query="TopUsers">
						<tr>
							<td class="labelmedium" align="right">#OfficerFirstName# #OfficerLastName#</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>	
		<tr><td class="linedotted" colspan="2"></td><tr>		
		<tr><td class="labelmedium">Average Preparation time (seconds):</td><td class="labelmedium" align="right">#AVGPreparationTime.PreparationTime#</td></tr>	
		<tr><td class="labelmedium">Active Subscription:</td><td class="labelmedium" align="right">#ActiveSubscriptions.SubscriptionCount#</td></tr>	
		<tr><td height="1" class="linedotted" colspan="2"></td><tr>
		<tr><td class="labelmedium">Hosts Used for this report:</td>
			<td>
				<table width="100%" align="center" border="0" celpadding="0" cellspacing="0">
					<cfloop query="HostsUsed">
						<tr>
							<td class="labelmedium" align="right">#HostName#</td>
						</tr>
					</cfloop>
				</table>
			
			</td>
		</tr>	
		<cfoutput>
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		<tr><td colspan="2" class="labelmedium"><a href="javascript:usage('#url.id#')"><font color="0080C0">>> Press here to detailed usage analysis</a></td></tr>
		</cfoutput>
								
</table>	
	
</cfoutput>	