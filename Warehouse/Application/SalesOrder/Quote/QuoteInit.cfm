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