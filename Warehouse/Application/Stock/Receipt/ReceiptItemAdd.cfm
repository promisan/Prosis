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
<cf_compression>

<cfset isDirty = 0>

<cfif url.field eq "TransferQuantity">

	<cfset url.value = replace(url.value, ",", "", "ALL")>
	
	<cfif not isNumeric(url.value)>
		<cfset url.value = 0>
	<cfelse>
		<cfif url.value lte 0>
			<cfset url.value = 0>
		<cfelse>
			<cfquery name="getLine"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
					WHERE	TransactionId = #url.id#
			</cfquery>
			<cfif url.value gt getLine.quantity>
				<cfset url.value = getLine.quantity>
			</cfif>
		</cfif>
	</cfif>
	
	<cfoutput>
		<script>
			document.getElementById('quantity_#url.id#').value = #url.value#;
		</script>
	</cfoutput>
	
</cfif>

<cfif isDirty eq 0>

	<cfquery name="saveChangeItem"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
			SET		#url.field# = <cfif url.value eq "">null<cfelse>'#url.value#'</cfif>
			WHERE 	1 = 1
			<cfif url.field neq "TransferQuantity">
			AND 	Selected = '1'
			</cfif>
			<cfif url.id neq "">
			AND   	TransactionId = #url.id#
			</cfif>
			
	</cfquery>

</cfif>