<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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