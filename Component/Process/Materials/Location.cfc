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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="LocationTransfer"
             access="public"
             returntype="any"
             displayname="Transaction Location">
		
		<cfargument name="FromWarehouse"   type="string"  required="true"   default="">
		<cfargument name="FromLocation"    type="string"  required="true"   default="">
		<cfargument name="ToWarehouse"     type="string"  required="true"   default="">
		<cfargument name="ToLocation"      type="string"  required="true"   default="">
		<cfargument name="ItemNo"          type="string"  required="true"   default="">
		<cfargument name="UoM"             type="string"  required="true"   default="">
		<cfargument name="TransactionLot"  type="string"  required="true"   default="">
		
		<!--- get stock for that location per item/uom/
		
		--- if location is default location in dbo.Warehouse we do not allow
		--- Create a new location and inherit all data from WarehouseLocation AND ItemWarehouseLocation associate the ParentStorageId of the old location
		--- set old location = operational = 0
		--- then define current stock for the OLD location per item/uom/productionLot and create -/- and +/+ to the new location, to reduce any stock levels to 0
				
		<cfquery name="getStock" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProductionLot
			WHERE     Mission        = '#Mission#' 			
			AND       TransactionLot = '#TransactionLot#'			
		</cfquery>		
		
		PENDING hanno, see whiteboard 
		
		--->
						
		<cfreturn getLot.recordcount>
		
	</cffunction>		
		
	
</cfcomponent>	
