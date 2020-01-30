
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

<cfinclude template="LocationEdit.cfm">