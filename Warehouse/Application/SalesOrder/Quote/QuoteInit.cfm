
<!--- reload quote --->

<cfoutput>
<cfquery name="getBatch"
	datasource="AppsMaterials"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  RequestNo = '#URL.RequestNo#'
</cfquery>

<cfif getBatch.BatchNo eq "">

	<script>
    	ptoken.navigate('#session.root#/warehouse/application/salesOrder/POS/Sale/SaleInit.cfm?systemfunctionid=#url.systemfunctionid#&scope=#url.scope#&mission=#getBatch.mission#&warehouse=#getBatch.warehouse#&requestNo=#url.requestNo#','content')			
	</script>

<cfelse>

	<script>			
		ptoken.navigate('#SESSION.root#/Warehouse/Application/Stock/Batch/BatchView.cfm?batchNo=#getBatch.BatchNo#&mode=embed','content')			
	</script>

</cfif>
</cfoutput>