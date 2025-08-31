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
<cfquery name="Lines" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT DISTINCT H.Mission,
	       ShipToWarehouse, 
		   ItemNo, 
		   UoM 
	FROM   RequestHeader H, Request R
	WHERE  H.Mission = R.Mission
	AND    H.Reference = R.Reference
	AND    Requestheaderid = '#object.ObjectkeyValue4#'
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="8"></td></tr>
<tr><td class="labelmedium" style="height:40">Request details</td></tr>

<tr>
	<td>
		<cfinclude template="EditHeader.cfm">
	</td>
</tr>

<tr><td height="8"></td></tr>
<tr><td class="labelmedium" style="height:40">Stock Transactions since last receipt</td></tr>

<cfloop query="lines">

    <tr><td>
	
	<cfoutput>
	
	<cfquery name="Item" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
		SELECT *
		FROM   Item I , ItemUoM U
		WHERE I.ItemNo = '#itemno#' and UoM = '#uom#'
		AND  I.ItemNo = U.ItemNo	
	</cfquery>
	
	<font size="2"><b>#Item.Itemdescription# (#Item.UoMdescription#)</font>
	
	</cfoutput>
	
	</td></tr>
	
	<tr>
	<td>
	
		<cfset url.warehouse = ShipToWarehouse>
		<cfset url.itemno    = ItemNo>
		<cfset url.uom       = UoM>
				
		<cfquery name="lastReceipt" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 SELECT    TOP 1 *		   
				 FROM      ItemTransaction
				 WHERE     Warehouse        = '#url.warehouse#'		
				 AND       ItemNo           = '#url.itemno#'
				 AND       TransactionUoM   = '#url.UoM#'		
				 AND       TransactionType IN ('1','6','8')
				 ORDER BY Created DESC	 						
		</cfquery>		
		
		<CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
		<cfset now = dateValue> 
				
		<cfif lastReceipt.recordcount eq "1">
		
		    <CF_DateConvert Value="#DateFormat(lastReceipt.TransactionDate,CLIENT.DateFormatShow)#">
		    <cfset dte = dateValue>
			<cfinclude template="../../../../Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMHistoryLines.cfm">		
			
		</cfif>		
		
	</td>
	</tr>	

</cfloop>	

</table>