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
<cfif url.id neq "">
	
	<cfquery name="Delete" 
	 datasource="appsMaterials">
	 DELETE FROM AssetItemLocation
	 WHERE  MovementId = '#URL.ID#'
	 AND    AssetId = '#URL.ID1#'
	</cfquery>
	
	<cfquery name="Delete" 
	 datasource="appsMaterials">
	 DELETE FROM AssetItemOrganization
	 WHERE  MovementId = '#URL.ID#'
	 AND    AssetId = '#URL.ID1#'
	</cfquery>

</cfif>

<cfquery name="ClearList" 
 datasource="appsQuery">
    DELETE FROM #SESSION.acc#AssetMove#URL.Table#
    WHERE AssetId = '#URL.ID1#'
</cfquery>

<!--- open screen again --->

<cfset url.movementid = url.id>
<cfinclude template="MovementItems.cfm">
