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

<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Invoice
		WHERE  InvoiceId = '#URL.AjaxID#'
</cfquery>

<cfquery name="InvoiceIncoming" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   InvoiceIncoming
	WHERE  Mission = '#Invoice.Mission#'
	AND    OrgUnitOwner  = '#Invoice.OrgUnitOwner#'
	AND    OrgUnitVendor = '#Invoice.OrgUnitVendor#'
	AND    InvoiceNo = '#Invoice.InvoiceNo#'
</cfquery>

<cfset link = "Procurement/Application/Invoice/Matching/InvoiceMatch.cfm?id=#URL.Ajaxid#">
			
	<cfif Invoice.ActionStatus eq "9">
	  <cfset hide  = "Yes">
	<cfelse>
	  <cfset hide  = "No">				
	</cfif>	
																	
	<cfquery name="Check" 
	datasource="AppsOrganization">
	SELECT * 
	FROM   Ref_EntityClass
	WHERE  EntityCode  = 'ProcInvoice'
	AND    EntityClass = '#Invoice.EntityClass#'								
	</cfquery>	
					
   <cfif check.recordcount eq "1">
   
   		 <cfif Invoice.orgunitvendor neq "0">	
		 
			 <cfquery name="OrgUnit" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM Organization
					WHERE OrgUnit = '#Invoice.orgunitvendor#'
				</cfquery>	
			
			<cfset ref = OrgUnit.OrgUnitName>
			
		<cfelse>
		
			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM  Person
				WHERE PersonNo = '#InvoiceIncoming.PersonNo#' 
			</cfquery>	
			
			<cfset ref = Person.LastName>

		</cfif>		
			
		 					
	   <cf_ActionListing 
	    TableWidth       = "98%"
	    EntityCode       = "ProcInvoice"
		EntityClass      = "#Invoice.EntityClass#"
		EntityClassReset = "1"
		EntityGroup      = "#Invoice.OrderType#"
		EntityStatus     = ""		
		Annotation       = "No"
		AjaxId           = "#URL.AjaxId#"							
		HideCurrent      = "#hide#" <!--- prevents generation as well --->
		Mission          = "#Invoice.Mission#"
		OrgUnit          = "#Invoice.OrgUnitOwner#"
		ObjectReference  = "#Invoice.InvoiceNo#"
		ObjectReference2 = "#ref#"
		ObjectKey4       = "#Invoice.InvoiceId#"
	  	ObjectURL        = "#link#"
		DocumentStatus   = "#Invoice.ActionStatus#">
		
	
	</cfif>