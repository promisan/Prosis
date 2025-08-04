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

<cfparam name="Form.Operational"            default="0">
<cfparam name="Form.TransferAsIssue"        default="0">
<cfparam name="Form.EnableReference"        default="0">
<cfparam name="Form.Distribution"           default="0">
<cfparam name="Form.DistributionCustomerId" default="">
<cfparam name="Form.DistributionCustomerIdBilling" default="">

<cfif Form.OrgUnitOperator eq "">
    <!--- enforce internal --->
    <cfset bmode = "Internal">
	<cfset dmode = Form.Distribution>
 <cfelse>
 	<cfset bmode = "#Form.BillingMode#">
	<cfset dmode = "0">
</cfif>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE  WarehouseLocation
	SET     LocationClass = '#Form.LocationClass#',
		    <cfif form.locationid neq "">
			    LocationId    = '#Form.LocationId#',
		    <cfelse>
			    LocationId    = NULL,
		    </cfif>	
		    <cfif form.assetid eq "">
				AssetId       = NULL,
		    <cfelse>
				AssetId       = '#Form.AssetId#', 
		    </cfif>
			<cfif Form.OrgUnitOperator neq "">
			OrgUnitOperator   = '#Form.OrgUnitOperator#',
			<cfelse>
			OrgUnitOperator   = NULL,
			</cfif>
			EnableReference   = '#Form.EnableReference#',
			<cfif form.PickingOrder neq "">
			PickingOrder      = '#Form.PickingOrder#',
			<cfelse>
			PickingOrder      = NULL,
			</cfif>
		    ListingOrder      = '#Form.Listingorder#',
			TransferAsIssue   = '#Form.TransferAsIssue#',
			Operational       = '#Form.Operational#',		
			StorageCode       = '#trim(Form.StorageCode)#',
			Distribution      = '#dmode#',
			<cfif Form.OrgUnitOperator eq "">
				<cfif Form.DistributionCustomerId eq "" or dmode neq "2">
				DistributionCustomerId = NULL,
				<cfelse>
				DistributionCustomerId = '#Form.DistributionCustomerId#',
				</cfif>
			<cfelse>
				<cfif Form.DistributionCustomerIdBilling eq "" or bmode eq "Internal">
				DistributionCustomerId = NULL,
				<cfelse>
				DistributionCustomerId = '#Form.DistributionCustomerIdBilling#',
				</cfif>
			</cfif>	
			StorageShape      = '#Form.StorageShape#',
			BillingMode       = '#bmode#',
			StorageWidth      = <cfif trim(form.storageWidth) neq "">#Form.StorageWidth#<cfelse>null</cfif>,
			StorageHeight     = <cfif trim(form.StorageHeight) neq "">#Form.StorageHeight#<cfelse>null</cfif>,
			StorageDepth      = <cfif trim(form.StorageDepth) neq "">#Form.StorageDepth#<cfelse>null</cfif>,
			Description       = '#Form.LocationDescription#'	   
	WHERE   Warehouse = '#url.warehouse#'
	AND     Location = '#url.location#'	
</cfquery>

<cfif form.PickingOrder neq "">
	
	<cfquery name="set" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemWarehouseLocation
		SET    PickingOrder = '#Form.pickingOrder#'
		WHERE  Warehouse = '#url.warehouse#'
		AND    Location = '#url.location#'	
	</cfquery>

</cfif>

<cfinclude template="LocationEdit.cfm">

<!--- refreshing listing on the parent --->

<cfoutput>

	<script>
		opener.applyfilter('0','','#url.location#')
	</script>

</cfoutput>