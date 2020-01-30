<cfoutput>
	<table width="100%">
		
		<input type  = "hidden" 
			   name  = "workflowlink_#url.submissionedition#" 
			   id    = "workflowlink_#url.submissionedition#" 		   
			   value = "#client.root#/roster/maintenance/rosterEdition/Workflow/WorkflowDetail.cfm">	
		
		<tr>
			<td id="#url.submissionedition#">
		
			   <cfset url.ajaxid = url.submissionedition>
			   <cfinclude template="WorkflowDetail.cfm"> 
		
			</td>
		</tr>
		
	</table>
</cfoutput>
