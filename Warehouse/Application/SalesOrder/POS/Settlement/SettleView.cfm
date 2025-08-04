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
<cfset url.scope = "none">

<cfinclude template="SettlementViewHeader.cfm">

<cfif url.scope neq "none">
	<cfif url.scope eq "settlement" or url.scope eq "standalone">
		<cfform id="salesdetails" name="salesdetails" method="POST" style="height:98%">		
			<cfinclude template="SettlementViewBody.cfm">
		</cfform>
	<cfelse>	
		<cfinclude template="SettlementViewBody.cfm">
	</cfif>
</cfif>	

