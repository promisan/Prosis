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
<cfquery name="GetWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT * 
	FROM   WarehouseJournal 
	WHERE  Area = 'SETTLE'
	AND    Warehouse = ( SELECT Warehouse
						 FROM   WarehouseBatch
				         WHERE  BatchId = '#URL.batchid#')		
						 		 
						 				 
</cfquery>	

<cfif GetWarehouse.eMailTemplate neq "">
	<cfinclude template="../../../../../#GetWarehouse.emailTemplate#">
<cfelse>
	<cf_receiptStandard batchId="#url.batchid#">	
</cfif>

<table><tr class="labelmedium2"><td><cf_tl id="Mail sent"></td></tr></table>

	