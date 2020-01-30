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
				INSERT INTO Ref_CategoryItem
					(
						Category,
						CategoryItem,
						CategoryItemName,
						CategoryItemOrder,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.category#',
						'#Form.CategoryItem#',
						'#Form.CategoryItemName#',
						#Form.CategoryItemOrder#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
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
			ColdFusion.navigate('CategoryItem/CategoryItem.cfm?idmenu=#url.idmenu#&category=#url.category#', 'contentbox1');
			ColdFusion.Window.hide('mydialog');
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
		ColdFusion.navigate('CategoryItem/CategoryItem.cfm?idmenu=#url.idmenu#&category=#url.category#', 'contentbox1');
		ColdFusion.Window.hide('mydialog');
	</script>

</cfif>
</cfoutput>