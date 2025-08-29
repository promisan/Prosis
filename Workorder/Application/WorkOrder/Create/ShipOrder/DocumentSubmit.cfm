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
<!--- --Deliver service for Kuntz data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<!--- save line --->

<cfparam name="url.workorderid"     default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline"   default="1">
<cfparam name="url.action"          default="">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT * FROM WorkOrderLine			
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'								  
</cfquery>		

<cfif url.action eq "purge">

    <!--- old 
	<cfquery name="Update" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			DELETE  WorkOrderLine			
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'									  
	</cfquery>		
	--->
	
	<cfquery name="Update" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			UPDATE  WorkOrderLine			
			SET     Operational   = 0, 
			        ActionStatus  = '9'
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'									  
	</cfquery>		
	
	<!--- check if valid lines --->
	
	<cfquery name="check" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT  * 
			FROM    WorkOrderLine						
			WHERE   WorkOrderId   = '#URL.workorderid#'	
			AND     WorkOrderLine = '#url.workorderline#'									  
			AND     Operational = 1
	</cfquery>	
	
	<cfif check.recordcount eq "0">
	
		<cfquery name="Update" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE  WorkOrder			
				SET     ActionStatus = '9'
				WHERE   WorkOrderId   = '#URL.workorderid#'												  
		</cfquery>		
	
	</cfif>
		
<cfelse>
	
	<cfquery name="getLogo" 
		datasource="AppsInit" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Parameter			
		WHERE  HostName  = '#CGI.HTTP_HOST#'											  
	</cfquery>	
				
	<cftransaction>
	
	<cfquery name="WorkOrder" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrder W 
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
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#url.Mission#' 
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
						 AddressNo,
					     City,		
						 Coordinates,
						 PhoneNumber,	
						 MobileNumber,	 
						 eMailAddress,   	
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				 VALUES ('#url.customerid#',
				         '#url.mission#',
						 '#Form.CustomerName#',
						 '#Form.PostalCode_order#',
				         '#Form.Address_order#', 
						 '#Form.AddressNo_order#',
						 '#Form.City_order#', 	
						 '#Form.cLatitude#,#Form.cLongitude#',
						 '#Form.PhoneNumber#',   		 
						 '#Form.MobileNumber#',
						 '#Form.eMailAddress#',
						 '#SESSION.acc#',
				    	 '#SESSION.last#',		  
					  	 '#SESSION.first#')
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
			       PostalCode   = '#Form.PostalCode_Order#',
			       Address      = '#Form.Address_Order#',
				   AddressNo    = '#Form.AddressNo_Order#',
				   City         = '#Form.City_Order#',
				   Coordinates  = '#Form.cLatitude#,#Form.cLongitude#',
				   PhoneNumber  = '#Form.PhoneNumber#',
				   MobileNumber = '#Form.MobileNumber#',
				   eMailAddress = '#Form.eMailAddress#'	
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
	
	<cfset url.workorderid = id>
	
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
	
	<cfparam name="Form.PersonNo" default="">
	<cfparam name="form.Action_Delivery" default="">

	<cf_assignid>
	
	<cfif Line.recordcount eq "0">		
	
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			INSERT INTO WorkOrderLine
			         ( WorkOrderId,
					   WorkOrderLine,    
					   PersonNo,	
					   Priority,
					   WorkOrderLineId,					
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName )
			  VALUES ('#id#',
			          '#url.workorderline#',
			          '#Form.PersonNo#', 						  
					  <cfif form.Action_Delivery eq "Today">
					  '2',
					  <cfelse>
					  '1',
					  </cfif>
					  '#rowguid#',				   
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfset mail     = "1">
			<cfset drillid = rowguid>
			
	<cfelse>
						
		<cfquery name="Update" 
			 datasource="AppsWorkOrder" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				UPDATE  WorkOrderLine
				SET     PersonNo      = '#Form.PersonNo#'				       
				WHERE   WorkOrderId   = '#id#'	
				AND     WorkOrderLine = '#url.workorderline#'					  
		</cfquery>		
		
		<cfset mail = "0">
		<cfset drillid = rowguid>
	
	</cfif>
		
	<!--- save custom --->
	
	<cf_getLocalTime datasource="AppsWorkOrder" Mission="#url.mission#">
		
	<cfinclude template="../CustomFieldsSubmit.cfm">	
	<cfinclude template = "CustomDocumentSubmit.cfm">
			
	<!--- ------------------------------------------------------------------------ --->
	<!--- we have delivery action customised in the form and as such it is handled --->
	<!--- ------------------------------------------------------------------------ --->
	
	<!--- save action --->
			
	<cfif url.context eq "Portal">
	
	    <!--- we construct the field --->
		
		<cfif form.Action_Delivery eq "Today">
		    <cfset Form.DateRequestedDelivery = dateformat(localtime,client.dateformatshow)>
		<cfelseif form.Action_Delivery eq "Tomorrow">
		    <cfset Form.DateRequestedDelivery = dateformat(localtime+1,client.dateformatshow)>
		<cfelse>
		    <cfset Form.DateRequestedDelivery = "#form.dateaction_Delivery_date#">	
		</cfif>	
		
		<cfset Form.DatePlanningDelivery = Form.DateRequestedDelivery>
		
	</cfif>
	
	<cfparam name="Form.DateMemoDelivery" default="">	
		
	<!--- save action --->
	
	<cf_WorkOrderActionFields
	       mission        = "#url.mission#" 
	       serviceitem    = "#url.serviceitem#" 
		   workorderid    = "#id#" 
		   workorderline  = "#url.workorderline#"
		   mode           = "save">	
	
					
	<!--- save provisioing --->
	<cfparam name="url.billingid"        default="">	
	<cfparam name="Form.DateEffective"   default="#dateformat(now(),CLIENT.DateFormatShow)#">
	<cfparam name="Form.DateExpiration"  default="#dateformat(now(),CLIENT.DateFormatShow)#">
	<cfset url.workorderid = id>		
		
	<cfinclude template="../../ServiceDetails/Billing/DetailBillingSubmit.cfm">
				
	</cftransaction>			
	
	<!--- send mail to processor --->
		
	<cfif url.context eq "Portal" and mail eq "1">
	
	    <cfinclude template="DocumentFormDeliveryMail.cfm">
		
	</cfif>
		
</cfif>	


<cfoutput>

	<script>

		<cfif form.scope eq "entry">	
				    		    
			returnValue = 1
			window.close()
			// ColdFusion.navigate('CustomerEdit.cfm?height='+h+'&dsn=appsWorkOrder&customerid=#url.customerid#&mode=view','detail',mycallBack,myerrorhandler)				  
			
		<cfelseif form.scope eq "add">	
				
		    try { parent.opener.applyfilter('1','','content') } catch(e) {}			
			try { opener.reloadtree();opener.reloadcontent('full') } catch(e) {}
			window.close()		
		
		<cfelseif form.scope eq "edit">		
		
			try { opener.applyfilter('1','','#get.workorderlineid#') } catch(e) {}		
			try { opener.reloadtree();opener.reloadcontent('full') } catch(e) {}
			
			// refresh the context of opening 
			
			try { opener.document.getElementById('#url.box#').click() } catch(e) {}
							   
			window.close()			
			
		</cfif>	

	</script>
		
</cfoutput>
