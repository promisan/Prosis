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
<table height="100%" width="100%">
	<tr>
		<td height="100%" width="100%" align="center">
			<cfif url.publicationId neq "" and url.code neq "">
				<cfoutput>
					<iframe height="99%" width="100%" frameborder="0" scrolling="No" src="Cluster/ClusterViewForm.cfm?publicationId=#url.publicationId#&code=#url.code#&preselOrgUnit="></iframe>
				</cfoutput>
			<cfelse>
				<table><tr><td style="color:red;" class="labelmedium"><cf_tl id="Please select a valid cluster"></td></tr></table>
			</cfif>
		</td>
	</tr>
</table>

