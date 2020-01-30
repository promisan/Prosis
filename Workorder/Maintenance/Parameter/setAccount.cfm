
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
	
		document.getElementById("glaccount_#url.area#").value     = '#get.GLAccount#'				
		document.getElementById("gldescription_#url.area#").value = '#get.Description#'		
		try {
		document.getElementById("debitcredit_#url.area#").value   = '#get.AccountType#' } catch(e) {}
	</script>	

</cfoutput>