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
<cfquery name="getAut"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControlAuthorization
	WHERE   Mission = '#url.mission#'
	AND     SystemFunctionId = '#url.systemfunctionid#'
	<!--- AND     Account = '#session.acc#' --->
	AND     DateEffective <= getDate() and DateExpiration >= getDate()
	AND     AuthorizationCode = '#url.val#'	
	
</cfquery>	

<cfoutput>

<cfif getAut.recordcount eq "0">
	
	<script>	
		alert('invalid authorization')
		ProsisUI.closeWindow('authorizationwindow')	
	</script>

<cfelse>

	<script>		
		document.getElementById('#url.object#').readOnly = false
		document.getElementById('#url.object#').focus()
		ProsisUI.closeWindow('authorizationwindow')	
	</script>

</cfif>

</cfoutput>
