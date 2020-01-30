
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ItemNo 
	FROM   Request
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE Request
	SET    RequestedQuantity = '#quantity#' 
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Line" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Request	
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfoutput>

	#NumberFormat(Line.RequestedAmount,'__,____.__')#

	<script>
		ColdFusion.navigate('setLineTotal.cfm?role=sorting=#url.sorting#&mission=#line.mission#&status=#line.status#&reference=#Line.Reference#','boxoverall')
	</script>

</cfoutput>



