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
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *			   
	FROM       workOrder.dbo.WorkOrderLine	
	WHERE      WorkOrderId = '#url.workorderid#' 
	AND        WorkOrderLine = '#url.workorderline#' 	
</cfquery>


<cfquery name="Production" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     T.TransactionType, 
	           T.ItemCategory, 
			   R.Description, 			   
			   SUM(T.TransactionValue) AS Total
			   
	FROM       ItemTransaction AS T LEFT OUTER JOIN
	           Ref_Category AS R ON T.ItemCategory = R.Category
	WHERE      T.WorkOrderId = '#url.workorderid#' 
	AND        T.WorkOrderLine = '#url.workorderline#' 
	AND        T.TransactionType <> '8'
	GROUP BY   T.TransactionType, T.ItemCategory, R.Description
	
</cfquery>

<table width="95%" cellspacing="4" cellpadding="4">

	<tr><td height="10"></td></tr>
	<tr><td colspan="4" style="font-size:35px" class="labellarge"> <cf_tl id="Stock Transactions"></td></tr>
	
	<tr>	  
	   <td colspan="4" class="line"></td>
	</tr>
	
	<cfoutput query="Production" group="TransactionType">
	
		<cfif TransactionType eq "0">
		
			<cfset sign = "1">
			<tr><td style="height:33px" colspan="4" class="labellarge">
			   <cf_tl id="Produced Goods"></td>
		    </tr>
		
		<cfelseif TransactionType eq "2">
		
		    <cfset sign = "-1">
			<tr><td style="height:33px" colspan="4" class="labellarge">
			   <cf_tl id="Consumed Materials"></td>
		    </tr>
			
		<cfelse>
		
			<cfset sign = "1">
			<tr><td style="height:33px" colspan="4" class="labellarge">
			   <cf_tl id="Other transaction"></td>
		    </tr>
			
		</cfif>
	
		<cfoutput>
		
		<tr class="labelmedium">
		   <td style="padding-left:30px">#Description#</td>
		   <td colspan="3" align="right">#numberformat(Total*sign,",__.__")#</td>
	    </tr>
		
		</cfoutput>
		
	</cfoutput>
	
	
	<tr><td height="20"></td></tr>
	<tr><td colspan="2" class="labellarge" style="font-size:35px"><cf_tl id="Ledger"></td></tr>
	<tr>	  
	   <td colspan="4" class="line"></td>
	</tr>
	<tr><td height="5"></td></tr>
	
	<cfquery name="Ledger" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
	SELECT GLAccount, 
	       Description, 
		   AccountType, 
		   AccountClass,
		   BatchNo, 
		   BatchDescription, 
		   ActionStatus,
		   Sum(Debit) as Debit, 
		   Sum(Credit) as Credit
	
	FROM (
	
			SELECT     	A.GLAccount, 
						A.Description, 
						A.AccountType, 
						A.AccountClass,
						WB.BatchNo, WB.BatchDescription,WB.ActionStatus,
			            SUM(L.AmountBaseDebit) AS Debit, 
						SUM(L.AmountBaseCredit) AS Credit
						 					
			FROM        ItemTransaction AS T INNER JOIN 
						Materials.dbo.WarehouseBatch as WB ON T.TransactionBatchNo = WB.BatchNo INNER JOIN
			            Accounting.dbo.TransactionHeader AS H ON T.TransactionId = H.ReferenceId INNER JOIN
			            Accounting.dbo.TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
			            Accounting.dbo.Ref_Account AS A ON L.GLAccount = A.GLAccount LEFT OUTER JOIN
			            Ref_Category AS R ON T.ItemCategory = R.Category
						
			WHERE       T.WorkOrderId   = '#url.workorderid#' 
			AND         T.WorkOrderLine = '#url.workorderline#' 			
			AND         T.TransactionType <> '8'			
				
			GROUP BY    A.GLAccount, A.Description, A.AccountType, A.AccountClass,WB.BatchNo, WB.BatchDescription,WB.ActionStatus
			
			<!--- ------------------------------------- --->
			<!--- production service transaction (COSU) --->
			<!--- ------------------------------------- --->
						
			UNION
			SELECT      A.GLAccount, 
						A.Description, 
						A.AccountType, 
						A.AccountClass,
						WB.BatchNo, WB.BatchDescription, WB.ActionStatus,
			            SUM(L.AmountBaseDebit) AS Debit, 
						SUM(L.AmountBaseCredit) AS Credit
						 					
			FROM        Accounting.dbo.TransactionHeader AS H INNER JOIN 
						Materials.dbo.WarehouseBatch as WB ON WB.BatchNo	= H.TransactionSourceNo AND WB.BatchId  = H.TransactionSourceID INNER JOIN
			            Accounting.dbo.TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
			            Accounting.dbo.Ref_Account AS A ON L.GLAccount = A.GLAccount 
						
			WHERE       H.TransactionSource   = 'WorkOrderSeries'
			AND         H.TransactionSourceId = '#get.workorderlineid#' 
			AND         NOT EXISTS (SELECT 'X' 
			                        FROM    Materials.dbo.Itemtransaction 
									WHERE  TransactionId = H.ReferenceId)						
										
					
			GROUP BY    A.GLAccount, A.Description, A.AccountType, A.AccountClass,WB.BatchNo, WB.BatchDescription,WB.ActionStatus
						
			) as Sub
		
		GROUP BY GLAccount, Description, AccountType, AccountClass, BatchNo, BatchDescription, ActionStatus
		ORDER BY BatchNo,GLAccount 
		  <!--- --->
	</cfquery>
	
	
	<tr class="labelit">
	   <td style="padding-left:24px" colspan="2"><cf_tl id="GLAccount"></td>	   
	   <td style="width:100px" align="right"><cf_tl id="Debit"></td>
	   <td style="width:100px" align="right"><cf_tl id="Credit"></td>
    </tr>
	
	<cfset dbt = 0>
	<cfset cdt = 0>
	
	<cfoutput query="Ledger" group="BatchNo">
	
		<cfif AccountClass neq "Result">
		    <cfset cl = "ffffff">
		<cfelse>
			<cfset cl = "e6e6e6">
		</cfif>
		<cfset clb = "ffffff">
		<cfif ActionStatus eq "0">
		    <cfset clb = "D6093C">
		<cfelse>
			<cfset clb = "3BF507">
		</cfif>
		<tr bgcolor="CFCFCF" class="labelmedium line" >
				<td colspan="4" align="center" ><a href="#Session.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?batchno=#BatchNo#&mode=process" target="_blank">
					<font color="#clb#">
					<b>#BatchNo# - <cf_tl id="#BatchDescription#"></b>
				</font>
				</a></td>
		</tr>	
		<cfoutput>
			<tr bgcolor="#cl#" class="labelmedium line">
		   		<td style="height:20px;padding-left:24px">#GLAccount#<cf_space spaces="30"></td> 
		   		<td style="height:20px;padding-left:5px">#Description#</td>
		   		<cfif Debit neq "0" and Credit neq "0">
			   		<cfif Debit gte Credit>
						<td style="height:20px;" align="right">#numberformat(Debit-Credit,",__.__")#</td>
				   		<td style="height:20px;" align="right">-</td>
				   		<cfset dbt = dbt + Debit-Credit>				
			   		<cfelse>
			   
			    	<cfset cdt = cdt + Credit - Debit>			   
			    	<td style="height:20px;" align="right">-</td>
			    	<td style="height:20px;padding-right:4px" align="right">#numberformat(Credit-Debit,",__.__")#</td>
			   	</cfif>
			   
		   		<cfelseif Debit neq "0">
		   
		   		<cfset dbt = dbt + Debit>
		   
		   		<td style="height:20px;" align="right">#numberformat(Debit,",__.__")#</td>
		   		<td style="height:20px;padding-right:4px" align="right">-</td>
		   		<cfelseif Credit neq "0">
		   
			   <cfset cdt = cdt + Credit>
			   <td style="height:20px;" align="right">-</td>
			   <td style="height:20px;padding-right:4px" align="right">#numberformat(Credit,",__.__")#</td>		   
		   	</cfif>
	    </tr>
		</cfoutput>

		<tr class="labelmedium" style="border-top:1px solid silver">
	   		<td colspan="2"></td>
	   		<td style="height:20px;" align="right">#numberformat(dbt,",__.__")#</td>
	   		<td style="height:20px;padding-right:4px"  align="right">#numberformat(cdt,",__.__")#</td>		
    	</tr>

		<cfset dbt = 0>
		<cfset cdt = 0>
				
	</cfoutput>
</table>

