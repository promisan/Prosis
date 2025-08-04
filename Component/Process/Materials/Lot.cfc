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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="checklot"
             access="public"
             returntype="any"
             displayname="Verify Lots">
		
		<cfargument name="Mission"   type="string"  required="false"  default="">
		<cfargument name="TransactionLot"  type="string"  required="true"   default="0">
		
		<cfquery name="getLot" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProductionLot
			WHERE     Mission        = '#Mission#' 			
			AND       TransactionLot = '#TransactionLot#'			
		</cfquery>		
						
		<cfreturn getLot.recordcount>
		
	</cffunction>	
	
	<cffunction name="addlot"
             access="public"
             returntype="any"
             displayname="Verify Lots">
		
		<cfargument name="Datasource"          type="string"  required="true"  default="AppsMaterials">
		<cfargument name="Mission"             type="string"  required="true"  default="">
		<cfargument name="TransactionLot"      type="string"  required="true"   default="0">
		<cfargument name="TransactionLotDate"  type="string"  required="true"   default="#dateformat(now(),client.dateformatshow)#">
		<cfargument name="OrgUnitVendor"       type="string" default="0">
		
		 <cfset dateValue = "">
		<CF_DateConvert Value="#TransactionLotDate#">
		<cfset dte = dateValue>
		
		<cfquery name="getLot" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Materials.dbo.ProductionLot
			WHERE     Mission        = '#Mission#' 			
			AND       TransactionLot = '#TransactionLot#'			
		</cfquery>		
		
		<cfif getLot.recordcount eq "0">
		
			<cfquery name="addLot" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Materials.dbo.ProductionLot
				(Mission,TransactionLot,TransactionLotDate,OrgUnitVendor,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
					('#mission#',
					 '#TransactionLot#',
					 #dte#,
					 '#OrgUnitVendor#',
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#')			
			</cfquery>		
		
		</cfif>				
		
	</cffunction>	
	
</cfcomponent>	
