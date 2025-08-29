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
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTS = dateValue>
	
<table width="100%" cellspacing="0" cellpadding="0" style="height:100%;min-height:100%;">
							
	<cfquery name="Actor"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">									
		SELECT    P.PersonNo, P.LastName, P.FirstName
		FROM      WorkPlan AS W INNER JOIN
	             	      Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo
		WHERE     W.DateEffective  <= #dts# 
		AND       W.DateExpiration >= #dts# 
		AND       W.Mission         = '#url.mission#'
		AND       EXISTS (SELECT 'X' FROM WorkPlanDetail WHERE WorkPlanId = W.WorkPlanId)
		GROUP BY  P.PersonNo, P.LastName, P.FirstName							
	  </cfquery>	
	
	<cfoutput query="Actor">
		<tr class="labelit">
		<td style="padding-left:16px">#firstname# #LastName#</td>
		<td></td>
		<td align="right" colspan="2" style="padding:2px;padding-right:3px">
		<input style="height:14px;width:14px" 
		    type="checkbox" 
			name="person" 
			id="person" 
			value="'#personNo#'" 
			onclick="reloadcontent('full')">			
		</td>				
		</tr>					
	</cfoutput>
			
</table>