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

<!--- --------CUSTOM FORM DATA ENTRY --------- --->
<!--- ---------------------------------------- --->
<!--- --Deliver service for Kuntz data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<!--- save line --->

<cfparam name="url.workorderid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline"   default="1">
<cfparam name="url.action"          default="">
<cfparam name="url.scope"           default="entry">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT * FROM WorkOrderLine			
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'									  
</cfquery>		

<cfif url.action eq "purge">

	<cfquery name="Update" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			DELETE  WorkOrderLine			
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'									  
	</cfquery>		

<cfelse>

	<cftransaction>
	
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder
			WHERE  WorkOrderId   = '#URL.workorderid#'					  
	</cfquery>			
	
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
				     <cfset No = 10000+#No#>
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
		
		<cfquery name="Customer" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   Customer
			WHERE  CustomerId   = '#URL.customerid#'					  
		</cfquery>			
		
		<cfif customer.recordcount eq "0">
		
		<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Customer
			        (CustomerId,
					 Mission,
					 CustomerName,
					 PostalCode,
			         Address,
				     City,		
					 PhoneNumber,		
					 MobileNumber,    	
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			 VALUES ('#url.customerid#',
			         '#url.mission#',
					 '#Form.CustomerName#',
					 '#Form.PostalCode#',
			         '#Form.Address#', 
					 '#Form.city#', 	
					 '#Form.PhoneNumber#',   		 
					 '#Form.MobileNumber#',
					 '#SESSION.acc#',
			    	 '#SESSION.last#',		  
				  	 '#SESSION.first#',
					 getDate())
		 </cfquery>
		
		
		</cfif>
		  
		<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO WorkOrder
			         (WorkOrderId,
					 CustomerId,
					 ServiceItem,
					 Mission, 
					 Reference, 
					 OrgUnitOwner,
					 OrderDate,			
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			 VALUES ('#id#',
			          '#url.customerid#',
					  '#form.ServiceItem#',
			          '#url.Mission#', 
					  '#no#', 
					  <cfif form.OrgUnitOwner neq "">
					  '#form.OrgUnitOwner#',
					  <cfelse>
					  NULL,
					  </cfif>
					  '#dateformat(now(),client.dateSQL)#',			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
		 </cfquery>
			
	<cfelse>
	
		<cfparam name="form.OrgUnitOwner" default="">
	
		<cfset id = URL.workorderid>
				
		<cfquery name="customerset" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE Customer			
			SET    CustomerName = '#Form.CustomerName#',
			       PostalCode   = '#Form.PostalCode#',
			       Address      = '#Form.Address#',
				   City         = '#Form.City#',
				   PhoneNumber  = '#Form.PhoneNumber#',
				   MobileNumber = '#Form.MobileNumber#'	
			WHERE  CustomerId   = '#workorder.customerid#'									  
		</cfquery>		
				
		<cfquery name="WorkOrder" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE  WorkOrder
				<cfif form.OrgUnitOwner neq "">
				SET OrgUnitOwner = '#Form.OrgUnitOwner#'
				<cfelse>
				SET OrgUnitOwner = NULL
				</cfif>
				WHERE  WorkOrderId   = '#id#'						  
		</cfquery>			
	
	</cfif>
	
	<!--- ------------------------------------------- --->
	<!--- -------------------lines------------------- --->
	<!--- ------------------------------------------- --->
		
	<cfquery name="Line" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrderLine
			WHERE  WorkOrderId   = '#id#'		  
			AND    WorkOrderLine = '#url.workorderline#'					  
	</cfquery>	
	
	<cfif Line.recordcount eq "0">
	
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO WorkOrderLine
				         (WorkOrderId,
						 WorkOrderLine, 
						 <!---   
						 PersonNo,						
						 --->
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#id#',
				          '#url.workorderline#',
						  <!---
				          '#Form.PersonNo#', 					   
						  --->
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			</cfquery>
			
	<cfelse>
	
		<!---
					
		<cfquery name="Update" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE  WorkOrderLine
				SET     PersonNo = '#Form.PersonNo#'
				WHERE   WorkOrderId   = '#id#'	
				AND     WorkOrderLine = '#url.workorderline#'					  
		</cfquery>		
		
		--->
	
	</cfif>
	
	<!--- save custom --->
	
	<cfinclude template="../CustomFieldsSubmit.cfm">
	
	<!--- save action --->
	
	<cf_WorkOrderActionFields
	       mission        = "#url.mission#" 
	       serviceitem    = "#url.serviceitem#" 
		   workorderid    = "#id#" 
		   workorderline  = "#url.workorderline#"
		   mode           = "save">
	
		
	</cftransaction>
	
</cfif>	



<!--- ajax embedded forms disabled 

<cfoutput>
	<script>
		if (window.innerHeight){ 
			h = window.innerHeight 
		}else{ 
			h = document.body.clientHeight
		} 
				
		<!--- refresh the dialog screen for adding --->
		<cfif form.scope eq "entry">		   
			ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)				  
		<cfelseif form.scope eq "add">			   		    
		    ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)		
			ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?mission=#url.mission#&customerid=#url.customerid#','addworkorder')
		<cfelseif form.scope eq "edit">					   	   
			<!--- ColdFusion.Window.hide('adddetail') --->
			<!--- apply the action by as an line script --->							
			applyfilter('1','','#url.workorderid#')
		</cfif>	
		
	</script>	
	 <cfset url.drillid = "#url.workorderid#">
	 <cfinclude template="../WorkorderEdit.cfm">
</cfoutput>

--->

<cfoutput>

	<script>

		<cfif form.scope eq "entry">		   
		    // window.dialogArguments.opener.applyfilter('1','','#url.workorderid#')
			returnValue = 1
			window.close()
			// ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)				  
		<cfelseif form.scope eq "add">	
		
		    try {			   	   
			window.dialogArguments.opener.applyfilter('1','','content') } catch(e) { returnValue = 1}
			window.close()		
			
		    // returnValue = 1 
		    // window.dialogArguments.opener.applyfilter('1','','#url.workorderid#')
			// window.close()		   		    
		    // ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)		
			// ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?mission=#url.mission#&customerid=#url.customerid#','addworkorder')
		<cfelseif form.scope eq "edit">		
		    // refresh the listing
		    try { opener.applyfilter('1','','#get.workorderlineid#') } catch(e) {}
			// refresh the context of opening 
			try { opener.document.getElementById('#url.box#').click() } catch(e) {}
			window.close()	
		  	
		</cfif>	

	</script>
	
</cfoutput>


