<cfquery name="qDelete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE ItemMasterStandardCost
	WHERE 
           ItemMaster 		= '#URL.id1#' AND
		   Mission   		= '#URL.id2#' AND
		   TopicValueCode	= '#URL.id3#' AND
		   CostElement		= '#URL.id4#' AND
		   DateEffective	= '#URL.id5#' AND
		   Location			= '#URL.id6#' 
</cfquery>


<cfoutput>
<script>
	ColdFusion.navigate('Budgeting/CostElementList.cfm?id1=#URL.id1#','dExisting');
</script>
</cfoutput>