
<cfparam name="url.warehouse" default="">

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
	     ColdFusion.navigate('../Transaction/TransactionLogSheetTotal.cfm?systemfunctionid=#url.systemfunctionid#&tratpe=#url.tratpe#&mode=#url.mode#&warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','logtotals')		
	 }
	 	 
	</script>

</cfoutput>








