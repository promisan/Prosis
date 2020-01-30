<cfquery name="validate" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT  C.*,
				(SELECT COUNT(*) FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId) as CountItems
   FROM   WarehouseBatchCollection C
   WHERE  C.BatchNo = '#url.batchno#'
   AND    Collectionid = '#url.collectionid#'
</cfquery> 

<cfif validate.recordCount gt 0 and validate.CountItems eq 0>
    <cfquery name="remove" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
    AND    Collectionid = '#url.collectionid#'
    </cfquery> 
</cfif>

<cfquery name="getBoxes" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  *
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
</cfquery>

<cf_tl id="Could not delete, the box has items." var="lblBoxHasItems">
<cfoutput>
    <script>
        <cfif validate.CountItems gt 0>alert('#lblBoxHasItems#');</cfif>
        ColdFusion.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxEdit.cfm?batchno=#url.batchno#', 'modalBody');
        refreshBoxes('#url.batchno#');
        <cfif getBoxes.recordCount eq 0>refreshBatch('#url.batchno#');</cfif>
    </script>
</cfoutput>