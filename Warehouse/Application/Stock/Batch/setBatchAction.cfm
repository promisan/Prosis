
<cfparam name="url.action" default="Collection">

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B
	WHERE    BatchNo           = '#URL.BatchNo#'	
</cfquery>

<cfquery name="Action"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatchAction B
	WHERE    BatchNo           = '#URL.BatchNo#'
	AND      ActionCode = '#url.action#'
</cfquery>

<cfoutput>

<!-- <cfform> -->

<table style="width:100%"><tr><td>
	
	<cfif Action.ActionDate eq "">
	
		<cf_intelliCalendarDate9
			FieldName="date#url.action#" 
			Manual="True"		
			class="regularxl"					
			DateValidStart="#Dateformat(Batch.TransactionDate, 'YYYYMMDD')#"				
			Default="#Dateformat(Batch.TransactionDate, client.dateformatshow)#"
			AllowBlank="False">	
	
	<cfelse>
	
		<cf_intelliCalendarDate9
			FieldName="date#url.action#" 
			Manual="True"		
			class="regularxl"					
			DateValidStart="#Dateformat(Batch.TransactionDate, 'YYYYMMDD')#"				
			Default="#Dateformat(Action.ActionDate, client.dateformatshow)#"
			AllowBlank="False">	
	
	</cfif>
	
	</td>
	<td style="padding-top:3px;padding-right:3px" align="right">			
	   <img src="#SESSION.root#/images/save.png" height="19" width="19" alt="" border="0" 
	    onclick="ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/setBatchActionSubmit.cfm?batchno=#url.batchno#&systemfunctionid=#url.systemfunctionid#&action=#url.action#&datevalue='+document.getElementById('date#url.action#').value,'#url.action#')">										
	</td>
					
	</tr>
</table>


<!-- </cfform> -->

</cfoutput>

<cfset ajaxonload("doCalendar")>
	