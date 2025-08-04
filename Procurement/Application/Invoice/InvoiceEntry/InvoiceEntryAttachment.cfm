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
<cfparam name="access"                default="">
<cfparam name="Invoice.ActionStatus"  default="">

<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Invoice
		WHERE  InvoiceId = '#URL.ID#'
</cfquery>

<cfquery name="Purchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   InvoicePurchase IP, Purchase P
	WHERE  IP.PurchaseNo = P.PurchaseNo
	AND    IP.InvoiceId = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<!--- the mission determines if a document server or file server is used ---> 

<cfquery name="Param" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_Mission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="Check" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
	FROM   Organization.dbo.OrganizationObject
	WHERE  EntityCode    = 'ProcInvoice'
	AND    ObjectKeyValue4 = '#URL.ID#'
</cfquery>	

<cfinvoke component     = "Service.Access"  
	   method           = "RoleAccess" 
	   Role             = "'ProcInvoice'"
	   Mission          = "#url.mission#" 
	   Unit             = "#Invoice.OrgUnitOwner#"
	   Parameter        = "#Purchase.OrderClass#"
	   AccessLevel      = "'1','2'"	   
	   returnvariable   = "accessinvoice"> 	  	   

<cfif  (access neq "") and (Access eq "Edit" or Access eq "All" or accessinvoice eq "GRANTED" or Invoice.ActionStatus eq "0" or Invoice.ActionStatus eq "9" or Check.recordcount eq "0") >

	<cf_filelibraryN
		DocumentPath   = "#Parameter.InvoiceLibrary#"
		SubDirectory   = "#URL.ID#" 
		DocumentServer = "#Param.DocumentServerMode#" <!--- No|Anonymous|Individual --->
		Filter=""
		Insert="yes"
		Remove="yes"
		reload="true">	
			
<cfelse>

	<cf_filelibraryN
		DocumentPath="#Parameter.InvoiceLibrary#"
		SubDirectory="#URL.ID#" 
		DocumentServer="#Param.DocumentServerMode#" <!--- No|Anonymous|Individual --->
		Filter=""
		Insert="no"
		Remove="no"
		reload="true">	

</cfif>	

