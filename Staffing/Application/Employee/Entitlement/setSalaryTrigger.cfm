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

<cfquery name="Trigger" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PayrollTrigger T
	WHERE   SalaryTrigger = '#url.id#'	
</cfquery>

<cfif trigger.triggerInstruction neq "">
	<table width="90%" align="center">
	<tr class="line">
		<td colspan="2" class="labelmedium" style="border-top:1px solid silver;height:1px;padding-left:10px; padding-right:10px">
		<font color="0080C0">
		<cfoutput>#trigger.triggerInstruction#</cfoutput>
		</td>
	</tr>
	</table>
</cfif>

<cfif Trigger.enableAmount eq "1">

	<script>
		document.getElementById('enableamount').className = "regular labelmedium"	 
	</script>
	
<cfelse>

	<script>
	 	document.getElementById('enableamount').className = "hide"	 
	</script>
	
</cfif>

	