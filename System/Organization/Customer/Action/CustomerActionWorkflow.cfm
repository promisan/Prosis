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
<cfset wflink = "System/Organization/Customer/Action/ActionListing.cfm?CustomerActionId=#url.ajaxid#">
				
<cfquery name="CustomerAction" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    CustomerAction 
	WHERE   CustomerActionId = '#url.ajaxid#'	
</cfquery>

<cfquery name="Customer" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Customer
	WHERE   CustomerId = '#CustomerAction.customerid#'	
</cfquery>

<cfquery name="Object" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Organization.dbo.OrganizationObject
	WHERE   ObjectKeyValue4 = '#url.ajaxid#'	
</cfquery>
	
<cfquery name="Action" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Ref_Action
	WHERE   Code = '#CustomerAction.ActionClass#'	
</cfquery>

<cf_ActionListing 
    EntityCode       = "WrkCustomer"
	EntityClass      = "#Object.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Customer.Mission#"	
	ObjectReference  = "#Customer.CustomerName#"
	ObjectReference2 = "#Action.Description#"	  
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "Yes"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No"> 

	



			