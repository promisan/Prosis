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

<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
	    FROM      Purchase
		WHERE     PurchaseNo = '#URL.PurchaseNo#' 		
</cfquery>  

<cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     Ref_ModuleControl
		WHERE    SystemModule  = 'Procurement' 
		AND      FunctionClass = 'Application' 
		AND      FunctionName  = 'Requisition Management'
</cfquery>  
	
<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
	    FROM      PurchaseLine
		WHERE     PurchaseNo   = '#URL.PurchaseNo#' 
		AND       ActionStatus != '9'
</cfquery>  

<cfoutput>
	
<cfloop query="Get">

	<cf_copyRequisitionLine requisitionNoFrom="#requisitionno#" workorder="No" ActionStatus="3">

</cfloop>

<cf_tl id="Purchase order requisitions were cloned" var="vMessage" class="message">
	
<script language="JavaScript">
	
		alert('#vMessage#.');		
		ptoken.open("#session.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?mission=#Purchase.Mission#&SystemFunctionId=#System.SystemFunctionId#","req_#purchase.mission#")
		
		<!--- ,"left=30, top=30, width=#client.widthfull-80#, height=#client.height-80#, status=yes, toolbar=no, scrollbars=no, resizable=yes") --->
		
</script>

</cfoutput>