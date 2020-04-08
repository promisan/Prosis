<cf_tl id = "This combination of Item No., UoM and Vendor already exists!" class="message" var = "vAlready">
<cf_tl id = "Vendor updated!" class="message" var = "vUpdated">



<cfif url.uom neq "" and url.orgunitvendor neq "">

	<cfquery name="Update" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				UPDATE	ItemVendor
				SET		<cfif trim(form.vendoritemno) neq "">VendorItemNo = '#form.vendoritemno#',</cfif>
						<cfif trim(form.vendoritemdescription) neq "">VendorItemDescription = '#form.vendoritemdescription#',</cfif>
						Preferred = #form.preferred#
				WHERE	ItemNo = '#url.itemno#'
				AND		UoM = '#url.uom#'
				AND		OrgUnitVendor = #url.orgunitvendor#
	</cfquery>

	<cfoutput>
		<script>		
			ColdFusion.navigate('#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/VendorListing.cfm?id=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#','divVendorListing');
			try { ProsisUI.closeWindow('mydialog') } catch(e) {}
		</script>
	</cfoutput>
	
<cfelse>

	<cfquery name="Validate" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT 	COUNT(*) AS Total
				FROM	ItemVendor
				WHERE	ItemNo = '#url.itemno#'
				AND		UoM = '#form.uom#'
				AND		OrgUnitVendor = #form.referenceorgunit#
	</cfquery>
	
	<cfif Validate.Total eq 0>

		<cfquery name="Insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				INSERT INTO ItemVendor
					(
						ItemNo,
						UoM,
						OrgUnitVendor,
						<cfif trim(form.vendoritemno) neq "">VendorItemNo,</cfif>
						<cfif trim(form.vendoritemdescription) neq "">VendorItemDescription,</cfif>
						Preferred,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.itemno#',
						'#form.uom#',
						#form.referenceorgunit#,
						<cfif trim(form.vendoritemno) neq "">'#form.vendoritemno#',</cfif>
						<cfif trim(form.vendoritemdescription) neq "">'#form.vendoritemdescription#',</cfif>
						#form.preferred#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
		<cfoutput>
			<script>
				ColdFusion.navigate("#SESSION.root#/Warehouse/Maintenance/ItemMaster/Vendors/vendorOfferEditPerDate.cfm?offerid=&itemno=#url.itemno#&mission=#url.mission#&uom=#form.uom#&orgunitvendor=#form.referenceorgunit#&dateEffective=&ts="+new Date().getTime(),'mydialog'); 
			</script>
		</cfoutput>
	
	<cfelse>
		<cfoutput>
		<script>		
			alert('#vAlready#');
		</script>
		</cfoutput>	
	
	</cfif>

</cfif>

