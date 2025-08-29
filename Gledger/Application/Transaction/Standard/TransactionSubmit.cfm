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
<cfparam name="Form.Party" default="Vendor">

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
</cfquery>

<cfoutput> 

   <cfif ParameterExists(Form.TransactionDate) and Form.TransactionDate neq "">
       <cfset dateValue = "">
	      <CF_DateConvert Value="#Form.transactionDate#">
	   <cfset dte = dateValue>
   </cfif>
   
   <cfif ParameterExists(Form.actionBefore) and Form.actionBefore neq "">
      <cfset dateValue = "">
        <CF_DateConvert Value="#Form.actionBefore#">
      <cfset dtebefore =  dateValue>
   <cfelse>	
      <cfset dtebefore = dte>	
   </cfif>
	
   <cfif ParameterExists(Form.documentdate) and Form.documentDate neq "">

    <cfset dateValue = "">
      <CF_DateConvert Value="#Form.documentdate#">
	  <cfset dtedoc = dateValue>	
	<cfelse>	
      <cfset dtedoc = dte>	
	</cfif>
	   
</cfoutput> 

<cfoutput query="HeaderSelect">

	<cfset Mission             = Mission>
	<cfset OrgUnitOwner        = Form.OrgUnitOwner>
	<cfset OrgUnitTax          = OrgUnitTax>
	<cfset TraCat              = TransactionCategory>
	<cfset ContraGLAccount     = FORM.GLAccount>
	<cfset ContraGLAccountType = FORM.debitcredit>
	
	<cfif FORM.actionDiscountDays neq "">
	
	         <cfset dtediscount = dtedoc + FORM.actionDiscountDays>
			 
			 <cfif FORM.actiondays neq "">
	    		   <!----<cfset dtebefore   = dtedoc + FORM.actiondays>	 since it's not a date format, it gets +2 days--->
				   <cfset dtebefore   = DateAdd("d",Form.actiondays,dtedoc)>	
			 </cfif>	 
			 
			 <cfif dtediscount gt dtebefore>
			   <cfset dtebefore = dtediscount>
			 </cfif>
	<cfelse> <cfset dtediscount = dtedoc>
	</cfif>
	
</cfoutput> 

<cfquery name="hasPriorWorkflow"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      OrganizationObject
	WHERE     ObjectKeyValue4 = '#HeaderSelect.TransactionId#'
	AND	      Operational = 1
</cfquery>

<cfif hasPriorWorkflow.recordcount eq "1">

	<cfquery name="resetPriorWorkflow"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    OrganizationObject
		SET       Operational = 0
		WHERE     ObjectKeyValue4 = '#HeaderSelect.TransactionId#'	
	</cfquery>
	
	<cfset trid = HeaderSelect.TransactionId>

</cfif>

<cftransaction>
	
	<!--- -------- --->
    <!--- post now --->
	<!--- -------- --->
						
	<cfinclude template="TransactionSubmitPosting.cfm"> 
		
</cftransaction>

<!--- ----------------- --->
<!--- generate workflow --->
<!--- ----------------- --->

<cfif (HeaderSelect.TransactionSource eq "SalesSeries" or 
      HeaderSelect.TransactionSource eq "ReceiptSeries" or 	  
	  HeaderSelect.TransactionSource eq "PurchaseSeries") and HasPriorWorkFlow.recordcount eq "0">

	<!--- 18/8 no workflow here to be created in case of edit of merged sourced transaction --->

<cfelse>
	
	<cfquery name="Jrn" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
			SELECT *
			FROM   Journal
			WHERE  Journal = '#HeaderSelect.Journal#'
	</cfquery>
	
	<cfif OrgUnitOwner eq "0">			   
	     <cfset org = "">			   
    <cfelse>			   
	     <cfset org = "#OrgUnitOwner#">				  
    </cfif>
	
	<cfset link = "gledger/application/transaction/view/TransactionView.cfm?id=#trid#">
	
	<cf_ActionListing 
		    TableWidth       = "100%"
		    EntityCode       = "GLTransaction"
			EntityClass      = "#Jrn.EntityClass#"
			EntityGroup      = ""
			EntityStatus     = ""
			Show             = "No"
			CompleteFirst    = "Yes"
			Mission          = "#Mission#"
			OrgUnit          = "#org#"
			ObjectReference  = "#Jrn.Description#"
			ObjectReference2 = "#FORM.Description# : #TraNo#"
			ObjectKey4       = "#trid#"
		  	ObjectURL        = "#link#"
			DocumentStatus   = "0">
		
</cfif>		

<!--- closing the windows --->
<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>

<cfif url.closewindow eq 1>
	<script language='JavaScript'>
		try {parent.opener.document.getElementById('apply').click();} catch(e) {
			try {parent.opener.history.go();} catch(e) {}
		}
		parent.window.close()
		//try {parent.history.go() } catch(e) {}
		ptoken.open('#session.root#/gledger/application/transaction/view/TransactionView.cfm?id=#trid#&mid=#mid#');
	</script>
<cfelse>
	<script language='JavaScript'>
		ptoken.open('#session.root#/gledger/application/transaction/view/TransactionView.cfm?id=#trid#&mid=#mid#');
		try {parent.history.go() } catch(e) {}
	</script>
</cfif>

</cfoutput>
