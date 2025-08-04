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

<cfif url.objectid neq "">
    
    <cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  OrganizationObject
			WHERE ObjectId = '#URL.objectid#' or ObjectKeyValue4 = '#URL.ObjectId#'
    </cfquery>		
			
	<cfif Object.ObjectId neq "">
	
	<cfset url.objectid = Object.ObjectId>
		
	<cfif url.item eq "Mail">	
	 	<cfinclude template="Notes/NoteView.cfm"> 
	<cfelseif url.item eq "Cost">
		<cfinclude template="Cost/CostView.cfm">
	</cfif>
	
	<cfelse>
	
	 <cf_screentop html="No" title="Problem">	
	 <table align="center"><tr><td class="labelt" align="center" height="40">Annotation feature could not be initialised as no workflow object has been created.</td></tr></table>
	 
	</cfif>
	
<cfelse>
		
	 <cf_screentop html="No" title="Problem">
	 <table align="center"><tr><td class="labelt" align="center" height="40">Annotation feature has not been initialised for this document.</td></tr></table>
		
</cfif>

	