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
<table width="100%" style="border:1xp solid black;">
	
	<input type  = "hidden" 
		   name  = "workflowlink_#url.submissionedition#" 
		   id    = "workflowlink_#url.submissionedition#" 		   
		   value = "#client.root#/roster/maintenance/rosterEdition/Position/RosterEditionWorkflow.cfm">	
	
	<tr>
		<td id="#url.submissionedition#">
	
		<!--- workflow --->
		
		   <cfset url.ajaxid = url.submissionedition>
		   
			<cfquery name="getEdition" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT *
				 FROM  Ref_SubmissionEdition
				 WHERE SubmissionEdition = '#URL.ajaxid#'	 
			</cfquery>
			
			<cfset link = "Roster/RosterSpecial/RosterView/RosterView.cfm?edition=#url.ajaxid#">			
			
			<cf_ActionListing 
			    EntityCode       = "RosterEdition"
				EntityClass      = "Standard"
				EntityGroup      = ""
				EntityStatus     = ""
				tablewidth       = "100%"
				Owner            = "#getEdition.Owner#"		
				ObjectReference  = "Roster Edition"
				ObjectReference2 = "#getEdition.EditionDescription#" 	
			    ObjectKey1       = "#url.ajaxid#"	
				AjaxId           = "#URL.ajaxId#"
				ObjectURL        = "#link#"
				Show             = "Yes"
				HideCurrent      = "No">
	
		</td>
	</tr>
	
</table>
 	
	
