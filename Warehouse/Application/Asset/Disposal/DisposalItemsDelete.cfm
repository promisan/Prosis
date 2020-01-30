
<cfquery name="Delete" 
 datasource="appsMaterials">
   DELETE FROM AssetItemDisposal
   WHERE  DisposalId = '#URL.ID#'
   AND    AssetId    = '#URL.ID1#' 
</cfquery>

<!--- open screen again --->

<cflocation url="DisposalItems.cfm?DisposalId=#URL.ID#&table=#URL.Table#" addtoken="No">

