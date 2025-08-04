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
<cf_tl id ="This item already exists in this category." var = "vAlready">

<script>
	Prosis.busy('yes');
</script>

<cfoutput>
<cfif url.item eq "">

	<cfquery name="Validate" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_CategoryItem
			WHERE 	Category = '#url.category#'
			AND		CategoryItem = '#Form.CategoryItem#'
	</cfquery>
	
	<cfif Validate.recordCount eq 0>
	
		<cfquery name="insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_CategoryItem (
						Category,
						CategoryItem,
						CategoryItemName,
						CategoryItemOrder,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
				) VALUES (
					'#url.category#',
					'#Form.CategoryItem#',
					'#Form.CategoryItemName#',
					#Form.CategoryItemOrder#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_CategoryItem" 
			Mode            = "Save"
			DataSource      = "AppsMaterials"
			Key1Value       = "#url.category#"
			Key2Value       = "#Form.CategoryItem#"
			Name1           = "CategoryItemName">
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Insert" 
							 content="#Form#">
		
		<script>
			ptoken.navigate('CategoryItem/CategoryItem.cfm?idmenu=#url.idmenu#&category=#url.category#', 'contentbox1');
			ProsisUI.closeWindow('mydialog');
		</script>
	
	<cfelse>
	
		<script>
			alert('#vAlready#');
		</script>
	
	</cfif>

<cfelse>

	<cfquery name="update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_CategoryItem
			SET		CategoryItemName  = '#Form.CategoryItemName#',
					CategoryItemOrder = #Form.CategoryItemOrder# 
			WHERE 	Category = '#url.category#'
			AND		CategoryItem = '#url.item#'
	</cfquery>
		
	<cf_LanguageInput
		TableCode       = "Ref_CategoryItem" 
		Mode            = "Save"
		DataSource      = "AppsMaterials"
		Key1Value       = "#url.category#"
		Key2Value       = "#Form.CategoryItem#"
		Name1           = "CategoryItemName">
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Update" 
							 content="#Form#">
	
	<script>
		ptoken.navigate('CategoryItem/CategoryItem.cfm?idmenu=#url.idmenu#&category=#url.category#', 'contentbox1');
		ProsisUI.closeWindow('mydialog');
	</script>

</cfif>

</cfoutput>