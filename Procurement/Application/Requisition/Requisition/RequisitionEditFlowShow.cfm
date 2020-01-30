
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR><TD>

<cfparam name="URL.EntityClass" default="">

<cfloop index="itm" list="#url.ajaxid#" delimiters="_"></cfloop>

<cfif URL.EntityClass neq "">
	
	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  RequisitionLine
		SET     EntityClass  = '#URL.entityclass#' 
		WHERE   RequisitionNo = '#itm#'
	</cfquery>

</cfif>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM RequisitionLine L
	WHERE RequisitionNo = '#itm#'
</cfquery>


<cfset link = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?id=#Line.RequisitionNo#">
 	
<cfif Line.actionStatus eq "1" or Line.actionStatus eq "0">
   <cfset p = "Yes"> 
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
 					
<cf_ActionListing 
	    EntityCode       = "ProcReq"
		EntityClass      = "#Line.EntityClass#"
		EntityClassReset = "1"
		EntityGroup      = ""
		EntityStatus     = ""
		CompleteFirst    = "No"
		OrgUnit          = "#Line.OrgUnit#"
		Mission          = "#Line.Mission#"
		ObjectReference  = "#Line.RequisitionNo#"
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

