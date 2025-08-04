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

<cf_screentop html="Label" jQuery="Yes" systemFunctionid="#url.systemfunctionid#">

<cfajaximport tags="cfdiv">

<cf_listingscript>

<table width="100%" height="100%">

<tr class="line">
	<td style="height:33px;padding-left:8px" class="labellarge">
	<table><tr class="labellarge"><td style="font-size:18px"><cfoutput>#screentoplabel#</cfoutput></td></tr></table> 	
	</td>
</tr>

<tr>
	<td style="padding-left:10px;padding-right:10px;padding-bottom:10px">	
	<cfinclude template="WorkOrderListingContent.cfm">
	</td>
</tr>

</table>