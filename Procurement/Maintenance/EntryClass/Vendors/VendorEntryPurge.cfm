
<cftransaction>
	<cfquery name="DeleteVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 DELETE FROM Ref_EntryClassVendor
			 WHERE  EntryClass    = '#URL.entryClass#' 
			 AND    OrgUnitVendor = '#URL.vendor#'
	</cfquery>
			
	<cfquery name="UpdateItemVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ItemMasterVendor
	     SET
		 	Operational = 0
		 WHERE OrgUnitVendor = '#url.vendor#'
		 AND Code IN (SELECT Code FROM ItemMaster WHERE	EntryClass = '#url.entryClass#')
	</cfquery>
			
</cftransaction>

<cfoutput>  	
	<script>
		ptoken.navigate('Vendors/VendorEntry.cfm?entryclass=#url.entryclass#&vendor=&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1')
	</script>
</cfoutput>	
