
<cftransaction>
		
	<!--- update workflow --->
	<cfquery name="Delete" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE WorkOrderLineAsset			  
			 SET    Operational = 0
			 WHERE  WorkOrderId = '#URL.WorkOrderId#'
			 AND    TransactionId = '#URL.ID2#'
	</cfquery>

</cftransaction>

<cfset url.id2 = "">

<script>
	document.getElementsByName('assetmode')[0].checked = true
</script>

<cfinclude template="Line.cfm">

