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
<cfset vApprovedStatus = "5">
<cfset vAuthorized = 1>

<cfset vActionCode = "">
<cfif url.status eq "1">
    <cfset vActionCode = "Picked">
</cfif>
<cfif url.status eq "2">
    <cfset vActionCode = "Moved">
</cfif>
<cfif url.status eq "5">
    <cfset vActionCode = "Consolidated">
</cfif>

<cfset vAcc = url.acc>
<cfif trim(url.acc) eq "">
    <cfset vAcc = session.acc>
</cfif>

<!--- selected user for the action --->

<cfquery name="getUser" 
    datasource="AppsSystem" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    UserNames
        WHERE   Account = '#vAcc#'
</cfquery>

<cfquery name="getAuthUser" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  MAX(AccessLevel) AccessLevel
        FROM	OrganizationAuthorization OA
        WHERE	Role        = 'WhsAssist'
        AND     UserAccount = '#getUser.account#'
</cfquery>

<cfif url.status eq vApprovedStatus AND getAuthUser.accessLevel neq "2">
    <cfset vAuthorized = 0>
</cfif>

<cfif vAcc eq "administrator">
    <cfset vAuthorized = 1>
</cfif>

<cfif vAuthorized eq "1">

    <cftransaction>
	
        <cfquery name="setStatusLog" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
                INSERT INTO ItemTransactionAction
                        (TransactionId,ActionCode,ActionStatus,ActionMemo,OfficerUserId,OfficerLastName,OfficerFirstName)
                    VALUES
                        ('#url.transactionid#',
                        '#vActionCode#',
                        '#url.status#',
                        '#trim(url.memo)#',
                        '#getUser.Account#',
                        '#getUser.LastName#',
                        '#getUser.FirstName#')
        </cfquery>

        <cfset vTransactionStatus = 0>
        <cfif url.status eq vApprovedStatus>
            <cfset vTransactionStatus = 1>
        </cfif>

        <cfquery name="setStatus" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
                UPDATE ItemTransaction
                SET    ActionStatus = '#vTransactionStatus#'
                WHERE  TransactionId = '#url.transactionId#'
        </cfquery>

    </cftransaction>

    <cfoutput>
        <script>
            updateCardStatus($('##container_#url.cid#'), '#url.batchno#', '#url.status#');
            $('##memo_#url.cid#').val("#trim(url.memo)#");
            $('.#url.detailscontainer#').html('<span title="#trim(url.memo)#">#getUser.Account#<br>#dateformat(now(), 'dd/mm')# #timeformat(now(), "hh:mm tt")#</span>');
        </script>
    </cfoutput>

<cfelse>

    <cfoutput>
        <cf_tl id="is not authorized to perform this action" var="1">
        <script>
            toastr.error('[#getUser.account#] #lt_text#.');
        </script>
    </cfoutput>

</cfif>