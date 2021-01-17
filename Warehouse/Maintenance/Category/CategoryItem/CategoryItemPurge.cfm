
<script>
	Prosis.busy('yes');
</script>

<cfquery name="delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_CategoryItem
		WHERE 	Category = '#url.category#'
		AND		CategoryItem = '#url.item#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
                     action ="Delete" 
					 content="#Form#">

<cfoutput>
	<script>
		ptoken.navigate('CategoryItem/CategoryItem.cfm?idmenu=#url.idmenu#&category=#url.category#','contentbox1');
	</script>
</cfoutput>