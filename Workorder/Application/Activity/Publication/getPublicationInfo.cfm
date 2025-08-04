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

<cfquery name="getPublication" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		WHERE	PublicationId = '#url.publicationId#'
</cfquery>

<cfoutput>
	<table>
		<tr>
			<td class="labellarge" style="padding-left:16px">
				#getPublication.Description# ( <span>#dateFormat(getPublication.PeriodEffective,client.dateformatshow)#&nbsp;-&nbsp;#dateFormat(getPublication.PeriodExpiration,client.dateformatshow)#</span> )
			</td>
		</tr>
	</table>
</cfoutput>