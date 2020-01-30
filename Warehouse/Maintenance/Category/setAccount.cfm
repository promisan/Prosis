
<!--- set the selected account --->


<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account
		WHERE  GLAccount = '#URL.glaccount#'
	</cfquery>

<cfoutput>
	
<script>
	document.getElementById("#url.area#glaccount").value     = '#get.GLAccount#'		
	document.getElementById("#url.area#gldescription").value = '#get.Description#'		
	document.getElementById("#url.area#debitcredit").value   = '#get.AccountType#' 	
</script>	

</cfoutput>