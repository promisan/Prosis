
<!--- show workflow object --->

<cfoutput>
	
	<cfquery name="get" 
		 datasource="AppsWorkorder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT  *
		   FROM    WorkOrder P, ServiceItem S
		   WHERE   P.ServiceItem = S.Code
		   AND     P.WorkOrderId = '#url.ajaxid#'	 
	</cfquery>
	
	<cfset link = "Workorder/Application/Workorder/WorkorderView/WorkOrderview.cfm?workorderid=#url.ajaxid#">
	
	<!--- if status eq "9", do not initiate a workflow --->
		
	<cfif get.ActionStatus eq "9">
	 <cfset hide = "Yes">
	<cfelse>
	 <cfset hide = "No">
	</cfif> 
					   			   				
	<cf_ActionListing 
	    EntityCode       = "WrkStatus"
		EntityClass      = "#get.ServiceClass#"			
		EntityStatus     = ""	
		Mission          = "#get.Mission#"
		OrgUnit          = ""
		HideCurrent      = "#hide#"
		ObjectReference  = "#get.Reference#"	
		ObjectReference2 = "#get.Description#"	
		ObjectKey4       = "#url.ajaxid#"	
	  	ObjectURL        = "#link#"
		AjaxId           = "#URL.ajaxid#"
		Show             = "Yes"
		ActionMail       = "Yes"
		PersonNo         = ""
		PersonEMail      = ""
		TableWidth       = "99%"
		DocumentStatus   = "0">		
	
</cfoutput>

