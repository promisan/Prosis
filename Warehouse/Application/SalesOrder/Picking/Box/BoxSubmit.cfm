
<cfif url.collectionid eq "">

    <cfquery name="validate" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  *
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
    AND    CollectionCode = '#url.code#'
    </cfquery> 

    <cfif validate.recordCount eq 0>

        <cf_assignid>

        <cfquery name="add" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            INSERT INTO [dbo].[WarehouseBatchCollection]
                    ([CollectionId]
                    ,[BatchNo]
                    ,[CollectionCode]
                    ,[CollectionName]
                    ,[OfficerUserId]
                    ,[OfficerLastName]
                    ,[OfficerFirstName])
                VALUES
                    ('#RowGuid#'
                    ,'#url.batchno#'
                    ,'#url.code#'
                    ,'#trim(url.name)#'
                    ,'#session.acc#'
                    ,'#session.last#'
                    ,'#session.first#')
        </cfquery> 

    <cfelse>
        <cf_tl id="Code already registered." var="lblCodeRegistered">
        <cfoutput>
            <script>
                alert('#lblCodeRegistered#');
            </script>
        </cfoutput>
    </cfif>

<cfelse>

    <cfquery name="update" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            UPDATE  WarehouseBatchCollection
            SET     CollectionName = '#trim(url.name)#'
            WHERE  BatchNo = '#url.batchno#'
            AND    CollectionId = '#url.CollectionId#'
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

<cfoutput>
    <script>
        ColdFusion.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxEdit.cfm?batchno=#url.batchno#', 'modalBody');
        refreshBoxes('#url.batchno#');
        <cfif getBoxes.recordCount eq 1>refreshBatch('#url.batchno#');</cfif>
    </script>
</cfoutput>
