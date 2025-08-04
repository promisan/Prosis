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
<!--- --Contract service for OICT data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<!--- save line --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">
<cfparam name="form.Reference"    default="">
<cfparam name="url.scope"         default="entry">

<cfquery name="Param" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   Parameter			  
</cfquery>		

<cfquery name="ServiceItem" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code   = '#URL.ServiceItem#'					  
</cfquery>				

<cfquery name="WorkOrder" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder
		WHERE  WorkOrderId   = '#URL.workorderid#'					  
</cfquery>	

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
					 Currency,
					 <!---
					 ServiceItemUnit,
					 --->
					 OrderMemo,
					 Mission, 
					 Reference, 
					 OrgUnitOwner,
					 OrderDate,			
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#id#',
			          '#url.customerid#',
					  '#url.serviceitem#',
					  '#Param.BaseCurrency#',
					  <!---
					  '#form.Unit#',		
					  --->
					  '#Form.Ordermemo#',			  
			          '#url.Mission#', 
					  <cfif form.reference eq "">
					  '#no#', 
					  <cfelse>
					  '#Form.Reference#',
					  </cfif>
					  <cfif form.OrgUnitOwner neq "">
					  '#form.OrgUnitOwner#',
					  <cfelse>
					  NULL,
					  </cfif>
					  '#dateformat(now(),client.dateSQL)#',			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
</cfif>

</cftransaction>


<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   CustomerGledger
	 WHERE  CustomerId = '#url.customerId#'					  
</cfquery>	

<cfif GL.recordcount eq "0">

	<!--- we take from the higher level --->

	<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	DISTINCT Area
		 FROM   	Ref_ParameterMissionGledger
		 WHERE  	Mission = '#url.mission#'		 				  
	</cfquery>	

</cfif>

<cfloop query="GL">

	<cfquery name="getGL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    GLAccount
		 FROM      Ref_ParameterMissionGledger
		 WHERE     Mission = '#url.mission#'	
		 AND       Area    = '#area#'
		 AND       (Serviceitem = '' OR ServiceItem = '#url.serviceitem#')
		 ORDER BY  ServiceItem DESC	 	 				  
	</cfquery>	

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
			   	    '#getGL.GLAccount#', 
				    '#SESSION.acc#',
			    	'#SESSION.last#',		  
				  	'#SESSION.first#')
	</cfquery>

</cfloop>

<!--- add workorder lines and 
      then add items to workorderlineitem --->

<CF_DateConvert Value="#Form.DateEffective#">
<cfset dte = dateValue>

<cfinvoke component     = "Service.Access"  
	   method           = "WorkOrderProcessor" 
	   mission          = "#url.mission#"  
	   serviceitem      = "#url.serviceitem#"
	   returnvariable   = "accessunit">
	 	  
