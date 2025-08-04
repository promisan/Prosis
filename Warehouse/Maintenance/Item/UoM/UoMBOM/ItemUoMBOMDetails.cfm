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

<cfquery name="GetBOM"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT IBD.*
		FROM   ItemBOMDetail IBD INNER JOIN ItemBOM IB
			ON IBD.BomId = IB.BomId  
		WHERE  
		<cfif URL.BomId eq "">
			1=0
		<cfelse>
			IBD.BomId = '#URL.BomId#'
		</cfif>
</cfquery>

<cfoutput>
	<cfset vMaterials = ValueList(GetBOM.MaterialId)>
	<input type="hidden" name="_materials_" id="_materials_" value="#vMaterials#">	
	<cfset AjaxOnLoad("doEditBOM")>
</cfoutput>