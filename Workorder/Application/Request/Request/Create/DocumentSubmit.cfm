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

<!---
Update/Insert
Request
RequestLine
RequestWorkOrder and then run the workflow to be shown 
--->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
			 			 
<cfif url.action eq "delete"> 

	<cftransaction>
				  
	 <cfinvoke component = "Service.Process.Workorder.PostWorkorder"  
	   method           = "RevertRequest" 
	   requestid        = "#url.requestid#">	
	   
	  <cfquery name="PurgeRecord" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  DELETE  Request
		  WHERE   Requestid = '#url.requestid#'
	</cfquery>		
						 
	</cftransaction>	 		   	
			
	<script>	    
		 returnValue=1;
	     window.close()
	</script>
		
<cfelseif url.action eq "submit"> 
	
	<cfparam name="FORM.Reference"           default="">
	<cfparam name="FORM.RequestDate"         default="#dateformat(now(),CLIENT.DateFormatShow)#">
	<cfparam name="FORM.PersonNo"            default="">
	<cfparam name="FORM.PersonNoUser"        default="#Form.PersonNo#">
	<cfparam name="FORM.eMailAddress"        default="">
	<cfparam name="FORM.OrgUnit"             default="0">
	<cfparam name="FORM.ServiceItem"         default="">
	<cfparam name="FORM.ServiceDomain"       default="">	
	<cfparam name="FORM.RequestType"         default="">
	<cfparam name="FORM.RequestAction"       default="">
	<cfparam name="FORM.WorkOrderLineId"     default="">
	<cfparam name="FORM.WorkOrderLine"       default="">
	<cfparam name="FORM.DateEffective"       default="#dateformat(now(),CLIENT.DateFormatShow)#">
	<cfparam name="FORM.DateExpiration"      default="">
	<cfparam name="FORM.Memo"                default="">	
	
	<cfquery name="getExist" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Request 		    
		  WHERE  Requestid    = '#url.requestid#'		 
	</cfquery>	
	
	<cfif not isValid("email",  eMailAddress)>
	
		<cf_alert message="Record a valid eMail address.">
		<cfabort>
		
	</cfif>	
	
	<cfif form.requestaction eq "">
	
		<cf_alert message="Record a valid request action.">
		<cfabort>
		
	</cfif>
	
	<cfif form.requesttype eq "">
	
		<cf_alert message="Record a valid request type.">
		<cfabort>
		
	</cfif>
	
	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Organization    
		  WHERE  OrgUnit   = '#form.orgunit#'		 
	</cfquery>	
	
	<cfif Org.recordcount eq "0" or Form.OrgUnit eq "0" or Form.OrgUnit eq "">
	
		<cf_alert message="Record a valid unit.">
		<cfabort>
		
	</cfif>	
	
	<cfif Len(Form.Memo) gt 400>
	  <cfset Memo = left(Form.Memo,400)>
	<cfelse>
	  <cfset Memo = Form.Memo>
	</cfif>  
	
	<cfset dateValue = "">
	<cfif Form.RequestDate neq ''>
	    <CF_DateConvert Value="#Form.RequestDate#">
	    <cfset dte = dateValue>
	<cfelse>
	    <cfset dte = 'NULL'>
	</cfif>	
	
	<cfset dateValue = "">
	<cfif Form.DateEffective neq ''>
	    <CF_DateConvert Value="#Form.DateEffective#">
	    <cfset eff = dateValue>
	<cfelse>
	    <cfset eff = 'NULL'>
	</cfif>	
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset exp = dateValue>
	<cfelse>
	    <cfset exp = 'NULL'>
	</cfif>	
	
	<cfquery name="RequestType" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_Request
		  WHERE  Code= '#Form.RequestType#'		 		 
	</cfquery>	
	
	<cfquery name="Param" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_ParameterMission
		  WHERE  Mission       = '#url.mission#'		 		 
	</cfquery>	
	
	<cfquery name="RequestService" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_RequestWorkflow
		  WHERE  RequestType   = '#Form.RequestType#'		 
		  AND    ServiceDomain = '#Form.ServiceDomain#'
		  AND    RequestAction = '#Form.RequestAction#'		
	</cfquery>	
	
	<cfset rfs = form.Reference>
		
	<cfif Form.Reference eq "">
						 
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
			
				<cfquery name="Parameter" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#url.Mission#' 
				</cfquery>
				
				<cfif Parameter.recordcount eq "0" or Parameter.RequisitionPrefix eq "">
							
					<cf_alert message="Invalid Reference">
					<cfabort>
				
				</cfif>
					
				<cfset No = Parameter.RequisitionSerialNo+1>
				<cfif No lt 10000>
				     <cfset No = 10000+No>
				</cfif>
					
				<cfquery name="Update" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE Ref_ParameterMission
					SET    RequisitionSerialNo = '#No#'
					WHERE  Mission = '#url.Mission#' 
				</cfquery>
				
				<cfset rfs = "#Parameter.RequisitionPrefix#-#No#">
			
		</cflock>		
		
	<cfelseif Param.verifyRequisitionNo eq "1">
		
			<!--- check if it exisits --->
	
			<cfquery name="check" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Request					
					WHERE  Mission = '#url.Mission#' 
					AND    Reference = '#rfs#'
					AND    ActionStatus <> '9'
				</cfquery>
				
			<cfif check.recordcount gte "1">
			
					<cf_alert message="A reference (#rfs#) is already recorded in the database.">
					<cfabort>
			
			</cfif>		
			
	</cfif>
		
	<cfif RequestService.isAmendment eq "1" and Form.workorderlineid eq "">
		
		<cf_alert message="You must select a service line.">
		<cfabort>
	  
	</cfif>
	
	<!--- enforce expiration --->
	
	<cfif RequestService.PointerExpiration eq "1" and Form.DateExpiration eq "">
	
		<cf_alert message="You must enter an expiration date for this request">
		<cfabort>
		
	</cfif>
	
	<cfif RequestService.isAmendment eq "1" and RequestType.TemplateApply neq "">
	
		<cfquery name="getLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   WorkorderLine
		  WHERE  WorkOrderLineId = '#Form.WorkorderLineId#'		 		 
	    </cfquery>	
		
		<cfset servicedomainclass = getLine.ServiceDomainClass>
	
		<!--- check for any requests that are pending not having status = 3 for this service
		or have a workflow pending  --->
			
		<cfquery name="getOther" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  R.Reference as RequestReference
				FROM    Request R, RequestWorkOrder RW, WorkOrderLine L
				WHERE   RW.WorkOrderId   = L.WorkOrderId
				AND     RW.WorkOrderLine = L.WorkOrderLine		
				AND     R.RequestId      = RW.RequestId		
				AND     L.ServiceDomain  = '#getLine.ServiceDomain#'				
				AND     L.Reference      = '#getLine.Reference#'						  					
				AND     R.ActionStatus IN ('0','1','2')
				AND     R.RequestId     != '#url.requestid#'							
		 </cfquery>		
		 
		 <cfif getOther.recordcount gte "1">		 
		 
				<cfquery name="Format" 
					datasource="appsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ServiceItemDomain
						WHERE  Code = '#getLine.serviceDomain#'			
				</cfquery>
			   
			   <cfif Format.displayformat eq "">
					<cfset val = getLine.reference>
			   <cfelse>
				    <cf_stringtoformat value="#getLine.reference#" format="#Format.DisplayFormat#">						
			   </cfif>		 

			   <cf_alert message="There is a pending amendment for #getLine.ServiceDomain# : #val# under reference: [#getOther.RequestReference#]. This request has to be completed (or cancelled) before a new amendment may be submitted.">
			   
			<cfabort>	
		<cfelse>
				<cfset val = getLine.reference>					
		 </cfif>	
		 
		 <!--- check if the are any pending workflows for this item --->
	
		<cfquery name="getRequest" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
				SELECT  R.RequestId, R.Reference as RequestReference
				FROM    Request R, RequestWorkOrder RW, WorkOrderLine L
				WHERE   RW.WorkOrderId   = L.WorkOrderId
				AND     RW.WorkOrderLine = L.WorkOrderLine		
				AND     R.RequestId      = RW.RequestId		
				AND     L.ServiceDomain  = '#getLine.ServiceDomain#'				
				AND     L.Reference      = '#getLine.Reference#'						  					
				AND     R.ActionStatus   = '3'
				AND     R.RequestId != '#url.requestid#'							
		 </cfquery>				
	
		<cfset transferstatus = "enabled">
		
		<cfloop query="getRequest">
		
			<cf_wfactive EntityCode="WrkRequest"  ObjectKeyValue4="#RequestId#">		
			
			<cfif wfStatus neq "closed">			
			
				 <cf_alert message="There is a pending workflow for #getLine.ServiceDomain# : #val# under reference: [#getRequest.RequestReference#]. This workflow has to be completed (or cancelled) before a new amendment may be submitted.">
		 		 <cfabort>		
				 
			</cfif>		
			
		</cfloop>	
		 
	<cfelse>
	
		<cfset servicedomainclass = RequestService.ServiceDomainClass>	 
	
	</cfif>
	
	<cfquery name="wf" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	      SELECT * 
		  FROM   Ref_RequestWorkflow
		  WHERE  RequestType   = '#Form.RequestType#'		 
		  AND    ServiceDomain = '#Form.ServiceDomain#'
		  AND    RequestAction = '#Form.RequestAction#'
	      AND    EntityClass IN (SELECT EntityClass 
		                         FROM   Organization.dbo.Ref_EntityClass 
								 WHERE  EntityCode = 'WrkRequest')
	
	</cfquery>	
			
	<cfif wf.entityclass eq "">
	 	<cfset cl = "Standard">
	<cfelse>
		<cfset cl = wf.entityclass> 
	</cfif>	
	
	<cftransaction>
		
		<cfif getExist.recordcount eq "0">
		
			<cfquery name="Insert" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO Request
					  (RequestId,
					   RequestDate, 
					   ServiceDomain,
					   <cfif servicedomainclass neq "">
					   ServiceDomainClass,					 
					   </cfif>
					   <cfif RequestService.PointerReference eq "1">
					   DomainReference,
					   </cfif>
					   Mission, 
					   Reference, 
					   OrgUnit, 
					   PersonNo, 
					   PersonNoUser,
					   RequestType, 	
					   RequestAction,
					   DateEffective,	
					   DateExpiration,			  
					   Memo, 
					   eMailAddress, 
					   EntityClass, 
					   OfficerUserId, 
					   OfficerLastName, 
		               OfficerFirstName)
				   VALUES
					   ('#url.requestid#',
					   #dte#,
					   '#Form.ServiceDomain#',
					   <cfif servicedomainclass neq "">
					   '#ServiceDomainClass#',
					   </cfif>
					   <cfif requestservice.pointerReference eq "1">
					   '#Form.DomainReference#',
					   </cfif>
					   '#url.mission#',
					   '#rfs#',
					   '#Form.OrgUnit#',
					   '#Form.PersonNo#',
					   '#Form.PersonNoUser#',
					   '#Form.requestType#',
					   '#Form.RequestAction#',
					   #eff#,
					   #exp#,
					   '#Form.Memo#',
					   '#Form.eMailAddress#',
					   '#wf.entityclass#',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')
			</cfquery>	
		
		<cfelse>
		
		     <!--- check if the workflow would change --->
			 
			  <cfquery name="get" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Request
				  WHERE  Requestid = '#url.requestid#'				 
			</cfquery>	
			 
			 <cfquery name="wf" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			      SELECT * 
				  FROM   Ref_RequestWorkflow
				  WHERE  RequestType   = '#form.RequestType#'		 
				  AND    ServiceDomain = '#get.ServiceDomain#'
				  AND    RequestAction = '#Form.RequestAction#'
			</cfquery>	
			
			<!--- check if the flow has changed --->
			
			<cfif wf.entityClass neq get.EntityClass and wf.entityclass neq "">	
			
			     <!--- closes the current workflow 
				 which will trigger a new one upon loading --->
				 
				<cfquery name="update" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			      UPDATE Organization.dbo.OrganizationObject
				  SET    Operational     = 0
				  WHERE  EntityCode      = 'wrkRequest'		 
				  AND    ObjectkeyValue4 = '#url.requestid#'			 
			    </cfquery>						 
						 
			</cfif>			 
			
		    <cfquery name="Update" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE Request
				  SET    RequestDate     = #dte#, 
					     Reference       = '#rfs#', 
						 
						 <cfif RequestService.ServiceDomainClass neq "">						 
						 ServiceDomainClass = '#RequestService.ServiceDomainClass#',
						 <cfelse>
						 ServiceDomainClass = NULL,
						 </cfif>
						 
						 <cfif requestservice.pointerReference eq "1">
						 DomainReference = '#Form.DomainReference#',
						 <cfelse>
						 DomainReference = NULL,
						 </cfif>
					     OrgUnit         = '#Form.OrgUnit#', 
					     PersonNo        = '#Form.PersonNo#', 
						 PersonNoUser    = '#Form.PersonNoUser#', 
					     RequestType     = '#Form.requestType#', 
						 RequestAction   = '#Form.RequestAction#',
						 DateEffective   = #eff#,	
						 DateExpiration  = #exp#,	
					     Memo            = '#Form.Memo#', 
					     eMailAddress    = '#Form.eMailAddress#', 
					     EntityClass     = '#wf.entityclass#'			  
				   WHERE Requestid = '#url.requestid#'
			</cfquery>	
			
			<cfquery name="Delete" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE 
				  FROM   RequestLine				  
				  WHERE  Requestid = '#url.requestid#'
			</cfquery>	
			
			<cfquery name="Delete" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE 
				  FROM   RequestWorkOrder				  
				  WHERE  Requestid = '#url.requestid#'
			</cfquery>			
					
		</cfif>
				
		<cfif requestservice.isAmendment eq "0">
				
			<cfparam name="client.itemselect" default="">	  				
			<cfinclude template="../Templates/RequestServiceSubmit.cfm">				
							
		</cfif>
		
		<cfset ln = 0>

		<cfif form.workorderlineid neq "">

			<cfquery name="CheckLine" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		      SELECT * 
			  FROM   WorkorderLine 		    
			  WHERE  WorkorderLineId = '#form.workorderlineid#'	
			  AND    DateEffective <= #eff#	 
			</cfquery>	
			
			<cfif checkline.recordcount eq "0">
			
				<cf_alert message="You submitted an invalid effective date.">
				<cfabort>
			
			<cfelseif checkLine.recordcount eq "1">
		
				<cfquery name="InsertLink" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  INSERT INTO RequestWorkorder (
								   RequestId,
								   WorkorderId, 
								   WorkOrderLine )
					   VALUES ('#url.requestid#',
							   '#checkLine.WorkorderId#',
							   '#checkLine.WorkOrderLine#')
				</cfquery>	
				
				<!--- capture any amendments for user, customer etc. --->
				
				<cfinclude template="../Templates/AmendmentSubmit.cfm">
				
				<!--- capture provisioning information --->		
				
				<cfparam name="Form.Provisioning" default="0">		
				
				<cfif Form.Provisioning eq "1">				
				       <cfparam name="Form.ServiceItemTo" default="#Form.Serviceitem#">					   			  
					   <cfinclude template="../Templates/RequestServiceSubmit.cfm">
				</cfif>	
			
			</cfif>
		
		</cfif>
				
	</cftransaction>				
				
	<cfoutput>
	
	<cfif url.scope eq "portal">
	
		<script language = "JavaScript">	
		    ColdFusion.navigate('DocumentEdit.cfm?accessmode=view&status=#url.status#&domain=#url.domain#&requestid=#url.requestid#&mission=#url.mission#','formcontent')										
			opener.document.getElementById('servicerequest').click() // refresh the view to show the listing		
		</script>	
	
	<cfelse>	
		
		<cfif getExist.recordcount eq "0">
			
				<script language = "JavaScript">					
				    ColdFusion.navigate('DocumentEdit.cfm?accessmode=view&status=#url.status#&domain=#url.domain#&requestid=#url.requestid#&mission=#url.mission#','formcontent')						
					opener.document.getElementById("listingrefresh").click()		
				</script>	
			
		<cfelse>
			
				<script language = "JavaScript">		
				   
				    opener.applyfilter('','','#url.requestid#')	
					window.close()
	//				opener.document.getElementById("listingrefresh").click()							   
				</script>	
			
		</cfif>
	
	</cfif>
		
	</cfoutput>	
	
</cfif>	

	   
	

