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

 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase 
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine)
</cfquery>	

<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderClass
		WHERE  Code = '#PO.OrderClass#' 
</cfquery>
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<cfif PurchaseClass.PurchaseTemplate neq "">
	<cfset tmp = "#PurchaseClass.PurchaseTemplate#">
<cfelseif Parameter.PurchaseTemplate neq "">
    <cfset tmp = "#Parameter.PurchaseTemplate#"> 
<cfelse>
	<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">  
</cfif>

<cfif PO.PrintDocumentId neq "">

	<cfoutput>
	
		<script>	
			window.location =  "#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#url.id1#&docid=#PO.PrintDocumentId#"	
		</script>
	
	</cfoutput>

<cfelse>
	
	<cfoutput>
	
		<script>	
			window.location =  "#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#url.id1#&templatepath=#tmp#"	
		</script>
	
	</cfoutput>
	
</cfif>	