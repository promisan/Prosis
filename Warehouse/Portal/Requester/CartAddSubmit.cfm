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

<!--- define the request status --->

<cfparam name="url.storageid"  default="">
<cfparam name="url.mode"       default="standard">
  
<!--- set status as cleared --->  
<cfset status   = "2">

<cfquery name="Item" 
datasource= "AppsMaterials" 
username  = "#SESSION.login#" 
password  = "#SESSION.dbpw#">
    SELECT *
	FROM   Item I, ItemUoM U
	WHERE  I.ItemNo = U.ItemNo
	AND    I.ItemNo = '#URL.ItemNo#'
	AND    U.Uom    = '#URL.UoM#'
</cfquery>
  
<cfif Item.InitialApproval is 1>

    <cfset status   = "i">

  <cfelse>
  
	<cfquery name="Category" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_Category 
	  WHERE  Category = '#Item.Category#'
	</cfquery>  
  
   <CFIF Category.InitialReview is 1>
         <!--- enforces a review in legacy screen --->
         <cfset status   = "1">
    </CFIF>

</cfif>

<cfif url.mode eq "dialog" and url.storageid neq "">

    <!--- saving from a storage location for predefined items --->

	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT *
	    FROM   WarehouseLocation
		WHERE  Warehouse = '#url.shipto#'
		AND    StorageId = '#url.storageid#'
	</cfquery>  
	
	<!--- looping --->
	
	<cfquery name="warehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Warehouse
			WHERE    Warehouse  = '#url.shipto#'			
	</cfquery>			
	
	<cfquery name="Location" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     WarehouseLocation
			WHERE    Warehouse  = '#get.Warehouse#'
			<cfif get.Locationid eq "">
			AND      LocationId is NULL			
			<cfelse>
			AND      LocationId = '#get.Locationid#'							
			</cfif>
			<!--- AND      LocationClass = '#get.LocationClass#' --->
			AND      Operational = 1
	</cfquery>			
	
	<cfloop query="Location">
	
		<cfquery name="ItemUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ItemWarehouseLocation
				  WHERE  Warehouse = '#Warehouse#'
				  AND    Location  = '#Location#'
				  AND    ItemNo    = '#URL.ItemNo#'
				  AND    UoM       = '#URL.UoM#'
		</cfquery>  
	
	    <!--- this to be replaced by the generic 85 -146
		  validation code passing the itemlocationid --->
	
		<cfparam name="Form.requestquantity_#left(storageid,8)#" default="0">
	
		<cfset qty = evaluate("Form.requestquantity_#left(storageid,8)#")>
		
		<cfif qty gte "1">
		
		     <!--- apply the validation rule enabled for this object --->			
		
		     <cf_applyBusinessRule			 
			       datasource   = "appsMaterials" 
			       triggergroup = "itemlocation"
				   mission      = "#warehouse.mission#"
				   sourceid     = "#itemuom.ItemLocationId#"
				   sourcevalue  = "#qty#">
			
			 <cfif _ValidationStopper eq "yes">
			 	<cfabort>
			 </cfif>	 
					
		</cfif>
		
	</cfloop>			
		
	<!--- -------------------- --->
	<!--- ------- SAVING ----- --->
	<!--- -------------------- --->
	
	<cfloop query="Location">
	
		<!--- check if record exists already --->
		
		<cfquery name="Check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			   SELECT *
			   FROM   WarehouseCart
			   WHERE  Warehouse       = '#url.warehouse#'
			   AND    ItemNo          = '#URL.ItemNo#' 
			   AND    UoM             = '#URL.UoM#'
			   AND    UserAccount     = '#SESSION.acc#' 
			   AND    ShipToWarehouse = '#Warehouse#'
			   AND    ShipToLocation  = '#Location#'
		</cfquery>

		<cfset qty = evaluate("Form.requestquantity_#left(storageid,8)#")>
		
			<cfif qty gt "0">
						
				<cfif Check.recordCount eq "0">
				
				<cfquery name="getLocation" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM WarehouseLocation WHERE Warehouse = '#Warehouse#' AND Location = '#Location#'				
				 </cfquery>				
	
				<cfquery name="Insert" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO WarehouseCart (
							  Warehouse,
							  UserAccount, 
							  ItemNo,
							  UoM,
							  <cfif url.storageid neq "">					  
								  ShipToWarehouse,			
								  ShipToLocation,	
								  ShipToLocationId,  
							  </cfif>
							  Quantity,
							  CostPrice,
							  Status,
							  Remarks
							 )
					VALUES ('#url.warehouse#',
					        '#SESSION.acc#', 
					        '#url.itemno#', 
					        '#url.uom#',		
							 <cfif url.storageid neq "">						
								'#Warehouse#',
								'#Location#',		
								'#getLocation.LocationId#',			
							</cfif>						
							round(#qty#,#item.itemprecision#),
							'#Item.StandardCost#',
							'#Status#',
							'#url.remarks#')
				 </cfquery>
					
			<cfelse>
			
				<cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM   WarehouseCart					   
					WHERE  Warehouse       = '#url.warehouse#'
					AND    ItemNo          = '#URL.ItemNo#' 
					AND    UoM             = '#URL.UoM#' 
					AND    ShipToWarehouse = '#Warehouse#'	
					AND    ShipToLocation  = '#Location#'						
				</cfquery>
				
				<cfquery name="Update" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE WarehouseCart
					
					   SET Quantity        = Quantity + round(#qty#,#item.itemprecision#),
					       UserAccount     = '#SESSION.acc#',
						   Remarks         = '#url.remarks#'  
					   
					WHERE  Cartid          = '#get.CartId#'
						
					
				</cfquery>
					  
			</cfif>
							
			<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ItemWarehouseLocation
				WHERE  Warehouse  = '#warehouse#'	
				AND    Location   = '#location#'
				AND    ItemNo     = '#url.itemno#'
				AND    UoM        = '#url.uom#'			  
			</cfquery>
			
			<!--- -------------------------------------------- --->
			<!--- update the underlying screen for the amounts --->
			<!--- -------------------------------------------- --->
			
			<cfif get.recordcount eq "1">
			
				<cfoutput>
				<script>
					ColdFusion.navigate("../Stock/InquiryWarehouseGetCart.cfm?itemlocationid=#get.itemlocationid#",'draft_#get.itemlocationid#')
				</script>
				</cfoutput>
			
			</cfif>
			
		</cfif>
			
	</cfloop>
		
<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   WarehouseCart
		WHERE  Warehouse   = '#url.Warehouse#'
		AND    ItemNo      = '#URL.ItemNo#' 
		AND    UoM         = '#URL.UoM#'
		AND    UserAccount = '#SESSION.acc#' 
	</cfquery>
		
	<!--- -------------------- --->
	<!--- ------- SAVING ----- --->
	<!--- -------------------- --->

	<cfif Check.recordCount eq "0">
	
		<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO WarehouseCart(
					  Warehouse,
					  UserAccount, 
					  ItemNo,
					  UoM,					
					  Quantity,
					  CostPrice,
					  Status,
					  Remarks )
			VALUES ('#url.warehouse#',
			        '#SESSION.acc#', 
			        '#url.itemno#', 
			        '#url.uom#',					
					round(#url.quantity#,#item.itemprecision#),
					'#Item.StandardCost#',
					'#Status#',
					'#url.remarks#'
					)
		 </cfquery>
			
	<cfelse>
		
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseCart
			   SET Quantity    = Quantity + '#URL.Quantity#'
			WHERE  Warehouse   = '#url.warehouse#'
			AND    ItemNo      = '#URL.ItemNo#' 
			AND    UoM         = '#URL.UoM#' 			
			AND    UserAccount = '#SESSION.acc#' 
		</cfquery>
			  
	</cfif>		
	
</cfif>


<cfoutput>		

<cfif url.mode eq "dialog" and url.Storageid neq "">

    <script>		    	
		ColdFusion.Window.hide('dialogrequest')		
		ColdFusion.navigate('#session.root#/warehouse/portal/Stock/InquiryWarehouseGetCartTotal.cfm?shipto=#url.shipto#&storageid=#url.storageid#&itemno=#url.itemno#&uom=#url.uom#','draft_#url.shipto#_#url.storageid#_#url.itemno#_#url.uom#')							
	</script>

<cfelse>

	<!--- show cart --->
	<cfinclude template="Cart.cfm">  
	
</cfif>	

</cfoutput>
	

