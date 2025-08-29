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
<cfparam name="url.selected" default="">

<cfoutput>

<cfif url.warehouseto eq "">

	<script>	 
	 document.getElementById('locationrow').className = 'hide labelmedium'	
	 stocktransfer('n','#url.systemfunctionid#');
	</script>

<cfelse>

	<script>
	 document.getElementById('locationrow').className = 'regular labelmedium'	
	 stocktransfer('n','#url.systemfunctionid#');
	</script>
		 
</cfif>
 		
    <cfquery name="qWarehouse"
        datasource="AppsMaterials"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
             SELECT ModeSetItem, LocationReceipt
             FROM   Warehouse
             WHERE  Warehouse = '#url.warehouseto#'
     </cfquery>    
                    
     <cfquery name="Location"
         datasource="AppsMaterials"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
             SELECT *
             FROM  WarehouseLocation D
             WHERE Warehouse = '#url.warehouseto#' 
             <!--- AND   Location != '#url.Location#' --->
             AND   Operational = 1
	         
		 
		      <!--- Note Hanno only location that have the same item as the transfer item also defined in its stock,
	              maybe that is a bit too strong 23/3/2023 : Hanno --->
				  
             <cfif qWarehouse.ModeSetItem eq "Location">
                 AND    Location IN (SELECT Location
					                 FROM   ItemWarehouseLocation
					                 WHERE  Warehouse = D.Warehouse
					                 AND    Location  = D.Location)
             </cfif>

     </cfquery>	 
	
					
	 <!--- we preset all locations in our table here --->
	
	 <cfset locto = Location.Location>
		  
	 <!--- preset values in our table and change interface to show only quantity, no support for conversion --->
	 		 	   
	 <select name  = "locationto" 
	         id    = "locationto" 
			 class = "regularxxl"
			 style = "width:auto;border:0px;border-right:1px solid silver;font-size:16px;background-color:transparent"
	         onChange = "ptoken.navigate('#session.root#/warehouse/application/stock/transfer/applyLocation.cfm?systemfunctionid=#url.systemfunctionid#&whs=#url.whs#&warehouseto=#url.warehouseto#&locationto='+this.value,'setvalue');">		 
						
		<cfloop query="Location">
			
			<cfif qWarehouse.LocationReceipt eq Location>
				
				<cfset locto = location>
					
			<cfelseif url.selected eq Location>
					
				<cfset locto = location>
					
			</cfif>					
					
			<option value="#Location#" <cfif qWarehouse.LocationReceipt eq Location>selected<cfelse><cfif url.selected eq Location>selected</cfif></cfif>>#StorageCode# <cfif description neq StorageCode>#Description#</cfif></option>
		</cfloop>
		
	 </select>	
	
	<cfquery name="Update"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#		
			SET    TransferWarehouse = '#url.warehouseto#',
    			   TransferLocation  = '#locto#'							
  	 </cfquery>
	
</cfoutput> 