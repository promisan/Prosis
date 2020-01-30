
<cfif url.field eq "Owner">

	<cfquery name="UpdateInvoice" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    	 UPDATE InvoiceIncoming
			 SET    OrgUnitOwner      = '#url.orgunit#'
		 	 WHERE  InvoiceIncomingId = '#URL.ID#'   
	</cfquery> 

<cfelse>	

	<cfquery name="UpdateInvoice" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	    	 UPDATE Invoice
			 SET    OrgUnit  = '#url.orgunit#'
		 	 WHERE  InvoiceId = '#URL.ID#'   
	</cfquery> 	

</cfif>