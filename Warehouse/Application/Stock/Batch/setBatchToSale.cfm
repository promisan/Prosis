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
<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B,
	         Ref_TransactionType R
	WHERE    B.TransactionType = R.TransactionType	
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>

<cfquery name="Customer"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseLocation L	
	WHERE    Warehouse = '#Batch.Warehouse#'
	AND      Location  = '#Batch.Location#'	
</cfquery>

<cfquery name="checkProcess"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseBatch 
		WHERE    ParentBatchNo = '#Batch.BatchNo#'
</cfquery>

<cfif Batch.recordcount eq "1" and checkProcess.recordcount eq "0">

	<cfinvoke component   = "Service.Process.Materials.POS"  
		   method         = "IssuanceToSale" 
		   BatchNo        = "#Batch.BatchNo#"		   		   
		   Warehouse      = "#Batch.Warehouse#"  	  
		   CustomerId     = "#Customer.DistributionCustomerId#"		  
		   returnvariable = "Sale">			
		   
	<cfoutput>	
	<script>
		ptoken.open('../../SalesOrder/POS/Sale/SaleInit.cfm?mode=sale&systemfunctionid=#url.systemfunctionid#&mission=#Batch.mission#&warehouse=#Batch.Warehouse#&customerid=#Customer.DistributionCustomerId#','_self')
	</script>	
	</cfoutput>	   

</cfif>

	