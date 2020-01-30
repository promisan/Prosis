
<cfquery name="Tax" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     CountryTaxCode
	WHERE    TaxCode   = '#url.taxcode#' 	  
</cfquery>	

<cfoutput>
<script>
  
	document.getElementById('BillingReference').value  = "#Tax.TaxCode#"
	document.getElementById('BillingName').value       = "#Tax.TaxName#"
</script> 	
</cfoutput>

