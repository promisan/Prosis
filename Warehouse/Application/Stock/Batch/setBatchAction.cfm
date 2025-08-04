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
	