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

<cfquery name="warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse
	WHERE  Warehouse = '#URL.warehouse#'		
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WarehouseLocation
	WHERE  Warehouse = '#URL.Warehouse#'	
	AND    Location  = '#URL.Location#'
</cfquery>

<table width="100%" height="99%" cellspacing="0" cellpadding="0" align="center">

<cfoutput>

<tr><td class="line"></td></tr>

<tr><td height="20">

	<table cellspacing="0" cellpadding="0" align="center">
		
	<tr>

	<cfset wd = "64">
	<cfset ht = "64">

	<cfset itm = 1>  
	
	<cf_tl id="Stock On Hand" var="1">
	
	<cf_menutab item  = "1" 
       iconsrc    = "Warehouse.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   class      = "highlight1"
	   name       = "#lt_text#"
	   source     = "ItemUoMHistory.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">				  	   
	 
	 <cfif trim(get.StorageWidth) neq "" and trim(get.StorageHeight) neq "" and lcase(get.StorageShape) neq "n/a">
	 
		 <cfset itm = itm+1> 
		 <cf_tl id="Strapping Table" var="1">
		 <cf_menutab item   = "#itm#" 
		   targetitem = "2"
	       iconsrc    = "Conversion.png" 
		   iconwidth  = "#wd#" 
		   iconheight = "#ht#" 
		   name       = "#lt_text#"
		   source     = "../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">
		   
	  </cfif>
		  	   
	 <cfset itm = itm+1>    
	 <cf_tl id="Acceptable Losses" var="1">
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "Losses.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../LocationItemLosses/AcceptableLosses.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">	  
	    
	 <cfset itm = itm+1>    
	 <cf_tl id="Transactions" var="1">
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "Transaction.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../LocationItemTransaction/TransactionClearance.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">
	 
	 <cfset itm = itm+1>    
	 <cf_tl id="Movement UoM" var="1">
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "UoM.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../LocationUoM/LocationUoM.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">
	 
	 <cfset itm = itm+1>    
	 <cf_tl id="Scheduled Requests" var="1">
	 <cf_menutab item   = "#itm#" 
	   targetitem = "2"
       iconsrc    = "Scheduled-Requests.png" 
	   iconwidth  = "#wd#" 
	   iconheight = "#ht#" 
	   name       = "#lt_text#"
	   source     = "../LocationItemRequest/Request.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#">
	   
	  <cfif get.LocationId neq "">
			  	  
		<cfquery name="Geo" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		 
				 SELECT    *
				 FROM      Location
				 WHERE     Location = '#get.Locationid#'		 		
		</cfquery>	
			   
	   <cfset itm = itm+1>    
	   		   	   
		   <cf_menutab item   = "#itm#" 
		       targetitem = "2"
		       iconsrc    = "Logos/Map.png" 
			   iconwidth  = "#wd#" 
			   iconheight = "#ht#" 
			   name       = "#Geo.LocationName# ?"
			   source     = "javascript:showmap('#get.LocationId#')">	
	   
	   </cfif>
	   		   		  
   </tr>
   </table>

</tr><tr><td class="line"></td></tr>

</cfoutput>

<tr><td height="5"></td></tr>
<tr><td height="100%" valign="top">
   <table width="98%" align="center" height="100%">
	<cf_menucontainer item="1" class="regular">
		 <cfinclude template="ItemUoMHistory.cfm"> 
 	</cf_menucontainer>	
	<cf_menucontainer item="2" class="hide">	 		
   </table>	
</td></tr>

</table>
