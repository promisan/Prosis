
<!--- save and show --->

<cfset dateValue = "">
<CF_DateConvert Value="#url.datevalue#">
<cfset dte = dateValue>

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseBatchAction
		WHERE    BatchNo           = '#URL.BatchNo#'
		AND      ActionCode        = '#url.action#'
</cfquery>

<cfif get.recordcount eq "1">

	<cfquery name="set"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  WarehouseBatchAction
			SET     ActionDate       = #dte#, 
			        ActionStatus     = '1', 
					OfficerUserId    = '#session.acc#',
					OfficerLastName  = '#session.last#',
					OfficerFirstName = '#session.first#'		
			WHERE   BatchNo           = '#URL.BatchNo#'
			AND     ActionCode        = '#url.action#'
	</cfquery>

<cfelse>

	<cfquery name="set"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WarehouseBatchAction
			(BatchNo,ActionCode,ActionDate,ActionStatus,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES 
			('#URL.BatchNo#','#url.action#',#dte#,'1','#session.acc#','#session.last#','#session.first#')							
	</cfquery>

</cfif>

<cfoutput>

<table width="100%">
	<tr class="labelmedium">
	<td>
	
	<!--- obtain collection date --->
	
	<cfquery name="BatchCollection"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseBatchAction
		WHERE    BatchNo           = '#URL.BatchNo#'
		AND      ActionCode        = '#url.action#'
	</cfquery>					
	#dateformat(BatchCollection.ActionDate,CLIENT.DateFormatShow)#	
	</td>
	<td align="right" style="padding-right:3px">
	    <cf_img icon="edit" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setBatchAction.cfm?action=#url.action#&systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#','#url.action#')">															
	</td>	
	</tr>
	
</table>

</cfoutput>

