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
		WHERE  PurchaseNo ='#URL.purchaseno#'
		AND    PurchaseNo IN (SELECT PurchaseNo FROM PurchaseLine)
</cfquery>	

<cfinvoke component="Service.Access"
	   Method="procApprover"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ApprovalAccess">	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>


<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_POLines">
		
<cfif Parameter.InvoiceRequisition eq "1">	  
	<cfinclude template="POViewGeneralLinesExcel_Balance.cfm"> 
<cfelse>  
	<cfinclude template="POViewGeneralLinesExcel_Regular.cfm"> 
</cfif> 
      
<cfset client.table1   = "#SESSION.acc#_POLines">