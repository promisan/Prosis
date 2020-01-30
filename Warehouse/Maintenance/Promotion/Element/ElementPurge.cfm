<cfquery name="delete" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		DELETE
		FROM 	PromotionElement
		WHERE	PromotionId = '#url.promotionid#'
		AND		ElementSerialNo = '#url.serial#'
</cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
				                     action="Delete" 
									 content="#form#">

<cfoutput>
	<script>
		ColdFusion.navigate('Element/ElementListing.cfm?idmenu=#url.idmenu#&id1=#url.promotionid#', 'divElementListing');
		
	</script>
</cfoutput>