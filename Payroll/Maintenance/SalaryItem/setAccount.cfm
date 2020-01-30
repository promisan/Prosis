
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
		document.getElementById("#url.field#_#url.scope#").value     = '#get.GLAccount#'		
		document.getElementById("#url.field#name_#url.scope#").value = '#get.Description#'				
	</script>	

</cfoutput>