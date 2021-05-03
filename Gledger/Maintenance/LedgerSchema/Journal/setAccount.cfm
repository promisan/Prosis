
<!--- set the selected account --->

<cfquery name="get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account
		WHERE  GLAccount = '#URL.account#'
	</cfquery>

<cfoutput>
		
	<script>	
		document.getElementById("sglaccount").value     = '#get.GLAccount#'		
		document.getElementById("sgldescription").value = '#get.Description#'		
		try {
		document.getElementById("sdebitcredit").value   = '#get.AccountType#' } catch(e) {}
	</script>	

</cfoutput>