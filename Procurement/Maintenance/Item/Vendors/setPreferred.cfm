
<!--- set default --->

<cfquery name="InsertVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ItemMasterVendor
		 SET    Preferred = '0'
		 WHERE  Code     = '#URL.ID#'
		 AND    Mission  = '#url.mission#'
</cfquery>

<cfquery name="setVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE ItemMasterVendor
		 SET    Preferred = '1'
		 WHERE  Code     = '#URL.ID#'
		 AND    Mission  = '#url.mission#'
		 AND   OrgUnitVendor   = '#url.id1#'
</cfquery>


<cfoutput>  	
<script>
	ColdFusion.navigate('Vendors/VendorEntry.cfm?mission=#url.mission#&id=#url.id#','contentbox1')
</script>
</cfoutput>	
 

