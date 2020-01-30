<table width="100%" cellspacing="0" cellpadding="0" align="center">
				
	<cfquery name="Request" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request		
		WHERE  Requestid = '#url.ajaxid#'	
	</cfquery>
	
	<cfquery name="Customer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Customer		
		WHERE  CustomerId = '#Request.CustomerId#'	
	</cfquery>
	
	<cfparam name="url.action" default="">	
	
	<cfoutput>
			
	<cfif Request.ActionStatus lte "2" and url.action neq "cancel">
	
	    <cfset Reset = "Yes">
	
		<tr><td align="left" id="cancel">
		
		<input type="button" 
		       name="Cancel"  id="Cancel"
			   class="button10s" 
			   value="Cancel" 
			   style="width:140px" 
			   onclick="ColdFusion.navigate('DocumentWorkflowContent.cfm?action=cancel&ajaxid=#url.ajaxid#','#url.ajaxid#')">
			   
		</td></tr>		
		<tr><td height="2"></td></tr>
		<tr><td class="line"></td></tr>
		
	<cfelse>
	
	    <cfset Reset = "Limited">
		
	</cfif>
	
	</cfoutput>
	
	<tr><td height="2"></td></tr>
					
	<tr><td>		
		
	<cfif url.action eq "cancel">
				
		<!--- revert the actions already taken here --->
				
		<cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
			   method           = "RevertRequest" 
			   requestid        = "#url.ajaxid#">	
			   
		<!--- set status to cancel --->	   
			   
		<cfquery name="Request" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Request
			SET    ActionStatus = '9'
			WHERE  Requestid = '#url.ajaxid#'	
		</cfquery>
		
		<!--- close the workflow --->
		
		<cfquery name="ArchiveFlow" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Organization.dbo.OrganizationObjectAction
				SET    ActionStatus     = '2',
				       ActionMemo       = 'Closed through cancellation',
				       OfficerUserId    = '#SESSION.acc#',
					   OfficerLastName  = '#SESSION.last#',
					   OfficerFirstName = '#SESSION.first#',									   
					   OfficerDate      = getDate()					   		
				WHERE  ObjectId IN (SELECT ObjectId 
				                    FROM   Organization.dbo.OrganizationObject 
									WHERE  ObjectKeyValue4 = '#url.ajaxid#')
				AND    ActionStatus = '0'			
		</cfquery>		   
			
	</cfif>
					
	<cfset wflink = "WorkOrder/Application/Medical/Complaint/Create/DocumentForm.cfm?requestid=#url.ajaxid#">
					
		<cfquery name="Request" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Request
			WHERE  Requestid = '#url.ajaxid#'	
		</cfquery>
					
		<cfquery name="RequestType" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Request
			WHERE  Code  = '#Request.RequestType#'			
		</cfquery>
		
		<!--- new request --->
				
		<cfquery name="RequestLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   RequestLine
			WHERE  Requestid   = '#url.ajaxid#'			
		</cfquery>
				
		<cfif RequestLine.recordcount eq "0">
		
			<!--- amended request --->
			
			<cfquery name="RequestLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT ValueFrom as Serviceitem
				FROM   RequestWorkorderDetail
				WHERE  Amendment = 'ServiceItem'			
				AND    Requestid   = '#url.ajaxid#' 			
			</cfquery>
		
		</cfif> 	
			
		<cfquery name="ServiceItem" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   ServiceItem
			WHERE  Code = '#RequestLine.ServiceItem#'
		</cfquery>
					
		<cf_ActionListing 
			EntityCode       = "WrkRequest"
			EntityClass      = "#Request.EntityClass#"
			EntityGroup      = "#ServiceItem.ServiceDomain#"
			EntityStatus     = ""
			Mission          = "#Request.mission#"
			PersonEMail      = "#Request.EmailAddress#"
			ObjectReference  = "#Request.Reference#"
			ObjectReference2 = "#RequestType.description#: #Customer.CustomerName#"						
			ObjectKey4       = "#url.ajaxid#"
			AjaxId           = "#url.ajaxid#"
			ObjectURL        = "#wflink#"
			Reset            = "#reset#"
			Show             = "Yes"
			ToolBar          = "No">

	
	</td></tr>	
	
	</table>