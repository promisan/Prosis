
<cfset vStart = 1>
<cfset vCurrentBoxes = 0>

<cfquery name="getMax" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  MAX(CONVERT(INT, CollectionCode)) as LastBox
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
</cfquery>

<cfif getMax.recordcount eq 1 AND getMax.LastBox neq "">
    <cfset vStart = getMax.LastBox + 1>
    <cfset vCurrentBoxes = getMax.LastBox>
</cfif>

<cfloop from="#vStart#" to="#url.number+vCurrentBoxes#" index="box">

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
                ,'#box#'
                ,'#box#'
                ,'#session.acc#'
                ,'#session.last#'
                ,'#session.first#')
    </cfquery> 

</cfloop>

<cfoutput>
    <script>
        ColdFusion.navigate('#session.root#/warehouse/application/salesorder/picking/box/FillBoxes.cfm?batchno=#url.batchno#&submitid=#url.submitid#&transactionid=#url.transactionid#', 'modalBody');
        refreshBoxes('#url.batchno#');
    </script>
</cfoutput>