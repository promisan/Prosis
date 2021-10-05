 
<cfquery name="DeleteVendor" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 DELETE FROM ItemMasterVendor
	 WHERE Code='#URL.ID#' 
	 AND   OrgUnitVendor='#URL.ID1#'
</cfquery>

<cfoutput>  	
<script>
	ptoken.navigate('VendorEntry.cfm?mission=#url.mission#&id=#url.id#','contentbox1')
</script>
</cfoutput>	


   