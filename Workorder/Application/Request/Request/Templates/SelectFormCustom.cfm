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
<!--- compression --->
<cf_compression>
<!--- ----------- --->

<cfparam name="url.workorderlineid" default="">
<cfparam name="url.requestaction"   default="">
<cfparam name="url.requestid"       default="">
<cfparam name="url.domain"          default="">

<cfquery name="serviceitem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code        = '#url.ServiceItem#'		
</cfquery>

<cfif url.requestid neq "">

	<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Request			
		WHERE  RequestId   = '#url.requestid#'		
	</cfquery>				
	
	<cfset url.requestaction = Request.RequestAction>
	
<cfelseif url.requestaction eq "" or url.requestaction eq "undefined">
	
	<cfquery name="getAction" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_RequestWorkflow
		WHERE  RequestType   = '#url.requestType#' 
		AND    ServiceDomain = '#serviceitem.servicedomain#'		
		ORDER BY RequestAction
	</cfquery>

	<cfset url.requestaction = getAction.RequestAction>
		
</cfif>
	
<cfquery name="getForm" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_RequestWorkflow
	WHERE  RequestType   = '#url.requestType#' 
	AND    ServiceDomain = '#serviceitem.servicedomain#'		
	AND    RequestAction = '#url.requestAction#' 	
	ORDER BY RequestAction
</cfquery>

<cfset passtruform = getForm.CustomForm>
<cfset param       = getForm.CustomFormCondition>

<cfoutput>

	<cfif getForm.isAmendment eq "1">
			
		<script>
					
		 	 document.getElementById("line").className          = "regular"	
			 document.getElementById("detail").className        = "hide" 		
			 
			 <cfif passtruform neq "">
			    document.getElementById("detail").className = "regular" 			 
			    ColdFusion.navigate('../Templates/#passtruform#?requesttype=#url.requesttype#&requestaction=#url.requestaction#&mission=#url.mission#&requestid=#url.requestid#&workorderlineid=#url.workorderlineid#&accessmode=#url.accessmode#&serviceitem=#url.serviceitem#&mode=#param#','contentdetail')
		     </cfif>
		</script>
	
	<cfelse>
			
		<script>
						
			 document.getElementById("line").className          = "hide"
			 document.getElementById("detail").className        = "regular" 			 
			 ColdFusion.navigate('../Templates/RequestService.cfm?scope=#url.scope#&requesttype=#url.requesttype#&requestaction=#url.requestaction#&mission=#url.mission#&requestid=#url.requestid#&serviceitem=#url.serviceitem#&accessmode=#url.accessmode#&param=#param#','contentdetail')		
			 
		</script>
	
	</cfif>

</cfoutput>
	