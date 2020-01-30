
<cfparam name="url.scope" default="portal">
<cfparam name="URL.ID" default="All">

<cfif URL.ID neq "All">

  <cfquery name="Update" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
       DELETE WarehouseCart
  	   WHERE  CartId      = '#URL.ID#'	  
   </cfquery>
       
	<cfoutput> 
	
	<script language="JavaScript">
		   
		 document.getElementById('row#URL.ID#').className = "hide"
		 se = document.getElementById('smenu1')
		 if (se) {
		 	ColdFusion.navigate('Requester/CartStatus.cfm','smenu1')
		 }
		 
		 se = document.getElementById('draft_#url.itemlocationid#')
		 if (se) {
			 ColdFusion.navigate('../Stock/InquiryWarehouseGetCart.cfm?itemlocationid=#url.itemlocationid#','draft_#url.itemlocationid#') 
		 
		 }		
		 
	</script>
	
	</cfoutput>
   
<cfelse>

   <cfquery name="Update" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    DELETE  WarehouseCart
	WHERE   UserAccount = '#SESSION.acc#'
   </cfquery>
      
	<cfinclude template="Cart.cfm">
   
</cfif>

<cf_compression>


