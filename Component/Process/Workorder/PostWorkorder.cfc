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
<!--- 

   This component contain several method which can be called to apply changes to socalled service based workorders which
   are controlled by a service amendment request (new service, port service, terminate etc.)
   
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="ApplyService"
        access="public"
        returntype="any"
        displayname="Apply or update service provisioning">
		
		<cfargument name="requestid"        type="string" required="true"  default="">	 
		<cfargument name="workorderid"      type="string" required="true"  default="">
		<cfargument name="workorderline"    type="string" required="true">
		<cfargument name="mode"             type="string" required="true"  default="submit">		
								
		<!--- ------------------------------------------ --->
		<!--- ----- get the provisioning lines --------- --->
		<!--- ------------------------------------------ --->
		
		<cftransaction>
		
		<cfquery name="get"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     Request
			WHERE    RequestId = '#requestid#'	
		</cfquery>		
		
		<cfif get.PersonNoUser eq "">
		   <cfset user = get.PersonNo>
		<cfelse>
		   <cfset user = get.PersonNoUser> 
		</cfif>
		
		<cfquery name="getLine"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     RequestLine
			WHERE    RequestId = '#requestid#'	
		</cfquery>			
				
		    <!--- this is a new service so we need to create a line 
			under an existing workorder --->
			
			<cfif workorderline eq "">	
		
				<cfif get.CustomerId eq "">		
								
					  <table width="100%" align="center">
					        <tr><td height="5"></td></tr>
					        <tr><td class="line"></td></tr>
						    <tr><td height="35" align="center"><font face="Verdana" size="2" color="FF0000">Customer was not defined</font></td></tr>
							<tr><td class="line"></td></tr>
					  </table>
					  <cfabort>  
					  
				</cfif>	  
	  
				<cfquery name="WorkOrder"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   TOP 1 *
					FROM     WorkOrder
					WHERE    CustomerId  = '#get.CustomerId#'	
					AND      ServiceItem = '#getLine.ServiceItem#'
					ORDER BY Created DESC
				</cfquery>						
				
				<cfif WorkOrder.recordcount eq "0">
				   
				   <table width="100%" align="center">
				        <tr><td height="5"></td></tr>
				        <tr><td class="line"></td></tr>
					    <tr><td height="35" align="center"><font face="Verdana" size="2" color="FF0000">No workorder found for this customer</font></td></tr>
						<tr><td class="line"></td></tr>
				  </table>
				   <cfabort>
				   
				</cfif>
	
				<cfquery name="Last"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   MAX(WorkorderLine) as SerialNo
					FROM     WorkOrderLine
					WHERE    Workorderid = '#workorder.workorderid#'		
				</cfquery>	
				
				<cfif Last.SerialNo eq "">
				     <cfset last = "0">
				<cfelse>
				     <cfset last = Last.SerialNo> 
				</cfif>		
		
				<!--- add the service line --->
				
				<cfquery name="Item" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					 SELECT   *	
				     FROM     ServiceItem
					 WHERE    Code   = '#getLine.ServiceItem#'	
				</cfquery>
								
				<cfquery name="CheckDomain" 
				  datasource="AppsWorkOrder" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				     SELECT   * 
				     FROM     WorkOrderService 
				     WHERE    Reference          = '#get.domainreference#' 				
				     AND      ServiceDomain      = '#item.servicedomain#'
			    </cfquery>
		
				<cfif CheckDomain.recordcount eq "0">
				
					<cfquery name="Log" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO WorkOrderService
							 (ServiceDomain,
							  Reference,		 
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName)
					 VALUES ('#item.servicedomain#',
	         				 '#get.domainreference#',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')				
				    </cfquery>		
				
				</cfif>			
				
				<cfquery name="Insert" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 
				     INSERT INTO WorkOrderLine 
				         (WorkOrderId,
						 WorkOrderLine,
						 DateEffective,
						 ServiceDomain,
						 <cfif get.servicedomainclass neq "">
						 ServiceDomainClass,
						 </cfif>
						 Reference,
						 PersonNo,
						 Source,
						 Operational,
						 OfficerUserId,
						 OfficerLastname,
						 OfficerFirstName)
				      VALUES
					     ('#workorder.WorkOrderId#',
					      '#last+1#',
						  '#getLine.dateEffective#',
						  '#get.servicedomain#',
						   <cfif get.servicedomainclass neq "">
						  '#get.servicedomainclass#',
						  </cfif>
						  '#get.domainreference#',
						  '#user#',
						  'Request',
						  1,				 
				      	  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>		
				
				<!--- record topics for the line --->				
				
				<cfquery name="InsertTopic" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO WorkOrderLineTopic 
					         (WorkOrderId,
							 WorkOrderLine,
							 DateEffective,
							 Topic,
							 ListCode,
							 TopicValue,						 
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
					  SELECT '#workorder.WorkOrderId#',
					         '#Last+1#',
						     '#getLine.dateEffective#',
						     Topic,
						     ListCode,
						     TopicValue, 
							 '#SESSION.acc#',
						     '#SESSION.last#',
						     '#SESSION.first#'
					  FROM   RequestTopic
					  WHERE  Requestid = '#requestid#'						  				      	
				</cfquery>										
				
				<cfquery name="Associate" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO RequestWorkOrder 
			        ( RequestId,
					  WorkOrderId,
					  WorkOrderLine,
					  WorkOrderAction )
			      VALUES
				    ('#requestid#',
					 '#workorder.WorkOrderId#',
				     '#Last+1#',
					 'NewLine')
				</cfquery>	
				
				<cfset workorderid   = workorder.workorderid>
				<cfset workorderline = "#Last+1#">
				
			<cfelse>	
			
				<cfquery name="Update" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">					
				     UPDATE RequestWorkOrder 
					 SET    WorkorderIdTo   = '#workorderid#',
					        WorkorderLineTo = '#workorderline#',
							WorkOrderAction = 'NewProvision'
				     WHERE  Requestid = '#requestid#'
				</cfquery>		
								
			</cfif>							
										
			<!--- add the billing/provisioning --->	
			
			<cfquery name="checkBilling" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				 
			     SELECT * 
				 FROM   WorkOrderLineBilling 
				 WHERE  WorkOrderId      = '#WorkOrderId#'
				 AND    WorkOrderLine    = '#workorderline#'
				 AND    BillingEffective = '#getLine.dateEffective#'
			</cfquery>
			
			<cfif checkBilling.recordcount eq "0">
						
				<cf_assignid>
				
				<cfquery name="InsertBilling" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">				 
				     INSERT INTO WorkOrderLineBilling 
					         (WorkOrderId,
							 WorkOrderLine,
							 Billingid,
							 BillingEffective,		
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
				      VALUES
						    ('#WorkOrderId#',
						      '#workorderline#',
							  '#rowguid#',
							  '#getLine.dateEffective#',		 
					      	  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>
				
				<!--- apply the funding lines --->
				
				<cfif get.Fundingid neq "">
				
					<cfquery name="InsertFunding" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">				 
					     INSERT INTO WorkOrderFunding 
						        (WorkOrderId,
								 WorkOrderLine,						
								 BillingEffective,		
								 FundingId,
								 DateEffective,	
								 OfficerUserId,
								 OfficerLastname,
								 OfficerFirstName)
					      VALUES ('#WorkOrderId#',
							      '#workorderline#',						
								  '#getLine.dateEffective#',	
								  '#get.Fundingid#',	
								  '#getLine.dateEffective#',	 
						      	  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
					</cfquery>
				
				</cfif>
				
				<!--- add the billing lines --->	
				
				<cfquery name="Insert" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO WorkOrderLineBillingDetail (
					         WorkOrderId,
							 WorkOrderLine,
							 BillingEffective,	
							 ServiceItem,
							 ServiceItemUnit,
							 Frequency,
							 BillingMode,
							 Charged,
							 Quantity,
							 Currency,
							 Rate,
							 Operational,		 	
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
					  
					  SELECT '#workorderid#',
						     '#workorderline#',
							 '#getLine.dateEffective#',	
							 R.ServiceItem,
							 R.ServiceItemUnit,
							 M.Frequency,
							 M.BillingMode,
							 R.Charged,
							 R.Quantity,
							 R.Currency,
							 R.Rate,	  
							 '1',		  	 
					      	 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#'
						  		  
					  FROM RequestLine R, ServiceItemUnitMission M, ServiceItemUnit S
					  WHERE R.CostId = M.CostId
					  AND   M.ServiceItem     = S.ServiceItem
					  AND   M.ServiceItemUnit = S.Unit
					  AND   R.Requestid = '#Requestid#'
					  AND   S.Operational = 1
				</cfquery>	
			
				<cfquery name="Update" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE RequestWorkOrder 
						 SET    Billingid = '#rowguid#'							
					     WHERE  Requestid = '#requestid#'
				</cfquery>		
				
			<cfelse>
			
				<cfquery name="Update" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     UPDATE RequestWorkOrder 
						 SET    Billingid = '#checkBilling.billingid#'							
					     WHERE  Requestid = '#requestid#'
				</cfquery>		
						
			</cfif>	
			
			<cfquery name="Update" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE Request
					 SET    ActionStatus = '2'							
				     WHERE  Requestid = '#requestid#'
					 AND    ActionStatus != '3'
			</cfquery>		
			
			</cftransaction>	
				
	</cffunction>	
	
	<cffunction name="ApplyTransfer"
             access="public"
             returntype="any"
             displayname="Transfer of item">
		
		<cfargument name="requestid"        type="string" required="true"  default="">	 
		<cfargument name="workorderid"      type="string" required="true"  default="">
		<cfargument name="workorderline"    type="string" required="true">
		<cfargument name="mode"             type="string" required="true"  default="standard">
		<cfargument name="workorderidto"    type="string" required="false" default="#workorderid#">
		<cfargument name="EffectiveDate"    type="string" required="true"  default="">
		<cfargument name="PersonNo"         type="string" required="true"  default="">
		<cfargument name="Assets"           type="string" required="true"  default="Y">
		<cfargument name="Billing"          type="string" required="true"  default="N">
							
		<cfset dateValue = "">
		<CF_DateConvert Value="#EffectiveDate#">
		<cfset EFF = dateValue>
		
		<cftransaction>		
		
		<cfquery name="get"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   * 
			FROM     Request
			WHERE    RequestId = '#requestid#'	
		</cfquery>		
		
		<!--- generate a non operational record for data entry --->
		
		<cfquery name="Current" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   WorkOrderLine
			 WHERE  WorkOrderId   = '#workorderid#'
			 AND    WorkOrderLine = '#workorderline#'			
		</cfquery>	
				
			
		<cfquery name="WorkOrder" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   WorkOrder
			 WHERE  WorkOrderId   = '#workorderid#'			 		
		</cfquery>		
		 
		<!--- add the service domain --->
				
		<cfquery name="Item" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    ServiceItem
			 WHERE   Code   = '#workorder.ServiceItem#'	
		</cfquery>
								
		<cfquery name="CheckDomain" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   WorkOrderService 
			WHERE  Reference      = '#Current.reference#' 				
			AND    ServiceDomain  = '#item.servicedomain#'
	    </cfquery>
				
		<cfif CheckDomain.recordcount eq "0">
		
			<cfquery name="Log" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO WorkOrderService
						 (ServiceDomain,
						  Reference,		 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				 VALUES ('#item.servicedomain#',
         				 '#current.reference#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')				
		    </cfquery>		
		
		</cfif>	
			
		<!--- Dev added lines to check first if we already have a line here --->
		
		<cfquery name="check" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM     WorkOrderLine
			 WHERE    ParentWorkorderId   = '#Current.WorkOrderid#'
			 AND      ParentWorkorderLine = '#Current.WorkOrderLine#'			 
		</cfquery>		
		
		<cfif check.recordcount gte "1">
		
		    <!--- the new line already exisis so we take that one and clean it if needed --->		
			<cfset No = check.workorderline>
		
		<cfelse>
		
			<!--- check if the line exist --->
			
			<cfquery name="last" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT TOP 1 WorkOrderLine as Line 
				 FROM     WorkOrderLine
				 WHERE    WorkOrderId = '#workorderidto#'
				 ORDER BY WorkOrderLine DESC
			</cfquery>	
				
			<cfif last.recordcount eq "0">
				<cfset No = 1>
			<cfelse>
				<cfset No = last.Line+1>	
			</cfif> 	
			
			<!--- in case of request we check if the combination requestid and current.workorderid is existining --->
			
			<cfif requestid neq "" and requestid neq "{00000000-0000-0000-0000-000000000000}">
			
				<cfquery name="validation" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT *
					 FROM     RequestWorkOrder
					 WHERE    Requestid    = '#requestid#'
					 AND (
					 	(WorkOrderId   = '#current.workorderid#' AND WorkOrderline = '#current.workorderline#')
						OR
					    (WorkOrderIdTo   = '#current.workorderid#' AND WorkOrderlineTo = '#current.workorderline#')
						)	
				</cfquery>	
				
				<cfif validation.recordcount eq "0">
				
					<script>
						alert("Request and current workorder do not have an occurence. Operation aborted")
					</script>	
					<cfabort>  	
								
				</cfif>
						
			</cfif>				
			
			 <cfquery name="InsertLine" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			     INSERT INTO WorkOrderLine 
				         (WorkOrderId, 
						 WorkOrderLine,
						 ServiceDomain,					
						 ServiceDomainClass,					
						 Reference,
						 DateEffective,
						 Operational,
						 Source,
						 <cfif requestid neq ""  and requestid neq "{00000000-0000-0000-0000-000000000000}">
						 SourceId,
						 </cfif>
						 PersonNo,
						 ParentWorkOrderId,
						 ParentWorkorderLine,
						 WorkOrderLineMemo, 
						 OfficerUserId,
						 OfficerLastname,
						 OfficerFirstName)
			      VALUES
					     ('#WorkOrderIdTo#',
					      '#No#',
						  '#item.servicedomain#',
						  <cfif get.servicedomainclass neq "">
							 '#get.servicedomainclass#', 
						  <cfelseif Current.servicedomainclass neq "">
						    '#Current.servicedomainclass#',	 
						  <cfelse> 
						    NULL,	
						  </cfif>
						  '#Current.Reference#',
						  #eff#,				  
						  1,	
						  <cfif requestid neq "" and requestid neq "{00000000-0000-0000-0000-000000000000}">
							'Request',	
							'#Requestid#',
						  <cfelse>
							'Manual',
						  </cfif>			
						  '#PersonNo#',	
						  '#Current.WorkOrderid#',
						  '#Current.WorkOrderLine#',	
						  <cfif mode neq "return">
						  'Apply Requested Transfer',	 
						  <cfelse>
						  'Return',
						  </cfif>
				      	  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#') 
		   	</cfquery>	
			
		</cfif>			
				
				
		<cfquery name="qCheck" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM WorkOrderLine
			WHERE WorkOrderId = '#WorkOrderIdTo#'
			AND WorkorderLine = '#no#'
		</cfquery>	
						
		<!--- update any record usage to the new line --->
		
		<cfloop index="tbl" list="Detail,DetailNonBillable,DetailCharge">

			<cfif qCheck.recordcount neq 0>						
				<cfquery name="UpdateUsage" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE  WorkOrderLine#tbl#
						SET     WorkorderId   = '#WorkOrderIdTo#',
						        WorkorderLine = '#No#'				
						WHERE   WorkorderId   = '#Current.WorkOrderid#'
						AND     WorkorderLine = '#Current.WorkOrderLine#'   
						AND     TransactionDate >= #eff#
				</cfquery>	
			</cfif>
		
		</cfloop>
						
		<cfif Current.PersonNo neq PersonNo>
		
		    <!--- open the records, this is not really needed anymore  
		
			<cfquery name="resetUsage" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE  WorkOrderLineDetail
					SET     ActionStatus  = '0'					
					WHERE   WorkorderId   = '#WorkOrderIdTo#'
					AND     WorkorderLine = '#No#'   
					AND     TransactionDate >= #eff#
			</cfquery>	
			
			<cfquery name="resetUsageCharge" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE  WorkOrderLineDetailCharge
					SET     ActionStatus  = '0'					
					WHERE   WorkorderId   = '#WorkOrderIdTo#'
					AND     WorkorderLine = '#No#'   
					AND     TransactionDate >= #eff#
			</cfquery>	
			
			--->
			
		<cfelse>
		
			<!--- close the records by creating a closing action, the lines
			already have actionstatus = 1 --->
			
			<cfif qCheck.recordcount neq 0>
				<cfquery name="setClosing" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					INSERT INTO WorkOrderLineAction ( 
							  WorkOrderId, 
					          WorkOrderLine, 
							  ActionClass, 
							  SerialNo, 
							  DateTimePlanning, 
							  DateTimeActual, 
							  ActionMemo, 
							  OfficerUserId, 
							  OfficerLastName, 
		                      OfficerFirstName)
					SELECT    '#WorkOrderIdTo#', 
							  '#No#', 
							  ActionClass, 
							  SerialNo, 
							  DateTimePlanning, 
							  DateTimeActual, 
							  ActionMemo, 
							  OfficerUserId, 
							  OfficerLastName, 
	                          OfficerFirstName
					FROM      WorkOrderLineAction 
					WHERE     WorkOrderId    = '#Current.WorkOrderid#'
					AND       WorkOrderLine  = '#Current.WorkOrderLine#'
					AND       ActionClass    = '#Item.UsageActionClose#'
				</cfquery>
						
			</cfif>					
		</cfif>	
		
		<!--- --------------------- --->
		<!---- end of usage closing --->
		<!--- --------------------- --->					
				
		<!--- move over the topics --->


			
		<cfif qCheck.recordcount neq 0>	

		<cfquery name="InsertTopic" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     INSERT INTO WorkOrderLineTopic 
			         (WorkOrderId,
					 WorkOrderLine,
					 Topic,
					 DateEffective,
					 ListCode,
					 TopicValue,			
					 OfficerUserId,
					 OfficerLastname,
					 OfficerFirstName)
		      SELECT '#WorkOrderIdTo#',
					 '#no#',
					 Topic,
					 #eff#,
					 ListCode,
					 TopicValue,			
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#'
			  FROM   WorkOrderLineTopic 
			  WHERE  Workorderid   = '#current.workorderid#'			
			  AND    WorkorderLine = '#current.WorkOrderLine#'		
			  AND	 Operational = 1  
			  AND    Topic NOT IN (SELECT Topic 
			                       FROM   WorkorderlineTopic
								   WHERE  WorkOrderId   = '#WorkOrderIdTo#'
								   AND    WorkOrderLine = '#no#'
								   AND    DateEffective = #eff# )
	   	</cfquery>
	   	
	   	</cfif>
		
		<cfset exp = dateadd("D",-1,eff)>	
		 	  
		<cfquery name="updateExisting" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  WorkOrderLine
			SET     DateExpiration = #exp#
			WHERE   Workorderid   = '#current.workorderid#'			
		    AND     WorkorderLine = '#Current.WorkOrderLine#'		  	
		</cfquery>
		
		<!--- check if expiration is smaller than effective, in that case we make it the same
		as it was likely a correction --->
		
		<cfquery name="updateExisting" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  WorkOrderLine
			SET     DateExpiration = #eff#
			WHERE   Workorderid   = '#current.workorderid#'			
		    AND     WorkorderLine = '#Current.WorkOrderLine#'	
			AND     DateExpiration < DateEffective	  	
		</cfquery>		
		
		<cfif Assets eq "Y">
		
			<!--- ---------------------------------------------------- --->
			<!--- transfer also the assets that are currently assigned --->
			<!--- ---------------------------------------------------- --->
			
			<cfquery name="Assets" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			     SELECT * 
				 FROM   WorkorderLineAsset 
				 WHERE  Workorderid   = '#Current.workorderid#'			
				  AND   WorkorderLine = '#Current.WorkOrderLine#'	
				  AND   (DateExpiration >= #eff# or dateExpiration is NULL)
				  AND   Operational = 1
			</cfquery>
				
			<cfloop query="Assets">
			
				<cfquery name="UpdateExisting" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE  WorkorderLineAsset 
					SET     DateExpiration  = #exp#
					WHERE   Workorderid     = '#Current.workorderid#'			
				    AND     WorkorderLine   = '#Current.WorkOrderLine#'	
					AND     AssetId         = '#assetid#'
					 AND    Operational = 1
			    </cfquery>
				
				<cfquery name="Insert" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO WorkorderLineAsset 
						(WorkorderId,
						 WorkorderLine,
						 AssetId,
						 DateEffective,
						 DateExpiration,
						 OfficerUserid,
						 OfficerLastName,
						 OfficerFirstName)
					VALUES
						('#workorderidto#',			
				         '#no#',
						 '#assetid#',
						 #eff#,
						 <cfif dateexpiration neq "">
						 	'#DateExpiration#',
						 <cfelse>
						 	NULL,
						 </cfif>
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')			
			    </cfquery>
			
			</cfloop>	  
		
		</cfif>
		
		<!--- ----------------------------- --->
		<!--- carry over provisioning lines --->
		<!--- ----------------------------- --->
		
		<cfif Billing eq "Y">
		
		   <!--- we create the selected billing/provisioning for this one --->	
		   
		   <cfquery name="clearBilling" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE WorkOrderLineBilling 
		        WHERE  WorkOrderId      = '#WorkOrderIdTo#'
		        AND    WorkOrderLine    = '#no#'
		        AND    BillingEffective = #eff#
			</cfquery>	
			
			<cfquery name="InsertBilling" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				 
			     INSERT INTO WorkOrderLineBilling 
			         (WorkOrderId,
					  WorkOrderLine,
					  BillingEffective,		
					  OfficerUserId,
					  OfficerLastname,
					  OfficerFirstName)
			      VALUES
				     ('#WorkOrderIdTo#',
				      '#no#',
					  #eff#,		 
			      	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
			<!--- apply the funding on the billing level if account is defined  --->
						
			<cfif get.Fundingid neq "">
			
				<cfquery name="InsertFunding" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">				 
				     INSERT INTO WorkOrderFunding 
					        (WorkOrderId,
							 WorkOrderLine,						
							 BillingEffective,		
							 FundingId,
							 DateEffective,
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)
				      VALUES ('#WorkOrderIdTo#',
					       '#no#',
					        #eff#,		
						   '#get.Fundingid#',	
						    #eff#,	 
				      	   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#')
				</cfquery>
			
			</cfif>
	
			<!--- add the billing lines --->	
			
			<cfquery name="Insert" 
			     datasource="AppsWorkOrder" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 
				 INSERT INTO WorkOrderLineBillingDetail (
				         WorkOrderId,
						 WorkOrderLine,
						 BillingEffective,	
						 ServiceItem,
						 ServiceItemUnit,
						 Frequency,
						 BillingMode,
						 Charged,
						 Quantity,
						 Currency,
						 Rate,
						 Operational,		 	
						 OfficerUserId,
						 OfficerLastname,
						 OfficerFirstName )
				  
				  SELECT '#WorkOrderIdTo#',
					     '#no#',
						 #eff#,	
						 R.ServiceItem,
						 R.ServiceItemUnit,
						 M.Frequency,
						 M.BillingMode,
						 R.Charged,
						 R.Quantity,
						 R.Currency,
						 R.Rate,	  
						 '1',		  	 
				      	 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#'
					  		  
				  FROM   RequestLine R, ServiceItemUnitMission M
				  WHERE  R.CostId = M.CostId
				  AND    R.Requestid = '#Requestid#'
				  
			</cfquery>
		
		<cfelse>
		
			<!--- ---------------------------------------------------------- --->
			<!--- carry-over the last provisioning to the new workorderline- --->
			<!--- ---------------------------------------------------------- --->
		
			<cfquery name="Billing" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			     SELECT   TOP 1 * 
				 FROM     WorkOrderLineBilling 
				 WHERE    Workorderid     = '#Current.workorderid#'			
			     AND      WorkorderLine   = '#Current.WorkOrderLine#'		
				 AND     (BillingExpiration is NULL or BillingExpiration >= #eff#)
				 ORDER BY Created DESC
			</cfquery>	 
			
			<cfloop query="Billing">
			
			    <cfif BillingEffective lt eff>
				     <cfset beff = dateformat(eff,client.dateSQL)>
				<cfelse>
				     <cfset beff = dateformat(billingeffective,client.dateSQL)>
				</cfif>
				
				<cfquery name="checkBilling" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM   WorkOrderLineBilling B1
			        WHERE  B1.WorkOrderId      = '#WorkOrderIdTo#'
			        AND    B1.WorkOrderLine    = '#no#'
			        AND    B1.BillingEffective = '#beff#'
				</cfquery>	
				
				<cfif CheckBilling.recordcount eq "1">
				
					<cfquery name="deleteBilling" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE WorkOrderLineBilling 
				        WHERE  WorkOrderId      = '#WorkOrderIdTo#'
				        AND    WorkOrderLine    = '#no#'
				        AND    BillingEffective = '#beff#'
					</cfquery>	
				
				</cfif>
				
				<!--- record a provisioning header --->
				<cfif qCheck.recordcount neq 0>
					<cfquery name="InsertBilling" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				      INSERT INTO WorkOrderLineBilling 
					  	     (WorkOrderId,
							  WorkOrderLine,
							  BillingEffective,
							  BillingExpiration,					
							  OfficerUserId,
							  OfficerLastname,
							  OfficerFirstName)
				      SELECT  '#WorkOrderIdTo#',
							  '#no#',
							  '#beff#',
							  BillingExpiration,						
							  OfficerUserId,
							  OfficerLastname,
							  OfficerFirstName
					  FROM    WorkOrderLineBilling B
					  WHERE   B.BillingId   = '#BillingId#'
					  AND NOT EXISTS (	SELECT 1
								        FROM   WorkOrderLineBilling B1
								        WHERE  B1.WorkOrderId      = '#WorkOrderIdTo#'
								        AND    B1.WorkOrderLine    = '#no#'
								        AND    B1.BillingEffective = '#beff#'
							  )
			   		</cfquery>	
				
					<!--- record the provisioning details --->
				
				
					<cfquery name="InsertBillingDetail" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				     INSERT INTO WorkOrderLineBillingDetail (
							 WorkOrderId,
							 WorkOrderLine,
							 BillingEffective,
							 ServiceItem,
							 ServiceItemUnit,
							 Frequency,
							 BillingMode,
							 Charged,					
							 Quantity,
							 Currency,
							 Rate,			
							 OfficerUserId,
							 OfficerLastname,
							 OfficerFirstName)			
							  
				      SELECT '#WorkOrderIdTo#',
							 '#no#',
							 '#beff#',
							 ServiceItem,
							 ServiceItemUnit,
							 Frequency,
							 BillingMode,
							 Charged,					
							 Quantity,
							 Currency,
							 Rate,			
							 D.OfficerUserId,
							 D.OfficerLastname,
							 D.OfficerFirstName	
							 	  
					  FROM   WorkOrderLineBilling AS WB 
					         INNER JOIN WorkOrderLineBillingDetail AS D ON WB.WorkOrderId = D.WorkOrderId 
							      AND WB.WorkOrderLine = D.WorkOrderLine 
								  AND WB.BillingEffective = D.BillingEffective
					  WHERE  WB.BillingId   = '#BillingId#'	
					  AND    D.Operational = 1				 
			   		</cfquery>			
		   		</cfif>					
				
				<cfif get.Fundingid neq "">
			
					<cfquery name="InsertFunding" 
					     datasource="AppsWorkOrder" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">				 
					     INSERT INTO WorkOrderFunding 
						        (WorkOrderId,
								 WorkOrderLine,						
								 BillingEffective,		
								 FundingId,
								 OfficerUserId,
								 OfficerLastname,
								 OfficerFirstName)
					      VALUES ('#WorkOrderIdTo#',
						       '#no#',
						        #beff#,		
							   '#get.Fundingid#',	 
					      	   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#')
					</cfquery>
			
			    </cfif>			
											
			</cfloop>
					
		</cfif>	
		
		<cfif RequestId neq "">
		
				<cfquery name="Update" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE Request
					 SET    ActionStatus = '2'							
				     WHERE  Requestid = '#requestid#'
					 AND    ActionStatus != '3'
    			</cfquery>		
				
				<cfif mode neq "return">
		
					<cfquery name="updateExisting" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE  RequestWorkOrder
						SET     WorkorderIdTo   = '#workorderidto#',
						        WorkorderLineTo = '#No#',
								WorkOrderAction = 'Transfer'			       
						WHERE   RequestId       = '#requestid#'
						AND     WorkorderId     = '#Current.WorkorderId#'			
					    AND     WorkorderLine   = '#Current.WorkOrderLine#'		  	
					</cfquery>	
				
				</cfif>
		
		</cfif>		
				
		<cfreturn No>
		
		</cftransaction>
			 
	</cffunction>
			
		
	<cffunction name="ApplyTermination"
             access="public"
             returntype="any"
             displayname="Termination of a service item">
		
		<cfargument name="requestid"        type="string" required="true"  default="">	 
		<cfargument name="workorderid"      type="string" required="true"  default="">
		<cfargument name="workorderline"    type="string" required="true">		
		<cfargument name="EffectiveDate"    type="string" required="true"  default="">
				
		<cftransaction>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#EffectiveDate#">
		<cfset EFF = dateValue>
		
		<cfset eff = dateadd("D",-1,eff)>	
		 	  
		<cfquery name="updateExisting" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  WorkOrderLine
			SET     DateExpiration    = #eff#,
			        WorkOrderLineMemo = 'Apply Termination'			      
			WHERE   Workorderid   = '#workorderid#'			
		    AND     WorkorderLine = '#WorkOrderLine#'		  	
		</cfquery>
		
		<!--- ---------------------------------------------------- --->
		<!--- transfer also the assets that are currently assigned --->
		<!--- ---------------------------------------------------- --->
		
		<cfquery name="Assets" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   WorkorderLineAsset 
			 WHERE  Workorderid   = '#workorderid#'			
			  AND   WorkorderLine = '#WorkOrderLine#'	
			  AND   (DateExpiration >= #eff# or dateExpiration is NULL)
			  AND   Operational = 1
		</cfquery>
			
		<cfloop query="Assets">
		
			<cfquery name="UpdateExisting" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE  WorkorderLineAsset 
				SET     DateExpiration  = #eff#
				WHERE   Workorderid     = '#workorderid#'			
			    AND     WorkorderLine   = '#WorkOrderLine#'	
				AND     AssetId         = '#assetid#'
				AND     Operational = 1
		    </cfquery>
		
		</cfloop>	
		
		<cfif RequestId neq "">
		
			    <cfquery name="Update" 
				     datasource="AppsWorkOrder" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE Request
					 SET    ActionStatus = '2'							
				     WHERE  Requestid    = '#requestid#'
					 AND    ActionStatus != '3'
			    </cfquery>		
		
				<cfquery name="updateExisting" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  RequestWorkOrder
					SET     WorkOrderAction = 'Termination'			       
					WHERE   RequestId       = '#requestid#'
					AND     WorkorderId     = '#workorderid#'			
				    AND     WorkorderLine   = '#WorkOrderLine#'		  	
				</cfquery>	
		
		</cfif>				  
				
		</cftransaction>
			 
	</cffunction>	
		
	<!--- REVERTING --->
		
	<cffunction name="RevertRequest"
             access="public"
             returntype="any"
             displayname="Revert the applied amendment action">
		
		<cfargument name="requestid"   type="string" required="true" default="">	 
					
		<!--- 1. remove new transaction    --->
		<!--- 2. reset dates for the line  --->
		<!--- 3. reset for the assets      --->
		
		<cftransaction>			
		
		<!--- Above : this has usually just one (1) record --->
		
		<!--- makes it editable --->
		
		<cfquery name="Update" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Request
			 SET     ActionStatus = '1'							
		     WHERE   Requestid = '#requestid#'
			 AND     ActionStatus IN ('2')
		</cfquery>	
		
				
		<cfquery name="getService" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  R.Workorderid, 
				        R.WorkOrderline, 
						R.WorkOrderIdTo,
						R.WorkorderLineTo,
						R.BillingId, 
						L.ServiceDomain,
						L.Reference, 
						R.WorkOrderAction 
				FROM    RequestWorkOrder R, WorkOrderLine L
				WHERE   R.WorkOrderId   = L.WorkOrderId
				AND     R.WorkOrderLine = L.WorkOrderLine				
				AND     R.RequestId = '#requestid#'				  					
		</cfquery>	
						
		<!--- check if for this service (domain + reference) there are later
		requests--->
								
		<cfloop query="getService">
				
			<!--- check we have for that SAME service any other pending requests --->
			
			<cfquery name="getOther" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  RW.Workorderid, RW.WorkOrderline, L.ServiceDomain, L.Reference 
				FROM    Request R, RequestWorkOrder RW, WorkOrderLine L
				WHERE   R.Requestid = RW.Requestid
				AND     RW.WorkOrderId   = L.WorkOrderId
				AND     RW.WorkOrderLine = L.WorkOrderLine				
				AND     L.ServiceDomain = '#ServiceDomain#'				
				AND     L.Reference     = '#Reference#'						  					
				AND     R.ActionStatus IN ('0','1','2')
				AND     R.RequestId != '#requestid#'
				
				<!--- this mean an [apply] has taken place and as such workorder effect, if we are going to revert we might
				revert something from another request and that we need to prevent --->				
				
				AND     RW.WorkOrderAction is not NULL
				
				<!--- this validation was made less restrictive and should not be 
					applied for request (like equipment) that do not have any apply action --->
					
				AND     R.RequestId IN (SELECT Requestid 
				                        FROM   Request
									    WHERE  RequestId = R.Requestid
									    AND    RequestType IN (SELECT Code 
										                       FROM   Ref_Request 
															   WHERE  TemplateApply != ''))
				
		    </cfquery>									
			
			<cfif getOther.recordcount gte "1">
			
			    <cfoutput>
				
				<tr><td colspan="5">
				
				<table width="100%" align="center"><tr><td style="height:30px;padding-left:30px" class="labelmedium">
					<font color="FF0000">Please be advised that for this service there are #getOther.recordcount# other potentially conflicting requests in Process.</font>
					</td></tr>
				</table>
				
				</td></tr>
					
				</cfoutput>		
										
			<cfelse>
					
				<cfswitch expression="#WorkorderAction#">
				
					<cfcase value="NewLine">
					
							<cfquery name="RemoveAssociation" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									DELETE  FROM    RequestWorkorder
									WHERE   RequestId     = '#requestid#'	
									AND     WorkOrderid   = '#WorkorderId#'		
									AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>	
							
							<cfquery name="Line" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * 
										FROM    WorkOrderLine
										WHERE   WorkOrderId   = '#WorkorderId#'		
										AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>	
							
							<!--- remove possible funding info first --->
							
							<cfquery name="RemoveLineFunding" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										DELETE  FROM WorkOrderFunding
										WHERE   WorkOrderId   = '#WorkorderId#'		
										AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>		
							
							<!--- this removes also the topics, log, mail, memo and provisioning (billing) if relevant --->					
					
							<cfquery name="RemoveLine" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										DELETE  FROM WorkOrderLine
										WHERE   WorkOrderId   = '#WorkorderId#'		
										AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>	
														
							<cfquery name="RemoveSupplies" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										DELETE  FROM  Materials.dbo.ItemTransaction
										WHERE   WorkOrderId   = '#WorkorderId#'		
										AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>	
							
							<cfquery name="Check" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT TOP 1 * 
										FROM    WorkOrderLine
										WHERE   Reference     = '#Line.Reference#'		
									    AND     ServiceDomain = '#Line.ServiceDomain#'			  	
							</cfquery>	
							
							<cfif check.recordcount eq "0">
							
								<cfquery name="RemoveDomain" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										DELETE  FROM WorkOrderService
										WHERE   Reference     = '#Line.Reference#'		
										AND     ServiceDomain = '#Line.ServiceDomain#'			  	
								</cfquery>	
							
							</cfif>
					
					</cfcase>
				
					<cfcase value="NewProvision">
															
						   <cfif BillingId neq "">
					
							   <cfquery name="RemoveLine" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											DELETE  FROM  WorkOrderLineBilling
											WHERE   WorkOrderid   = '#WorkorderId#'		
											AND     WorkOrderLine = '#WorkorderLine#'			  	
											AND     Billingid = '#billingid#'
							   </cfquery>	
						   
						   </cfif>
					
					</cfcase>
				
					<cfcase value="Transfer">
					
						<!--- remove added lined and reinstate the prior line --->
								
						<cfif workorderidto neq "" and workorderlineto neq "">
					
							<cfquery name="GetAdded" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT *
									FROM    WorkOrderLine
									WHERE   WorkOrderid   = '#WorkorderIdTo#'		
									AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>	
							
							<!--- revert the expiration of the old line --->
													
							<cfquery name="Update" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE  WorkOrderLine 
									<cfif getAdded.DateExpiration neq "">
									SET     DateExpiration = '#getAdded.DateExpiration#'	
									<cfelse>
									SET     DateExpiration = NULL
									</cfif>				
									WHERE   WorkOrderid    = '#WorkorderId#'		
									AND     WorkOrderLine  = '#WorkorderLine#'			  	
							</cfquery>	
							
							<!--- --------------------------------------------- --->
							<!--- revert the usage from the new to the old line --->
							<!--- --------------------------------------------- --->
							
							<cfloop index="tbl" list="Detail,DetailNonBillable,DetailCharge">
														
								<cfquery name="UpdateUsage" 
									datasource="AppsWorkOrder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    UPDATE  WorkOrderLine#tbl#
										SET     WorkorderId   = '#WorkorderId#',
										        WorkorderLine = '#WorkorderLine#'				
										WHERE   WorkorderId   = '#WorkorderIdTo#'
										AND     WorkorderLine = '#WorkorderLineTo#'   										
								</cfquery>	
							
							</cfloop>
							
							<cfquery name="RemoveLineFunding" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								DELETE  FROM WorkOrderFunding
								WHERE   WorkOrderId   = '#WorkorderIdTo#'		
								AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>	
								
							<!--- asset --->						
							
							<cfquery name="Update" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE  WorkOrderLineAsset						 
									<cfif getAdded.DateExpiration neq "">
									SET     DateExpiration = '#getAdded.DateExpiration#'	
									<cfelse>
									SET     DateExpiration = NULL
									</cfif>			
												
									WHERE   WorkOrderid    = '#WorkorderId#'		
									AND     WorkOrderLine  = '#WorkorderLine#'		
									AND     Operational = 1	  	
							</cfquery>	
							
							<cfquery name="RemoveAssociation" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										UPDATE  RequestWorkorder
										SET     WorkorderIdTo   = NULL, 
										        WorkorderLineTo = NULL								
										WHERE   RequestId     = '#requestid#'	
										AND     WorkOrderid   = '#WorkorderId#'		
										AND     WorkOrderLine = '#WorkorderLine#'			  	
							</cfquery>	
							
							<!--- deletes assets, topics and billing --->
							
							<cfquery name="Line" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * FROM WorkOrderLine
										WHERE   WorkOrderid   = '#WorkorderIdTo#'		
										AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>	
							
							<!--- revert possible usage to the new line to the old line 
							
							<cfquery name="RevertUsage" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE  WorkOrderLineDetail
									SET     WorkorderId   = '#WorkOrderId#',
									        WorkOrderLine = '#WorkOrderLine#'								
									WHERE   WorkOrderid   = '#WorkorderIdTo#'		
									AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>	
							
							--->
							
							<!--- removed by Dev for now
							
							<cfloop query="getNext">
							
									<cfquery name="clearRequest" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										DELETE FROM Request
										WHERE  RequestId IN
						                          (SELECT  RequestId
	                    					       FROM    RequestWorkOrder
						                           WHERE   WorkOrderId   = '#WorkorderId#'
												   AND     WorkOrderLine = '#workorderline#')
									</cfquery>
									
									<!--- this will fail if we have usage --->
									
									<cfquery name="checkUsage" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT TOP 1 *
											FROM WorkOrderLineDetail
											WHERE   WorkOrderid   = '#WorkorderId#'		
											AND     WorkOrderLine = '#WorkorderLine#'		  	
									</cfquery>	
									
									<cfif checkUsage.recordcount gte "1">
									
										<cfoutput>
					
										<tr><td colspan="5">
										
										<table width="100%" align="center">
										    <tr>
											<td class="labelit">
											<font color="FF0000">Please be advised that for this service there is already usage in Process for related workorder: #WorkorderId# (#workorderline#). Action aborted</font>
											</td></tr>
										</table>
										
										</td></tr>
										
										<cfabort>
											
										</cfoutput>	
																		
									</cfif>
																
									<cfquery name="clearRequest" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											DELETE FROM WorkOrderLine
											WHERE   WorkOrderid   = '#WorkorderId#'		
											AND     WorkOrderLine = '#WorkorderLine#'		  	
									</cfquery>	
								
							</cfloop>
							
							--->
																					
							<cfquery name="DeleteNew" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE FROM  WorkOrderLine
									WHERE   WorkOrderid   = '#WorkorderIdTo#'		
									AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>		
														
							<cfquery name="RemoveSupplies" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE  FROM  Materials.dbo.ItemTransaction
									WHERE   WorkOrderId   = '#WorkorderIdTo#'		
									AND     WorkOrderLine = '#WorkorderLineTo#'			  	
							</cfquery>	
							
							<cfquery name="Check" 
									datasource="AppsWorkorder" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT TOP 1 * 
										FROM    WorkOrderLine
										WHERE   Reference     = '#Line.Reference#'		
									    AND     ServiceDomain = '#Line.ServiceDomain#'			  	
							</cfquery>	
							
							<cfif check.recordcount eq "0">
							
								<cfquery name="RemoveDomain" 
										datasource="AppsWorkorder" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										DELETE  FROM WorkOrderService
										WHERE   Reference     = '#Line.Reference#'		
										AND     ServiceDomain = '#Line.ServiceDomain#'			  	
								</cfquery>	
							
							</cfif>
						
						</cfif>				
					
					</cfcase>
				
					<cfcase value="Termination">
					
						<cfquery name="get" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   Request
									WHERE  Requestid = '#Requestid#'									  	
						</cfquery>	
					
						<cfquery name="Update" 
								datasource="AppsWorkorder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE  WorkOrderLine 
									SET     DateExpiration = NULL								
									WHERE   WorkOrderid    = '#WorkorderId#'		
									AND     WorkOrderLine  = '#WorkorderLine#'			  	
						</cfquery>	
														
						<cfquery name="ListAssets" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						     SELECT  * 
							 FROM    WorkorderLineAsset 
							 WHERE   Workorderid   = '#workorderid#'			
							 AND     WorkorderLine = '#WorkOrderLine#'	
							 AND     DateExpiration >= '#get.DateEffective#'
							  AND   Operational = 1
						</cfquery>
							
						<cfloop query="ListAssets">
						
							<cfquery name="UpdateExisting" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    UPDATE  WorkorderLineAsset 						
								SET     DateExpiration  = NULL
								WHERE   Workorderid     = '#workorderid#'			
							    AND     WorkorderLine   = '#workorderline#'	
								AND     AssetId         = '#assetid#'
								AND     Operational = 1
						    </cfquery>
						
						</cfloop>	 				
					
					</cfcase>			
				
				</cfswitch>
				
			</cfif>	
		
		</cfloop>		
		
		<!--- 10/1/2015 
		check if request already has been effected on the workorder line --->
		
		<cfquery name="validation" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT *
				 FROM     WorkOrderLine
				 WHERE    SourceId    = '#requestid#'							
		</cfquery>	
						
		<cfif validation.recordcount gte "1">
		
		<!--- temp provision to capture only for marina based on 10/1/2015 where we found
		a transfer without request parent which means it was somehow removed --->
		
		<cfoutput>
				
			<tr><td colspan="5">
			
						
			<table width="100%" align="center"><tr><td style="height:30px;padding-left:30px" class="labelmedium">
				<font color="FF0000">Attention : Please be advised that for this request there are already applied lines.</font>
				</td></tr>
			</table>
			
			</td></tr>
			
			<cfabort>
					
		 </cfoutput>			
				
		</cfif>
								
		</cftransaction>
			 
	</cffunction>
	
</cfcomponent>			 