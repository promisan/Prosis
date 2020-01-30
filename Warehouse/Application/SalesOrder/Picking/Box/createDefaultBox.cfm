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
            ,'1'
            ,'1'
            ,'#session.acc#'
            ,'#session.last#'
            ,'#session.first#')
</cfquery> 

<cfoutput>
    <script>
        refreshBoxes('#url.batchno#');
    </script>
</cfoutput>