
<!--- set the values --->

<cfoutput>

<cfquery name="set" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *	
	FROM       PostalAddress A 			
	WHERE      Country = '#url.country#' 
	AND        PostalCode = '#url.keyvalue#'		
</cfquery>

<script>
    document.getElementById('field_#url.box#').value      = '#url.keyvalue#'
	document.getElementById('postalcode_#url.box#').value = "#set.PostalCode#"
	document.getElementById('city_#url.box#').value       = "#set.City#";
	document.getElementById('address_#url.box#').value    = "#set.Address#"	
</script>


</cfoutput>
