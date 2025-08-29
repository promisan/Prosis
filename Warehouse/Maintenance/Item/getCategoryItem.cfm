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
<cfparam name="url.itemNo" default="">

<cfquery name="CatItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_CategoryItem
		WHERE	Category = '#url.Category#'
</cfquery>

<!-- <cfform> -->

<cfif CatItem.recordcount eq "0">
	
	<font color="FF0000">No Item Categories defined.</font>
	
	<script>
	    try {
		document.getElementById('processbutton').className = "hide"
		} catch(e) {}
	</script>

<cfelse>

	<cfselect name="CategoryItem" 
		class="regularxl"
		query="CatItem" 
		required="Yes" 
		value="CategoryItem" 
		message="Please, select a valid generic item." 
		selected="#url.CategoryItem#"
		onChange="refreshItemMaster(this)"
		display="CategoryItemName"/>		
	
	<script>
	
		itm    = document.getElementById('ItemMasterOld');
   		miss   = document.getElementById('mission');  
		_cf_loadingtexthtml='';	
		if ($('#bItemMaster').length > 0) { 				
   			ptoken.navigate('getItemMaster.cfm?itemmaster='+itm.value+'&mission='+miss.value+'&categoryitem=<cfoutput>#CatItem.CategoryItem#</cfoutput>','bItemMaster')	
		}
	    try {
		document.getElementById('processbutton').className = "regular"		
		} catch(e) {}
		
	</script>

</cfif>

<cfif url.itemNo neq "">


	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Item
		WHERE	ItemNo = '#url.ItemNo#'
	</cfquery>	
		
	<cfif get.ItemMaster neq "">
	
		<cfoutput>
				
			<cfset AjaxOnLoad("refreshByCategory")>
		 
		</cfoutput>
	
	</cfif>

</cfif>


<!-- </cfform> -->