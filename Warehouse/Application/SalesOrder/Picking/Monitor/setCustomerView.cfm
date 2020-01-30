
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