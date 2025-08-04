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
<cfparam name="URL.Warehouse" default="">
<cfparam name="URL.mode" 	  default="">

<cfparam name="Attributes.Warehouse"  default="#URL.Warehouse#">
<cfparam name="Attributes.Mode" 	  default="#URL.mode#">


<cfif Attributes.Warehouse neq "" and Attributes.Mode neq "">

	<cfset tableName = "StockTransaction#Attributes.Warehouse#_#Attributes.Mode#"> 

	<cfif Attributes.mode eq "initial">
		
		<cfquery name="GetSetting"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT PreparationMode
			FROM   WarehouseTransaction
			WHERE  TransactionType = '9'
			AND    Warehouse = '#Attributes.warehouse#'
			
		</cfquery>
		<cfif GetSetting.recordcount gt 0>
		
			<!---
			PreparationMode: 
				0 = default
				1 = warehouse : Temp table handled at WarehouseLevel, so users can colaborate
				2 = user : Temp table handled at UserLevel, so transactions go by individual
			--->
			<cfif GetSetting.PreparationMode eq '2'>
				<cfset tableName = "StockTransaction#Attributes.Warehouse#_#Attributes.mode#_#SESSION.acc#"> 
			</cfif>
			
		</cfif>
		
	</cfif>

	<cfset caller.tableName = tableName>
	
</cfif>

