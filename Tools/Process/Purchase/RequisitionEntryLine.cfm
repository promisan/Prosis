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

<!--- 16/7/2013 : currently this method will mostly work for replenishment of stock and some basic
requisition that do not need more details --->

<cfparam name="Attributes.DataSource"               default="AppsPurchase">
<cfparam name="Attributes.Mission"                  default="Promisan">
<cfparam name="Attributes.Period"                   default="">
<cfparam name="Attributes.OrgUnit"                  default="">
<cfparam name="Attributes.PersonNo"                 default="">
<cfparam name="Attributes.ItemMaster"               default="">
<cfparam name="Attributes.RequestDescription"       default="">
<cfparam name="Attributes.RequestType"              default="Regular">

<cfparam name="Attributes.Remarks"                  default="">
<cfparam name="Attributes.RequestDate"              default="#dateformat(now(),client.dateformatshow)#">
<cfparam name="Attributes.RequestDue"               default="#dateformat(now()+21,client.dateformatshow)#">
<cfparam name="Attributes.RequestQuantity"          default="1">
<cfparam name="Attributes.QuantityUoM"              default="">
<cfparam name="Attributes.RequestCurrency"          default="#Application.BaseCurrency#">
<cfparam name="Attributes.RequestCostPrice"         default="0">
<cfparam name="Attributes.RequestCurrencyPrice"     default="#Attributes.RequestCostPrice#">
<cfparam name="Attributes.ActionStatus"             default="1">  <!--- better to keep it like that --->
<cfparam name="Attributes.CaseNo"                   default="">
<cfparam name="Attributes.SourceNo"                 default="">

<!--- Program module --->
<cfparam name="Attributes.RequirementId"            default="">

<!--- workorder module --->
<cfparam name="Attributes.WorkOrderId"              default="">
<cfparam name="Attributes.WorkOrderLine"            default="0">
<cfparam name="Attributes.WorkOrderItemId"          default="">

<!--- Materials integration --->
<cfparam name="Attributes.Warehouse"                default="">
<cfparam name="Attributes.WarehouseItemNo"          default="">
<cfparam name="Attributes.WarehouseUoM"             default="">

<cfif Attributes.Mission eq "">
									
		<cf_message  message = "No entity defined">
		<cfabort>
	 
</cfif>

<!--- set dates --->

<CF_DateConvert Value="#Attributes.RequestDate#">
<cfset reqdte = dateValue>
<CF_DateConvert Value="#Attributes.RequestDue#">
<cfset duedte = dateValue>

<cfif Attributes.Period eq "">

		<cfquery name="getPeriod" 
			datasource="#Attributes.Datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization.dbo.Ref_MissionPeriod
				WHERE    Mission = '#attributes.Mission#'
				ORDER BY DefaultPeriod DESC				
		</cfquery>
		
		<cfset Attributes.Period = getPeriod.Period>
		
<cfelse>

	<cfquery name="getPeriod" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization.dbo.Ref_MissionPeriod
				WHERE    Mission = '#attributes.Mission#'
				AND      Period  = '#attributes.Period#'						
	</cfquery>
	
	<cfif getPeriod.recordcount eq "0">
		<cf_message  message = "Invalid period">		
	</cfif>	

</cfif> 

<!--- validate the orgunit with the mission + period --->

<cfif Attributes.OrgUnit eq "">

	<!--- we take the tree unit --->
	
	<cfquery name="getOrganization" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Organization.dbo.Organization
			WHERE    Mission   = '#attributes.Mission#'
			AND      MandateNo = '#getPeriod.MandateNo#'						
			ORDER BY HierarchyCode
	</cfquery>	
	
	<cfset Attributes.OrgUnit = getOrganization.OrgUnit>
		
<cfelse>

	<cfquery name="getOrganization" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Organization.dbo.Organization
			WHERE    Mission   = '#attributes.Mission#'
			AND      MandateNo = '#getPeriod.MandateNo#'						
			AND      OrgUnit   = '#attributes.OrgUnit#'
	</cfquery>	
	
	<cfif getOrganization.recordcount eq "0">
		<cf_message message = "Invalid orgunit">		
	</cfif>		
	 
</cfif>

<cfif Attributes.ItemMaster eq "" and attributes.WarehouseItemNo eq "0">
									
	<cf_message  message = "No item master defined">
	<cfabort>
	 
