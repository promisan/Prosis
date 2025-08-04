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

