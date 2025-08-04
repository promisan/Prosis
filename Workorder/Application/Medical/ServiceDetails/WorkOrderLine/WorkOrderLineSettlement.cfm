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
<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrderLine  		
		WHERE  WorkOrderLineId = '#url.workorderlineid#'					
</cfquery>	

<cfquery name="Settlement" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineSettlement										
		WHERE   WorkOrderId      = '#get.Workorderid#'
		AND     WorkOrderLine    = '#get.WorkOrderLine#'
		AND     OrgUnitOwner     = '#orgunitowner#'		
		AND     TransactionDate  = '#TransactionDate#'
 </cfquery>										

<cfif settlement.recordcount eq "0">

<!---
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td align="center" class="labelit"><cf_tl id="no settlement recorded"></td></tr>
	</table>	
	--->

<cfelse>

	<table width="100%" class="navigation_table">
	
		<tr class="labelmedium line">			
			<td style="padding-left:15px;"><cf_tl id="Name"></td>	
			<td style="padding-left:15px;"><cf_tl id="Reference"></td>	
			<td style="padding-left:15px;"><cf_tl id="Code"></td>			
			<td style="padding-right:10px" align="right"><cf_tl id="Amount"></td>		
		</tr>
		
		<cfoutput query = "Settlement">		
			<tr class="labelmedium navigation_row line" style="height:23px">			   
			   <td style="padding-left:15px">#SettleCustomerName#</td>		
			   <td style="padding-left:15px"><cfif SettleReference eq "">n/a<cfelse>#SettleReference#</cfif></td>		
			   <td style="padding-left:15px">#SettleCode#</td>			  
			   <td style="padding-right:10px" align="right">#SettleCurrency# #numberformat(SettleAmount,',.__')#</td>
			</tr>			
		</cfoutput>
	
	</table>	

</cfif>			

<cfset ajaxOnLoad("doHighlight")>		