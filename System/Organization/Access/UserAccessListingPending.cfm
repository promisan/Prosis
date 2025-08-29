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
<cfoutput>

<table style="height:100%;width:100%">
	<tr>
		<td valign="top" id="processlist"><cfinclude template="UserAccessListingPendingLines.cfm"></td>
	</tr>
</table>

<!---
<iframe src="#SESSION.root#/System/Organization/Access/UserAccessListingPendingLines.cfm?search=#url.search#&id=#url.id#" 
    width="100%" 
	height="100%" 
	frameborder="">
</iframe>
--->

</cfoutput>
