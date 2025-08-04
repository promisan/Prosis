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
<cfoutput>

	<!--- -------------- --->
	<!--- - dialog wf  - --->
	<!--- -------------- --->	
	<cfset l = len(url.ajaxid)>
	
	<cfif l eq 37 and mid(url.ajaxId,1,1) eq "c">	
		<cfset id = mid(url.ajaxid, 2, l-1)>			
	<cfelse>
		<cfset id = url.ajaxid>		
	</cfif>		
	
			
	<script>
	try {		
		//applyfilter('1','','#id#')			
	} catch(e) {}			
	</script>		
			    		
	<cfquery name="Doc" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  OrganizationObject
		WHERE ObjectKeyValue4 = '#id#' 
		AND   Operational     = 1
	</cfquery>
		
	<cfif Doc.recordcount gte "1">
						
	   <cf_ActionListing 
	    TableWidth       = "100%"
	    EntityCode       = "#Doc.EntityCode#"
		EntityClass      = "#Doc.EntityClass#"
		EntityGroup      = "#Doc.EntityGroup#"
		Mission          = "#Doc.Mission#"
		OrgUnit          = "#Doc.OrgUnit#"
		PersonNo         = "#Doc.PersonNo#" 
		Communicator     = "Yes"
		Annotation       = "No"
		ObjectReference  = "#Doc.ObjectReference#"
		ObjectReference2 = "#Doc.ObjectReference2#" 
		ObjectKey1       = "#doc.ObjectKeyValue1#"
		ObjectKey4       = "#doc.ObjectKeyValue4#"
		ObjectURL        = "#doc.ObjectURL#"
		AjaxId           = "#url.ajaxid#">		
		
	</cfif>	
	
</cfoutput>	
	