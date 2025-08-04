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

<cfoutput>

<cfparam name="url.mid" default="">

<cfif url.mid eq "">

	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/> 
	
<cfelse>

	<cfset mid = url.mid>	

</cfif>

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">
	
	   window.location =  'ReceiptViewView.cfm?systemfunctionid=#url.systemfunctionid#&period=' + parent.window.receipt.PeriodSelect.value + '&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&mid=#url.mid#'
	   
	</script>

<cfelse>

	<script language="JavaScript">	
	   
	   window.location = 'ReceiptViewView.cfm?systemfunctionid=#url.systemfunctionid#&Period=' + parent.window.receipt.PeriodSelect.value + '&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&mid=#url.mid#'
	   
	</script>

</cfif>

</cfoutput>

