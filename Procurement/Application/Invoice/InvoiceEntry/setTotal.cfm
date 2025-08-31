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
<cfset tot = 0>

<cfloop index="itm" list="#Form.SelectedPurchase#" delimiters=",">

	<cfparam name="Form.Purchase_#itm#" default="">	
	<cfset val = evaluate("Form.Purchase_#itm#")>
	
	<cfif val neq "">
	
		<cfif IsNumeric(val)>		
		   	<cfset tot = tot + val> 	
		</cfif>
	
	</cfif>

</cfloop>

<table>
	<tr >
	<td class="labelit"><cf_tl id="selected">:</td>
    <td class="labelmedium" style="padding-left:7px"><cfoutput>#numberformat(tot,',.__')#</cfoutput></td>
	</tr>
</table>

