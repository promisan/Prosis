<cfquery name="getStatus" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    ItemTransaction WITH (NOLOCK)
        WHERE   TransactionBatchNo = '#url.batchno#'
</cfquery>

<cfset vTransactionIds = "">
<cfif getStatus.recordCount gt 0>
    <cfset vTransactionIds = QuotedValueList(getStatus.TransactionId)>
</cfif>

<cfquery name="getStatusAction" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    ItemTransactionAction WITH (NOLOCK)
        WHERE   1=1
        <cfif vTransactionIds neq "">
            AND     TransactionId IN (#preserveSingleQuotes(vTransactionIds)#)
        <cfelse>
            AND     1=0
        </cfif>
</cfquery>

<cfquery name="getStatusOne" dbtype="query">
    SELECT  *
    FROM    getStatus
    WHERE   ActionStatus = '1'
</cfquery>

<cf_tl id="On hold" var="lblOnHold">
<cf_tl id="Initiated" var="lblInitiated">

<cfoutput>
    <script>
        //Initiated label
        $('##initiated#url.batchno#').hide();
        <cfif getStatusAction.recordCount gt 0>
            $('##initiated#url.batchno#').html('<span style="font-weight:bold; color:##12AEAE;">#lblInitiated#</span>').show(250);
        <cfelse>
            $('##initiated#url.batchno#').html('<span style="color:##F28D8D;">#lblOnHold#</span>').show(250);
        </cfif>

        //Progress label
        $('##progress#url.batchno#').hide().html('#getStatusOne.recordCount#').show(250);

        //Progress percentage label
        $('##progressPercentage#url.batchno#').hide().html('#numberformat(getStatusOne.recordCount*100/getStatus.recordCount, ",")#').show(250);

        //Row color
        $('.clsColorMainContainer#url.batchno#').css('background-color', getLineColor(#getStatusOne.recordCount/getStatus.recordCount#));
    </script>
</cfoutput>