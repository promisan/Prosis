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

 <!--- workflow driven --->	
				
	<cfquery name="subAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT       D.DocumentId, D.DocumentCode, D.DocumentDescription, D.DocumentOrder, D.DocumentTemplate
		FROM         Ref_EntityActionDocument AS A INNER JOIN
		             Ref_EntityDocument AS D ON A.DocumentId = D.DocumentId
		WHERE        A.ActionCode = '#url.actioncode#'
		AND          DocumentType = 'activity'
		AND          DocumentMode = 'notify'
		AND          D.Operational = 1
		ORDER BY     D.DocumentOrder		
	</cfquery>
	
	<table width="100%">
	<cfloop query="subaction">		
		<tr class="labelmedium"><td colspan="2" id="inspectionbox">									
		<cfinclude template="../../../../#DocumentTemplate#">		
		</td></tr>		
	</cfloop>
	</table>
	
	<script>Prosis.busy('no')</script>