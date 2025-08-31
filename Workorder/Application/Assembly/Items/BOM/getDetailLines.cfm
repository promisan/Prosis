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
<cfquery name="Details" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    TOP 100 T.ItemNo, 	          
	          T.ItemDescription, 
			  T.TransactionUoM, 
			  T.TransactionLot, 
			  T.Warehouse, 
			  W.WarehouseName,
			  T.TransactionType, 
			  T.TransactionDate, 
			  R.Description,
			  T.TransactionQuantity, 
			  T.TransactionReference, 
			  T.TransactionBatchNo, 
	          T.ParentTransactionId, 			  
			  T.ActionStatus,
			  T.OfficerLastName, 
			  T.OfficerFirstName, 
			  T.Created
    FROM      ItemTransaction T INNER JOIN
              Ref_TransactionType R ON T.TransactionType = R.TransactionType INNER JOIN
              Warehouse W ON T.Warehouse = W.Warehouse
	WHERE     RequirementId = '#url.drillid#' 
	ORDER BY T.Created
</cfquery>

<table align="center" width="100%" class="navigation_table">

<cfif details.recordcount eq "0">

	<tr><td align="center" bgcolor="D3F5F8" class="labelit" style="height:31"><font color="808080">Sorry, no records to show in this view</font></td></tr>
	
<cfelse>

   <tr class="line labelmedium">
   	<td width="100"><cf_tl id="Warehouse"></td>
	<td width="100"><cf_tl id="Date"></td>
	<td width="90"><cf_tl id="Lot"></td>
	<td width="120"><cf_tl id="Type"></td>	
	<td width="140"><cf_tl id="Description"></td>
	<td width="90"><cf_tl id="Reference"></td>
	<td width="100"><cf_tl id="Officer"></td>
	<td width="100"><cf_tl id="Quantity"></td>   
   </tr>
           
	<cfoutput query="Details">
	
	<tr class="navigation_row labelmedium line">
		<td>#WarehouseName#</td>
		<td>#dateformat(TransactionDate,client.dateformatshow)#</td>
		<td>#TransactionLot#</td>
		<td>#Description#</td>
		<td>#ItemDescription#</td>
		<td>#TransactionReference#</td>
		<td>#OfficerLastName#</td>
		<td align="right">#numberFormat(TransactionQuantity,",__.__")#</td>   
	</tr>

	</cfoutput>
	
</cfif>	
		
</table>

<cfset ajaxonload="doHighlight">