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

<cfset vCapacity = replace(form.capacity, ",", "", "ALL")>

<cfquery name="update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		UPDATE   WarehouseLocationCapacity
		SET		 DetailDescription = '#form.detailDescription#',
				 DetailStorageCode = '#form.DetailStorageCode#',
				 Capacity          = #vCapacity#
		WHERE    Warehouse         = '#url.warehouse#'
		AND		 Location          = '#url.location#'
		AND		 DetailId          = '#url.detailid#'
		
</cfquery>

<cfoutput>
<script>
	parent.parent.editLocationRefresh('#url.warehouse#','#url.location#')
	parent.parent.ProsisUI.closeWindow('mydialog',true)	
</script>
</cfoutput>