<cfquery name="Phase" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      WorkOrderService
		 WHERE     ServiceDomain = '#serviceitem.serviceDomain#'
		 <cfif getAdministrator(url.mission) eq "1" or accessunit eq "ALL">			 
		 AND       1=1
		 <cfelseif accessunit eq "0">
		 AND       1=0
		 <cfelse>
		 AND       EXISTS (SELECT 'X'
		                   FROM    WorkOrderServiceMission  
						   WHERE   ServiceDomain = W.ServiceDomain						   
						   AND     Mission = '#url.mission#'
						   AND     OrgUnit IN (#accessorgunit#)
		 </cfif>				  	
		 ORDER BY  ListingOrder				  
</cfquery>	  

<cfloop query="Phase">

	<cfset line = currentrow>

	<cfset impl = evaluate("Form.orgunitP#line#")>
	<cfset whse = evaluate("Form.warehouse#line#")>
	<cfset lot  = evaluate("Form.transactionlot#line#")>
	
	<cfif lot neq "">
	
		<cfinvoke component = "Service.Process.Materials.Lot"  
		   method                 = "addlot" 
		   datasource             = "AppsWorkOrder"
		   mission                = "#url.Mission#" 
		   transactionlot         = "#lot#"
		   TransactionLotDate     = "#dateFormat(dte, CLIENT.DateFormatShow)#"
		   OrgUnitVendor          = "#impl#"
		   returnvariable         = "result">		
	
	</cfif>
	
	<cfparam name="Form.item#line#" default="">		
	<cfset items = evaluate("Form.item#line#")>
	
	<cfif items neq "">

			<cfquery name="Insert" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WorkOrderLine
					        (WorkOrderId,
							 WorkOrderLine,  
							 OrgUnitImplementer,
							 ServiceDomain,		
							 ServiceDomainClass,			
							 Reference,
							 DateEffective,
							 DateExpiration,   					 					
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					  VALUES ('#id#',
					          '#line#',
							  '#impl#',
							  '#serviceitem.serviceDomain#',
							  'Internal',  <!--- to be adjusted in the interface --->
							  '#Reference#',
							  #dte#,
							  #dte#,			          				   
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
				</cfquery>		
						
				<cfloop index="itemuomid" list="#items#">
				
					<!--- recorded the -planned- items --->
				
					<cfquery name="get" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ItemUoM
						WHERE  ItemUoMId = '#itemuomid#'			
					</cfquery>
					
					<cfset quantity = evaluate("Form.value#line#_#left(itemuomid,8)#")>
					
					<cfif quantity neq "0" and quantity neq "">
																	
						<!--- obtain the standard cost price --->
						
						<cf_assignId>
																		
						<cfquery name="Insert" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO WorkOrderLineItem
						        (WorkOrderItemId,
								 WorkOrderId,
								 WorkOrderLine,  
								 ItemNo,
								 UoM,
								 Warehouse,								 
								 TransactionLot,								
								 Quantity,
								 Currency,								
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName,	
								 Created)
						  VALUES ('#rowguid#',
						          '#id#',
						          '#line#',
								  '#get.itemno#',
								  '#get.UoM#',
								  '#whse#',
								  <cfif lot eq "">
								  '0',
								  <cfelse>
								  '#lot#',
								  </cfif>
								  '#quantity#',
								  '#application.BaseCurrency#',		   
								  '#SESSION.acc#',
						    	  '#SESSION.last#',		  
							  	  '#SESSION.first#',
								  getDate())
						</cfquery>
						
						<!--- create bom for items --->
						
						<cfinvoke component = "Service.Process.WorkOrder.WorkOrderLineItem" 
						  method		    = "WorkOrderLineItemResource" 
		    			  workorderitemid   = "#rowguid#">	
						  
						<cfquery name="getBOM" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							  SELECT SUM(Amount) as Price
							  FROM   WorkOrderLineItemResource
						      WHERE  WorkOrderItemId = '#rowguid#' 
						</cfquery> 
						 
						<cfif getBOM.Price neq "">
						 
							 <cfquery name="Insert" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE WorkOrderLineItem
									SET    SalePrice         = #getBOM.Price# / quantity, 
									       SaleAmountIncome  = '#getBOM.Price#'
									WHERE  WorkOrderItemId   = '#rowguid#' 
							</cfquery>
						
						</cfif>
													
					</cfif>		
								
			</cfloop>
			
			<!--- sync the BOM table on the higher level --->
				
			<cfinvoke component = "Service.Process.WorkOrder.WorkOrderLineItem" 
			  method		    = "SyncWorkOrderLineResource" 
		      workorderid 	    = "#id#" 
		      workorderline     = "#line#">
	
		</cfif>

</cfloop>

<!--- save custom 

<cfinclude template="../CustomFieldsSubmit.cfm">

<!--- save action --->

<cfinclude template="../ActionFieldsSubmit.cfm">

--->

<cfoutput>

	<script>
	
	   try {
	   opener.applyfilter('','','content')		  
	   ptoken.open('#session.root#/WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#id#&idmenu=#url.idmenu#','_self')
	   } catch(e) {}
	  		
	</script>
	
</cfoutput>
