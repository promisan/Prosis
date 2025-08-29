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
<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->


<cfquery name="qDeleteLines" 
	datasource="AppsTransaction" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	DELETE FROM #tableName#
	WHERE TransactionId = '#URL.id#'		   
</cfquery>	

<cfoutput>
	
	<script language="JavaScript">
		$('##line_#URL.id#').remove();
		$('##line_#URL.id#_asset').remove();
		$('##line_#URL.id#_location').remove();
		$('##line_#URL.id#_remarks').remove();
		$('##line_#URL.id#_dot').remove();		
		$('##line_#URL.id#_attach').remove();	
		
	</script>
	
</cfoutput>