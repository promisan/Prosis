
<cfparam name="url.VendorCode" default="">
	
	<cfquery name="CheckVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM ItemMasterVendor 
		 WHERE Code       = '#URL.ID#'
		 and OrgUnitVendor= '#url.VendorCode#'
	</cfquery>
		
	<cfif CheckVendor.recordcount eq "0">
			
	<cfquery name="InsertVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ItemMasterVendor
	         (Code,
			 OrgUnitVendor,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.ID#',
	      	  '#url.VendorCode#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>

	<cfelse>
		
		<cfquery name="InsertVendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ItemMasterVendor
	         (Code,
			 OrgUnitVendor,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.ID#',
	      	  '#url.VendorCode#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
		</cfquery>		

	</cfif>

<cfoutput>  	
<script>
	ptoken.navigate('VendorEntry.cfm?mission=#url.mission#&id=#url.id#','contentbox1')
</script>
</cfoutput>	
 
