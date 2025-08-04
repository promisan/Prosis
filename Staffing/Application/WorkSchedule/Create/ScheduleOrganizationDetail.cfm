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

<cfquery name= "org" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   O.*, (SELECT count(*) 
		              FROM  WorkSchedulePosition WP,Position P 
					  WHERE WP.PositionNo = P.PositionNo
					  AND   OrgUnitOperational = O.OrgUnit
					  AND   WP.WorkSchedule = W.WorkSchedule) as Used
		FROM     WorkScheduleOrganization W, Organization.dbo.Organization O
		WHERE    W.WorkSchedule = '#url.workschedule#'		
		AND      W.OrgUnit      = O.OrgUnit
		AND      O.Mission      = '#mission#' 
		AND      O.MandateNo    = '#mandateno#' 
		ORDER BY HierarchyCode
</cfquery>

<table width="96%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">

<cfoutput query="org">

	<tr  class="navigation_row linedotted labelit">
		<td style="padding-left:4px">#OrgUnitName#</td>	
	    <td width="20" align="center" style="padding-top:3px; padding-right:5px;">
		
		<cf_verifyOperational Module="workorder">
		
		<cfif operational eq "1">
		
		   <cfquery name= "schedulecheck" 
		    datasource= "AppsWorkOrder" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">   
				SELECT DISTINCT WOLS.WorkSchedule, WOI.OrgUnit
				FROM   WorkOrderLineSchedule WOLS INNER JOIN
		               WorkOrderImplementer WOI ON WOLS.WorkOrderId = WOI.WorkOrderId
				WHERE     (WOLS.ActionStatus = '1')
				AND    WOI.OrgUnit       = '#orgunit#'
				AND    WOLS.WorkSchedule = '#url.workschedule#'	
			</cfquery>	
			
			<cfif used eq "0" and schedulecheck.recordcount eq "0">
				<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#client.root#/staffing/application/workschedule/create/ScheduleOrganizationSubmit.cfm?action=delete&workschedule=#url.workschedule#&mission=#mission#&mandateno=#mandateno#&orgunit=#orgunit#','box#mandateno#')">		   
			</cfif>   		
		
		<cfelse>
		
			<cfif used eq "0">
				<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#client.root#/staffing/application/workschedule/create/ScheduleOrganizationSubmit.cfm?action=delete&workschedule=#url.workschedule#&mission=#mission#&mandateno=#mandateno#&orgunit=#orgunit#','box#mandateno#')">		   
			</cfif>   
		
		</cfif>
				
		</td>
	</tr>
	
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>