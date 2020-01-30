
<cfquery name="delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_BusinessRule
		WHERE 	Code  = '#URL.ID1#' 
</cfquery>

	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Delete"
	 contenttype = "scalar"
	 content="#URL.id1#">				

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListing.cfm?idmenu=#url.idmenu#','rulesListing');
	</script>
</cfoutput>