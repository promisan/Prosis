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

<cfquery name="get" 
   datasource="AppsMaterials"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Request
	   WHERE  RequestId = '#URL.Id#'
</cfquery>	   

<cfquery name="qUpdate" 
   datasource="AppsMaterials"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE RequestTask
	   SET    RecordStatus        = '3',	         
	          RecordStatusDate    = getDate(), 
			  RecordStatusOfficer = '#SESSION.acc#',
			  DeliveryStatus      = '3'
	   WHERE  RequestId           = '#URL.Id#'
	   AND    TaskSerialNo        = '#URL.tn#'
</cfquery>	  

<!--- ---------------------------------- --->
<!--- set the status of the request line --->
<!--- ---------------------------------- --->
		
<cf_setRequestStatus requestid = "#url.Id#">

<cfoutput>

<script>
	document.getElementById('r'+'#URL.Id#'+'_'+'#URL.tn#').className = 'highLight4';
	
	try {	
	if (opener.document.getElementById('tasktreerefresh')) {				
        opener.ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
    }	
	} catch(e) {}
	
	try {	
	if (document.getElementById('tasktreerefresh')) {				
        ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#get.mission#&warehouse=#get.warehouse#','tasktreerefresh')
    }	
	} catch(e) {}
	
</script>	

</cfoutput>		   	   