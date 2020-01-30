

<cfparam name="Form.DistributionAverage" default="0">
<cfparam name="url.refreshstrap"         default="0">

<cfquery name="warehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse
	WHERE  Warehouse = '#URL.warehouse#'		
</cfquery>

<cf_tl id="Authorised capacity may not exceed the Physical capacity." var ="msg1">
<cf_tl id="Item UOM combination already exists for this location. Operation not allowed" var ="msg2">


<cfif Form.HighestStock neq "0" and Form.MaximumStock neq "0">
	
	<cfif Form.HighestStock lt Form.MaximumStock>
			<cfoutput>
			<script>
				alert("#msg1#")
			</script>
			</cfoutput>
			
			<cfabort>
	
	</cfif>

</cfif>

<cfif url.drillid eq "">

		<cfparam name="Form.UoM" default="">
		
		<cfif form.UoM eq "">
		
			<script language="JavaScript">
				alert("UoM was not defined for the selected product")
			</script>
			<cfabort>
		
		</cfif>
			
		<cfquery name="Check" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">				 
			 SELECT * 
			 FROM   ItemWarehouseLocation
			 WHERE  Warehouse  = '#url.Warehouse#'
			 AND    Location   = '#url.Location#'
		     AND    ItemNo     = '#Form.ItemNo#'
			 AND    UoM        = '#Form.UoM#' 
	    </cfquery>	 	 
		
		<cfif check.recordcount eq "1">
		
			<cfoutput>
			<script>
				alert("#msg2#")
			</script>
			</cfoutput>
			
			<cfabort>
		
		<cfelse>		
	
			<cftransaction>
			
		        <cf_assignid>
				
				<cfquery name="Check" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		 
					 SELECT * 
					 FROM   ItemUoMMission
					 WHERE  Mission   = '#warehouse.Mission#'			
				     AND    ItemNo    = '#Form.ItemNo#'
					 AND    UoM       = '#Form.UoM#'
		        </cfquery>	 
				
				<!--- record for the mission --->
				
				<cfif check.recordcount eq "0">
				
					<cfquery name="Add" 
					     datasource="AppsMaterials" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">		 
						 INSERT INTO  ItemUoMMission
							 (Mission,					 
							  ItemNo,
							  UoM, 						 				
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
						 VALUES ( '#warehouse.Mission#',	
								  '#form.ItemNo#',
								  '#form.UoM#',					 												 
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
					</cfquery>	
				
				</cfif>		
				
				<!--- enable for the warehouse --->
										
				<cfquery name="Check" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">		 
					 SELECT * 
					 FROM   ItemWarehouse
					 WHERE  Warehouse  = '#url.Warehouse#'			
				     AND    ItemNo    = '#Form.ItemNo#'
					 AND    UoM       = '#Form.UoM#'
		        </cfquery>	 	
				
				<cfif check.recordcount eq "0">
				
					<cfquery name="Add" 
					     datasource="AppsMaterials" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">		 
						 INSERT INTO ItemWarehouse
							 (Warehouse,					 
							  ItemNo,
							  UoM, 
							  MinimumStock, 
							  MaximumStock, 					
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
						 VALUES (		 
							  '#url.Warehouse#',	
							  '#form.ItemNo#',
							  '#form.UoM#',					 			
							  '#Form.MinimumStock#',
							  '#Form.MaximumStock#',					 
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					</cfquery>	
				
				</cfif>		
				
				<!--- enable for the location --->		
				
				<cfparam name="Form.StrappingIncrementMode" default="Strapping">	
			 	 
				<cfquery name="Add" 
				     datasource="AppsMaterials" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		 
					 INSERT INTO ItemWarehouseLocation
						 (Warehouse,
						  Location,
						  ItemNo,
						  UoM, 
						  ItemLocationId, 					  
						  DistributionDays, 
						  SafetyDays,
						  LowestStock, 
						  AveragePeriod,
						  MinimumStock, 
						  SafetyStock,
						  MaximumStock, 
						  HighestStock,
						  PickingOrder,
						  ItemLocationMemo,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
					 VALUES (		 
						  '#url.Warehouse#',	
						  '#url.Location#',
						  '#form.ItemNo#',
						  '#form.UoM#',
						  '#rowguid#',
						  '#Form.DistributionDays#',
						  '#Form.SafetyDays#',
						  '#Form.LowestStock#',
						  '#Form.AveragePeriod#',
						  '#Form.MinimumStock#',
						  '#Form.SafetyStock#',
						  '#Form.MaximumStock#',
						  '#Form.HighestStock#',
						  '#Form.PickingOrder#',
						  '#Form.ItemLocationMemo#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>	
				
				<cfset url.itemno = form.itemno>
				<cfset url.uom = form.uom>
				<!--- also populate the transactions for this warehouse location in a default fashion --->
				<cfinclude template="ItemWarehouseLocationDefaultValues.cfm">
			
			</cftransaction>
						
			<cfoutput>
			
			<script>			
			  try {
				 window.dialogArguments.opener.ColdFusion.navigate('LocationItemUoM/ListingData.cfm?mission=#warehouse.mission#&warehouse=#URL.warehouse#&location=#url.location#','contentbox1')					
				 } catch(e) {}
			</script>
			
			</cfoutput>
			
		
		</cfif>
	 
<cfelse>

	<cftransaction>

	<cfparam name="Form.ReadingEnabled" default="0">
	
	<cfparam name="Form.StrappingIncrementMode" default="Strapping">	

	<cfquery name="Update" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 UPDATE ItemWarehouseLocation
			 SET    LowestStock             = '#Form.LowestStock#', 
				    DistributionDays        = '#Form.DistributionDays#', 
				    SafetyDays              = '#Form.SafetyDays#',
					AveragePeriod           = '#Form.AveragePeriod#',
				    DistributionAverage     = '#form.DistributionAverage#',
				    MinimumStock            = '#Form.MinimumStock#', 
					SafetyStock             = '#Form.SafetyStock#',
				    MaximumStock            = '#Form.MaximumStock#', 
				    HighestStock            = '#Form.HighestStock#',
				    PickingOrder            = '#Form.PickingOrder#',
					ItemLocationMemo        = '#Form.ItemLocationMemo#',
				    ReadingEnabled          = '#Form.ReadingEnabled#'
			 WHERE  ItemLocationId      = '#url.drillid#'	 			
	</cfquery>	
	
	
	</cftransaction>	
		
	<cfoutput>
	
	<script>	   
	   try {				
		opener.applyfilter('1','','#url.drillid#') } catch(e) {}    			
	</script>	
	</cfoutput>
		
</cfif>

	
<cfif url.drillid eq "">
		
	<cfquery name="getItem" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      ItemWarehouseLocation 		
			 WHERE     ItemLocationId = '#rowguid#'		 
	</cfquery>
				
	<cfoutput>
	<script>	 
	  if (opener.document.getElementById('menu4')) {
	    opener.document.getElementById('menu4').click()
	  } else {
	    try { opener.applyfilter('1','','content') } catch(e) {}
	  }	 
	  ColdFusion.navigate('ItemUoMEditForm.cfm?drillid=#rowguid#&warehouse=#url.warehouse#&location=#url.location#','item')
	  ColdFusion.navigate('ItemUoMMenu.cfm?drillid=#url.drillid#&warehouse=#url.warehouse#&location=#url.location#&itemno=#getitem.itemno#&uom=#getitem.uom#','details')
	</script>
	</cfoutput>

<cfelse>
	 
	<font face="Calibri" color="gray"><cf_tl id="Saved"></font>
		
	<cfif url.refreshstrap eq "1">
	
		<cfoutput>
		
			<cfquery name="getItem" 
				     datasource="AppsMaterials" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		 
					 SELECT    *
					 FROM      ItemWarehouseLocation 		
					 WHERE     ItemLocationId = '#url.drillid#'		 
			</cfquery>
			
			
			<cfquery name="get" 
				     datasource="AppsMaterials" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">		 
					 SELECT    *
					 FROM      WarehouseLocation 		
					 WHERE     Warehouse = '#getItem.Warehouse#'	
					 AND       Location  = '#getItem.Location#'	 
			</cfquery>
			
			<cfif trim(get.StorageWidth) neq "" and trim(get.StorageHeight) neq "" and lcase(get.StorageShape) neq "n/a">
		
			<script>
				ColdFusion.navigate('../LocationItemStrapping/StrappingRefresh.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#getItem.ItemNo#&uoM=#getItem.UoM#','contentbox2');
			</script>
			
			</cfif>
			
		</cfoutput>
		
	</cfif>
	
</cfif>	



