<!--
    Copyright © 2025 Promisan B.V.

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