</cfif>

<cfif attributes.WarehouseItemNo neq "">

	<cfset Attributes.RequestType = "Warehouse">	
	
	<cfquery name="getItem" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Materials.dbo.Item
			WHERE    ItemNo  = '#attributes.WarehouseItemNo#'						
	</cfquery>
	
	<cfif getItem.recordcount eq "0">
	
		<cf_message  message = "No warehouse item defined">
		<cfabort>
		
	<cfelse>
	
		<cfif attributes.requestDescription eq "">	
			<cfset attributes.requestDescription = getItem.ItemDescription>	
		</cfif>	
	
	</cfif>
		
	<cfset attributes.ItemMaster = getItem.ItemMaster>
				
	<cfif attributes.WarehouseUoM eq "">
									
		<cf_message  message = "No item uom defined">
		<cfabort>
	 
	</cfif>
		
</cfif>

<!--- create requisitionline --->

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Purchase.dbo.Ref_ParameterMission
			WHERE Mission = '#attributes.Mission#' 
		</cfquery>
		
		<cfif Parameter.recordcount eq "0" or Parameter.MissionPrefix eq "">
					
			<cf_message message="SerialNo could not be assigned">
			<cfabort>
		
		</cfif>
			
		<cfset No = Parameter.RequisitionNo+1>
		<cfif No lt 10000>
		     <cfset No = 10000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Purchase.dbo.Ref_ParameterMission
			SET    RequisitionNo = '#No#'
			WHERE  Mission = '#Attributes.Mission#' 
		</cfquery>
	
</cflock>

<cfquery name="Insert" 
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    INSERT INTO Purchase.dbo.RequisitionLine 
			(Mission,
			 RequisitionNo, 
			 Period,
			 OrgUnit,
			 PersonNo,
			 ItemMaster,
			 RequestDescription,
			 RequestType,
			 Warehouse,
			 WarehouseItemNo,
			 WarehouseUoM,
			 Remarks,
			 RequestDate,
			 RequestDue,
			 RequestQuantity,
			 QuantityUoM,
			 
			 RequestCurrency,
			 RequestCurrencyPrice,
			 RequestCostPrice,
			 RequestAmountBase,
			 
			 ActionStatus,
			 CaseNo,
			 SourceNo,
			 <cfif Attributes.RequirementId neq "">
			 RequirementId,
			 </cfif>
			 <cfif Attributes.WorkorderId neq "">
				 WorkOrderId,
				 WorkOrderLine,
				 <!---  
				 <cfif Attributes.RequirementId neq "">
				 RequirementId,
				 </cfif> --->
			 </cfif>
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	VALUES ('#attributes.Mission#',
	        '#Parameter.MissionPrefix#-#No#',
	        '#attributes.Period#',
			'#attributes.OrgUnit#',
		 	'#Attributes.PersonNo#',
		    '#Attributes.ItemMaster#',
		    '#Attributes.RequestDescription#',
		    '#Attributes.RequestType#',
		    '#Attributes.Warehouse#',
		    '#Attributes.WarehouseItemNo#',
		    '#Attributes.WarehouseUoM#',
		    '#Attributes.Remarks#',
		    #reqdte#,
		    #duedte#,
		    '#Attributes.RequestQuantity#',
		    '#Attributes.QuantityUoM#',		 
		    '#Attributes.RequestCurrency#',
		    '#Attributes.RequestCurrencyPrice#',
		    '#Attributes.RequestCostPrice#',		 
		    '#Attributes.RequestCostPrice*Attributes.RequestQuantity#',
		 
		    '#Attributes.ActionStatus#',
		    '#Attributes.CaseNo#',
		    '#Attributes.SourceNo#',
		    <cfif Attributes.RequirementId neq "">
		    '#Attributes.RequirementId#',
		    </cfif>
		    <cfif Attributes.WorkorderId neq "">
			 '#Attributes.WorkOrderId#',
			 '#Attributes.WorkOrderLine#',
			 <!---
			 <cfif Attributes.RequirementId neq "">
				 '#Attributes.RequirementId#',
			 </cfif> --->
		    </cfif>
		    '#SESSION.acc#', 
		    '#SESSION.last#', 
		    '#SESSION.first#') 
</cfquery>

