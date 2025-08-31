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
	SELECT    TOP 40 T.ItemNo, 	          
	          T.ItemDescription, 
			  T.Mission,
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
    FROM      ItemTransaction T 
	          INNER JOIN Ref_TransactionType R ON T.TransactionType = R.TransactionType 
			  INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
	WHERE     RequirementId = '#url.drillid#' 
	ORDER BY  T.Created
</cfquery>

<table align="center" width="99%" class="navigation_table">

<cfif details.recordcount eq "0">

	<tr><td align="center" class="labelit" style="height:31"><font color="808080">No records to show in this detail view</font></td></tr>
	
<cfelse>

   <tr class="labelmedium">
   	<td><cf_tl id="warehouse"></td>
	<td><cf_tl id="Batch"></td>
	<td><cf_tl id="Date"></td>	
	<td><cf_tl id="Type"></td>	
	<td><cf_tl id="Description"></td>
	<td><cf_tl id="Lot"></td>
	<td><cf_tl id="Reference"></td>
	<td><cf_tl id="Officer"></td>
	<td width="100" align="right"><cf_tl id="In"></td>   
	<td width="100" align="right"><cf_tl id="Out"></td>  
   </tr>
   
   <cfset Incoming = 0>
   <cfset Outgoing = 0>
           
   <cfoutput query="Details">
	
		<tr class="navigation_row labelmedium line">
			<td style="padding-left:3px;padding-right:3px">#WarehouseName#</td>
			<td style="padding-right:3px"><a href="javascript:batch('#transactionbatchno#','#mission#')">#TransactionBatchNo#</a></td>
			<td style="padding-right:3px">#dateformat(TransactionDate,client.dateformatshow)#</td>		
			<td style="padding-right:3px">#Description#</td>
			<td style="padding-right:3px">#ItemDescription#</td>
			<td style="padding-right:3px">#TransactionLot#</td>
			<td style="padding-right:3px">#TransactionReference#</td>
			<td style="padding-right:3px">#OfficerLastName#</td>
			<td align="right">
			<cfif transactionquantity gte "0">#numberFormat(TransactionQuantity,",._")#
			<cfset incoming = incoming+TransactionQuantity>
			</cfif>
			</td>
			<td align="right">
			<cfif transactionquantity lte "0">#numberFormat(TransactionQuantity*-1,",._")#
			<cfset outgoing = outgoing+(TransactionQuantity*-1)>
			</cfif>
			</td>		   
		</tr>

    </cfoutput>
	
	<cfoutput>
	
	<tr class="navigation_row labelmedium line">
		<td colspan="8"></td>		
		<td align="right" style="padding-right:4px;color:gray;border:1px solid silver">#numberFormat(Incoming,",._")#</td>
		<td align="right" style="padding-right:4px;color:gray;border:1px solid silver">#numberFormat(Outgoing,",._")#</td>		   
	</tr>
	
	</cfoutput>
	
</cfif>	
		
</table>

<cfset ajaxonload("doHighlight")>