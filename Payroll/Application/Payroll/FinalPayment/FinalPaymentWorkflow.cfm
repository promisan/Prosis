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
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Payroll.dbo.EmployeeSettlement ES
	  WHERE      SettlementId = '#url.ajaxid#'	           
</cfquery> 

<cfquery name="person"
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      SELECT     *
      FROM       Person
	  WHERE      PersonNo = '#get.PersonNo#'	           
</cfquery>

<cfset link = "Payroll/Application/Payroll/FinalPayment/FinalPaymentView.cfm?settlementid=#url.ajaxid#">

<cfif get.source eq "Force">
	<cfset cl = "Offcycle">
<cfelse>
	<cfset cl = "Standard">
</cfif>

 <cf_ActionListing 
    EntityCode       = "FinalPayment"
	EntityClass      = "#cl#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#get.Mission#"
	PersonNo         = "#get.PersonNo#"						
	ObjectReference  = "Separation and Final Payment"												
	ObjectReference2 = "#Person.FirstName# #Person.LastName# #Person.IndexNo#"	
    ObjectKey1       = "#get.PersonNo#"
	ObjectKey4       = "#get.SettlementId#"
	AjaxId           = "#get.SettlementId#"
	ObjectURL        = "#link#"
	Show             = "Yes">					