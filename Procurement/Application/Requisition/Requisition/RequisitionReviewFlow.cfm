
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<cfset itm = right(url.ajaxid,len(url.ajaxid)-7)>
	
	<tr><td id="review_<cfoutput>#itm#</cfoutput>">
			
	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT L.*
	    FROM   RequisitionLine L
		WHERE  RequisitionNo = '#itm#' 
	</cfquery>
	
	<cfset link = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?id=#Line.RequisitionNo#">
	
	<!--- we do not allow to revert it once it reaches a purchase 
	    level otherwise we allow 18/1/2013 before we checked on the requisition.ActionStatus > 2 --->
	
	<cfquery name="CheckPurchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PurchaseLine
		WHERE  RequisitionNo = '#itm#' 
		AND    ActionStatus != '9'
	</cfquery>
	
	<cfif CheckPurchase.recordcount eq "0">
	   <cfset p = "Yes">	  <!--- disable processing --->
	<cfelse>
	   <cfset p = "No">  
	</cfif>
	
	<cfif Line.ActionStatus eq "9">
	   <cfset c = "Enforce">
	<cfelseif Line.ActionStatus eq "3">
	   <cfset c = "Enforce">   
	<cfelse>
	   <cfset c = "No">
	</cfif>
	
	<cfif Line.caseNo neq "">
	  <cfset ref = "#Line.CaseNo# (#Line.RequisitionNo#)">
	<cfelse>
	  <cfset ref = "#Line.RequisitionNo#">  
	</cfif>
			 					
	<cf_ActionListing 
	    EntityCode       = "ProcReview"		
		EntityClassReset = "0"
		EntityGroup      = ""
		EntityStatus     = ""
		CompleteFirst    = "Yes"
		OrgUnit          = "#Line.OrgUnit#"
		Mission          = "#Line.Mission#"
		ObjectReference  = "#ref#"
		ObjectReference2 = "#Line.RequestDescription#"
		ObjectKey1       = "#Line.RequisitionNo#"
	  	ObjectURL        = "#link#"
		AjaxId           = "#URL.AjaxId#"
		Show             = "Yes" 
		AllowProcess     = "#p#" 
		HideCurrent      = "#c#"
		DocumentStatus   = "0">
		
	</td></tr>

</table>

