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
<cfparam name="URL.Reference" default="">
<cfparam name="URL.ExecutionId" default="">

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   PurchaseExecutionRequest
	WHERE  Reference='#URL.Reference#'
	<cfif URL.ExecutionId neq "">
	AND    RequestId!='#URL.ExecutionId#'
	</cfif>
</cfquery>

<cfoutput>

	<cfif check.recordcount gt "0">
	
		<script>
			alert("Problem, Reference [#URL.Reference#] has been recorded already.")
		</script>
		<font color="green"><img src="#SESSION.root#/Images/alert4.gif" align="absmiddle" alt="Value has been used before" width="16" height="15" border="0"></font>
			
	<cfelse>
	
		<font color="green"><img src="#SESSION.root#/Images/check_mark3.gif" align="absmiddle" alt="Value has not been used before" width="16" height="15" border="0"></font>
		
	</cfif>
		
</cfoutput>	
		
		