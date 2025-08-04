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

<cf_screentop html="No">

<cf_listingscript>

<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">

<tr><td class="labelmedium" style="padding-left:5px;height:35px;"><b><i><cfoutput>#URL.ID2#</cfoutput></i></b>: staff members that have a contract but do not have an assignment</td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="100%">					
	<cf_divscroll overflowx="auto">  
		<cfinclude template="ContractNoAssignmentListing.cfm">
	</cf_divscroll>
	</td>
</tr>

</table>