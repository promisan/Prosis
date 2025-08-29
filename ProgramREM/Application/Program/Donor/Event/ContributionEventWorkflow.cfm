<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="getEvent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ContributionEvent
		WHERE      ContributionEventId = '#url.ajaxid#'	   	 	
</cfquery>

<cfquery name="getContribution" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       Contribution
		WHERE      ContributionId = '#getEvent.ContributionId#'			
</cfquery>

<!--- show the workflow object --->
	
<cfset link = "ProgramREM/Application/Program/Donor/Event/ContributionEventView.cfm?ID=#url.ajaxid#">
 
<!--- ----------------------------------- --->	
<!--- create and show the workflow object --->
<!--- ----------------------------------- --->

<cfif getEvent.entityClass neq "">
	   					
	<cf_ActionListing 
	    TableWidth       = "100%"
	    EntityCode       = "EntDonorEvent"
		EntityClass      = "#getEvent.entityClass#"  
		EntityGroup      = "" 	
		EntityStatus     = ""		
		ajaxid           = "#url.ajaxid#"
		Mission          = "#getContribution.Mission#"
		OrgUnit          = "#getContribution.OrgUnitDonor#"
		ObjectReference  = "Reporting Event"
		ObjectReference2 = "#getContribution.Reference#"
		ObjectKey4       = "#url.ajaxid#"
		Show             = "Yes"	
	  	ObjectURL        = "#link#"
		DocumentStatus   = "0">
	
</cfif>	