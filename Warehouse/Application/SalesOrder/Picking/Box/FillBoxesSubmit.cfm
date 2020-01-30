
<cftransaction>
    <cfquery name="getTransaction" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            SELECT *
            FROM   ItemTransaction WITH (NOLOCK)
            WHERE  TransactionId = '#url.transactionId#'
    </cfquery> 

    <cfquery name="getBoxes" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            SELECT  C.*
            FROM   WarehouseBatchCollection C
            WHERE  C.BatchNo = '#url.batchno#'
    </cfquery> 

    <cfquery name="clearCollections" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            DELETE
            FROM   ItemTransactionCollection
            WHERE  TransactionId = '#url.transactionId#'
    </cfquery> 

    <cfset vCollectedQuantity = 0>
    <cfoutput query="getBoxes">
        <cfset vThisId = replace(collectionid, "-", "", "ALL")>
        <cfif isDefined("fbQuantity_#vThisId#")>
            <cfset vQuantity = evaluate("fbQuantity_#vThisId#")>
            <cfif vQuantity neq "" AND vQuantity neq "0">
                <cfset vMemo = trim(evaluate("fbMemo_#vThisId#"))>
                <cf_assignid>
                <cfquery name="insertCollection" 
                    datasource="AppsMaterials" 
                    username="#SESSION.login#" 
                    password="#SESSION.dbpw#">
                        INSERT INTO [dbo].[ItemTransactionCollection]
                                ([TransactionCollectionId]
                                ,[TransactionId]
                                ,[CollectionId]
                                ,[CollectionDate]
                                ,[CollectionOfficer]
                                ,[CollectionQuantity]
                                ,[Memo]
                                ,[OfficerUserId]
                                ,[OfficerLastName]
                                ,[OfficerFirstName])
                            VALUES
                                ('#RowGuid#'
                                ,'#url.transactionid#'
                                ,'#collectionid#'
                                ,GETDATE()
                                ,'#session.acc#'
                                ,'#vQuantity#'
                                ,'#vMemo#'
                                ,'#session.acc#'
                                ,'#session.last#'
                                ,'#session.first#')
                </cfquery>

                <cfset vCollectedQuantity = vCollectedQuantity + vQuantity>
            </cfif>
        </cfif>

    </cfoutput>
</cftransaction>

<cfset vTransactionQuantity = getTransaction.transactionQuantity*-1>
<cfset vCollectedPending = vTransactionQuantity - vCollectedQuantity>

<cfif vCollectedPending eq 0>
    <cfoutput>
        <script>
            parent.toggleStatus(parent.$('##container_#url.submitid#'), '#url.submitid#', '#url.transactionId#', '#url.batchNo#', '5', 'Consolidated', true);
            parent.$('##modalBoxes').modal('hide');
        </script>
    </cfoutput>
<cfelse>
    <cf_tl id="Saved but not consolidated." var="lblBoxesPendingError1">
    <cf_tl id="Pending items" var="lblBoxesPendingError2">
    <cfoutput>
        <script>
            alert('#lblBoxesPendingError1#\n#lblBoxesPendingError2#: #numberformat(vCollectedPending, ",")#');
            parent.$('##modalBoxes').modal('hide');
        </script>
    </cfoutput>
</cfif>