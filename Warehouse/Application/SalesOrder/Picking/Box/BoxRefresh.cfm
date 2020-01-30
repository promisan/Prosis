<cfquery name="getBoxes" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
        SELECT  *
        FROM   WarehouseBatchCollection
        WHERE  BatchNo = '#url.batchno#'
</cfquery> 

<cfoutput>
    #numberformat(getboxes.recordcount,",")#
</cfoutput>