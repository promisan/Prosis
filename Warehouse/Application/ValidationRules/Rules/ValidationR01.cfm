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
<!--- -----Rule ItemLocation :
      ---Ensure that location has never more requests than it can hold ------------ --->
<!--- ----------------------------------------------------------------------------- --->

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   ItemWarehouseLocation
		   WHERE  ItemLocationId = '#attributes.sourceid#'		  
	</cfquery>		

<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   WarehouseCart
		   WHERE  ItemNo          = '#get.ItemNo#' 
		   AND    UoM             = '#get.UoM#'		   
		   AND    ShipToWarehouse = '#get.Warehouse#'
		   AND    ShipToLocation  = '#get.Location#'
</cfquery>				
						
<cfif check.recordcount gte "0">
						
	<cfquery name="Total" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    SUM(Quantity) as Quantity
		FROM      WarehouseCart
		 WHERE    ItemNo          = '#get.ItemNo#' 
		   AND    UoM             = '#get.UoM#'		   
		   AND    ShipToWarehouse = '#get.Warehouse#'
		   AND    ShipToLocation  = '#get.Location#' 
		   <cfif attributes.conditionid neq "">
		   AND   CartId != '#attributes.ConditionId#'		   
		   </cfif>
	</cfquery>			
								
	<cfif Total.quantity eq "">
	 	 <cfset totalcount = attributes.sourceValue>
	<cfelse>
	  	 <cfset totalcount = attributes.sourceValue+Total.quantity>
	</cfif>
	
	<cfif get.MaximumStock lt totalcount and get.MaximumStock gt "0">
				
		 <cf_ApplyBusinessRuleResult
		    ValidationId     = "#rowguid#"
		    Datasource       = "#attributes.datasource#"
			Source           = "#TriggerGroup#"
			SourceId         = "#attributes.sourceid#"
			BusinessRule     = "#Code#"	
			Result           = "9"			
			ValidationMemo   = "Requested quantity exceeds the maximum stock #get.MaximumStock# for this location. Operation not allowed">
					
	<cfelse>
		
		 <cf_ApplyBusinessRuleResult
		    ValidationId     = "#rowguid#"
		    Datasource       = "#attributes.datasource#"
			Source           = "#TriggerGroup#"
			SourceId         = "#attributes.sourceid#"
			BusinessRule     = "#Code#"	
			Result           = "1"			
			ValidationMemo   = "">
						
	</cfif>
			
</cfif>

<!--- ------------------------------ --->
<!--- --------- end of query-------- --->
<!--- ------------------------------ --->
