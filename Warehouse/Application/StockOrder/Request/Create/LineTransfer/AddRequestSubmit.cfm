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

<cfparam name="form.Quantity"        default="0">

<cfif url.scope eq "backoffice">
	<cfset warehouseto = url.warehouse>
<cfelse>
	<cfparam name="form.WarehouseTo"     default="#url.warehouse#">
	<cfset warehouseto = form.warehouseTo>
</cfif>	

<cfparam name="form.ShipToLocation"  default="">

<cfoutput>
	<cfif form.shipToLocation eq "">
			<cf_tl id ="Please select a storage location" var ="1">
			<script>
				alert('#lt_text#');
			</script>
			<cfabort>
	</cfif>		
</cfoutput>

<cfif url.warehouse neq form.warehouseTo>
	 <cfset url.refresh = "1">
</cfif>

<cfset form.quantity = replace(form.quantity, ",", "","ALL")>

<cfif form.quantity neq 0 and form.quantity neq "">

	<cfquery name="getCost" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	ItemUoM
			WHERE	ItemNo = '#Form.ItemNo#'
			AND		UoM    = '#Form.UoM#'
	</cfquery>
	
	<cfif getCost.StandardCost eq "">
		<cfset cost = "0">
	<cfelse>
		<cfset cost = getCost.StandardCost> 
	</cfif>
		
	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   WarehouseLocation
		   WHERE  Warehouse = '#Form.ShipToWarehouse#'
		   AND    Location  = '#Form.ShipToLocation#'
	</cfquery>
	
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   WarehouseCart
		   WHERE  Warehouse       = '#warehouseTo#'   <!--- facility to which the request is directed --->
		   AND    ItemNo          = '#Form.ItemNo#' 
		   AND    UoM             = '#Form.UoM#'
		   AND    UserAccount     = '#SESSION.acc#' 
		   AND    ShipToWarehouse = '#Form.ShipToWarehouse#'
		   AND    ShipToLocation  = '#Form.ShipToLocation#'
	</cfquery>
	
	<cfif Check.RecordCount eq 0>
	
			<cfquery name="insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO WarehouseCart (
						Warehouse,
						UserAccount,
						ItemNo,
						UoM,
						ShipToWarehouse,
						ShipToLocation,
						ShipToLocationId,
						Quantity,
						CostPrice )
				VALUES ('#warehouseTo#',
						'#SESSION.acc#',
						'#Form.itemno#',
						'#Form.UoM#',
						'#Form.ShipToWarehouse#',
						'#Form.ShipToLocation#',
						<cfif get.LocationId neq "">
						'#get.LocationId#',
						<cfelse>
						NULL,
						</cfif>
						#Form.Quantity#,
						#cost# )
			</cfquery>
			
			<cfoutput>
				<script>
					submitaddrequest('#url.mission#','#url.warehouse#','#url.refresh#');
				</script>
			</cfoutput>
	
	<cfelse>
	
			<cfquery name="update" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  WarehouseCart
				SET    Quantity = Quantity + #Form.Quantity#
				WHERE  Warehouse       = '#warehouseTo#'
				AND    ItemNo          = '#Form.ItemNo#' 
				AND    UoM             = '#Form.UoM#'
				AND    UserAccount     = '#SESSION.acc#' 
				AND    ShipToWarehouse = '#Form.ShipToWarehouse#'
				AND    ShipToLocation  = '#Form.ShipToLocation#'
			</cfquery>
			
			<cfoutput>
				<script>
					submitaddrequest('#url.mission#','#url.warehouse#','#url.refresh#');
				</script>
			</cfoutput>
	
	</cfif>

<cfelse>

	<cfoutput>
		<cf_tl id ="Please, enter a valid numeric greater than 0 numeric quantity." var ="1">
		<script>
			alert('#lt_text#');
		</script>
	</cfoutput>
	
	<cfoutput>
			<script>
				submitaddrequest('#url.mission#','#url.warehouse#','#url.refresh#');
			</script>
	</cfoutput>
	
</cfif>