<cfquery name="getSearchResult" 
	datasource="AppsMaterials">
		SELECT TOP 100 	
				I.*
		FROM 	Item I
		WHERE	Operational = '1'
		<cfif url.warehouse eq "" and url.category eq "" and url.categoryItem eq "" and url.item eq "">
		AND 	1=0
		</cfif>
		<cfif url.warehouse neq "">
		AND 	I.ItemNo IN
				(
					SELECT 	ItemNo
					FROM 	ItemWarehouse
					WHERE 	Warehouse = '#url.warehouse#'
					AND 	Operational = '1'
				)
		</cfif>
		<cfif url.category neq "">
		AND 	I.Category = '#url.category#'
		</cfif>
		<cfif url.categoryItem neq "">
		AND 	I.categoryItem = '#url.categoryItem#'
		</cfif>
		<cfif url.item neq "">
		AND 	(I.ItemDescription LIKE '%#url.Item#%' OR I.ItemNo LIKE '%#url.Item#%')
		</cfif>
		ORDER BY ItemDescription ASC
</cfquery>

<cf_mobileSearchListingContainer recordCount="#getSearchResult.recordCount#" ElementsPerRow="3">
	
	<cfset vAnimation = "Yes">
	<cfif getSearchResult.recordCount gt 50>
		<cfset vAnimation = "No">
	</cfif>

    <cfoutput query="getSearchResult">
		
		<cf_mobileSearchListingItem id="#ItemNo#" searchText="#ItemNo# #ItemDescription# #Classification# #ItemColor# #ItemShipmentMode#" animation="#vAnimation#">

			<div class="col-lg-2">
				<cfset vName = itemNo>
				<cfinclude template="getPicture.cfm">
		        <img src="#vPhoto#" style="height:60px; width:60px; border:1px solid ##808080;">
		    </div>
		
			<div class="col-lg-10 clsElementListingItemText">
				<p style="font-size:180%; padding-top:10px;">[#ItemNo#] #ItemDescription#</p>
				<p style="font-size:90%; padding-top:5px;"><b><cf_tl id="Classification">:</b> #Classification# | <b><cf_tl id="Color">:</b> #ItemColor# | <b><cf_tl id="Shipment">:</b> #ItemShipmentMode#</p>
			</div>

		</cf_mobileSearchListingItem>
		
	</cfoutput>

</cf_mobileSearchListingContainer>