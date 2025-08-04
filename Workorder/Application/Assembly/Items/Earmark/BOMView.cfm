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

<!--- ------------------------------------------------------- --->
<!--- this template is for earmarking and consuming BOM items --->
<!--- ------------------------------------------------------- --->

<!--- ideally move this template under Items/BOM/Earmark --->

<!--- collection --->

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Workorder
    WHERE     WorkorderId = '#url.workorderid#'    									  
</cfquery>

<cf_tl id="Earmark" var="tEarmark">
<cf_tl id="Collection for" var="tCollection">

<!--- 
<cf_screentop height="100%" layout="webapp" jQuery="Yes" menuAccess="Context" scroll="Yes" banner="red" label="#tEarmark# / #tCollection# #workorder.reference#">

--->

<!---

<table width="95%" align="center">

<tr><td class="labelmedium">

	Select the warehouse, then within this warehouse you have the stock for this workorder; 
	enter a quantity which falls between request -/- consumed and currently available for workorder</td>
</tr>

<tr>
	<td class="labelmedium">Submit will generate a batch (pickticket) which can be printed and approved (by warehouse staff)</td>
</tr>

</table>

--->

<!---
<cfajaximport tags="cfdiv,cfwindow">
--->


<!--- get warehouses that indeed have stock for collection for this workorder/line --->

<cfquery name="ItemList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT     P.ItemNo
	FROM       WorkOrderLineResource AS R INNER JOIN
               Materials.dbo.Item AS I ON R.ResourceItemNo = I.ItemNo INNER JOIN
               Materials.dbo.Item AS P ON I.ParentItemNo = P.ParentItemNo
	WHERE      WorkOrderId    = '#url.workorderid#'
	AND        WorkOrderLine  = '#url.WorkOrderLine#'
	UNION
	SELECT     ResourceItemNo AS ItemNo
	FROM       WorkOrderLineResource AS X
	WHERE      WorkOrderId  = '#url.workorderid#'
	AND        WorkOrderLine  = '#url.WorkOrderLine#'
</cfquery>

<cfset itm = quotedValueList(ItemList.ItemNo)> 

<cfif itm eq "">
	<cfset itm = "''">
</cfif>

<cfquery name="WarehouseList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   *
	FROM     Materials.dbo.Warehouse 
	WHERE    Mission = '#workorder.mission#'	
	AND      Operational = 1	
	AND      Warehouse IN (SELECT Warehouse 
	                       FROM	  Materials.dbo.WarehouseCategory
						   WHERE  Category = '#url.category#')	
						   
	<!--- has stock for any items in this workorder --->
						   
	AND      Warehouse IN 
	                      ( SELECT    Warehouse
						    FROM      Materials.dbo.Itemtransaction 
						    WHERE     Mission   = '#workorder.mission#'            
							<!--- confirmed --->
							AND (
						     (ActionStatus   = '1' AND TransactionType != '2') 
		        	               OR
						     (ActionStatus  IN ('0','1') AND TransactionType = '2')
							)
							AND       ItemNo        IN (#preserveSingleQuotes(itm)#) 
							AND       ItemCategory  = '#url.category#'
							GROUP BY  Warehouse, ItemNo, TransactionUoM		
							
							<!--- we now allow to see it
							HAVING SUM(TransactionQuantity) > 0							
							--->
						  )							   
	ORDER BY SupplyWarehouse					   
						   		  
</cfquery>		

<table height="100%" width="94%" align="center" class="navigation_table">

<cfif WarehouseList.recordcount eq "0">

	<tr><td class="labelmedium" align="center"><font color="#FF0000"><cf_tl id="There are no confirmed items on hand to be earmarked or collected from any warehouse"></font></td></tr>

<cfelse>

	<cfset url.warehouse = WarehouseList.warehouse>
	
	<tr><td height="3"></td></tr>
	<tr>
		<td height="29" class="labelit"><cf_tl id="Facility">:</td>
		<td width="93%">
			
		<cfoutput>	
		
			<table cellspacing="0" cellpadding="0">
			<tr>			
				
				<input type="hidden" name="warehouseselect" id="warehouseselect" value="#url.warehouse#">
				
				<cfloop query="WarehouseList">			
				<td style="padding-left:1px">
				<input onclick="document.getElementById('warehouseselect').value='#warehouse#';ptoken.navigate('../../Assembly/Items/Earmark/BOMStockOnHand.cfm?mode=#url.mode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#&warehouse=#warehouse#&pointersale='+document.getElementById('pointerselect').value,'details')"
				   type="radio" name="warehouse" id="warehouse" value="#warehouse#" <cfif url.warehouse eq warehouse>checked</cfif> style="height:19px;width:19px">
				</td>
				<td style="padding-left:6px;padding-right:10px" class="labelmedium">#WarehouseName# (#warehouse#)</td>				
				</cfloop>				
								
			</tr>
			</table>
		
		</cfoutput>	
		
		</td>
		
	</tr>
	
	<tr>
	
		<td></td>			
		<td>
		
			<table>
			<tr>
			
				<cfoutput>	
				
				 <input type="hidden" name="pointerselect" id="pointerselect" value="0">	
				
				 <td class="labelit" style="padding-right:4px"><cf_tl id="Selection mode">:</td>
				 <td>
				 <input type="radio" checked name="salepointer" value="0" onclick="document.getElementById('pointerselect').value='0';ptoken.navigate('../../Assembly/Items/Earmark/BOMStockOnHand.cfm?mode=#url.mode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#&warehouse='+document.getElementById('warehouseselect').value+'&pointersale=0','details')">
				 </td>
				 <td style="padding-left:3px" class="labelit"><cf_tl id="Free stock"><cf_tl id="and">/<cf_tl id="or"><cf_tl id="Internal production"></td>
				 <td style="padding-left:16px">
				 <input type="radio" name="salepointer" value="" onclick="document.getElementById('pointerselect').value='';ColdFusion.navigate('../../Assembly/Items/Earmark/BOMStockOnHand.cfm?mode=#url.mode#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#&warehouse='+document.getElementById('warehouseselect').value+'&pointersale=','details')">			
				 </td>
				 <td style="padding-left:3px" class="labelit"><cf_tl id="Free stock"><cf_tl id="and">/<cf_tl id="or"><cf_tl id="Earmarked stock for other workorders"></td>		 
							
				</cfoutput>
			
			</tr>
			</table>		
		
		</td>
	</tr>
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="3" class="line"></td></tr>
	
	<tr>
		<td height="100%" colspan="3">
		<cf_divscroll id="details" style="height:100%">		
		    <cfset url.pointersale = "0">								
			<cfinclude template="BOMStockOnHand.cfm">			
		</cf_divscroll>
		</td>
	</tr>

</cfif>
</table>

<cf_screenbottom layout="webapp">		