
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
	document.getElementById("entryglaccount").value     = '#get.GLAccount#'	
	<cfif get.AccountLabel neq "">	
	document.getElementById("entrygllabel").value       = '#get.AccountLabel#'
	<cfelse>
	document.getElementById("entrygllabel").value       = '#get.GLAccount#'
	</cfif>
	
	document.getElementById("entrygldescription").value = '#get.Description#'		
	document.getElementById("entrydebitcredit").value   = '#get.AccountType#' 
	
	<cfif get.ForceCurrency neq "">
	
	document.getElementById("entrycurrency").value   = '#get.ForceCurrency#' 	
	document.getElementById("entrycurrency").disabled = true
	
	<cfelse>
	
	document.getElementById("entrycurrency").disabled = false
	
	</cfif>
	
	<cfif get.AccountClass eq "Balance">
	
		document.getElementById('setdate').className = "hide"
	
	<cfelse>
	
		document.getElementById('setdate').className = "regular"
		
	</cfif>
	
	<cfif get.ForceProgram eq "1">
	
		document.getElementById('program0').className = "regular"
		document.getElementById('program1').className = "regular"
		document.getElementById('program2').className = "regular"
		document.getElementById('program3').className = "regular"
		
	<cfelse>
	
		document.getElementById('program0').className = "hide"
		document.getElementById('program1').className = "hide"
		document.getElementById('program2').className = "hide"
		document.getElementById('program3').className = "regular"
	
	</cfif>
		
	document.getElementById("entryglaccount").focus()		
	
</script>	

</cfoutput>