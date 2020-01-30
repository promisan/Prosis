
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