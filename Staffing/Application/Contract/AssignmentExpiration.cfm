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
<!--- missing contract are not included --->
<cf_screentop html="No">

<cf_listingscript>

<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">

<tr> <td class="labellarge" style="padding-left:8px;font-size:29px;height:40px;"><b><cfoutput>#URL.ID2#</cfoutput></b>: assignments expiring before the end of the next month.</td> </td> </tr>

<tr><td height="100%" style="padding:8px">					
	<cf_divscroll overflowx="auto">  
		<cfinclude template="ContractExpirationListing.cfm">
	</cf_divscroll>
	</td>
</tr>

</table>

