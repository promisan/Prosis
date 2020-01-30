
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ItemNo 
	FROM Request
	WHERE RequestId = '#URL.ID#'
</cfquery>

<!---
<cf_quantityOutput itemNo="#Item.ItemNo#" 
         quantity="#URL.quantity#">
		 --->

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
    SELECT * FROM Request	
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfoutput>
#NumberFormat(Line.RequestedAmount,'__,____.__')#

<script>
if (document.getElementById('total_#line.status#')) {
ColdFusion.navigate('RequestEditTotal.cfm?mission=#line.mission#&status=#line.status#','total_#line.status#')
}
</script>

</cfoutput>



