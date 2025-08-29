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
<cfparam name="URL.mode" default="regular"> 

	<cfquery name="PayGeneral" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	PersonNo, ProcessNo, ProcessBatchID, Mission
		FROM 	Payroll.dbo.CalculationLog
		WHERE   ProcessId ='#url.drillid#' 
	</cfquery>		

	<cfquery name="PayDetails" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	SalarySchedule,ESL.Source,PaymentDate,SettlementPhase,  CAST(ESL.PayrollItem as VARCHAR(6))+'-'+LEFT(PIT.PayrollItemName,30) as PayrollItem,
  				Currency,PaymentAmount
		FROM 	Payroll.dbo.CalculationLogSettlementLine as ESL
				INNER JOIN Payroll.dbo.Ref_PayrollItem as PIT ON ESL.PayrollItem = PIT.PayrollItem
  		WHERE 	PersonNo 		= '#URL.personNo#'
  		AND	 	ProcessNo 		= '#PayGeneral.ProcessNo#'
  		AND	 	ProcessBatchID	= '#PayGeneral.ProcessBatchID#' 
		ORDER BY PrintOrder
	</cfquery>	
	
<cfinvoke component="Service.Access"
	Method="PayrollOfficer"
	Role="PayrollOfficer"
	Mission="#PayGeneral.mission#"
	ReturnVariable="PayrollAccess">		

<cfinvoke component="Service.Access"
	Method="employee"
	PersonNo="#url.PersonNo#"	
	ReturnVariable="HRAccess">		
	
<cfif PayDetails.recordcount eq "0">

	<table width="100%">
	  <tr class="labelmedium">
	     <td style="padding-left:16px"><cf_tl id="This process does not have any details associated"></td>
 	  </tr>
    </table>

<cfelse>
	
	<cfif PayrollAccess neq "NONE" or HRAccess neq "NONE" or CLIENT.PersonNo eq URL.ID>
			
		<table width="96%" border="0" cellspacing="0" align="center" class="navigation_table formpadding">
			<tr class="labelmedium line">
				<td style="padding-left:3px" width="100%"><b><cf_tl id="Payroll Item"></td>
				<td style="min-width:100px"><b><cf_tl id="Source"></td>
				<td style="min-width:100px"><b><cf_tl id="Settle under"></td>
				<td style="min-width:100px"><b><cf_tl id="Slip"></td>			
				<td style="min-width:50px"><b><cf_tl id="Curr"></td>
				<td align="right" style="min-width:100px;padding-right:4px"><b><cf_tl id="Amount"></td>
			</tr>		
							
			<cfoutput query="PayDetails">
				<tr class="line labelmedium navigation_row">
					<td style="padding-left:3px">#PayDetails.PayrollItem#</td>
					<td>#PayDetails.Source#</td>
					<td>#DateFormat(PayDetails.PaymentDate,client.dateformatshow)#</td>
					<td>#PayDetails.SettlementPhase#</td>				
					<td>#PayDetails.Currency#</td>
					<td align="right" style="padding-right:4px">#NumberFormat(PayDetails.PaymentAmount,"_,.__")#</td>
				</tr>
			</cfoutput>
						
		</table>	
			
	<cfelse>
		
			No access granted
		
	</cfif>

</cfif>

<cfset ajaxonload("doHighlight")>