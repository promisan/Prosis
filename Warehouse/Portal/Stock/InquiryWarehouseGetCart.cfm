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
	SELECT *
	FROM   ItemWarehouseLocation
	WHERE  ItemLocationId  = '#url.ItemLocationId#'	  
</cfquery>

<cfquery name="Warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Warehouse
	   WHERE  Warehouse  = '#get.Warehouse#'	  
</cfquery>

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Item
	   WHERE  ItemNo  = '#get.ItemNo#'	  
</cfquery>

<cf_precision number="#item.ItemPrecision#">

<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	   SELECT SUM(Quantity) as Total
	   FROM   WarehouseCart
	   WHERE  ShipToWarehouse = '#get.warehouse#'
	   AND    ItemNo          = '#get.ItemNo#' 
	   AND    UoM             = '#get.UoM#'	  
	   AND    ShipToLocation  = '#get.Location#'
</cfquery>

<cfoutput>
	
	<cfif check.total gt "0">
	
	  <a href="javascript:showcart('#get.itemlocationid#','#warehouse.mission#','#get.warehouse#','#get.location#','#get.itemno#','#get.uom#')">			 
		  <font face="Verdana" color="0080C0">#numberformat(check.total,'#pformat#')#
	  </a>
	
	<cfelse>
	
	  <font face="Verdana">#numberformat(check.total,'#pformat#')#
	 
	</cfif>
		
	<cfquery name="getLocation" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   WarehouseLocation
		WHERE  Warehouse  = '#get.Warehouse#'	  	
	</cfquery>
	
	<cfloop query="getLocation">
	
		<script language="JavaScript">
		
			se = document.getElementById('draft_#get.Warehouse#_#storageid#_#get.itemno#_#get.uom#')
			if (se) {
			   ColdFusion.navigate('#session.root#/warehouse/portal/Stock/InquiryWarehouseGetCartTotal.cfm?shipto=#get.Warehouse#&storageid=#storageid#&itemno=#get.itemno#&uom=#get.uom#','draft_#get.Warehouse#_#storageid#_#get.itemno#_#get.uom#')									
			}
		
		</script>
		
	</cfloop>
	 
	
</cfoutput>