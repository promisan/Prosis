<!--- ------------------------------------------------------------------------------------------ --->
<!--- Component to serve requests that relate to the provisioing of a service based workorder -- ---> 
<!--- ------------------------------------------------------------------------------------------ --->
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Delivery Component">
	
	<cffunction name="addDelivery"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="addDelivery">
		
		<cfargument name="Mode" type="string" default="Add" required="yes">
		<cfargument name="BatchId"                 type="string" required="true">
		<cfargument name="DataSource"              type="string" default="appsMaterials" required="true">
		<cfargument name="ServiceDomain"           type="string" default="Shipment"      required="yes">
		<cfargument name="ActionClassDelivery"     type="string" default="Delivery"      required="yes">
		<cfargument name="ActionClassNotification" type="string" default="">
		<cfargument name="AddressType"             type="string" default="Shipping">
		<cfargument name="DeliveryDate"            type="string" default="#dateformat(now()+1,client.dateformatshow)#" required="yes">
		
		<!--- 
		
		1.	from the batch id we link from the itemtransactions to the workorder -> customer and workorderline
		2.	we check if the customer has an address/eMail otherwise we inherit it from a organizationaddress
		3.  add workorder for 
			   the service item with the domain above, 
			   workorderid == batchid
		       orgunit owner is unit of the warehouse to be collected (in case of pick will be the unit of the pickup like Walmart, 			    
			   reference == reference of the sale workorder
		4.	add workorderline with implementer the unit of the warehouse
		       line = 1
			   Domain = servicedomain
			   OrgUnit = unit of the workorder (sales unit)
			   Implementer = [shipping unit can be the same as the warehouse here]
			   Reference = NULL
			   Effective = today + 1 	
			   Source = 'Batch"
			   SourceId = batchid
		4.	add workorderlineaction for delivery and notification
				
		Ask Diaz to adjust the print-out       
		
		--->
		
		<cfquery name="get"
			datasource="#DataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT   *
			FROM     Materials.dbo.WarehouseBatch
			WHERE    BatchId = '#batchId#'			
		</cfquery>		
		
		<cfif mode eq "add">
		
			<cfquery name="serviceItem"
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT   TOP 1 *
				FROM     WorkOrder.dbo.ServiceItem
				WHERE    ServiceDomain = '#servicedomain#'			
				AND      Code IN (SELECT ServiceItem FROM WorkOrder.dbo.ServiceItemMission WHERE Mission = '#get.Mission#')
			</cfquery>		
			
			<cfquery name="checkPrior"
				datasource="#Datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT  * 
				FROM    WorkOrder.dbo.WorkOrder
				WHERE   WorkOrderId = '#batchid#'				
			</cfquery>	
			
			<cfquery name="set"
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					
				UPDATE   WorkOrder.dbo.WorkOrder
				SET      ActionStatus = '1'
				WHERE    WorkOrderId = '#batchId#'			
				
			</cfquery>		
			
			<cfquery name="ShipmentOrder"
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						
					SELECT   T.Mission, 
							 W.CustomerId,					
					         T.WorkOrderId, 
					         T.OrgUnit AS OrgUnitImplementer, 
							 T.Warehouse, 
							 Whs.MissionOrgUnitId, 
							 MAX(T.OrgUnit) AS OrgUnitOwner, 
							 COUNT(*) AS Items, 
							 W.Reference
					FROM     Materials.dbo.ItemTransaction AS T INNER JOIN
		                     Materials.dbo.Warehouse AS Whs ON T.Warehouse = Whs.Warehouse INNER JOIN
		                     Organization.dbo.Organization AS O ON Whs.MissionOrgUnitId = O.MissionOrgUnitId INNER JOIN
		                     WorkOrder.dbo.WorkOrder AS W ON T.WorkOrderId = W.WorkOrderId
					WHERE    T.TransactionType = '2' 
					AND      T.TransactionBatchNo = '#get.BatchNo#'
		            GROUP BY  T.Mission, 
							 W.CustomerId,		
							 T.WorkOrderId, 
					         T.OrgUnit, 
							 T.Warehouse, 
							 Whs.MissionOrgUnitId, 
							 O.OrgUnitName, 
							 T.OrgUnitCode, 
							 T.OrgUnitName, 
							 W.Reference
							 
			</cfquery>	
				
			<cfquery name="Customer"
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				
					SELECT  * 
					FROM    WorkOrder.dbo.Customer
					WHERE   Customerid = '#ShipmentOrder.CustomerId#'			
					
			</cfquery>				
			
			<cfquery name="getAddress"
					datasource="#DataSource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
				
					SELECT       OA.TelephoneNo, 
					             OA.MobileNo, 
								 R.Country,
								 R.AddressPostalCode, 
								 R.AddressCity, 
								 R.Address, 
								 R.Coordinates
					FROM         Organization.dbo.OrganizationAddress AS OA INNER JOIN
			                     System.dbo.Ref_Address AS R ON OA.AddressId = R.AddressId
					WHERE        OA.OrgUnit     = '#Customer.OrgUnit#' 
					AND          OA.AddressType = '#AddressType#'	
								
				</cfquery>
				
			<cfquery name="setCustomer"
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
						
					UPDATE  WorkOrder.dbo.Customer
					
					SET     PhoneNumber  = '#getAddress.TelephoneNo#',
					        MobileNumber = '#getAddress.MobileNo#',
							PostalCode   = '#getAddress.AddressPostalCode#',
							City         = '#getAddress.AddressCity#',
							Address      = '#getAddress.Address#',
							Coordinates  = '#getAddress.Coordinates#'
							 
					WHERE   Customerid   = '#ShipmentOrder.CustomerId#'				
					
			</cfquery>			
			
			<!--- get service item --->
		
			<cfif checkPrior.recordcount eq "0" and serviceitem.recordcount gte "1">					
			
				<cfquery name="addDeliveryOrder"
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					INSERT INTO WorkOrder.dbo.WorkOrder
							(WorkOrderId, 
							 Reference, 
							 Mission, 
							 ServiceItem, 
							 CustomerId, 					 
							 OrderDate, 					 
							 OrgUnitOwner, 					  
							 ActionStatus, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)
					 VALUES 
					 		('#batchid#',
						     '#ShipmentOrder.Reference#',
							 '#ShipmentOrder.Mission#',		
							 '#ServiceItem.code#',
							 '#ShipmentOrder.CustomerId#',
							 '#dateformat(now(),client.dateSQL)#',
							 '#ShipmentOrder.OrgUnitOwner#',
							 '1',
							 '#session.acc#',
							 '#session.last#',
							 '#session.first#')				
				</cfquery>	
				
				<cftry>
				
					<cfquery name="addService"
						datasource="#Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						INSERT INTO WorkOrder.dbo.WorkOrderService (				
						 		ServiceDomain, 						
								Reference, 										
								OfficerUserId, 
								OfficerLastName, 
		                        OfficerFirstName 					
								)
								
						 VALUES	('#ServiceDomain#', 					     
								 'FactoryDelivery',												 
								 '#session.acc#',
								 '#session.last#',
								 '#session.first#')
						
					</cfquery>	
					
					<cfcatch></cfcatch>
				
				</cftry>
			
				<cfquery name="addDeliveryOrderLine"
					datasource="#Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					INSERT INTO WorkOrder.dbo.WorkOrderLine (				
					 		WorkOrderId, 
							WorkOrderLine, 						
							ServiceDomain, 
							<!---
							ServiceDomainClass, 
							--->
							OrgUnitImplementer, 
							Reference, 
							DateEffective, 						
							OrgUnit, 						
							Source,                       				
							ActionStatus, 						
							OfficerUserId, 
							OfficerLastName, 
	                        OfficerFirstName 					
							)
							
					 VALUES	('#batchid#',
							 '1',
							'#ServiceDomain#', 
						     '#ShipmentOrder.OrgUnitImplementer#',
							 'FactoryDelivery',						
							 '#dateformat(now(),client.dateSQL)#',
							 '#ShipmentOrder.OrgUnitImplementer#',
							 'Batch',						
							 '1',
							 '#session.acc#',
							 '#session.last#',
							 '#session.first#')
					
				</cfquery>	
				
				<!--- ----------------------------- --->
				<!--- ---delivery action request--- --->
				<!--- ----------------------------- --->
											
				<cf_assignid>
				
				<cfquery name="InsertAction" 
				  datasource="#Datasource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  
				  INSERT INTO  WorkOrder.dbo.WorkOrderLineAction
					 		 (WorkActionId,
							  WorkOrderId,
							  WorkOrderLine, 
							  ActionClass,
							  DateTimeRequested,
							  DateTimePlanning, 						  						  				
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					  VALUES ('#rowguid#',
					          '#batchid#',
					          '1',
							  '#ActionClassDelivery#',
							  '#dateformat(now(),client.dateSQL)#',		
							  '#dateformat(now(),client.dateSQL)#',						  		 
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')						  
							  
				</cfquery>				
								
				<!--- ----------------------------- --->
				<!--- delivery notification request ---> 
				<!--- ----------------------------- --->
				
				<cfif ActionClassNotification neq "">
				
					<cf_assignid>
					
					<cfquery name="InsertAction" 
					  datasource="#Datasource#" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  
					  INSERT INTO WorkOrder.dbo.WorkOrderLineAction
						 		 (WorkActionId,
								  WorkOrderId,
								  WorkOrderLine, 
								  ActionClass,
								  DateTimeRequested,
								  DateTimePlanning, 						  						  				
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
						  VALUES ('#rowguid#',
						          '#batchid#',
						          '1',
								  '#ActionClassNotification#',
								  '#dateformat(now(),client.dateSQL)#',		
								  '#dateformat(now(),client.dateSQL)#',						  		 
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')						  
								  
					</cfquery>	
				
				</cfif>
						
			</cfif>		
			
		<cfelseif mode eq "Cancel">	 	
		
			<cfquery name="set"
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				UPDATE   WorkOrder.dbo.WorkOrder
				SET      ActionStatus = '9'
				WHERE    WorkOrderId = '#batchId#'			
			</cfquery>							
		
		</cfif>	
		
	</cffunction>	
	
	<cffunction name="checkWorkPlan"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="Yes"
        displayname="checkWorkPlan">
				  
		 <cfargument name="Validation"    type="string" required="yes" default="No">
		 <cfargument name="Date"          type="string" required="true">			
		 <cfargument name="DateHour" 	  type="string" default="">
		 <cfargument name="DateMinute"    type="string" default="">						
		 <cfargument name="Mission"       type="string" required="true">
		 <cfargument name="CustomerId"    type="string" required="true">
		 <cfargument name="ServiceItem"   type="string" required="false">
		 <cfargument name="PositionNo"    type="string" required="true">					
		 <cfargument name="PlanOrderCode" type="string" default="">		
		 
		 <cfset dateValue = "">
		 <CF_DateConvert Value="#date#">
		 <cfset dts = dateValue>
			
		 <cfif datehour neq "">			
				<cfset dtp = DateAdd("h",datehour,  dts)>
				<cfset dtp = DateAdd("n",dateminute,dtp)>
		 <cfelse>
				<cfset dtp = dts>
		 </cfif>
		 
		  <cfset accepted = "1">
		 
		 <!--- check if the schedule for this person allows for overlap --->
				
		<cfquery name="workschedule" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
				SELECT   *
				FROM     Employee.dbo.WorkSchedulePosition
				WHERE    PositionNo = '#PositionNo#' 					
				AND      DAY(CalendarDate)   = #day(dts)# 
				AND      MONTH(CalendarDate) = #month(dts)#
				AND      YEAR(CalendarDate)  = #year(dts)#									
		</cfquery>	
				
		<cfif workschedule.recordcount gte "1">
										
				<cfquery name="getWorkSchedule" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  * 
						FROM    Employee.dbo.WorkSchedule
						WHERE   Code = '#workschedule.workschedule#'								
				</cfquery>
													
				<cfquery name="checkWorkPlan"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					SELECT    WPD.*
					FROM      WorkPlanDetail WPD INNER JOIN
				              WorkOrderLineAction WLA ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
				              WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
				              WorkPlan WP ON WPD.WorkPlanId = WP.WorkPlanId
					WHERE     W.Mission              = '#mission#'				
					AND       WP.PositionNo          = '#PositionNo#'		
					AND       WPD.DateTimePlanning   = #dtp# 	
					AND       Operational = 1 <!--- schedule is enabled --->
					AND       EXISTS (SELECT 'X' 
					                  FROM   WorkOrderLineAction 
									  WHERE  WorkActionId = WLA.WorkActionId
									  AND    ActionStatus != '9') <!--- action is valid --->
																						
				</cfquery>	
								
				<cfif checkworkplan.recordcount gte "1">
				
					<cfif getWorkSchedule.MultipleActions eq "0">			
		
					 <cfset accepted = "9">
					 
					<cfelse>
					
					 <cfset accepted = "7">
					
					</cfif> 
					
				<cfelse>
				
					<!--- check if person has already a confliucting appointment for the same service on the same day --->
				
					<cfquery name="check"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					
						SELECT    C.CustomerId, WP.PositionNo, W.ServiceItem, WPD.DateTimePlanning
						FROM      WorkOrder W INNER JOIN
		                		  WorkOrderLineAction WLA ON W.WorkOrderId = WLA.WorkOrderId INNER JOIN
			                      Customer C ON W.CustomerId = C.CustomerId INNER JOIN
		    	                  WorkPlanDetail WPD ON WLA.WorkActionId = WPD.WorkActionId INNER JOIN
		    	                  WorkPlan WP ON WP.WorkPlanId = WPD.WorkPlanId
						WHERE     W.CustomerId                = '#CustomerId#' 
						<!--- AND     W.ServiceItem               = '#ServiceItem#'	--->
											
						AND       DAY(WPD.DateTimePlanning)   = #day(dtp)# 
						AND       MONTH(WPD.DateTimePlanning) = #month(dtp)#
						AND       YEAR(WPD.DateTimePlanning)  = #year(dtp)# 
						AND       WPD.Operational = 1
						AND       WLA.ActionStatus != '9'
												
					</cfquery>		
														
					<cfif check.recordcount gte "1">
					
						<cfset accepted = "9">
					
					</cfif>	
						 
				</cfif> 
		
		 </cfif>		 	
		 
		 <cfreturn Accepted>
				
	</cffunction>	
	
	<cffunction name="applyWorkPlan"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="Yes"
        displayname="applyWorkPlan">
		
		    <cfargument name="WorkActionId"  type="string" required="true">
			<cfargument name="Action"        type="string" required="yes" default="Apply">
			<cfargument name="Validation"    type="string" required="yes" default="No">
						
		    <cfargument name="Date"          type="string" required="true">			
			<cfargument name="DateHour" 	 type="string" default="">
			<cfargument name="DateMinute"    type="string" default="">
						
			<cfargument name="Mission"       type="string" required="true">
			<cfargument name="PositionNo"    type="string" required="true">		
			
			<cfargument name="PlanOrderCode" type="string" default="">		
			
			<cfargument name="Topic1"        type="string" required="false" default="">
			<cfargument name="Topic1Value"   type="string" required="false" default="">
			<cfargument name="Topic2"        type="string" required="false" default="">
			<cfargument name="Topic2Value"   type="string" required="false" default="">
			<cfargument name="Topic3"        type="string" required="false" default="">
			<cfargument name="Topic3Value"   type="string" required="false" default="">
			<cfargument name="Topic4"        type="string" required="false" default="">
			<cfargument name="Topic4Value"   type="string" required="false" default="">						
	
			<cfset dateValue = "">
			<CF_DateConvert Value="#date#">
			<cfset dts = dateValue>
			
			<cfif datehour neq "">			
				<cfset dtp = DateAdd("h",datehour,  dts)>
				<cfset dtp = DateAdd("n",dateminute,dtp)>
			<cfelse>
				<cfset dtp = dts>
			</cfif>
									
			<!--- manual planner 
						
			1. check if workplan record exists, 
					if exists for a different date we remove it first
					create record if needed
			2. add record, and check if branch exists, if not add branc
			3. Refresh right (ability to relink)
			--->

			<cfquery name="WorkOrder"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">									
				SELECT     *
				FROM       Workorder
				WHERE      WorkOrderId IN (SELECT WorkOrderId
				                           FROM   WorkOrderLineAction 
										   WHERE  WorkActionId = '#workactionid#')			
			</cfquery>			

			<cfquery name="Actor"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">						
			
				SELECT     PA.PositionNo, 
						   PA.OrgUnit,	
				           PA.FunctionNo, 
						   PA.FunctionDescription, 
						   P.PersonNo, 
						   P.LastName, 
						   P.FirstName, 
						   PA.DateEffective, 
						   PA.DateExpiration
						   
				FROM       Employee.dbo.Person AS P INNER JOIN
	                       Employee.dbo.PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
		                   Employee.dbo.Position AS Pos ON PA.PositionNo = Pos.PositionNo
				WHERE      PA.DateEffective  <= #dts#
				AND        PA.DateExpiration >= #dts#
				AND        PA.AssignmentStatus IN ('0', '1') 
				AND        Pos.Mission       = '#mission#' 
				AND        Pos.PositionNo    = '#PositionNo#'
			</cfquery>		
			
			<cfif Validation eq "SameDay">
			
				<!--- check if the schedule for this person allows for overlap --->
				
				<cfquery name="workschedule" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT   *
					FROM     Employee.dbo.WorkSchedulePosition
					WHERE    PositionNo = '#PositionNo#' 					
					AND      DAY(CalendarDate)   = #day(dts)# 
					AND      MONTH(CalendarDate) = #month(dts)#
					AND      YEAR(CalendarDate)  = #year(dts)#					
				</cfquery>	
				
				<cfif workschedule.recordcount gte "1">
								
					<cfquery name="getWorkSchedule" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  * 
						FROM    Employee.dbo.WorkSchedule
						WHERE   Code = '#workschedule.workschedule#'								
					</cfquery>
				
					<cfif getWorkSchedule.MultipleActions eq "0">
					
						<cfquery name="checkWorkPlan"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT    C.*,WPD.*
							FROM      WorkPlanDetail WPD INNER JOIN
						              WorkOrderLineAction WLA ON WPD.WorkActionId = WLA.WorkActionId INNER JOIN
						              WorkOrder W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
									  Customer C ON C.CustomerId = W.CustomerId INNER JOIN
						              WorkPlan WP ON WPD.WorkPlanId = WP.WorkPlanId
							WHERE     W.Mission              = '#mission#'				
							AND       WP.PositionNo          = '#PositionNo#'		
							AND       WPD.DateTimePlanning   = #dtp# 	
							AND       WPD.Operational = 1 <!--- schedule is active --->
							AND       EXISTS (SELECT 'X' 
					                          FROM   WorkOrderLineAction 
										      WHERE  WorkActionId = WLA.WorkActionId
										      AND    ActionStatus != '9') <!--- action is valid    --->
																								
						</cfquery>				
						
						<cfif checkworkplan.recordcount gte "1">
				
							<cf_tl id="Conflict in schedule found" var="conflict">
							<cf_tl id="Select different date or slot" var="slot">
							<cfoutput>
							<script>					
								alert("#conflict#:[1]\n\n#dateformat(dtp,client.dateformatshow)# @ #timeformat(dtp,'HH:MM')#\n#checkWorkplan.CustomerName#\n\n#slot#")
								Prosis.busy('no')
							</script>
							</cfoutput>
							
							<cfabort>
														
						</cfif>				
					
					</cfif>
				
				</cfif>
			
			    <!--- check if for the same customer we have on this date an entry already --->
			
				<cfquery name="check"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				
					SELECT    C.CustomerId, WP.PositionNo, W.ServiceItem, WPD.DateTimePlanning
					FROM      WorkOrder W INNER JOIN
	                		  WorkOrderLineAction WLA ON W.WorkOrderId = WLA.WorkOrderId INNER JOIN
		                      Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	    	                  WorkPlanDetail WPD ON WLA.WorkActionId = WPD.WorkActionId INNER JOIN
	    	                  WorkPlan WP ON WP.WorkPlanId = WPD.WorkPlanId
					WHERE     W.CustomerId   = '#WorkOrder.CustomerId#' 
					AND       W.ServiceItem  = '#WorkOrder.ServiceItem#'
					<!---
					AND       WP.PositionNo  = '#PositionNo#' 
					--->
					AND       DAY(WPD.DateTimePlanning)   = #day(dts)# 
					AND       MONTH(WPD.DateTimePlanning) = #month(dts)#
					AND       YEAR(WPD.DateTimePlanning)  = #year(dtp)# 
					AND       WPD.Operational = 1
					AND       WLA.ActionStatus != '9'
					
				</cfquery>
						
				
				<cfif check.recordcount gte "1">
				
					<cfquery name="get"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
				
						SELECT    *
						FROM      Customer
						WHERE     Customerid = '#workorder.customerid#'		
								
					</cfquery>
				
					<cf_tl id="has a scheduled action on" var="mes">
					<cf_tl id="This operation is not supported" var="sup">
				
				    <cfoutput>
					<script>
						alert("#get.customername# #mes#: #dateformat(dts,dateformatshow)#.\n#sup#.")
						Prosis.busy('no')
					</script>
					</cfoutput>
					
					<cfabort>
				
				</cfif>
						
			</cfif>	
			
			<cfquery name="WorkPlan"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				
					SELECT *
				    FROM   WorkPlan W
				    WHERE  W.Mission      = '#mission#'
					AND    W.PositionNo   = '#PositionNo#'
					AND    DateEffective  <= #dts# 
				    AND    DateExpiration >= #dts#  
							
			</cfquery>		

			<cftransaction>			

			<cfif WorkPlan.recordcount eq "0">
				
				<cf_assignid>
				<cfset workplanid = rowguid>
			
				<!--- create workplan --->
					
				<cfquery name="addWorkPlan"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
								
				
					INSERT INTO WorkPlan 
						
						(WorkPlanId, 
						 Mission, 
						 OrgUnit, 
						 PositionNo, 
						 PersonNo, 
						 DateEffective, 
						 DateExpiration, 		
						 OfficerUserid, 
						 OfficerLastName, 
				         OfficerFirstName)		
					  
					 VALUES
					 
						 ('#workplanid#',
						  '#url.mission#',
						  '#Actor.OrgUnit#',
						  '#Actor.PositionNo#',
						  '#Actor.PersonNo#',
						  #dts#,
						  #dts#,
						  '#session.acc#',
						  '#session.last#',
						  '#session.first#')
						 							
				</cfquery>			
			
			<cfelse>
			
				<cfset workplanid = workplan.workplanid>
			
			</cfif>		
			
			<cfif topic1 neq "">
					
				<cfquery name="GetTopics" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT  *
					  FROM    Ref_Topic 
					  WHERE   Code = '#topic1#'				 
					  AND     (Mission = '#url.Mission#' or Mission is NULL)				 
					  AND     Operational = 1   
					  AND     TopicClass = 'WorkOrder'			  			  
				</cfquery>
			
				<cfloop query="getTopics">
							    			
					 <cfquery name="DeactivateValues" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						 UPDATE  WorkPlanTopic
						 SET     Operational   = 0
						 WHERE   WorkPlanId    = '#workplanid#'		  		
						 AND     Topic         = '#Code#'			
				     </cfquery>
							
					 <cfif ValueClass eq "List">
									
						 <cfquery name="GetList" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							  SELECT *
							  FROM   Ref_TopicList
							  WHERE  Code     = '#Code#'
							  AND    ListCode = '#topic1value#'				  
						</cfquery>		
									
						<cfif topic1value neq "">
								
							<cfquery name="SelectCurrentValue" 
							  datasource="AppsWorkOrder" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT   TOP 1 * 
								  FROM     WorkPlanTopic
								  WHERE    WorkPlanId    = '#workplanid#'	  			 
								  AND      Topic         = '#Code#'
								  ORDER BY DateEffective DESC 						  						  
						    </cfquery>		
						
					        <!--- check if new value = last value --->
							
							<cfif action neq "purge">
							
								<cfif getList.ListValue eq SelectCurrentValue.TopicValue>
														
								     <!--- reactivate --->
									 
									<cfquery name="CheckLast" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">							  								     			  	
										  UPDATE  WorkPlanTopic 
										  SET     Operational   = 1
										  WHERE   WorkPlanId    = '#workplanid#'	 	  					 
										  AND     Topic         = '#Code#' 
										  AND     DateEffective = '#SelectCurrentValue.DateEffective#'		
								   </cfquery>		
							 
								<cfelse>											
										  		
									<cfquery name="CleanSameDateEntries" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">											     
										  DELETE  FROM    WorkPlanTopic
										  WHERE   WorkPlanId      = '#workplanid#'						  
										  AND     Topic           = '#Code#'
										  AND     DateEffective   >  '#dateformat(now()-1,client.dateSQL)#'			
								    </cfquery>								
																	
									<cfquery name="InsertTopics" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  INSERT INTO  WorkplanTopic
									 		 (WorkPlanId,							  
											  Topic,
											  DateEffective,
											  ListCode,
											  TopicValue,
											  OfficerUserId,
											  OfficerLastName,
											  OfficerFirstName)
									  VALUES ('#workplanid#',					          
									          '#Code#',
											  getDate(),
											  '#topic1value#',
											  '#getList.ListValue#',
											  '#SESSION.acc#',
											  '#SESSION.last#',
											  '#SESSION.first#') 
											  
									</cfquery>
																	
								</cfif>								
												
							<cfelse>
							
									<!--- deactivate --->
									 
									<cfquery name="CheckLast" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">		
									  		  	
									  UPDATE  WorkPlanTopic 
									  SET     Operational   = 0
									  WHERE   WorkPlanId    = '#workplanid#'		  					  
									  AND     Topic         = '#Code#'
									  AND     DateEffective = '#SelectCurrentValue.DateEffective#'		
								   </cfquery>						
							
							</cfif>						
								
						</cfif>
							
					<cfelse>
					
						<cfquery name="SelectCurrentValue" 
							  datasource="AppsWorkOrder" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  SELECT   TOP 1 * 
							  FROM     WorkPlanTopic
							  WHERE    WorkPlanId    = '#workplanid#'		  			 
							  AND      Topic         = '#Code#'
							  ORDER BY DateEffective DESC 
						    </cfquery>		
																
						<cfif topic1value neq "">
						
							<cfif action neq "purge">
						
								<cfif topic1value eq SelectCurrentValue.TopicValue>
								
								     <!--- reactivate --->
									 
									<cfquery name="UpdateLast" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  UPDATE  WorkPlanTopic
									  SET     Operational = 1
									  WHERE   WorkPlanId    = '#workplanid#'		  					 
									  AND     Topic         = '#Code#'
									  AND     DateEffective = '#SelectCurrentValue.DateEffective#'			 
								   </cfquery>		
							 
								<cfelse>
							
									<cfquery name="CleanSameDateValues" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  DELETE  FROM    WorkPlanTopic
									  WHERE   WorkPlanId    = '#workplanid#'						 
									  AND     Topic         = '#Code#'
									  AND     DateEffective =  '#dateformat(now(),client.dateSQL)#'			  
								    </cfquery>
								
									<cfquery name="InsertTopics" 
									  datasource="AppsWorkOrder" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
									  INSERT INTO WorkPlanTopic
									 			 (WorkPlanId,								 
												  Topic, 
												  DateEffective, 
												  TopicValue,
												  OfficerUserId,
												  OfficerLastName,
												  OfficerFirstName)
									  VALUES 	 ('#workplanid#',					             
												  '#Code#',
												  getDate(),
												  '#topic1value#',
												  '#SESSION.acc#',
												  '#SESSION.last#',
												  '#SESSION.first#')
									</cfquery>	
									
								</cfif>	
							
							<cfelse>
						
								<!--- reset --->
						
								<cfquery name="CheckLast" 
								  datasource="AppsWorkOrder" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">						  	
								  UPDATE  WorkPlanTopic 
								  SET     Operational   = 0
								  WHERE   WorkPlanId    = '#workplanId#'		  				 
								  AND     Topic         = '#Code#'				 
							   </cfquery>				
						
							</cfif>
							
						</cfif>	
						
					</cfif>	
				
				</cfloop>
					
			</cfif>	
						
			<!--- ------------------ --->
			<!--- end of custom code --->
			<!--- ------------------ --->	
						
			<cfquery name="getLast"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT MAX(PlanOrder) as Last
				FROM   WorkPlanDetail
				WHERE  WorkPlanId = '#workplanid#'			
			</cfquery>		
			
			<cfif getLast.Last eq "">
				<cfset last = "1">
			<cfelse>
				<cfset last = getLast.Last+1>	
			</cfif>	
			
			
			<cfif workorder.serviceitem eq "Delivery">
			
				<!--- ------------------------------------------------- --->
				<!--- check if the branch exists otherwise add it first --->
				<!--- ------------------------------------------------- --->
				<!--- ----- KUNTZ provision to ensure a pick-up visit   --->			
			
				<cfquery name="getOwner"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT *
					FROM   WorkPlanDetail
					WHERE  WorkPlanId   = '#workplanid#'			
					AND    OrgUnitOwner = '#workorder.orgunitowner#'
				</cfquery>		
				
				<cfif getOwner.recordcount eq "0">
						
					<cfquery name="addWorkPlanDetail"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
											
						INSERT INTO WorkPlanDetail (
								WorkPlanId, 
								PlanOrder, 
								PlanOrderCode, 
							    PlanActionMemo, 
							    DateTimePlanning, 		    
							    OrgUnitOwner, 
							    OfficerUserId, 
							    OfficerLastName, 
					            OfficerFirstName
					      ) VALUES (
						  	'#workplanid#',
							'#last#',
							<cfif PlanOrderCode neq "">
							'#PlanOrderCode#',
							<cfelse>
							NULL,
							</cfif>
							'Manual',
							#dtp#,
							'#workorder.orgunitowner#',
							'#session.acc#',
							'#session.last#',
							'#session.first#')			  			
					</cfquery>		
					
					<cfset last = last+1>	
				
				</cfif>
			
			</cfif>
			
			<!--- action was planned for today and this it will be removed if NOT for the same position it was planned --->

			<cfquery name="Set" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				DELETE FROM WorkPlanDetail
				WHERE     WorkActionId  = '#workactionid#'
				<!--- action was planned for today and this it will be removed if NOT for the same position it was planned --->
				AND       WorkPlanId IN (SELECT WorkPlanId
				                         FROM   WorkPlan
										 WHERE  Mission     = '#mission#'
										 AND    PositionNo != '#PositionNo#'
										 AND    DateEffective  <= #dts# 
			                             AND    DateExpiration >= #dts# )
			    	  
			</cfquery>
			
			<!--- action was planned but not planner for another date --->
			
			<cfquery name="Set" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				DELETE FROM WorkPlanDetail
				WHERE     WorkActionId  = '#workactionid#'				
				AND       DateTimePlanning != #dtp#		  
			</cfquery>
			
			<cfquery name="getAction"
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT *
				FROM   WorkPlanDetail
				WHERE  WorkPlanId   = '#workplanid#'			
				AND    WorkActionId = '#workactionid#'
			</cfquery>	

			<cfif getAction.recordcount eq "0">
				
				<!--- add the line --->
				
				<cfquery name="addWorkPlanDetail"
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
										
						INSERT INTO WorkPlanDetail (
							WorkPlanId, 
							PlanOrder, 
							PlanOrderCode, 
						    PlanActionMemo, 
						    DateTimePlanning, 		    
						    WorkActionId, 
						    OfficerUserId, 
						    OfficerLastName, 
				            OfficerFirstName
						) VALUES (
						  '#workplanid#',
						  '#last#',
						  <cfif PlanOrderCode neq "">
						  '#PlanOrderCode#',
						  <cfelse>
						  NULL,
						  </cfif>
						  'Manual',
						  #dtp#,
						  '#workactionid#',
						  '#session.acc#',
						  '#session.last#',
						  '#session.first#')		
						  		
				</cfquery>	
				
			<cfelse>
			
				<cfif PlanOrderCode neq "">
				
					<cfquery name="getAction"
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						UPDATE WorkPlanDetail
						SET    PlanOrderCode = '#PlanOrderCode#'
						WHERE  WorkPlanId   = '#workplanid#'			
						AND    WorkActionId = '#workactionid#'
					</cfquery>	
					
				</cfif>	
		
			</cfif>		

		   </cftransaction>
		   
		   <cfif PlanOrderCode neq "">
		   
		   		<!--- adjusts the order of the records in case no specific time is set like for kuntz --->
							
				<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
				   method           = "setWorkPlanOrder" 
				   WorkPlanId       = "#workplanid#">   						
			   
			</cfif>   
						
	</cffunction>				
	
	<cffunction name="setWorkPlanOrder"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="setWorkPlanOrder">
		
		<cfargument name="workplanId"   type="string" required="false">		
		
			 <cfif workplanid neq "">
										
				<!--- reset --->
				
				<cfquery name="worklist" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT    WorkActionId
					FROM      WorkPlanDetail
					WHERE     WorkPlanId = '#workplanId#'
					AND       WorkActionid is not NULL
				</cfquery>
				
				<!--- ---------------------------------------------------------------------------------------- --->
				<!-- we check if there are any branch visits that lie after the first delivery of that branch, 
				if so we adjust this owner to the schedulecode of the first	delivery for that branch           --->
				<!--- ---------------------------------------------------------------------------------------- --->
				
				<cfquery name="getFirstOwner" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT     W.OrgUnitOwner, 
					           MIN(R.ListingOrder) AS ListingOrder
					FROM       WorkPlanDetail AS D INNER JOIN
				               WorkOrderLineAction AS WLA ON D.WorkActionId = WLA.WorkActionId INNER JOIN
				               WorkOrder AS W ON WLA.WorkOrderId = W.WorkOrderId INNER JOIN
				               Ref_PlanOrder AS R ON D.PlanOrderCode = R.Code
					WHERE      D.WorkPlanId = '#workplanId#' 
					AND        D.OrgUnitOwner IS NULL
					GROUP BY W.OrgUnitOwner
				</cfquery>
				
				<cfloop query="getFirstOwner">
						
					<cfquery name="get" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT    *
							FROM      Ref_PlanOrder
							WHERE     ListingOrder = '#ListingOrder#'	
					</cfquery>
					
					<cfquery name="ownerorder" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT   ListingOrder
							FROM     WorkPlanDetail D, Ref_PlanOrder R			
							WHERE    WorkPlanId         = '#workplanId#'
							AND      D.PlanOrderCode    = R.Code
							AND      OrgUnitOwner       = '#orgunitowner#'								    	  
					</cfquery>		
						
					<cfif ownerorder.listingorder gt listingorder>	
					
						<!--- reset --->		
					
						<cfquery name="update" 
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
								UPDATE   WorkPlanDetail
								SET      PlanOrderCode   = '#get.Code#'
								WHERE    WorkPlanId      = '#workplanId#'
								AND      OrgUnitOwner    = '#orgunitowner#'								    	  
						</cfquery>	
					
					</cfif>	
						 
				</cfloop>	
				
				<cfquery name="get" 
					datasource="appsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT    WorkPlanId, 
					          WorkPlanDetailId,
					          PlanOrder, 
							  PlanOrderCode, 
							  DateTimePlanning, 
							  OrgUnitOwner, 
							  WorkActionId
					FROM      WorkPlanDetail W, Ref_PlanOrder R
					WHERE     W.PlanOrderCode = R.Code
					AND       WorkPlanId = '#workplanId#'
					ORDER BY  R.ListingOrder, 	          
							  W.OrgUnitOwner DESC,
							  W.PlanOrder 
				</cfquery>
				
				<cfset order = 0>
				
				<cfoutput query="get">
					
					<cfset go = "1">
							
					<cfif OrgUnitOwner neq "">
					
						<!--- we check if this owner has any deliveries in the list of the user, if not we remove the owner visit  --->	
						
						<cfset list = QuotedValueList(worklist.WorkActionid)>
						
						<cfif list eq "">
						
							<cfquery name="removeOwner" 
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
									DELETE FROM WorkPlanDetail
									WHERE  WorkPlanId = '#workplanId#'
									AND    OrgUnitOwner = '#orgUnitOwner#'					    	  
							</cfquery>
								
							<cfset go = "0">
						
						<cfelse>
							
							<cfquery name="check" 
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
								SELECT     WorkActionId
								FROM       WorkOrder W, WorkOrderLineAction WA
								WHERE      W.OrgUnitOwner = '#orgunitOwner#'
								AND        W.WorkOrderId = WA.WorkOrderId
								AND        WA.WorkActionId IN (#preserveSingleQuotes(list)#)
							</cfquery>
							
							<cfif check.recordcount eq "0">
							
								<cfquery name="removeOwner" 
								datasource="appsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
									DELETE FROM WorkPlanDetail
									WHERE  WorkPlanId = '#workplanId#'
									AND    OrgUnitOwner = '#orgUnitOwner#'					    	  
							    </cfquery>
								
								<cfset go = "0">
												
							</cfif>
						
						</cfif>
						
					</cfif>
					
					<!--- now we do a sequential order --->
					
					<cfif go eq "1">
					
						<cfset order= order+1>
					
						<cfquery name="update" 
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
								UPDATE   WorkPlanDetail
								SET      PlanOrder        = '#order#'
								WHERE    WorkPlanId       = '#workplanId#'
								AND      WorkPlanDetailid = '#workplanDetailid#'								    	  
						 </cfquery>		
					
					</cfif>			
			
			</cfoutput>	
			
			</cfif>
								
	</cffunction>
	
	<cffunction name="moveWorkPlanOrder"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="moveWorkPlanOrder">
		
			<cfargument name="WorkOrderId"        type="string" required="false">			
				
			<cfreturn get>	
					
	</cffunction>
		
		
</cfcomponent>	