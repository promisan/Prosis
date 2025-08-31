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
<cfquery name="selecteditems" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   userTransaction.dbo.FinalProduct_#session.acc#
		WHERE  WorkOrderId    = '#url.workorderId#'	
		AND    WorkOrderLine  = '#url.workorderLine#'		
		AND    Quantity > 0 and Quantity is not NULL
		AND    Price > 0 
		AND    Price IS NOT NULL
</cfquery>


<table width="100%">

	<tr><td height="4"></td></tr>
	<tr><td bgcolor="e4e4e4" class="labelmedium" style="border:0px solid gray;height:30px;padding-left:14px;color:black"><cf_tl id="Selected Items"></td></tr>
	<tr><td bgcolor="white" style="border:0px solid silver;padding:5px">
		
	<cfif selecteditems.recordcount gte "0">
	
	<cf_divscroll height="140">
	
		<table width="98%" cellspacing="0" cellpadding="0" class="navigation_table">				
		
		<cfoutput query="SelectedItems">
			<tr class="labelit navigation_row line">
			  <td style="width:10px"></td>
			  <td style="width:20px"><cf_img icon="delete" onclick="deleteSelected('#WorkorderItemId#')"></td>
			  <td>#Warehouse# #TransactionLot#</td>
			  <td>#Class1ListValue#</td>
			  <td>#Class2ListValue#</td>
			  <td>#Class3ListValue#</td>
			  <td>#Class4ListValue#</td>
			  <td>#Class5ListValue#</td>
			  <td>#Class6ListValue#</td>
			  <td align="right">#Quantity#</td>
			  <td>#Currency#</td>
			  <td align="right" style="padding-right:5px">#numberformat(Price,",__.__")#</td>  
			</tr>
		</cfoutput>
		
		<cfif selecteditems.recordcount lte 7>
		<cfloop index="itm" from="1" to="#7-selecteditems.recordcount#">
		<tr class="labelit navigation_row line"><td colspan="12"></td></tr>
		</cfloop>
		</cfif>
			
		</table>
		
		</cf_divscroll>
		
		</td>
		</tr>
			
		<cfif selecteditems.recordcount gte "1">
			
			<tr><td class="line"></td></tr>
			<tr><td align="center" style="height:40px;padding-top:4px">
				<cfoutput>
				    <cf_tl id="Apply Finished Product" var="label">
					<input type="button" name="Submit" value="#label#" style="border-radius:4px;width:220;height:29px" class="button10g" 
					onclick="submitTransactions('#url.workorderId#','#url.workorderLine#')">
				</cfoutput>	
			
			</td></tr>
		
		</cfif>
	
	</cfif>

	</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>