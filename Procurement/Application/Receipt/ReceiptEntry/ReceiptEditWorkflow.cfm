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
<cfquery name="Receipt" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Receipt 
		 WHERE  ReceiptNo = '#url.ajaxid#'		
</cfquery>

<cfset link = "Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?id=#url.ajaxid#&mode=receipt">

<cfif Receipt.ActionStatus eq "9">
   <cfset cpl = "Yes">
<cfelse>
   <cfset cpl = "No">
</cfif>

<cf_ActionListing 
    EntityCode       = "ProcReceipt"
	EntityClass      = "#Receipt.EntityClass#"
	EntityClassReset = "1"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Receipt.Mission#"
	OrgUnit          = ""
	ObjectReference  = "#Receipt.ReceiptNo#"
	ObjectReference2 = "#Receipt.ReceiptReference2#"
	ObjectKey1       = "#Receipt.ReceiptNo#"			
  	ObjectURL        = "#link#"
	Show             = "Yes"
	ActionMail       = "Yes"
	AjaxId           = "#URL.AjaxId#"
	CompleteCurrent  = "#cpl#"
	PersonNo         = ""
	PersonEMail      = ""
	TableWidth       = "100%"
	DocumentStatus   = "0">		
	