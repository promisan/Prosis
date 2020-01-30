
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

<cfset link = "Procurement/Application/PurchaseOrder/Purchase/POViewGeneral.cfm?id1=#Purchase.PurchaseNo#">

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
	TableWidth       = "99%"
	DocumentStatus   = "0">		
	
	<!---	EntityGroup      = "#Job.JobCategory#" --->

</cfoutput>