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
<cf_compression>

<!--- from the header --->
<cfparam name="url.mission"       default="">
<cfparam name="url.orgunitvendor" default="0">

<!--- from the line itself --->
<cfparam name="url.itemno"        default="">
<cfparam name="url.uom"           default="0">
<cfparam name="url.warehouse"     default="">  <!--- get the location from the warehouse --->
<cfparam name="url.itemUoMId" 	  default="">

<cfquery name="purchase" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Purchase
	WHERE    PurchaseNo = '#url.purchaseno#'	
</cfquery>	

<cfif trim(url.itemUoMId) neq "">

	<cfquery name="getItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemUoM
		WHERE  ItemUoMId = '#url.ItemUomId#'				
	</cfquery>

<cfelse>

	<cfquery name="getItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemUoM
		WHERE  ItemNo = '#url.ItemNo#'				
		AND    UoM = '#url.uom#'
	</cfquery>

	<cfset url.itemUoMId = getItem.itemUoMId>
	
</cfif>	

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Item
	WHERE  ItemNo = '#getItem.ItemNo#'				
</cfquery>	

<cfoutput>
<script> 

    document.getElementById('itemno').value          = '#item.ItemNo#'	
	
	document.getElementById('itemdescription').value = '#item.Itemdescription#'	
	
	document.getElementById('itemuom').value         = '#getItem.UoM#'	
	
	document.getElementById('uomname').value         = '#getItem.UoMDescription#'	
	
	document.getElementById('receiptitem').value     = '#item.Itemdescription#'	
	
	document.getElementById('receiptitem').focus()	
</script>
</cfoutput>

<cfquery name="warehouse" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Warehouse
	WHERE    Warehouse = '#url.warehouse#'	
</cfquery>	

<!--- Hanno : warehouse geo location (fuel) to determine 
    the correct batch price for receipt --->

<cfif warehouse.locationid neq "">
	
	<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      ItemVendorOffer
		WHERE     ItemNo        = '#getItem.itemno#'
		AND       UoM           = '#getItem.uom#' 
		AND       Mission       = '#purchase.mission#' 
		AND       OrgUnitVendor = '#purchase.orgunitvendor#' 
		AND       LocationId    = '#warehouse.locationid#'
		AND       DateEffective <= GETDATE()
		ORDER BY  DateEffective DESC
	</cfquery>	
	
	<cfquery name="Currency" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     CurrencyMission
		WHERE    Mission = '#Purchase.Mission#' 
	</cfquery>
	
	<cfif currency.recordcount eq "0">

	    <cfquery name="Currency" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Currency
			WHERE   EnableProcurement = '1'
		</cfquery>
	
	</cfif>
	
	<cfset itm = 0>
	
	<cfloop query="currency">
	
	 <cfif currency eq get.Currency>
	    <cfset set = itm>
	 <cfelse>
	    <cfset itm = itm+1>	
	 </cfif>
	 	
	</cfloop>
			
	<cfif get.recordcount eq "1" and get.itemprice neq "0">
			
		<!--- set the price and set the currency --->
		
		<cfoutput>
		
		<script>		 
		  document.getElementById('receiptprice').value     = '#get.itemprice#'			   
		  document.getElementById('currency').selectedIndex = #set#
		  calc(document.getElementById('receiptquantity').value,'#get.itemprice#',document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value)
		</script>
		
		</cfoutput>
	
	</cfif>

</cfif>


