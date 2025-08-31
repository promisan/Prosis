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
<cfset link = "Gledger/Application/Transaction/View/TransactionView.cfm?id=#url.ajaxid#">
	 
<cfquery name="Transaction" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionHeader
	WHERE   TransactionId = '#URL.ajaxid#'
</cfquery>
  
   
<cfquery name="Jrn" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM    Journal
	WHERE   Journal = '#Transaction.Journal#'
</cfquery>
  
<cfif Transaction.OrgUnitOwner eq "0">			   
      <cfset org = "">			   
<cfelse>			   
      <cfset org = "#Transaction.OrgUnitOwner#">				  
</cfif>

  				
<cf_ActionListing 
    TableWidth       = "100%"
    EntityCode       = "GLTransaction"
	EntityClass      = "#Jrn.EntityClass#"
	EntityGroup      = ""  <!--- to be configured --->	
	CompleteFirst    = "Yes"
	Mission          = "#Transaction.Mission#"
	OrgUnit          = "#org#"
	AjaxId           = "#url.ajaxid#"
	ObjectReference  = "#Jrn.Description#"
	ObjectReference2 = "#Transaction.Description# : #Transaction.JournalTransactionNo#"
	ObjectKey4       = "#url.ajaxid#"
  	ObjectURL        = "#link#"
	DocumentStatus   = "#Transaction.ActionStatus#">