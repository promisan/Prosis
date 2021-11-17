

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

<cfquery name="get" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  RequestNo = '#url.RequestNo#'					  
</cfquery>	

<cfquery name="ServiceItem" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code   = '#Form.ServiceItem#'					  
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
				WHERE Mission = '#get.Mission#' 
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
				WHERE  Mission = '#get.Mission#' 
			</cfquery>
		
	</cflock>
		
	<cfset no = "#Parameter.WorkOrderPrefix#-#No#">
	
	<cfparam name="form.orgunitOwner" default="#form.OrgUnit1#">
	
	<cfset id = rowguid>
	
	    <CF_DateConvert Value="#Form.OrderDate#">
		<cfset dte = dateValue>
	  
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
			          '#form.customerid#',
					  '#form.serviceitem#',
					  '#form.currency#',
					  <!---
					  '#form.Unit#',		
					  --->
					  '#Form.memo#',			  
			          '#get.Mission#', 
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
					  #dte#,			 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
</cfif>


<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   CustomerGledger
	 WHERE  CustomerId = '#form.customerId#'					  
</cfquery>	

<cfif GL.recordcount eq "0">

	<!--- we take from the higher level --->

	<cfquery name="GL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	DISTINCT Area
		 FROM   	Ref_ParameterMissionGledger
		 WHERE  	Mission = '#get.mission#'		 				  
	</cfquery>	

</cfif>

<cfloop query="GL">

	<cfquery name="getGL" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    GLAccount
		 FROM      Ref_ParameterMissionGledger
		 WHERE     Mission = '#get.mission#'	
		 AND       Area    = '#area#'
		 AND       (Serviceitem = '' OR ServiceItem = '#form.serviceitem#')
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

<CF_DateConvert Value="#Form.DateExpiration#">
<cfset exp = dateValue>

  <cf_assignId>
  
  <cfset wlid = rowguid>

<cfquery name="Insert" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO WorkOrderLine
		        (WorkOrderId,
				 WorkOrderLine,  
				 WorkOrderLineId,
				 OrgUnitImplementer,
				 ServiceDomain,		
				 ServiceDomainClass,			
				 Reference,
				 DateEffective,
				 DateExpiration, 
				 Source,
				 SourceNo,  					 					
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#id#',
		          '#url.workorderline#',
				  '#wlid#',
				  '#form.OrgUnitOwner#',
				  '#form.serviceDomain#',
				  'Standard',  <!--- to be adjusted in the interface --->
				  'Standard',				 
				  #dte#,
				  #exp#,	
				  'Quote',
				  '#get.RequestNo#',	<!--- cross reference, add index --->	          				   
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>			
	
	<cfquery name="Lines" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Materials.dbo.CustomerrequestLine
		WHERE RequestNo = '#get.Requestno#'
	</cfquery>	
	
	<cfloop query="Lines">
	
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
				 ItemPrice,		
				 SalePrice,		
				 
				 SaleTax,
				 TaxCode,
				 TaxIncluded,
				 TaxExemption,
				 SaleAmountIncome,
				 SaleAmountTax,
				 
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#rowguid#',
		          '#id#',
		          '#url.workorderline#',
				  '#itemno#',
				  '#TransactionUoM#',
				  '#get.Warehouse#',
				  <cfif TransactionLot eq "">
				  '0',
				  <cfelse>
				  '#Transactionlot#',
				  </cfif>
				  '#TransactionQuantity#',
				  '#Salescurrency#',		
				  '#SchedulePrice#',
				  '#SalesPrice#',
				  '#TaxPercentage#',
				  '#TaxCode#',
				  '#TaxIncluded#',
				  '#TaxExemption#',
				  '#SalesAmount#',
				  '#SalesTax#',				     
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')	
		
	    </cfquery>			
	
	</cfloop> 
	
<!--- this quote is moved to the workorder --->

<cfquery name="getRequest"
	datasource="AppsWorkOrder"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	UPDATE Materials.dbo.CustomerRequest
	SET    ActionStatus = '1'
	WHERE  RequestNo = '#get.RequestNo#'			
</cfquery>	

</cftransaction>
		       
<!---	

<cfinvoke component     = "Service.Access"  
	   method           = "WorkOrderProcessor" 
	   mission          = "#get.mission#"  
	   serviceitem      = "#form.serviceitem#"
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
						   AND     Mission = '#get.mission#'
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

--->


<cfoutput>

	<script>
	
	   try {	
	   
	   ProsisUI.closeWindow('processquote') <!--- close window --->
	   addquote()  <!--- new quote --->
	   <!--- opem sales order --->
	   <cfif form.openquote eq '1'>
	   ptoken.open('#session.root#/Workorder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?drillid=#wlid#&idmenu=#url.idmenu#','_self')
	   <cfelse>
	   ptoken.open('#session.root#/WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#id#&idmenu=#url.idmenu#','_self')
	   </cfif>   
	   } catch(e) {}
	  		
	</script>
	
</cfoutput>
