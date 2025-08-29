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
<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_Mandate
WHERE    Mission = '#URL.Mission#'
ORDER BY DateEffective DESC
</cfquery>

<cfoutput>
	
	<table width="200" class="formpadding">
	
		<input type="hidden" name="mandateno" id="mandateno" value="#Mandate.MandateNo#">
		
		<cfloop query="Mandate">
		
			<tr class="labelmedium2">
			    <td><input type="radio" class="radiol"
				onclick="document.getElementById('mandateno').value='#mandateno#'" 
				name="mymandate" 
				value="#MandateNo#" <cfif currentRow eq "1">checked</cfif>></td>
				<td style="padding-left:4px">#MandateNo#</td>
				<td style="padding-left:4px">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
				<td style="padding-left:4px">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
			</tr>
				
		</cfloop>
	
	</table>

</cfoutput>