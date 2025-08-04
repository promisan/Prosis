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

<!--- show the details to be returned --->

<cfparam name="url.mission" default="">
<cfparam name="url.itemno"  default="">
<cfparam name="url.uom"     default="">
<cfparam name="url.lot"     default="">

<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       ItemTransaction 
		WHERE      TransactionId  = '#url.TransactionId#' 		
</cfquery>

<cfquery name="Details" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT      T.Warehouse, 
		            W.WarehouseName, 
					WL.Location, 
					WL.Description, 
					WL.StorageId,
					T.ItemNo, 
					T.TransactionUoM, 
					T.TransactionLot, 
					SUM(T.TransactionQuantity) AS OnHand
		FROM        ItemTransaction T INNER JOIN
		            Warehouse W ON T.Warehouse = W.Warehouse INNER JOIN
		            WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
		WHERE       T.Mission        = '#get.mission#' 
		AND         T.ItemNo         = '#get.itemno#' 
		AND         T.TransactionUoM = '#get.TransactionUoM#' 
		AND         T.TransactionLot = '#get.TransactionLot#'
		GROUP BY    T.ItemNo, 
		            T.TransactionUoM, 
					T.TransactionLot, 
					W.WarehouseName, 
					WL.Description, 
					WL.StorageId,
					T.Warehouse, 
					W.WarehouseName, 
					WL.Location, 
					WL.Description
		HAVING      SUM(T.TransactionQuantity) > 0
		ORDER BY    T.Warehouse, WL.Location
		
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<cfoutput query="Details">

<tr class="labelmedium line">
	<td style="height:32px;width:200">#WarehouseName#</td>
	<td style="width:200">#Description#</td>
	<td align="right" style="width:100">#OnHand#</td>
	<td align="right" style="width:100">
		  
	  <input type="hidden" name="loc_#left(transactionid,8)#"  value="#StorageId#"> 
	  	  
	  <input type="text" 
	         name="loc_#left(transactionid,8)#_#left(StorageId,8)#" 
			 onchange="ptoken.navigate('#session.root#/Warehouse/Application/Stock/Return/setReturn.cfm?mission=#get.mission#&transactionid=#url.transactionid#','return_#url.transactionid#','','','POST','returnform')" 
			 style="text-align:right;width:50px" 
			 class="regularxl enterastab" 
			 maxlength="6">
	</td>	
</tr>

</cfoutput>
</table>
