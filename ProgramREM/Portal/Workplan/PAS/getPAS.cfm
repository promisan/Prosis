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

<cfquery name="getPAS" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Contract
		WHERE  ActionStatus NOT IN ('8','9')
		AND    PersonNo = '#url.personNo#'
		AND    Period   = '#url.period#'
</cfquery>

<cfif getPas.recordcount gte "1">
	<table width="100%" class="formpadding">
	<tr class="line"><td colspan="5"></td></tr>
	<cfoutput query="getPAS">
	<tr class="line labelmedium">
	  <td style="padding-left:3px"><a href="javascript:pasdialog('#ContractId#')">#ContractNo#</a></td>
	  <td>#ContractClass#</td>
	  <td>#dateformat(DateEffective,client.dateformatshow)#-#dateformat(DateExpiration,client.dateformatshow)#</td>
	  <td>#FunctionDescription#</td>
	</tr>
	</cfoutput>
	</table>
</cfif>