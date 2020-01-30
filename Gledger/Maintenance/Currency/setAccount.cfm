
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

	<cfif url.mode eq "invoice">
			
	<script>
		document.getElementById("glaccount1").value     = '#get.GLAccount#'		
		document.getElementById("gldescription1").value = '#get.Description#'		
		try {
		document.getElementById("debitcredit1").value   = '#get.AccountType#' } catch(e) {}
	</script>	
	
	<cfelse>
	
		
	<script>
		document.getElementById("glaccount2").value     = '#get.GLAccount#'		
		document.getElementById("gldescription2").value = '#get.Description#'		
		try {
		document.getElementById("debitcredit2").value   = '#get.AccountType#' } catch(e) {}
	</script>	
	
	</cfif>

</cfoutput>