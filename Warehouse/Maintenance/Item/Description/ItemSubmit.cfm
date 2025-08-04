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

<cfquery name="UPDATE" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  Item
	SET     ItemDescription = N'#Form.ItemDescription#'
	WHERE   ItemNo = '#url.itemno#'
</cfquery>						 

<cf_LanguageInput
	TableCode    = "Item" 
	Mode         = "Save"
	DataSource   = "AppsMaterials"
	Key1Value    = "#url.itemno#"
	Name1        = "ItemDescription">	

<!---
<cfoutput>#url.context#-#url.id#</cfoutput>
--->

<cfif url.context eq "purchase">
	
	<cfquery name="UPDATE" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  PurchaseLine
		SET     OrderItem  = N'#Form.ItemDescription#'
		WHERE   RequisitionNo = '#url.id#' 
	</cfquery>
		
</cfif>

<cfoutput>
	#Form.ItemDescription#
</cfoutput>

<script>
	ProsisUI.closeWindow('setitem')		
</script>


