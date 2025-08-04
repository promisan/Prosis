<!--
    Copyright © 2025 Promisan

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

<cftransaction>

    <cfquery name="getAction" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            SELECT  *
            FROM    WarehouseBatchAction
            WHERE   BatchNo      = '#url.batchno#'
            AND     ActionCode   = 'Monitor'           
    </cfquery>

    <cfif getAction.recordcount eq 0>
	
        <cfquery name="insertData" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
                INSERT INTO dbo.WarehouseBatchAction
                       (BatchNo,ActionCode,ActionDate,ActionStatus,OfficerUserid,OfficerLastName,OfficerFirstName)
                VALUES ('#url.batchno#','Monitor',GETDATE(),'1','#session.acc#','#session.last#','#session.first#')
        </cfquery>
		
	<cfelse>
			
		<cfquery name="updateData" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            UPDATE  WarehouseBatchAction
			SET     <cfif getAction.ActionStatus eq "1">
					ActionStatus = '0', 
					<cfelse>
					ActionStatus = '1',
					</cfif>
			        Created      = getdate()
            WHERE   BatchNo      = '#url.batchno#'
            AND     ActionCode   = 'Monitor'
	    </cfquery>
		
    </cfif>

    <cfquery name="getAction" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            SELECT  *
            FROM    WarehouseBatchAction
            WHERE   BatchNo      = '#url.batchno#'
            AND     ActionCode   = 'Monitor'           
    </cfquery>
	
</cftransaction>

<cfoutput>
    <script>
        <cfif getAction.recordCount eq 1 AND getAction.ActionStatus eq "1">
            $('##customerView#url.batchno#').css('color','###url.colorOn#').removeClass('#url.iconoff#').addClass('#url.iconon#');
        <cfelse>    
            $('##customerView#url.batchno#').css('color','###url.colorOff#').removeClass('#url.iconon#').addClass('#url.iconoff#');
        </cfif>
    </script>
</cfoutput>