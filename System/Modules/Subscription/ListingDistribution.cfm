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
<table width="100%" cellpadding="0">

	<tr><td><cfinclude template="Criteria.cfm"></td></tr>
	
	<cfoutput>
	<tr class="line"><td><iframe src="ListingDistributionDetail.cfm?row=#url.row#&id=#url.id#" width="100%" height="200" scrolling="no" frameborder="0">
	</cfoutput>
	
	<!---
	<tr><td height="200">
		<cfinclude template="ListingDistributionDetail.cfm">
	</td>
	</tr>
	--->

</table>
