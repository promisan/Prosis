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
<cfquery name="Allotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT   PA.ActionId, 
			         PA.Status, 
					 PA.TransactionDate,
                        (SELECT   Reference
                         FROM     ProgramAllotmentAction
                         WHERE    ActionId = PA.ActionId) AS Reference, 
						 
						(SELECT   Status
                         FROM     ProgramAllotmentAction
                         WHERE    ActionId = PA.ActionId) AS WorkflowActionStatus,  
						 
					 SUM(PAR.Amount) as Amount
			FROM     ProgramAllotmentDetailRequest PAR INNER JOIN
               	     ProgramAllotmentDetail PA ON PAR.TransactionId = PA.TransactionId
			WHERE    PAR.RequirementId = '#requirementid#' AND PA.Status IN ('0','1')
			GROUP BY PA.ActionId, PA.Status, PA.TransactionDate
			ORDER BY Status DESC
</cfquery>

<cfquery name="getMax" dbtype="query">
	SELECT   MAX(Status) as status
	FROM    Allotment
</cfquery>

<!--- we hide if ALL is pending --->

<cfif getMax.Status eq "1">
	   
	<table>
			
			<cfoutput query="Allotment">
			<tr class="labelmedium">
				<td style="padding-left:10px;min-width:190px">
					<cfif status neq "1" >
					   <font color="6688aa"><cf_tl id="Pending"></a></font>
					<cfelseif WorkflowActionStatus neq "" and WorkFlowActionStatus neq "3">
					   <a href="javascript:budgetaction('#actionid#')"><font color="red">P:#reference#</font></a>
				    <cfelseif reference neq "">
					   <a href="javascript:budgetaction('#actionid#')"><font color="0080C0">#reference#</font></a>
					</cfif>
				</td>
				<cfif status eq "1">
				<td style="padding-left:10px;width:80" ><font color="gray">#dateformat(TransactionDate,client.dateformatshow)#</td>
				</cfif>
				<td align="right" style="width:80;padding-right:2px" bgcolor="<cfif status eq '1'>00ff00<cfelse>yellow</cfif>">#numberformat(amount,",.__")#</font></td>			
			</tr>
			</cfoutput>	
	  	
	</table>	

</cfif>	
		