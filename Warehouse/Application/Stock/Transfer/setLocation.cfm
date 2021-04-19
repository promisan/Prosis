
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
	              maybe that is a bit too strong --->
				  
             <cfif qWarehouse.ModeSetItem eq "Location">
                 AND    Location IN (SELECT Location
					                 FROM   ItemWarehouseLocation
					                 WHERE  Warehouse = D.Warehouse
					                 AND    Location  = D.Location)
             </cfif>
     </cfquery>	  
		
	 <!--- we preset all locations in our table here --->
		 
	 <cfquery name="Update"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#		
			SET    TransferWarehouse = '#url.warehouseto#',
    			   TransferLocation  = '#Location.Location#'							
  	 </cfquery>
  
	 <!--- preset values in our table and change interface to show only quantity, no support for conversion --->
	 		 	   
	 <select name  = "locationto" 
	         id    = "locationto" 
			 class = "regularxxl"
			 style = "width:auto;border:0px;border-right:1px solid silver;font-size:16px;background-color:transparent"
	         onChange = "ptoken.navigate('#session.root#/warehouse/application/stock/transfer/applyLocation.cfm?systemfunctionid=#url.systemfunctionid#&whs=#url.whs#&warehouseto=#url.warehouseto#&locationto='+this.value,'setvalue');">		 
						
		<cfloop query="Location">
			<option value="#Location#" <cfif qWarehouse.LocationReceipt eq Location>selected<cfelse><cfif url.selected eq Location>selected</cfif></cfif>>#StorageCode# #Description#</option>
		</cfloop>
		
	 </select>	
	
</cfoutput> 