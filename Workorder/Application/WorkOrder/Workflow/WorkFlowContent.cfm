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

