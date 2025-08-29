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
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM RequisitionLineService 
		 WHERE RequisitionNo = '#URL.ID#'
		 AND Serviceid = '#URL.ID2#'
</cfquery>


<cfquery name="Total" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT  SUM(ServiceQuantity * Quantity * UoMRate) AS Total
		 FROM    RequisitionLineService
		 WHERE   RequisitionNo      = '#URL.ID#'		 
</cfquery>

<cfquery name="Update" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   UPDATE RequisitionLine 
	   SET    RequestQuantity    = '1',
	          RequestCostPrice   = '#Total.Total#',
	          RequestAmountBase  = '#Total.Total#'  
	   WHERE  RequisitionNo      = '#URL.ID#'		  
</cfquery>

<cfoutput>

<script>	
	try { document.getElementById("requestquantity").value = "1"	
	      document.getElementById("requestcostprice").value = "#Total.Total#"	
	} catch(e) {}
	base2('#url.id#','#Total.Total#','1')	
	tagging()
	ptoken.navigate('../Service/ServiceItem.cfm?ID=#URL.ID#&ID2=new','iservice') 
</script>		

</cfoutput>