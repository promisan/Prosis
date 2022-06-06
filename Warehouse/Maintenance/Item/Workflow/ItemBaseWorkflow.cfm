
<cfoutput>

<table width="100%">
  <tr>
  <td id="workflow" colspan="2">
														   
	    <cfset wflnk = "Workflow/ItemWorkflow.cfm">
			  
		<input type="hidden" 
          name="workflowlink_#url.id#" id="workflowlink_#url.id#" value="#wflnk#"> 
				 		 
   		<cf_securediv id="#url.id#" bind="url:#wflnk#?ajaxid=#url.id#">		 				
			 
   </td>
   </tr>
</table>	

</cfoutput>					  
	