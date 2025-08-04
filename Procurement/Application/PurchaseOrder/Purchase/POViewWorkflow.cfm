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

<cfoutput>

<cfquery name="Purchase" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  P.*
	   FROM    Purchase P
	   WHERE   P.Purchaseno = '#url.ajaxid#'	 
</cfquery>

<cfif Purchase.OrgUnitVendor neq "0">
	
	<cfquery name="Org" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT  *
		   FROM    Organization
		   WHERE   OrgUnit = '#Purchase.OrgUnitVendor#'	 
	</cfquery>
	
	<cfset ref = "#Org.OrgUnitName#">

<cfelse>

	<cfquery name="Person" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT  *
		   FROM    Person
		   WHERE   PersonNo = '#Purchase.PersonNo#'	 
	</cfquery>
	
	<cfset ref = "#Person.LastName#">


</cfif>

<cfset link = "Procurement/Application/PurchaseOrder/Purchase/POView.cfm?id1=#Purchase.PurchaseNo#">

<!--- if status eq "9", do not initiate a workflow --->

<cfif Purchase.ActionStatus eq "9">
 <cfset hide = "Yes">
<cfelse>
 <cfset hide = "No">
</cfif> 
				   			   				
<cf_ActionListing 
    EntityCode       = "ProcPO"
	EntityClass      = "#Purchase.OrderClass#"			
	EntityStatus     = ""	
	Mission          = "#Purchase.Mission#"
	OrgUnit          = ""
	HideCurrent      = "#hide#"
	ObjectReference  = "#Purchase.PurchaseNo#"
	ObjectReference2 = "#ref#"
	ObjectKey1       = "#Purchase.PurchaseNo#"	
  	ObjectURL        = "#link#"
	AjaxId           = "#URL.AjaxId#"
	Show             = "Yes"
	ActionMail       = "Yes"
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "100%"
	DocumentStatus   = "0">		
	
	<!---	EntityGroup      = "#Job.JobCategory#" --->

</cfoutput>