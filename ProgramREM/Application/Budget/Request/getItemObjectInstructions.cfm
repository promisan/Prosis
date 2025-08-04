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
<cfquery name="Get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
	  	FROM   	ItemMasterObject
	 	WHERE  	ItemMaster = '#url.itemmaster#'
	  	AND		ObjectCode = '#url.object#'
</cfquery>

<cfoutput>
	<table width="99%" align="center" class="formpadding">		
		<tr>
			<td class="labelit" colspan="2" style="padding:10px; border:1px solid ##d0d0d0; background-color:##f1f1f1;">
				<cfif trim(get.BudgetEntryInstruction) neq "">
					#get.BudgetEntryInstruction#
				<cfelse>
					<table>
						<tr><td class="labelit" align="center">[<cf_tl id="No instructions recorded">]</td></tr>
					</table>
				</cfif>				
			</td>
		</tr>
	</table>

</cfoutput>
