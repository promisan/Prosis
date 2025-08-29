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
<cfparam name="url.warehouse" default="">
<cfparam name="url.location" default="">
<cfparam name="url.itemno" default="">
<cfparam name="url.uom" default="">

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->

<cfquery name="Select" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT * 
   FROM   #tableName#
   WHERE  TransactionId = '#URL.ID#'
</cfquery>

<cfset url.tratpe = "#Select.TransactionType#">

<cfquery name="Delete" 
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM #tableName#
	WHERE  TransactionId = '#URL.ID#'
</cfquery>

<cfoutput>

	<script language="JavaScript">
	 se = document.getElementsByName('line_#url.id#')
	 var count = 0
	 while (se[count]) {
	     se[count].className = "hide"
	     count++
	 }
	 
	 if (document.getElementById("logtotals")) {
	     ptoken.navigate('../Transaction/TransactionLogSheetTotal.cfm?systemfunctionid=#url.systemfunctionid#&tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','logtotals')		
	 }
	 	 
	</script>

</cfoutput>








