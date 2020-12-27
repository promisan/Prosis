
<cfquery name="Inv" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  InvoiceIncoming
	WHERE InvoiceIncomingId = '#url.invoiceincomingid#'
</cfquery>

<cfquery name="Payable" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM   Invoice
	WHERE  InvoiceNo        = '#INV.InvoiceNo#'
	AND    Mission          = '#INV.Mission#'
	AND    OrgUnitOwner     = '#INV.OrgUnitOwner#'
	AND    OrgUnitVendor    = '#INV.OrgUnitVendor#'
</cfquery>	

<cfset v = evaluate("form.documentAmount")>
<cfset v = replace(v,',','',"ALL")>

<cfif NOT LSisNumeric(v)>
		
	 <cfif url.dialog eq "0">	
		 <cf_message message = "You have entered a non-numeric amount. Operation not allowed."
		  return = "back">
	 <cfelse>
		  <cf_alert message = "You have entered a non-numeric amount. Operation not allowed."
		  return = "back">
	 </cfif> 
	 <cfabort>			
</cfif>

<cfset amt = v*100/(100+form.tax)>
<cfset dif = v - amt>

<cftransaction>
 
<cfquery name="Update" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE InvoiceIncoming
		SET    DocumentAmount      = '#v#',
			   ExemptionPercentage = '#form.tax/100#',
			   ExemptionAmount     = '#dif#'
		WHERE  InvoiceIncomingId   = '#url.invoiceincomingid#'
</cfquery>

<cfquery name="ClearInvoiceLine" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM InvoiceLine
		WHERE InvoiceId = '#Payable.InvoiceId#'		
</cfquery>
	
<cfquery name="ClearIncomingLine" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM InvoiceIncomingLine
		WHERE  InvoiceNo        = '#INV.InvoiceNo#'
		AND    Mission          = '#INV.Mission#'
		AND    OrgUnitOwner     = '#INV.OrgUnitOwner#'
		AND    OrgUnitVendor    = '#INV.OrgUnitVendor#'			
</cfquery>
	
<!--- -------------- --->
<!--- record details --->
<!--- -------------- --->
	
<cfquery name="Detail" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO InvoiceIncomingLine
			   (Mission,
				OrgUnitOwner,
				OrgUnitVendor,
				InvoiceNo,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName,
				InvoiceLineId,
				LineSerialNo,
				LineDescription,
				LineReference,
				LineAmount )
	  SELECT    '#INV.Mission#',
			    '#INV.OrgUnitOwner#',
			    '#INV.orgunitvendor#',
			    '#INV.invoiceNo#',
			    '#SESSION.acc#',
			    '#SESSION.last#',
			    '#SESSION.first#',
				InvoiceLineId,
			    InvoiceLineNo,
			    LineDescription,
			    LineReference,
			    LineAmount
		FROM    stInvoiceIncomingLine
		WHERE   InvoiceId = '#url.invoiceIncomingid#'			
</cfquery>	

<!--- associate incoming lines to this invoice --->
			
<cfquery name="Detail" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO InvoiceLine
			( InvoiceId,
			  InvoiceLineId,
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName)
	    SELECT '#Payable.InvoiceId#',
			   InvoiceLineId,				 
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
		FROM   InvoiceIncomingLine
		WHERE  InvoiceNo        = '#INV.InvoiceNo#'
		AND    Mission          = '#INV.Mission#'
		AND    OrgUnitOwner     = '#INV.OrgUnitOwner#'
		AND    OrgUnitVendor    = '#INV.OrgUnitVendor#'						
</cfquery>	

<cfoutput>
 
<script>
    
	parent.parent.document.getElementById('refreshinvoice').click()
	parent.parent.ProsisUI.closeWindow('mydialogs',true)
	
</script>	

</cfoutput>
	