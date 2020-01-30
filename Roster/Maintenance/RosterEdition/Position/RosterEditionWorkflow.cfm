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
 	
	
