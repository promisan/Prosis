
<cfparam name="Form.Operational"    default="0">
<cfparam name="Form.Location"       default="">
<cfparam name="Form.LocationClass"  default="">
<cfparam name="Form.Description"    default="">
<cfparam name="Form.ListingOrder"   default="">

<cf_tl id = "Sorry, but #Form.Location# already exists" var = "msg"> 

<cfquery name="get" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   Warehouse
		WHERE  Warehouse = '#URL.Warehouse#'		
</cfquery>

<cfquery name="getAsset" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   AssetItem
		WHERE  Mission = '#get.Mission#'		
		AND    AssetBarCode = '#Form.StorageCode#'
</cfquery>


<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE WarehouseLocation
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 StorageCode         = '#trim(Form.StorageCode)#',
				 <cfif getAsset.recordcount gte "1">
					 AssetId       = '#getAsset.AssetId#', 
				 </cfif>
				 <cfif form.locationclass neq "">
				 LocationClass       = '#Form.LocationClass#',
				 <cfelse>
				 LocationClass       = NULL,				
				 </cfif>				 
				 ListingOrder        = '#Form.ListingOrder#'
		 WHERE Warehouse = '#URL.Warehouse#'
		 AND Location = '#URL.id2#'
	</cfquery>
		
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   WarehouseLocation
		WHERE  Warehouse = '#URL.Warehouse#'
		 AND   Location = '#form.location#'
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO WarehouseLocation
				         (Warehouse,
						 Location,
						 LocationClass,
						 StorageCode,
						 <cfif getAsset.recordcount gte "1">
							 AssetId, 
						 </cfif>
						 Description,					 
						 ListingOrder,
						 Operational,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			      VALUES ('#URL.Warehouse#',
				      '#trim(Form.Location)#',					  
					  '#Form.LocationClass#',
					  '#trim(Form.StorageCode)#',
					   <cfif getAsset.recordcount gte "1">
					   	  '#getAsset.AssetId#', 
				       </cfif>
					  '#Form.Description#',
					  '#Form.ListingOrder#',
			      	  '#Form.Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("#msg#")
		</cfoutput>
		</script>
				
	</cfif>		
			   	
</cfif>

<cfoutput>
  <script>
	 ColdFusion.navigate('#SESSION.root#/warehouse/maintenance/warehouselocation/List.cfm?systemfunctionid=#url.systemfunctionid#&Warehouse=#URL.Warehouse#&ID2=','f#url.warehouse#_list')	
  </script>	
</cfoutput>

