
<cfquery name="removeStatus" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        DELETE 
        FROM    ItemTransactionAction
        WHERE   TransactionId = '#url.transactionId#'
</cfquery>

<cfquery name="setTransactionStatus" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        UPDATE ItemTransaction
        SET    ActionStatus = '0'
        WHERE  TransactionId = '#url.transactionId#'
</cfquery>

<cfoutput>
    <script>
        showBatch('#url.batchno#');
    </script>
</cfoutput>