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

<cfparam name="url.scope" default="portal">

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   WarehouseCart 
	WHERE  CartId = '#URL.ID#'
</cfquery>

<cf_quantityOutput itemNo="#Item.ItemNo#" quantity="#URL.quantity#">

<cfif Item.ShipToWarehouse neq "" and Item.ShipToLocation neq "">
	
	<!--- check if record exists already --->
			
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT sum(Quantity) as Quantity
		   FROM   WarehouseCart
		   WHERE  ItemNo          = '#Item.ItemNo#' 
		   AND    UoM             = '#Item.UoM#'		   
		   AND    ShipToWarehouse = '#Item.ShipToWarehouse#'
		   AND    ShipToLocation  = '#Item.ShipToLocation#'
		   AND    CartId != '#URL.ID#'
	</cfquery>
	
	<cfquery name="ItemUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT *
		  FROM   ItemWarehouseLocation
		  WHERE  Warehouse = '#Item.ShipToWarehouse#'
		  AND    Location  = '#Item.ShipToLocation#'
		  AND    ItemNo    = '#Item.ItemNo#'
		  AND    UoM       = '#Item.UoM#'
	</cfquery>  
	
	<cfif itemUoM.recordcount eq "1">
		
		<cfif check.quantity eq "">
		  <cfset total = url.quantity>
		<cfelse>
		  <cfset total = url.quantity+check.quantity>
		</cfif>
		
		<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Warehouse
			  WHERE  Warehouse = '#Item.ShipToWarehouse#'		  
		</cfquery>  
				
		<cfif total gte "1">
		
		     <!--- apply the validation rule enabled for this object --->			
		
		     <cf_applyBusinessRule			 
			       datasource   = "appsMaterials" 
			       triggergroup = "itemlocation"
				   mission      = "#get.mission#"
				   conditionid  = "#item.cartid#" 
				   sourceid     = "#itemuom.ItemLocationId#"
				   sourcevalue  = "#total#">	
			
			 <cfif _ValidationStopper eq "yes">
			 	<cfabort>
			 </cfif> 
				  			
		<cfelse>
		
			<cfoutput>
	
				<script language="JavaScript">
												
				     se = document.getElementById('draft_#ItemUoM.itemlocationid#')
					 if (se) {
						 ColdFusion.navigate("../Stock/InquiryWarehouseGetCart.cfm?itemlocationid=#ItemUoM.itemlocationid#",'draft_#ItemUoM.itemlocationid#') 
					 }		
					 
				</script>	
				
			</cfoutput>	
		
		</cfif>
	
	</cfif>
	
</cfif>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE WarehouseCart
	SET    Quantity = '#quantity#' 
	WHERE  CartId   = '#URL.ID#'
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT *
	    FROM   WarehouseCart C, Item I, ItemUoM U
	    WHERE  C.ItemNo = I.ItemNo 
		AND    C.UoM = U.UoM
		AND    I.ItemNo = U.ItemNo
		AND    C.CartId = '#URL.ID#'
</cfquery>

<cfoutput>  
#NumberFormat(get.Quantity*get.CostPrice*get.UoMMultiplier,'__,____.__')#
</cfoutput>
