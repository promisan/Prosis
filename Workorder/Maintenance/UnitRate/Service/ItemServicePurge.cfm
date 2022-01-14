
<!--- remove service item --->

<cfquery name="set" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ServiceItemUnitWorkorderService 		
		WHERE UsageId = '#url.id#'		
</cfquery>		

<cfoutput>

<script>	
	_cf_loadingtexthtml='';
	ptoken.navigate('Service/ItemUnitServiceListingDetail.cfm?ID1=#url.id1#&id2=#url.id2#','servicelisting')
</script>

</cfoutput>	
