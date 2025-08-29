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
<!--- ---------------------------------------- --->
<!--- --Contract service for OICT data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<!--- save line --->

<cfparam name="url.requestid"     default="">
<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="form.Reference"    default="">
<cfparam name="url.scope"         default="entry">

<cfquery name="ServiceItem" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code   = '#URL.serviceitem#'					  
</cfquery>		

<cfquery name="WorkOrder" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder
		WHERE  WorkOrderId   = '#URL.workorderid#'		
		AND    Serviceitem = '#url.serviceitem#'			  
</cfquery>		

<cfif isDefined("Form.OrderDate") AND Form.OrderDate neq "">
    <CF_DateConvert Value="#Form.OrderDate#">
	<cfset DTE = dateValue>
<cfelse>
    <cfset DTE = 'NULL'>
</cfif>	

<cftransaction>

<cfif WorkOrder.recordcount eq "0">

	<cf_assignId>
	
	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
		
			<cfquery name="Parameter" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_ParameterMission
				WHERE Mission = '#url.Mission#' 
			</cfquery>		
				
			<cfset No = Parameter.WorkOrderSerialNo+1>
			<cfif No lt 10000>
			     <cfset No = 10000+No>
			</cfif>
				
			<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ParameterMission
				SET    WorkOrderSerialNo = '#No#'
				WHERE  Mission = '#url.Mission#' 
			</cfquery>
		
	</cflock>
		
	<cfset no = "#Parameter.WorkOrderPrefix#-#No#">
	
	<cfparam name="form.OrgUnitOwner" default="">
	
	<cfset id = rowguid>
	  
		<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrder
			         (WorkOrderId,
					  CustomerId,
					  ServiceItem,					
					  <cfif isDefined ("Form.Ordermemo") >
						OrderMemo,
					  </cfif>
					  Currency,
					  Mission, 
					  Reference, 
					  OrgUnitOwner,
					  OrderDate,							
					  ExternalLoad,	
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#id#',
			          '#url.customerid#',
					  '#url.serviceitem#',
					   <cfif isDefined ("Form.Ordermemo") >
						'#Form.Ordermemo#',	
					  </cfif>					
					  '#Form.Currency#',		  
			          '#url.Mission#', 
					  <cfif form.reference eq "">
					  '#no#', 
					  <cfelse>
					  '#Form.Reference#',
					  </cfif>
					  <cfif form.OrgUnit1 neq "">
					  '#form.OrgUnit1#',
					  <cfelse>
					  NULL,
					  </cfif>					 
					  #dte#,		
					  '0',	 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
<cfelse>

	<cfparam name="form.OrgUnitOwner" default="">

	<cfset id = URL.workorderid>


    <!---
			
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE  WorkOrder
			<cfif form.OrgUnitOwner neq "">
			SET OrgUnitOwner = '#Form.OrgUnit1#'
			<cfelse>
			SET OrgUnitOwner = NULL
			</cfif>
			WHERE  WorkOrderId   = '#id#'						  
	</cfquery>	
	
	--->		

</cfif>

<!--- populate base GL Accounts for posting --->

<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionGledger WITH (NOLOCK)
		WHERE  Mission = '#url.mission#'					  
</cfquery>	

<cfloop query="GL">

	<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderGledger
			         (WorkOrderId,
					 Area,    
					 GLAccount,						
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			VALUES ('#id#',
			        '#Area#', 					   
			   	    '#GLAccount#', 
				    '#SESSION.acc#',
			    	'#SESSION.last#',		  
				  	'#SESSION.first#')
	</cfquery>


</cfloop>
	
<cfquery name="Line" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrderLine
		WHERE  WorkOrderId   = '#id#'		  
		AND    WorkOrderLine = '#url.workorderline#'					  
</cfquery>	
		
		<cfif Line.recordcount eq "1">		
						
			<cfquery name="Last" 
				 datasource="AppsWorkOrder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT MAX(WorkOrderLine) as WorkOrderLine
					FROM   WorkOrderLine
					WHERE  WorkOrderId   = '#id#'								  
			</cfquery>	
		
			<cfset line = last.WorkOrderLine+1>
		
		<cfelse>
		
			<cfset line = url.workorderline>		
		
		</cfif>
				
		<cf_assignid>

		<cfquery name="Insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WorkOrderLine
			         (WorkOrderId,
					 WorkOrderLine,   
					 WorkOrderLineId,
					 ServiceDomain,
					 ServiceDomainClass,
					 OrgUnitImplementer,
					 Reference,
					 DateEffective,					 
					 OrgUnit, 
					 PersonNo,				
					 <cfif form.parentworkorderid neq "" and form.parentworkorderid neq "00000000-0000-0000-0000-000000000000">
					 ParentWorkOrderId,
					 ParentWorkOrderLine,
					 </cfif>
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#id#',
			          '#line#',
					  '#rowguid#',
					  '#ServiceItem.ServiceDomain#',
					  '#Form.ServiceDomainClass#',
					  '#Form.OrgUnit2#',
					  '#Form.ServiceReference#',
					  #dte#,
					  NULL, <!--- orgunit customer --->
			          '#Form.PersonNo#', 	
					  <cfif form.parentworkorderid neq "" and form.parentworkorderid neq "00000000-0000-0000-0000-000000000000">
					  '#Form.ParentWorkOrderId#',
					  '#Form.ParentWorkOrderLine#',
					  </cfif>				   
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
					  
		</cfquery>
				
		<cfif url.requestid neq "">
				
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO RequestWorkOrder
				         (RequestId,
						 WorkOrderId,
						 WorkOrderLine,   
						 WorkOrderAction,										
						 Created)
				  VALUES ('#url.requestid#',
				          '#id#',
				          '#url.workorderline#',
						  'newline',					 					
						  getDate())
			</cfquery>
			
			<cfquery name="Update" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Request
				SET    ActionStatus = '3'
				WHERE  RequestId = '#url.requestid#'
			</cfquery>
				
		</cfif>
			
	<!--- save custom --->
	
	<cfset url.topicclass   = "request">
	<cfset url.domainclass  = "#Form.ServiceDomainClass#">
	
	<cfinclude template="../CustomFieldsSubmit.cfm">

</cftransaction>



<!--- save action --->

<cfset setworkplan = "0">


<cf_WorkOrderActionFields
    mission           = "#url.mission#" 
    serviceitem       = "#url.serviceitem#" 
	workorderid       = "#id#" 
	workorderline     = "#line#"
	ActionFulFillment = "schedule"
	validation        = "SameDay"
	mode              = "save">




<cfoutput>



	<cfif url.requestid eq "">
	
	

		<script>


		   <cfif setworkplan eq '1'>

		     try { opener.applyfilter('','','content') } catch(e) { console.log('error in applyfilter',e);}
			 
			 <cfloop index="dte" list="#pdte#">	   		   		  		   			   		        		     
		     try { opener.calendarrefresh('#day(dte)#','#dateformat(dte,client.datesql)#') } catch(e) { console.log(e); }
			 </cfloop>
			 
			 try { window.close(); } catch(e) { console.log(e); }
			 
			  try {			 
			      parent.Prosis.busy('yes')

			      parent.ptoken.open('#session.root#/WorkOrder/Application/Medical/ServiceDetails/Workorderline/WorkOrderLineView.cfm?drillid=#rowguid#&idmenu=#url.idmenu#','_self');
			 } catch(e)
		   		{ console.log('error opening',e); }

			 try {
				 parent.ProsisUI.closeWindow('myorder');
			 }catch(e)
			 { console.log('error closing',e); }


		   <cfelse>
		   
		   	 try {			 
			      parent.Prosis.busy('yes') 
			      parent.ptoken.open('#session.root#/WorkOrder/Application/Medical/ServiceDetails/Workorderline/WorkOrderLineView.cfm?drillid=#rowguid#&idmenu=#url.idmenu#','_self'); } catch(e) { console.log(e); }	
				  parent.ProsisUI.closeWindow('myorder'); 	
		   </cfif>	 		   
		    		  		
		</script>
	
	<cfelse>
	
	    <script>		
	      try { opener.applyfilter('','','content') } catch(e) { console.log(e); }
	      try { ptoken.open('#session.root#/WorkOrder/Application/Medical/Complaint/Workflow/endFullfillmentWorkOrder.cfm?drillid=#rowguid#&idmenu=#url.idmenu#','_self'); } catch(e) { console.log(e); }	  
	    </script> 
	
	</cfif>
	
</cfoutput>