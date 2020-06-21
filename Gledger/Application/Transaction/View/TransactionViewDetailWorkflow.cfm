
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