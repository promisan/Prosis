<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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