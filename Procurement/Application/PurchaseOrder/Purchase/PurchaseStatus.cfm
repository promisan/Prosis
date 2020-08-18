
<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.PurchaseNo#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfif PO.ActionStatus eq "3">

<cfoutput>
<script>
	ptoken.location("POView.cfm?header=#url.header#&Mode=view&role=#URL.Role#&ID1=#URL.Purchaseno#")
</script>
</cfoutput>

</cfif>