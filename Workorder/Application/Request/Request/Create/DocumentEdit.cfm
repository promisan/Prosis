
<!--- container --->

<cfparam name="url.drillid"       default="">
<cfparam name="url.requestid"     default="#url.drillid#">
<cfparam name="url.scope"         default="backoffice"> 

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Request		
		WHERE  RequestId = '#url.requestid#'						
</cfquery>

<cfquery name="RequestType" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Request
		WHERE  Code = '#request.RequestType#'						
</cfquery>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td style="padding-left:20px;padding-right:20px">
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "48">
			<cfset wd = "48">
					
			<tr>					
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Logos/WorkOrder/Order.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Request: <b>#RequestType.Description#</b>"
								source     = "">			
									
					<cf_menutab item       = "2" 
					            iconsrc    = "Logos//Workflow.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Processing of Request"
								source     = "DocumentWorkflow.cfm?ajaxid=#url.requestid#&scope=#url.scope#">
								
										
					<td width="20%" id="statusbox" valign="top" align="right" style="padding-left:4px" class="labelmedium">
					
					   <cf_space spaces="40">
		
					    <cfif Request.ActionStatus neq "">
						
							<cfquery name="Status" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT *
								FROM   Ref_EntityStatus
								WHERE  EntityCode  = 'wrkRequest'
								AND    EntityStatus = '#Request.ActionStatus#'
							</cfquery>
						
							<cfif status.entitystatus eq "0"><font color="808080">
							<cfelseif status.entitystatus eq "9"><font color="FF0000"></cfif>
							
							<cfif status.statusdescription eq ""><font color="green">Draft<cfelse>#Status.StatusDescription# on: <b>#dateformat(request.created,CLIENT.DateFormatShow)# #timeformat(request.created,"HH:MM")#</cfif>
							
						</cfif>
						
				       </td>
													
														 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="line"></td></tr>
<tr><td height="4"></td></tr>

<tr><td height="100%">
    
    <cf_divscroll>
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">	  
	 		
			<tr class="hide"><td valign="top" height="100" id="result"></td></tr>
			
			<tr><td height="4"></td></tr>
			
			<cfoutput>
			<input type="hidden" 
				name="workflowlink_#url.requestid#" id="workflowlink_#url.requestid#" 
				value="DocumentWorkflowContent.cfm">	
			</cfoutput>	
			
			<cf_menucontainer item="1" class="regular">
			
				<cfinclude template="DocumentForm.cfm">
			
			</cf_menucontainer>
			
			<cf_menucontainer item="2" innerbox="#url.requestid#" class="hide"/>		
						
	</table>
	
	</cf_divscroll>

</td></tr>

</table>
