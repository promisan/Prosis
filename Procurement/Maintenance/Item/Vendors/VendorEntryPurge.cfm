 
<cfquery name="get" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   ItemMasterVendor
	 WHERE  Code          = '#URL.ID#' 
	 AND    OrgUnitVendor = '#URL.ID1#'
</cfquery>

<cfif get.operational eq "0">

	<cfquery name="DeleteVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE   ItemMasterVendor
		 SET      Operational   = 1
		 WHERE    Code          = '#URL.ID#' 
		 AND      OrgUnitVendor = '#URL.ID1#'
	</cfquery>

<cfelse>
	
	<cfif get.Source eq "Manual">
		 
		<cfquery name="DeleteVendor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 DELETE FROM ItemMasterVendor
			 WHERE  Code          = '#URL.ID#' 
			 AND    OrgUnitVendor = '#URL.ID1#'
		</cfquery>
	
	<cfelse>
		
		<cfquery name="DeleteVendor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 UPDATE ItemMasterVendor
			 SET    Operational   = 0
			 WHERE  Code          = '#URL.ID#' 
			 AND    OrgUnitVendor = '#URL.ID1#'
		</cfquery>
	
	</cfif>
	
</cfif>	

<cfoutput>  	
	<script>
		ColdFusion.navigate('Vendors/VendorEntry.cfm?mission=#url.mission#&id=#url.id#','contentbox1')
	</script>
</cfoutput>	
