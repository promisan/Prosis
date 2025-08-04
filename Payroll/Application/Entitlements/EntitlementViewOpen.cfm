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

<!--- passtru template --->

<cfparam name="url.systemfunctionid" default="">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">		
	   window.location = 'EntitlementViewView.cfm?ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#&mid=#mid#'
	</script>

<cfelse>

	<script language="JavaScript">	 
	   	window.location = 'EntitlementViewView.cfm?Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid=#url.systemfunctionid#&mid=#mid#'						 
	</script>

</cfif>

</cfoutput>

