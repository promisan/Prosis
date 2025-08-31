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
<!--- Component to serve requests that relate to the handlinmg of production based workorder --- ---> 
<!--- ------------------------------------------------------------------------------------------ --->

<cfcomponent>

   <cfproperty name="name" type="string">
   <cfset this.name = "Execution Queries">	
   
   <cffunction name="copyWorkOrderLine"
        access="public"
        returntype="any"
        displayname="Copy a production workorder line to a another workorder">
				
		<cfargument name="workorderid"      type="string"  required="true"  default="">
		<cfargument name="workorderline"    type="numeric" required="yes">
		<cfargument name="workorderidto"    type="string"  required="true"  default="">
		<cfargument name="mode"             type="string"  required="true"  default="copy">								
		
		<!--- ------------------------------------------ --->
		<!--- ----- get the provisioning lines --------- --->
		<!--- ------------------------------------------ --->
		
		<cftransaction>
		
		<!--- check if the workorder belongs to a -production- workorder (Serviceitem.servicemode = WorkOrder)
		    and likely we need to check if the currency of both workorder = same
			also check if the To workorder is not closed (status = 3)
			
		obtain the workorder line info from the old
			create a new workorderline under the to workorder, with the same effective dates (?)
			determine the correct workorderline serial no
			the new workorder line references the old one in the fields ParentWorkOrder and parentWorkOrderLine
		
		copy the dbo.workorderlineItem over to the new workorderline and then
		
		   we run the commmon BOM process for this new line to -populate- WorkOrderLineItemResource and WorkorderLineResource (this we need to make a componet as it is now in the code)
		
		--->	
		
		
		</cftransaction>	
				
	</cffunction>		
   
   <cffunction name="InternalWorkOrder"
             access="public"
             returntype="string"
             displayname="Generate a list of received/produced workorder items which are meant for INTERNAL usage">
		 
		 <cfargument name="Mission"                  type="string" required="false">
		 <cfargument name="Datasource"               type="string" default="appsWorkOrder">
		 <cfargument name="Table"                    type="string" default="WorkOrderLineItem">
		 <cfargument name="PointerSale"              type="string" default="0">
		 <cfargument name="WorkOrderId"              type="string" required="false">
		 <cfargument name="WorkOrderLine"            type="string" required="true" default="">
		 <cfargument name="Mode"                     type="string" default="output">
		 
		 <!--- added validation to reset RequirementId 
		      once the RequirementId no longer exist in the workorder tables as otherwise the stock can not be used --->
		 
		 <cfquery name="release" 
				datasource="#Datasource#"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE    Materials.dbo.ItemTransaction
				SET       RequirementId = NULL
				FROM      Materials.dbo.ItemTransaction T
				WHERE     WorkOrderId   = '#WorkOrderId#' 
				AND       WorkOrderLine = '#WorkOrderLine#' 
				AND       RequirementId NOT IN
	                            (SELECT   WorkOrderItemId
	                             FROM     WorkOrder.dbo.WorkOrderLineItem
	                             WHERE    WorkOrderItemId = T.RequirementId) 
				AND       RequirementId NOT IN
	                          	(SELECT   ResourceId
    	                        FROM      WorkOrder.dbo.WorkOrderLineResource
        	                    WHERE     ResourceId      = T.RequirementId) 
				AND       RequirementId IS NOT NULL
		 </cfquery>		
		 		 
		 <!--- retrieve any ids of workorders that are associated to a internal workorder --->		 		 
		 
		 <cfif table eq "WorkOrderLineItem">
		 			
				<cfoutput>
					<cfsavecontent variable="base">
						SELECT DISTINCT WOLI.WorkOrderItemId as RequirementId
						FROM   WorkOrder.dbo.WorkOrderLineItem WOLI INNER JOIN
							WorkOrder.dbo.WorkOrderLine WL ON WOLI.WorkOrderId = WL.WorkOrderId AND WOLI.WorkOrderLine = WL.WorkOrderLine INNER JOIN
							WorkOrder.dbo.Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
							WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
						WHERE  W.Mission = '#mission#'
						<cfif workorderid neq "">
						AND    (
								WL.WorkorderId   != '#workorderid#' 
								OR 
								(WL.WorkorderId   = '#workorderid#' AND WL.WorkOrderLine != '#workorderline#')
							)
						</cfif>
						<cfif pointersale neq "">
						AND    R.PointerSale = '#pointersale#' <!--- workorders for interal production and thus not earmarked --->
						</cfif>
						
						<!--- ------------------------------------------------------------------------------------------ --->
						<!--- also has potential values of stock to prevent too many records to be passed for no reason- --->
						<!--- ------------------------------------------------------------------------------------------ 
						
						removed as this slowed down the query a lot 5/4/2021
						
						AND   WorkOrderItemId IN (
											
									SELECT     RequirementId
									FROM       Materials.dbo.ItemTransaction
									WHERE      RequirementId = WOLI.WorkOrderItemId
									GROUP BY   RequirementId, 
											   ItemNo, 
											   TransactionUoM
									HAVING     SUM(TransactionQuantity) > 0
						
							)	
							
							--->					
					</cfsavecontent>
				</cfoutput>
			
				<cfif Mode eq "Output">
				
					<cfquery name="get" 
							datasource="#Datasource#"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							 #preservesingleQuotes(base)#					 
					</cfquery>
				
				</cfif>		 			 
								
		<cfelse>		
			<cfoutput>			
				<cfsavecontent variable="base">			
					SELECT DISTINCT WOLI.ResourceId as RequirementId
					FROM   WorkOrder.dbo.WorkOrderLineResource WOLI INNER JOIN
						WorkOrder.dbo.WorkOrderLine WL ON WOLI.WorkOrderId = WL.WorkOrderId AND WOLI.WorkOrderLine = WL.WorkOrderLine INNER JOIN
						WorkOrder.dbo.Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
						WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
					WHERE  W.Mission = '#mission#'
				<cfif workorderid neq "">
					AND    (
							WL.WorkorderId   != '#workorderid#' 
							OR 
							(WL.WorkorderId   = '#workorderid#' AND WL.WorkOrderLine != '#workorderline#')
						)
					</cfif>
					<cfif pointersale neq "">
					AND    R.PointerSale = '#pointersale#' <!--- workorders for interal production and thus not earmarked --->
					</cfif>
					
					<!--- removed Dev as this was confusing as sometimes there are negatives, with the function to set inventory
					you can control this better.
					
					AND ResourceId IN (
										
								SELECT     RequirementId
								FROM       Materials.dbo.ItemTransaction
								WHERE      RequirementId = WOLI.ResourceId
								GROUP BY   RequirementId, ItemNo, TransactionUoM
								HAVING     HAVING     (SUM(TransactionQuantity) > 0)
								
							
					
					)
					
					--->
							
					<!--- added 30/12 to include FP lines which can be made available for production requirement --->
										
					UNION
					
					SELECT DISTINCT WOLI.WorkOrderItemId as RequirementId
					FROM   WorkOrder.dbo.WorkOrderLineItem WOLI INNER JOIN
						WorkOrder.dbo.WorkOrderLine WL ON WOLI.WorkOrderId = WL.WorkOrderId AND WOLI.WorkOrderLine = WL.WorkOrderLine INNER JOIN
						WorkOrder.dbo.Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code INNER JOIN
						WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
					WHERE  W.Mission = '#mission#'
					<cfif workorderid neq "">
					AND    (
							WL.WorkorderId   != '#workorderid#' 
							OR 
							(WL.WorkorderId   = '#workorderid#' AND WL.WorkOrderLine != '#workorderline#')
						)
					</cfif>
					<cfif pointersale neq "">
					AND    R.PointerSale = '#pointersale#' <!--- workorders for interal production and thus not earmarked --->
					</cfif>	
					
					<!--- removed Dev as this was confusing as sometimes there are negatives, with the function to set inventory
					you can control this better.
					AND WorkOrderItemId IN (
										
								SELECT     RequirementId
								FROM       Materials.dbo.ItemTransaction
								WHERE      RequirementId = WOLI.WorkOrderItemId
								GROUP BY   RequirementId, ItemNo, TransactionUoM
								HAVING     (SUM(TransactionQuantity) > 0)
								
								
					
					)		
					
					--->					
				</cfsavecontent>
			</cfoutput>
			
			<cfif Mode eq "Output">
				
				<cfquery name="get" 
					datasource="#Datasource#"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 #preservesingleQuotes(base)#					 
				</cfquery>
				
			</cfif>		 					
		
		</cfif>
		
		<!--- returns all workorderlineitems that are internal --->
		
		<cfif mode eq "output">
		
			<cfset internal = quotedValueList(get.RequirementId)>
	
			<cfif internal eq "">
				 <cfset internal = "'00000000-0000-0000-0000-000000000000'">
			</cfif>
			
		<cfelse>
		
			<cfset internal = base>
			
		</cfif>	
		
		<cfreturn internal>		 
		 
   </cffunction>	 
   
   <cffunction name="WorkOrderLineItemResource"
         access="public"
         returntype="any"
         displayname="Applies the BOM">    
		 
		 <cfargument name="WorkOrderItemId"    type="string" required="true" default=""> 
		 
		 <cfquery name="get" 
			datasource="AppsWorkOrder"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    WorkOrderLineItem WOL INNER JOIN WorkOrder W ON WOL.WorkOrderId = W.WorkOrderId			
			WHERE	WOL.WorkOrderItemId = '#workorderitemid#' 											
		 </cfquery>
		 		 
		 <cfquery name="CleanWorkOrderLineItemResource" 
			datasource="AppsWorkOrder"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE	 WorkOrderLineItemResource
				WHERE    WorkOrderItemId = '#workorderItemId#'
			</cfquery>			
		
			<cfquery name="getLast" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     Materials.dbo.ItemBOM IB 
				WHERE    IB.Mission = '#get.Mission#'  <!--- only for that mission --->
				AND      IB.ItemNo  = '#get.ItemNo#' 
				AND      IB.UoM     = '#get.UoM#'
				ORDER BY DateEffective DESC							
			</cfquery>		
						
			<cfif getLast.recordcount eq "0">
			
				<!--- ---------------------------------------------------------- --->
				<!--- no BOM found so we go to the parent -to inherit optionally --->
				<!--- ---------------------------------------------------------- --->
			
				<cfquery name="getItem" 
				datasource="AppsWorkorder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Materials.dbo.Item 
				WHERE    ItemNo  = '#get.ItemNo#' 								
				</cfquery>		
			
				<!--- we go to the parent BOM -to inherit optionally --->
				
				<cfquery name="BOMParent" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     Materials.dbo.ItemBOM 
					WHERE    ItemNo  = '#getItem.ParentItemNo#'
					AND	     UoM     = '#get.UoM#'  
					AND      Mission = '#get.Mission#'
					ORDER BY DateEffective DESC
				</cfquery>
				
				<!--- apply the BOM of the parent to the -new- child --->
				
				<cfif BOMParent.recordcount eq "1">
				
					<cf_AssignId>
					<cfset bomId = rowguid>
					
					<cfquery name="InheritBOM" 
					   datasource="AppsWorkOrder" 
					   username="#SESSION.login#" 
			           password="#SESSION.dbpw#">
						INSERT INTO Materials.dbo.ItemBOM
									(BOMId,
									 Mission,
									 ItemNo,
									 UoM,
									 DateEffective,
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
						VALUES  ('#bomId#',
						         '#get.Mission#',
							     '#get.ItemNo#',
							     '#get.UoM#',
							     '#BOMParent.DateEffective#',
							     '#session.acc#',
							     '#session.last#',
							     '#session.first#') 
					</cfquery>
	
					<cfquery name="InheritBOM" 
					   datasource="AppsWorkOrder" 
					   username="#SESSION.login#" 
			           password="#SESSION.dbpw#">
					   
						INSERT INTO Materials.dbo.ItemBOMDetail
							   (BOMId,
								MaterialItemNo,
								MaterialUoM,
								MaterialQuantity,
								MaterialCost,
								MaterialMemo,
				  			    OfficerUserId,
								OfficerLastName,
								OfficerFirstName)
						SELECT '#bomId#',
							    IBD.MaterialItemNo,
							    IBD.MaterialUoM,
							    IBD.MaterialQuantity,
							    IBD.MaterialCost,
							    IBD.MaterialMemo,
							    '#session.acc#',
							    '#session.last#',
							    '#session.first#' 
						FROM    Materials.dbo.ItemBOMDetail IBD
						WHERE   IBD.BomId = '#BOMParent.BOMID#'					
						
					</cfquery>
				
				</cfif>
				
				<cfquery name="getLast" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     Materials.dbo.ItemBOM IB 
					WHERE    IB.Mission = '#get.Mission#'  <!--- only for that mission --->
					AND      IB.ItemNo  = '#get.ItemNo#' 
					AND      IB.UoM     = '#get.UoM#'
					ORDER BY DateEffective DESC							
				</cfquery>		
			
			</cfif>	
			
			<cfif getLast.recordcount eq "1">

				<cfquery name="ItemMaterial" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   IBD.*,
					         MIS.StandardCost AS MissionStandardCost, 
							 UoM.StandardCost AS StandardCost
					FROM     Materials.dbo.ItemBOM IB INNER JOIN Materials.dbo.ItemBOMDetail IBD ON IB.BOMId = IBD.BOMId INNER JOIN
	                	     Materials.dbo.ItemUoMMission MIS ON IB.ItemNo = MIS.ItemNo 
							                                 AND IB.UoM = MIS.UoM 
															 AND IB.Mission = MIS.Mission 
							 INNER JOIN  Materials.dbo.ItemUoM UoM ON IB.ItemNo = UoM.ItemNo AND IB.UoM = UoM.UoM
							 
					WHERE    IB.Mission = '#get.Mission#'  <!--- only for that mission --->
					AND      IB.ItemNo  = '#get.ItemNo#' 
					AND      IB.UoM     = '#get.UoM#'
					AND      IB.DateEffective = '#dateformat(getLast.DateEffective,client.dateSQL)#'					
				</cfquery>			
				
				<!--- generate the item on the workorderlineresource level --->
				
				<cfset wid = workorderitemid>
								
				<cfloop query="ItemMaterial">	
							
					<cfset qty = get.Quantity * MaterialQuantity>
					
					<cfif MaterialCost neq "0">
					    <!--- inherit from bom --->
						<cfset prc = MaterialCost>
					<cfelse>
						<cfif MissionStandardCost gt 0>
							<cfset prc = MissionStandardCost>
						<cfelse>
						    <cfset prc = StandardCost>
						</cfif>
					</cfif>	
					<cfif prc eq "">
						<cfset prc = 0>
					</cfif>		
													
					<cfquery name="insertBOMRecord" 
						datasource="AppsWorkOrder"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							INSERT INTO WorkOrderLineItemResource
						           	(WorkOrderItemId,							
						           	 ResourceItemNo,
						           	 ResourceUoM,	
									 OrgUnit,
									 Quantity,
									 Price,		
									 Memo,	          
						           	 OfficerUserId,
						           	 OfficerLastName,
						           	 OfficerFirstName)
					     	VALUES ('#wid#',				           
						           	'#MaterialItemNo#',
						           	'#MaterialUoM#',
									'0',
									'#qty#',
									'#prc#',
									'#MaterialMemo#',
					    	        '#Session.acc#',
					        	   	'#Session.last#',
					           		'#Session.acc#')
					</cfquery>					
												
				</cfloop>					
				
			</cfif>			
		 		 
   </cffunction>		 
	
   <cffunction name="SyncWorkOrderLineResource"
         access="public"
         returntype="any"
         displayname="Sync WorkOrderLineResource table with the details in WorkOrderLineItemResource">
				
			<cfargument name="WorkOrderId"      type="string" required="false">
			<cfargument name="WorkOrderLine"    type="string" required="true" default="">
						
			<!--- insert new entries --->
			
			<cfquery name="base" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   ResourceItemNo, 
				         ResourceUoM, 
						 Reference, 
						 'Supply' as Class,
						 MAX(Price) AS Price
				FROM     WorkOrderLineItemResource R, WorkOrderLineItem I
				WHERE    R.WorkOrderItemId = I.WorkOrderItemId
				AND      WorkOrderId    = '#workorderid#' 
				AND      WorkOrderLine  = '#workorderline#'		
				AND      R.ResourceItemNo IN (SELECT ItemNo FROM Materials.dbo.Item WHERE ItemNo = R.ResourceItemNo and ItemClass = 'Supply')	
				GROUP BY ResourceItemNo, 
				         ResourceUoM, 
						 Reference
						 
				UNION ALL
				
				SELECT   ResourceItemNo, 
				         ResourceUoM, 
						 Reference, 
						 'Service' as Class,
						 ROUND(SUM(R.Amount)/SUM(R.Quantity),2) as Price
				FROM     WorkOrderLineItemResource R, WorkOrderLineItem I
				WHERE    R.WorkOrderItemId = I.WorkOrderItemId
				AND      WorkOrderId    = '#workorderid#' 
				AND      WorkOrderLine  = '#workorderline#'		
				AND      R.ResourceItemNo IN (SELECT ItemNo FROM Materials.dbo.Item WHERE ItemNo = R.ResourceItemNo and ItemClass = 'Service')	
				GROUP BY ResourceItemNo, 
				         ResourceUoM, 
						 Reference				
						 
			</cfquery>	
			
			<cfloop query="Base">
						
				<cfquery name="check" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    WorkOrderLineResource
						WHERE	WorkOrderId       = '#workorderid#' 
						AND     WorkOrderLine     = '#workorderline#'						
						AND     ResourceItemNo    = '#ResourceItemNo#'
						AND     ResourceUoM       = '#ResourceUoM#'
						AND     ResourceReference = '#Reference#'
				</cfquery>
				
				<cfif check.recordcount eq "0">				
				
					<cfquery name="qWorkOrderLineResource" 
						datasource="AppsWorkOrder"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						INSERT INTO WorkOrderLineResource
					           	(WorkOrderId,
								 WorkOrderLine,
					           	 ResourceItemNo,
					           	 ResourceUoM,	
								 ResourceReference,
								 Quantity,
								 Price,			
								 Source,          
					           	 OfficerUserId,
					           	 OfficerLastName,
					           	 OfficerFirstName)
				     	VALUES  ('#workorderid#',
					           	'#workorderline#',
					           	'#ResourceItemNo#',
					           	'#ResourceUoM#',
								'#Reference#',
								'0',
								'#Price#',
								'Inherited',
				    	        '#SESSION.acc#',
				        	   	'#SESSION.last#',
					           	'#SESSION.acc#')
					</cfquery>		
					
				<cfelseif class eq "Service">
				
					<cfquery name="check" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
						UPDATE  WorkOrderLineResource
						SET     Price = '#price#'
						WHERE	WorkOrderId       = '#workorderid#' 
						AND     WorkOrderLine     = '#workorderline#'						
						AND     ResourceItemNo    = '#ResourceItemNo#'
						AND     ResourceUoM       = '#ResourceUoM#'
						AND     ResourceReference = '#Reference#'
				</cfquery>
									
								
				</cfif>	
			
			</cfloop>		
			
						
			<!--- update existing entries but only if the detailed quantities higher than recorded quantities --->
			
			<cfquery name="updateParentRecord" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
				UPDATE WorkOrderLineResource	
				SET    Quantity = T.Quantity,
				       Source = 'Inherited'				
				FROM   WorkOrderLineResource S, 
				
					   ( SELECT   WorkOrderId,
					              WorkOrderLine,
								  ResourceItemNo,
								  ResourceUoM,
								  Reference,
								  SUM(WOR.Quantity) as Quantity
						 FROM     WorkOrderLineItem WOLI
						          INNER JOIN WorkOrderLineItemResource WOR 
								  ON WOLI.WorkOrderItemId = WOR.WorkOrderItemId 
						 WHERE    WOLI.WorkOrderId   = '#workorderid#' 
						 AND      WOLI.WorkOrderLine = '#workorderline#'	
						 GROUP BY WOLI.WorkOrderId, 
						          WOLI.WorkOrderLine, 
								  WOR.ResourceItemNo, 
								  WOR.ResourceUoM, 
								  WOR.Reference 	
					   ) as T
					   
				 WHERE S.WorkorderId        = T.WorkOrderId
				 AND   S.WorkOrderLine      = T.WorkOrderLine
				 AND   S.ResourceItemNo     = T.ResourceItemNo
				 AND   S.ResourceUoM        = T.ResourceUoM 
				 AND   S.ResourceReference  = T.Reference 
				 <!---
				 AND   T.Quantity > S.Quantity 				 
				 --->
				 AND   T.Quantity >= 0 				 
				 
			</cfquery>
			
						
			<cfsavecontent variable="exist">
			
				<cfoutput>
				
							SELECT S.ResourceId 		
							FROM   WorkOrderLineResource S, 
							
								   ( SELECT   WorkOrderId,
								              WorkOrderLine,
											  WOR.ResourceItemNo,
											  WOR.ResourceUoM,
											  WOR.Reference
									 
									 FROM     WorkOrderLineItem WOLI
									          INNER JOIN WorkOrderLineItemResource WOR ON WOLI.WorkOrderItemId = WOR.WorkOrderItemId 
									 
									 WHERE    WOLI.WorkOrderId   = '#workorderid#' 
									 AND      WOLI.WorkOrderLine = '#workorderline#'										 
									 
									 GROUP BY WOLI.WorkOrderId, 
									          WOLI.WorkOrderLine, 
											  WOR.ResourceItemNo,
											  WOR.ResourceUoM, 	
											  WOR.Reference
											  
									 HAVING  SUM(WOR.Quantity) > 0
									 
								   ) as T
								   
							WHERE S.WorkorderId       = T.WorkOrderId
							AND   S.WorkOrderLine     = T.WorkOrderLine
							AND   S.ResourceItemNo    = T.ResourceItemNo
							AND   S.ResourceUoM       = T.ResourceUoM
							AND   S.ResourceReference = T.Reference 		
							
				</cfoutput>
						
			</cfsavecontent>
			
			<!--- reset requirements that no longer exist --->
			<cfquery name="updateParentRecord" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				
					UPDATE WorkOrderLineResource	
					SET    Quantity = 0,
					       Source = 'Inherited'		
						   
					FROM   WorkOrderLineResource V
					
					WHERE  WorkOrderId   = '#workorderid#' 
					AND    WorkOrderLine = '#workorderline#'		
					AND    ResourceId NOT IN (#preserveSingleQuotes(exist)#)		
					AND    Source = 'Inherited'
										
			 </cfquery>			
						
			<!--- now we try to remove procurement if the quantity under procured is 20% larger than the 
			     current requirement so we can gnerate it again --->
				 
			<cfquery name="getRequisitionToBeCleared" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT * 
				FROM   Purchase.dbo.RequisitionLine
				WHERE  RequirementId IN (				
							SELECT   WLR.ResourceId
							FROM     WorkOrderLineResource WLR INNER JOIN
			                		 Purchase.dbo.RequisitionLine RL ON WLR.ResourceId = RL.RequirementId 
							WHERE    WLR.WorkOrderId   = '#workorderid#'
							AND      WLR.WorkOrderLine = '#workorderline#'	
							<!--- requirement is clearly lower than requisition quantity --->
							AND      (WLR.Quantity*1.2) < RL.RequestQuantity
							) 	 											
						
				 AND   (ActionStatus < '3' or ActionStatus = '9')			
			 </cfquery>		
			 
			<cfloop query="getRequisitionToBeCleared">	
			
				<cfquery name="clearRequisition" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					DELETE FROM Purchase.dbo.RequisitionLine WHERE RequisitionNo = '#requisitionNo#'				
				</cfquery>				 			
				
			</cfloop>					
									
			<!--- remove supply BOM items if they do no longers exist in the details and we do not have
			any procurement left --->
						
			<cfquery name="removeParentRecord" 
				datasource="AppsWorkOrder"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
				DELETE WorkOrderLineResource
				
				FROM   WorkOrderLineResource S
				
				WHERE  S.WorkOrderId   = '#workorderid#'
				AND    S.WorkOrderLine = '#workorderline#'

				<!--- we only remove supply items or items that do not exisit anymore --->
				
				AND    (
				
				       S.Source = 'Inherited'					 
											
				       OR 
					   
					   S.ResourceItemNo NOT IN (SELECT ItemNo 
					                            FROM   Materials.dbo.Item TS
											    WHERE  TS.ItemNo = S.ResourceItemNo)
											   
					   )
					   
				AND    S.Quantity = 0	   
				
				<!--- and are NOT under procurement already for the workorder line, 
				   in that case we might want ot keep them ????? HOWEVER I can imagine we want to drop them as well if they are not procured yet ? --->
				
				AND    NOT EXISTS (
				          SELECT 'X' 
						  FROM    Purchase.dbo.RequisitionLine
						  WHERE   WorkOrderId     = S.WorkOrderId
						  AND     WorkOrderLine   = S.WorkOrderLine
						  AND     RequirementId   = S.ResourceId						  						  
						  AND     ActionStatus NOT IN ('0','9')				
						  )
					 
							 				
			</cfquery>									
							
	</cffunction>
	
	<cffunction name="ProcessProduction"
         access="public"
         returntype="any"
         displayname="Generate stock transactions (+/+ and -/-) for a production workorder">
				
			<cfargument name="WorkOrderId"      type="string" required="true">
			<cfargument name="WorkOrderLine"    type="string" required="true" default="">
			<cfargument name="ActionStatus"     type="string" required="true" default="0">
			<cfargument name="Mode"             type="string" required="true" default="Both">
			
			<!--- create a batch of the generated items --->			
			
			<cfquery name="get" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrder
				WHERE     WorkOrderId = '#workorderid#' 				
			</cfquery>				
			
			<cfquery name="param" 
			   datasource="AppsMaterials" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   SELECT   *
			   FROM     Ref_ParameterMission
			   WHERE    Mission = '#get.mission#' 
			</cfquery>
			
			<cfquery name="line" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderLine
				WHERE     WorkOrderId   = '#workorderid#' 				
				AND       WorkOrderLine = '#workorderline#'
			</cfquery>	
			
			<cfquery name="setting" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    R.PointerStock, 
				          R.PointerOverdraw
				FROM      WorkOrder.dbo.WorkOrderLine AS WL INNER JOIN
                          WorkOrder.dbo.Ref_ServiceItemDomainClass AS R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
				WHERE     WorkOrderId   = '#workorderid#' 				
				AND       WorkOrderLine = '#workorderline#'		   
			</cfquery>			   
			
			<cfif mode eq "Consumption" or mode eq "Both">
			
			<cftransaction>		
			
			<!--- clean transactions posted before --->
			
			<cfquery name="getBatch" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT    BatchNo
                FROM      WarehouseBatch
                WHERE     BatchId = '#line.workorderlineid#'
				AND       TransactionType = '2'
			</cfquery>
			
			<cfloop query="getBatch">
											 
			 	<!--- remove any sourcing made on the positive side of the transaction --->
			 	<cfquery name="removeValuation" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM   ItemTransactionValuation
					WHERE  TransactionId IN (SELECT TransactionId 
					                         FROM   ItemTransaction 
											 WHERE  TransactionBatchNo = '#batchno#')	
																																																		
			    </cfquery>					 					 
				
				<!--- we can revaluate it --->			 											
				<cfquery name="revertTransactions" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE FROM ItemTransaction
						WHERE TransactionBatchNo = '#batchno#'										
				</cfquery>																	
			
			</cfloop>
			
			<!--- create a batch for the consumed items / BOM but only if the
			line has a warehouse associated --->
			
			<cfquery name="service" 
				datasource="AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			

				SELECT    *
				FROM      WorkOrder.dbo.WorkOrderServiceMission
				WHERE     ServiceDomain   = '#Line.ServiceDomain#' 				
				AND       Reference       = '#Line.Reference#'
				AND       Mission         = '#get.Mission#'				
			</cfquery>	
			
			<cfif service.orgunitimplementer neq "">
			
				<cfquery name="BOMwarehouse" 
					datasource="AppsMaterials"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">					
					SELECT    W.*
					FROM      Organization.dbo.Organization AS O INNER JOIN
	    	                  Materials.dbo.Warehouse AS W ON O.MissionOrgUnitId = W.MissionOrgUnitId
					WHERE     O.OrgUnit = '#service.OrgUnitImplementer#'			
				</cfquery>
				
				<!--- only items that have no lot defined we will load --->
				
				<cfif BOMWarehouse.recordcount eq "1">
									
					<cfquery name="check" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT  * 
						FROM    WarehouseBatch 
						WHERE   BatchId   = '#Line.WorkOrderLineId#'
						AND     Warehouse = '#BOMWarehouse.warehouse#'
						AND     TransactionType = '2'
						AND     TransactionLot is NULL									
					</cfquery>
					
					<cfif check.recordcount eq "1">
					
						<cfset batchno = check.BatchNo>
												
					<cfelse>
							
						<cfquery name="Parameter" 
						   datasource="AppsMaterials" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   SELECT   TOP 1 *
						   FROM     WarehouseBatch
						   ORDER BY BatchNo DESC
						</cfquery>
						
						<cfif Parameter.recordcount eq "0">
							<cfset batchNo = 10000>
						<cfelse>
							<cfset BatchNo = Parameter.BatchNo+1>
							<cfif BatchNo lt 10000>
							     <cfset BatchNo = 10000+BatchNo>
							</cfif>
						</cfif>	
															
						<cfquery name="Insert" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO WarehouseBatch
								    (Mission,
									 Warehouse, 
									 BatchWarehouse,									 	
									 BatchReference,		
									 BatchClass,
								 	 BatchNo, 	
									 BatchId,
									 BatchDescription,						
									 TransactionDate,
									 TransactionType, 					
									 ActionStatus,
									 OfficerUserId, 
									 OfficerLastName, 
									 OfficerFirstName)
						VALUES 	   ('#get.mission#',
							        '#BOMWarehouse.warehouse#',
									'#BOMWarehouse.warehouse#',									
									'WorkOrder Production',
									'Production',
									'#batchNo#',	
									'#Line.WorkOrderLineId#',
									'Production Consumption',										
									'#line.DateEffective#',
									'2',					
									'#ActionStatus#',
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#')
						</cfquery>					
						
					</cfif>	
							
					<cfquery name="ItemToConsume" 
						datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						
						SELECT    WOL.ResourceId as RequirementId,
								  WOL.WorkOrderId,
								  WOL.WorkOrderLine,   
								  I.ItemNo, 
								  I.ItemDescription,
								  U.UoM, 
								  I.Category,					
								  U.UoMDescription, 								 
								  WOL.Quantity, 	
								  
								  (  SELECT  ISNULL(SUM(TransactionQuantity*-1), 0)
						             FROM    Materials.dbo.Itemtransaction			  
						             WHERE   Mission         = '#get.Mission#' 
									 AND     RequirementId   = WOL.ResourceId									 
						     	     AND     TransactionType = '2' 	<!--- confirmed and not confirmed --->										   
								     AND     WorkOrderId     = WOL.WorkOrderId 
								     AND     WorkOrderLine   = WOL.WorkOrderLine) AS Consumed,				
								  							 
								  WOL.Created
								  
						FROM      Workorder.dbo.WorkOrderLineResource WOL 
						          INNER JOIN Item I ON WOL.ResourceItemNo = I.ItemNo 
								  INNER JOIN ItemUoM U ON WOL.ResourceItemNo = U.ItemNo AND WOL.ResourceUoM = U.UoM
								  
						WHERE     WorkOrderId   = '#workorderid#' 
						AND       WorkOrderLine = '#workorderline#'
										
						AND       ItemClass = 'Supply'		
												
					</cfquery>	
										
					<cfoutput query="ItemToConsume">
					
							<!--- link with ledger --->
			
						 	<cfquery name="AccountStock"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
								    SELECT  GLAccount
									FROM    Ref_CategoryGLedger
									WHERE   Category = '#Category#' 
									AND     Area     = 'Stock'
									AND     GLAccount IN (SELECT GLAccount 
									                      FROM   Accounting.dbo.Ref_Account)
							</cfquery>	
							
							<cfquery name="AccountTask"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    	SELECT  GLAccount
								FROM    Ref_CategoryGLedger
								WHERE   Category = '#Category#' 
								AND     Area     = 'Variance'
								AND     GLAccount IN (SELECT GLAccount 
									                      FROM   Accounting.dbo.Ref_Account)
							</cfquery>	
							
							<cfquery name="AccountProduction" 
								datasource="AppsMaterials"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								   SELECT * 
								   FROM   Workorder.dbo.WorkorderGLedger 
								   WHERE  WorkorderId   = '#workorderid#'		
								   AND    Area          = 'Production'
								   AND    GLAccount IN (SELECT GLAccount 
								                        FROM   Accounting.dbo.Ref_Account)	  
							</cfquery>   
							
							<cfif AccountProduction.GLAccount eq "">
							
								<!--- then we defined the default income account for the production based on the category --->
											
								<cfquery name="AccountProduction"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
									    SELECT  GLAccount
										FROM    Ref_CategoryGLedger
										WHERE   Category = '#Category#' 
										AND     Area     = 'Production'
										AND     GLAccount IN (SELECT GLAccount 
										                      FROM   Accounting.dbo.Ref_Account)
								</cfquery>	
							
							</cfif>
							
							<cfif AccountProduction.GLAccount eq "" or AccountStock.GLAccount eq "" or AccountTask.GLAccount eq "">
							   
							   <table align="center">
							   	<tr><td class="labelmedium" align="center"><font color="FF0000">Attention : GL Account for stock and/or workorder production has not been defined yet</td></tr>
							   </table>
							   <cfabort>
							
							</cfif>
					
							<cfset toConsume = Quantity - Consumed> <!--- to be consumed --->
							
							<!--- first consume from the lot stock and then from the non-lot stock for the remainer --->
							
							<cfquery name="LocationOnhand" 
							datasource="AppsMaterials"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
								SELECT    T.Warehouse,
										  T.ItemNo,
										  T.TransactionUoM,
								          T.Location, 
										  T.TransactionLot, 
										  PL.TransactionLotDate,										 
										  L.ListingOrder,
										  SUM(T.TransactionQuantity) AS OnHand 
										  
								FROM      ItemTransaction AS T INNER JOIN
					                      WarehouseLocation AS L ON T.Warehouse = L.Warehouse AND T.Location = L.Location INNER JOIN
				                          ProductionLot AS PL ON T.Mission = PL.Mission AND T.TransactionLot = PL.TransactionLot
										  
								WHERE     T.Warehouse      = '#BOMWarehouse.Warehouse#' 
								AND       T.ItemNo         = '#ItemNo#' 								
								AND       T.TransactionUoM = '#Uom#' 
								
								<!--- on 9/6 I droped the below
								as the purpose of this ware is to have stock for the production so we take it
								regardless 
								
								AND       T.RequirementId is NULL
								
								--->
								
							    GROUP BY  T.Warehouse,
										  T.ItemNo,
										  T.TransactionUoM,
										  T.Location, 
								          T.TransactionLot, 
										  PL.TransactionLotDate, 
										  L.ListingOrder
										  
								ORDER BY  L.ListingOrder, 
								          PL.TransactionLotDate
										 										  										  
							</cfquery>
							
							<cfset dte = Line.dateEffective>
																		
							<cfloop query="LocationOnHand">		
							
								<cfif toConsume gt "0" and onhand gte "0">					
							
									<cfif toConsume gte onhand>
										<cfset apply = onhand>
										<cfset toConsume = toConsume - onhand>									
									<cfelse>
										<cfset apply = 	toConsume>
										<cfset toConsume = 0>
									</cfif>
																									
									<cfif apply neq "0">
									
										<!--- transfer from stock --->	
									
										<cf_assignid>		
										
										<cfset parentid = rowguid>																	
															
										<cf_StockTransact 
											    DataSource            = "AppsMaterials" 
												TransactionId         = "#rowguid#"													
											    TransactionType       = "8"  <!--- transfer from nonearmarked stock --->
												TransactionSource     = "WorkOrderSeries"
												ItemNo                = "#ItemNo#" 
												TransactionUoM        = "#TransactionUoM#"	
												Mission               = "#get.Mission#" 
												Warehouse             = "#Warehouse#" 												
												TransactionLot        = "#TransactionLot#" 						
												Location              = "#Location#"																												
												TransactionQuantity   = "#apply*-1#"																		
												TransactionLocalTime  = "Yes"
												TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
												TransactionTime       = "#timeformat(dte,'HH:MM')#"
												TransactionBatchNo    = "#batchno#"												
												GLTransactionNo       = "#batchNo#"			
												ActionStatus          = "#ActionStatus#"													
												
												OrgUnit               = "#line.orgunitimplementer#"
												GLAccountDebit        = "#AccountTask.GLAccount#"
												GLAccountCredit       = "#AccountStock.GLAccount#">	
												
										<!--- move to earmarked stage --->	
									
										<cf_assignid>	
											
										<cf_StockTransact 
									        ParentTransactionId   = "#parentid#"
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"							
										    TransactionType       = "8"  <!--- transfer to earmarked stock under new transaction --->											
											TransactionSource     = "WorkOrderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#TransactionUoM#"	
											Mission               = "#get.Mission#" 
											Warehouse             = "#Warehouse#" 
											Location              = "#Location#"
											TransactionLot        = "#TransactionLot#" 																									
											TransactionQuantity   = "#apply#"		
																										
											TransactionLocalTime  = "Yes"
											TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
											TransactionTime       = "#timeformat(dte,'HH:MM')#"
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"		
															
											ActionStatus          = "#ActionStatus#"
											WorkOrderId           = "#ItemToConsume.workorderid#"
											WorkOrderLine         = "#ItemToConsume.workorderline#"	
											RequirementId         = "#ItemToConsume.RequirementId#"										
											
											OrgUnit               = "#line.orgunitimplementer#"
											GLAccountDebit        = "#AccountStock.GLAccount#"
											GLAccountCredit       = "#AccountTask.GLAccount#">										
											
										<!--- deduct from earmarked stock --->		
										
										<cf_assignId>		
																
										<cf_StockTransact 
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"	
										    TransactionType       = "2"  <!--- production consumption --->
											TransactionSource     = "WorkorderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#TransactionUoM#"
											Mission               = "#get.Mission#" 
											Warehouse             = "#Warehouse#" 
											Location              = "#Location#"
											TransactionLot        = "#transactionLot#"
											TransactionQuantity   = "#apply*-1#"																	
																		
											TransactionLocalTime  = "No"
											TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"	
											TransactionTime       = "#timeformat(dte,'HH:MM')#"				
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"
											
											ActionStatus          = "#ActionStatus#"
											WorkOrderId           = "#ItemToConsume.workorderid#"
											WorkOrderLine         = "#ItemToConsume.workorderline#"	
											RequirementId         = "#ItemToConsume.RequirementId#"				
											
											OrgUnit               = "#line.orgunitimplementer#"
											GLAccountCredit       = "#AccountStock.GLAccount#"
											GLAccountDebit        = "#AccountProduction.GLAccount#">	
											
									</cfif>		
									
								</cfif>	
									
							</cfloop>
							
							<!--- ------------------------------------------------------------------------- --->
							<!--- !!!!! attention : this is the remainder to consume for which we do not have stock
							 we consume into negatives for those !!!!! --->
							<!--- ------------------------------------------------------------------------- ---> 
																					
							<cfif toConsume gt "0">									
							
								<cfif Setting.PointerOverdraw eq "0">
								
									<table align="center">
										<tr><td class="labelmedium" style="padding-top:30px" align="center"><font color="FF0000">Attention : Insufficient stock.Operational halted</td></tr>
								   </table>
								
									<script>										
										Prosis.busy('no')
									</script>
								
									<cfabort>
										
								<cfelse>
							
									<cf_assignid>	
						
									<cfset parentid = rowguid>																												
														
									<cf_StockTransact 
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"													
										    TransactionType       = "8"  <!--- transfer from nonearmarked stock --->
											TransactionSource     = "WorkOrderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#UoM#"	
											Mission               = "#get.Mission#" 
											Warehouse             = "#BOMWarehouse.Warehouse#" 												
																																					
											TransactionQuantity   = "#toConsume*-1#"																		
											TransactionLocalTime  = "Yes"
											TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
											TransactionTime       = "#timeformat(dte,'HH:MM')#"
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"			
											ActionStatus          = "#ActionStatus#"													
											
											OrgUnit               = "#line.orgunitimplementer#"
											GLAccountDebit        = "#AccountTask.GLAccount#"
											GLAccountCredit       = "#AccountStock.GLAccount#">	
											
									<!--- move to earmarked stock --->	
								
									<cf_assignid>	
										
									<cf_StockTransact 
									        ParentTransactionId   = "#parentid#"
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"							
										    TransactionType       = "8"  <!--- transfer to earmarked stock under new transaction --->
											
											TransactionSource     = "WorkOrderSeries"
											ItemNo                = "#ItemNo#" 
											TransactionUoM        = "#UoM#"	
											Mission               = "#get.Mission#" 
											Warehouse             = "#BOMWarehouse.Warehouse#" 																																	
											TransactionQuantity   = "#toConsume#"		
																										
											TransactionLocalTime  = "Yes"
											TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"
											TransactionTime       = "#timeformat(dte,'HH:MM')#"
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"		
															
											ActionStatus          = "#ActionStatus#"
											WorkOrderId           = "#ItemToConsume.workorderid#"
											WorkOrderLine         = "#ItemToConsume.workorderline#"	
											RequirementId         = "#ItemToConsume.RequirementId#"										
											
											OrgUnit               = "#line.orgunitimplementer#"
											GLAccountDebit        = "#AccountStock.GLAccount#"
											GLAccountCredit       = "#AccountTask.GLAccount#">								
								
										<cf_assignId>		
																
										<cf_StockTransact 
										    DataSource            = "AppsMaterials" 
											TransactionId         = "#rowguid#"	
										    TransactionType       = "2"  <!--- production --->
											TransactionSource     = "WarehouseSeries"
											ItemNo                = "#ItemNo#" 
											Mission               = "#get.Mission#" 
											Warehouse             = "#BOMWarehouse.Warehouse#" <!--- takes default location --->											
											TransactionQuantity   = "#toConsume*-1#"
											TransactionUoM        = "#UoM#"																								
											TransactionLocalTime  = "No"
											TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"		
											TransactionTime       = "#timeformat(dte,'HH:MM')#"			
											TransactionBatchNo    = "#batchno#"												
											GLTransactionNo       = "#batchNo#"
											ActionStatus          = "#ActionStatus#"
											WorkOrderId           = "#workorderid#"
											WorkOrderLine         = "#workorderline#"	
											RequirementId         = "#RequirementId#"				
											OrgUnit               = "#line.orgunitimplementer#"
											GLAccountCredit       = "#AccountStock.GLAccount#"
											GLAccountDebit        = "#AccountProduction.GLAccount#">	
											
									</cfif>									
							
							</cfif>											
										
				  </cfoutput>
				  				  
				<cfelse>
				
					   <table align="center">
							<tr><td class="labelmedium" align="center"><font color="FF0000">Attention : No supply warehouse (BOM) could be determined for this workorder</td></tr>
					   </table>
					   <script>
						   Prosis.busy('no')
					   </script>					   
					   <cfabort>
							
				</cfif>
			
			</cfif>
						
			</cftransaction>
			
			</cfif>
			
			<cfif mode eq "Production" or mode eq "Both">
			
			<!--- --->
				<cftransaction>
				
				
					<cfquery name="getBatch" 
						datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT    BatchNo
		                FROM      WarehouseBatch
		                WHERE     BatchId = '#line.workorderlineid#'
						AND       TransactionType = '0'
					</cfquery>
																			
					<cfloop query="getBatch">										
					
					         <!--- remove any sourcing made on the positive side of the transaction --->
							 <cfquery name="removeValuation" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE FROM ItemTransactionValuation
									WHERE  TransactionId IN (SELECT TransactionId 
									                         FROM   ItemTransaction 
															 WHERE  TransactionBatchNo = '#batchno#')	
																																																						
							 </cfquery>			
							
							 <!--- redo this --->
								
							  <cfquery name="clearTransactions" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE FROM Materials.dbo.ItemTransaction
									WHERE  TransactionBatchNo = '#batchno#'								
							  </cfquery>	
							  
							  <!--- 12/10/2016 
							  we also delete service postings that are related to 
							  this transaction --->
							  
							   <cfquery name="clearTransactions" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									DELETE FROM Accounting.dbo.TransactionHeader
									WHERE  TransactionSource   = 'WorkOrderSeries'
									AND    TransactionSourceNo = '#batchno#'								
							  </cfquery>	
							  																								
					
					</cfloop>	
										
					<!--- -------------- --->
					<!--- produced items --->
					<!--- -------------- --->
								
					<cfquery name="ItemProduced" 
						datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    WOL.WorkorderItemId as RequirementId,
								  WOL.WorkOrderId,
								  WOL.WorkOrderLine,   
								  I.ItemNo, 
								  I.ItemDescription,
								  U.UoM, 
								  I.Category,					
								  U.UoMDescription, 
								  WOL.Warehouse,
								  WOL.TransactionLot,
								  WOL.Quantity, 
								  WOL.Currency, 
								  WOL.SalePrice, 
								  WOL.SaleAmountIncome, 
								  WOL.Created
						FROM      Workorder.dbo.WorkOrderLineItem WOL 
						          INNER JOIN Item I ON WOL.ItemNo = I.ItemNo 
								  INNER JOIN ItemUoM U ON WOL.ItemNo = U.ItemNo AND WOL.UoM = U.UoM
						WHERE     WorkOrderId   = '#workorderid#' 
						AND       WorkOrderLine = '#workorderline#'
						AND       Warehouse is not NULL				
						ORDER BY  Warehouse,TransactionLot						
					</cfquery>							
								
					<cfoutput query="ItemProduced" group="Warehouse">
								
						<cfoutput group="TransactionLot">
						
							<cfquery name="Warehouse" 
							   datasource="AppsMaterials" 
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT   *
							   FROM     Warehouse
							   WHERE    Warehouse = '#warehouse#'
							   AND      LocationReceipt IN (SELECT Location
							                                FROM   WarehouseLocation 
															WHERE  Warehouse = '#warehouse#')
							</cfquery>
							
							<cfif Warehouse.LocationReceipt eq "">
								   
								   <table align="center">
								   	<tr><td class="labelmedium" align="center"><font color="FF0000">Attention : #Warehouse.WarehouseName# receipt location is not configured.</td></tr>
								   </table>		
								   
								   <script>
								   	Prosis.busy('no')
								   </script>						     
								   
								   <cfabort>
								   
							<cfelse>
							
								<cfset loc = Warehouse.LocationReceipt>	   
								
							</cfif>
							
							<cfquery name="check" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  * 
								FROM    WarehouseBatch 
								WHERE   BatchId         = '#Line.WorkOrderLineId#'
								AND     Warehouse       = '#warehouse#'
								AND     TransactionLot  = '#TransactionLot#'		
								AND     TransactionType = '0'			
							</cfquery>
							
							<cfif check.recordcount eq "1">
							
								<cfset batchno = check.BatchNo>						
														
							<cfelse>
									
								<cfquery name="Parameter" 
								   datasource="AppsMaterials" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								   SELECT   TOP 1 *
								   FROM     WarehouseBatch
								   ORDER BY BatchNo DESC
								</cfquery>
								
								<cfif Parameter.recordcount eq "0">
									<cfset batchNo = 10000>
								<cfelse>
									<cfset BatchNo = Parameter.BatchNo+1>
									<cfif BatchNo lt 10000>
									     <cfset BatchNo = 10000+BatchNo>
									</cfif>
								</cfif>	
								
								<cfinvoke component = "Service.Process.Materials.Lot"  
									   method                 = "addlot" 
									   datasource             = "AppsMaterials"
									   mission                = "#get.Mission#" 
									   transactionlot         = "#TransactionLot#"
									   TransactionLotDate     = "#dateFormat(now(), CLIENT.DateFormatShow)#"
									   OrgUnitVendor          = ""
									   returnvariable         = "result">			
																	
								<cfquery name="Insert" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									INSERT INTO WarehouseBatch
										    (Mission,
											 Warehouse, 
											 BatchWarehouse,
											 TransactionLot,		
											 BatchReference,		
											 BatchClass,
										 	 BatchNo, 	
											 BatchId,
											 BatchDescription,						
											 TransactionDate,
											 TransactionType, 					
											 ActionStatus,
											 OfficerUserId, 
											 OfficerLastName, 
											 OfficerFirstName)
								VALUES 	   ('#get.mission#',
									        '#warehouse#',
											'#warehouse#',
											'#TransactionLot#',		
											'WorkOrder Production',
											'Production',
											'#batchNo#',	
											'#Line.WorkOrderLineId#',
											'Production',										
											'#line.DateEffective#',
											'0',					
											'#ActionStatus#',
											'#SESSION.acc#',
											'#SESSION.last#',
											'#SESSION.first#')
								</cfquery>					
								
							</cfif>	
						
							<cfoutput>
							
								<!--- link with ledger --->
				
							 	<cfquery name="AccountStock"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT  GLAccount
										FROM    Ref_CategoryGLedger
										WHERE   Category = '#Category#' 
										AND     Area     = 'Stock'
										AND     GLAccount IN (SELECT GLAccount 
										                      FROM   Accounting.dbo.Ref_Account)
								</cfquery>	
								
								<cfquery name="AccountProduction" 
									datasource="AppsMaterials"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									   SELECT * 
									   FROM   Workorder.dbo.WorkorderGLedger 
									   WHERE  WorkorderId   = '#workorderid#'		
									   AND    Area          = 'Production'
									   AND    GLAccount IN (SELECT GLAccount 
									                        FROM   Accounting.dbo.Ref_Account)	  
								</cfquery>   
								
								<cfif AccountProduction.GLAccount eq "">
								
									<!--- then we defined the default income account for the production based on the category --->
												
									<cfquery name="AccountProduction"
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
										    SELECT  GLAccount
											FROM    Ref_CategoryGLedger
											WHERE   Category = '#Category#' 
											AND     Area     = 'Production'
											AND     GLAccount IN (SELECT GLAccount 
											                      FROM   Accounting.dbo.Ref_Account)
									</cfquery>	
								
								</cfif>
								
								<cfif AccountProduction.GLAccount eq "" or AccountStock.GLAccount eq "">
								   
								   <table align="center">
								   	    <tr>
										   <td class="labelit" align="center"><font color="FF0000">Attention : GL Account for stock and/or workorder production has not been defined yet</td>
										</tr>
								   </table>
								   <cfabort>
								
								</cfif>
								
								<cfset prc = SaleAmountIncome/Quantity>
								<cfset cur = Currency>
								<cfset dte = Line.dateEffective>								
																
								<!--- receipt location --->
								
								<cf_assignId>		
														
								<cf_StockTransact 
							    DataSource            = "AppsMaterials" 
								TransactionId         = "#rowguid#"	
							    TransactionType       = "0"  <!--- production --->
								TransactionSource     = "WorkorderSeries"
								ItemNo                = "#ItemNo#" 
								Mission               = "#get.Mission#" 
								Warehouse             = "#Warehouse#" 
								TransactionLot        = "#TransactionLot#" 		
										
								Location              = "#Loc#"		
											
								TransactionCurrency   = "#cur#"
								TransactionCostPrice  = "#prc#"
										
								TransactionQuantity   = "#Quantity#"
								TransactionUoM        = "#UoM#"						
								ReceiptCurrency       = "#cur#"					
								ReceiptPrice          = "#prc#"
								ReceiptCostPrice      = "#prc#"
								
								TransactionLocalTime  = "No"
								TransactionDate       = "#dateformat(dte,CLIENT.DateFormatShow)#"					
								TransactionBatchNo    = "#batchno#"												
								GLTransactionNo       = "#batchNo#"
								ActionStatus          = "#ActionStatus#"
								WorkOrderId           = "#workorderid#"
								WorkOrderLine         = "#workorderline#"	
								RequirementId         = "#RequirementId#"				
								OrgUnit               = "#line.orgunitimplementer#"
								GLAccountDebit        = "#AccountStock.GLAccount#"
								GLAccountCredit       = "#AccountProduction.GLAccount#">
											
							</cfoutput>
					
						</cfoutput>
				
					</cfoutput>		
					
					<!--- once this is completed we make a service booking for the service items involved
					in the production as part of the BOM 
					r: 10-14-2016, to post the Services (labour) and the Indirect Costs of production (GIF)
					Production 
					a/ coming from: Materials.dbo.Ref_CategoryGledger.Area="COGS"
					
					--->
					
				<cfquery name="ServicesIndCosts"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     	   WL.DateEffective, 
									   W.Reference, 
									   WL.WorkOrderLineId, 
									   WLR.ResourceItemNo, 
									   WLR.ResourceUoM, 
									   I.ItemDescription, 
									   WL.OrgUnitImplementer, 
					        	       R.GLAccount AS ProvisionAccount, 									
									   WL.Reference as Phase,
									   ROUND(SUM(WLR.Amount),2) AS Total
									
						FROM           WorkOrder.dbo.WorkOrder AS W 
							
							INNER JOIN 	WorkOrder.dbo.ServiceItem AS si ON SI.Code = W.ServiceItem 
							INNER JOIN 	WorkOrder.dbo.WorkOrderLine AS WL ON WL.WorkOrderId = W.WorkOrderId 
							INNER JOIN	WorkOrder.dbo.WorkOrderLineResource AS WLR ON wlr.WorkOrderId = wl.WorkOrderId AND WLR.WorkOrderLine = WL.WorkOrderLine 
							INNER JOIN 	Materials.dbo.Item AS I ON i.ItemNo = WLR.ResourceItemNo  
							INNER JOIN	Materials.dbo.Ref_CategoryGledger AS R ON I.Category = R.Category AND R.Area = 'COGS'
							
						WHERE          W.WorkOrderId    = '#workorderId#'
						AND			   WL.WorkOrderLine = '#workOrderLine#'
						AND            I.ItemClass      = 'Service'
						
						GROUP BY 	   WL.WorkOrderLineId,
						               WL.DateEffective, 									 
									   W.Reference, 									
  									   WLR.ResourceItemNo, 
									   WLR.ResourceUoM, 
									   I.ItemDescription, 
									   WL.OrgUnitImplementer, 
						        	   R.GLAccount, 
									  WL.Reference
				</cfquery>
								
				<cfquery name="getJournal"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM	Accounting.dbo.Journal
						WHERE 	Mission 		= '#get.Mission#'
						AND		SystemJournal 	= 'Services'
						AND		Currency		= '#get.Currency#'						
				</cfquery>
				
				<cfif getJournal.recordCount lte 0>
					<cf_message message = "No Services Journal is configured currency #ServicesIndCosts.Currency# and Mission #ServicesIndCosts.Mission#"
						return  = "no">
				     <cfabort>	
				</cfif>
				
				<cfset thisOwner 	 =  "0">
				<cfset thisJournal 	 =  getJournal.Journal>
				<cfset thisDesc 	 =  "Distribution">
				<cfset thisTransCat  =  "Inventory">
				
				<cfloop query = "ServicesIndCosts" group ="workOrderLineId">	
				
					<cf_GledgerEntryHeader
				    		DataSource            = "AppsMaterials"
							Mission               = "#get.Mission#"
							OrgUnitOwner          = "#thisOwner#"
							Journal               = "#thisJournal#" 
							Description           = "#thisDesc#"
							TransactionSource	  = "WorkOrderSeries"
							TransactionReference  = "WorkOrder Distribution"
							TransactionSourceNo   = "#batchno#"	
							TransactionSourceId   = "#WorkOrderLineId#"
							DocumentDate          = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
							TransactionDate       = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
							TransactionCategory   = "#thisTransCat#"							
							ActionStatus          = "1"
							MatchingRequired	  = "1"
							Reference             = "WorkOrder"       
							ReferenceName         = "#ResourceItemNo# #ItemDescription#"
							ReferenceId			  = "#WorkOrderLineId#"
							DocumentCurrency      = "#get.Currency#"					
							DocumentAmount        = "0">
							
							<cfquery dbtype="query" name="getItem">
								SELECT * FROM ServicesIndCosts WHERE  WorkOrderLineId = '#ServicesIndCosts.WorkOrderLineId#'
							</cfquery>
							<cfset total 		= getItem.recordCount >
							<cfset totalDebit 	= 0>
							<cfset thisLine		= 1>
							
							<cfloop query="getItem">
								<cf_GledgerEntryLine
							    DataSource            = "AppsMaterials"
								Lines                 = "1"
								DocumentDate	 	  = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
								Journal               = "#ThisJournal#"
								JournalNo             = "#JournalTransactionNo#"
								Currency              = "#get.Currency#"	
								TransactionDate 	  = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
							
								TransactionSerialNo1  = "#thisLine#"
									Class1                = "Credit"
									Reference1            = "Warehouse"  
									Memo1				  = "CostDistribution"
									WorkOrderLineId1	  = "#WorkOrderLineId#"  
									ReferenceId1	  	  = "#WorkOrderLineId#"
									ReferenceName1		  = "#ItemDescription#"   
									ReferenceNo1		  = "#ResourceItemNo#"   
									Description1          = "Distribution"
									GLAccount1            = "#ProvisionAccount#"
									Costcenter1           = "#OrgUnitImplementer#"						
									TransactionType1      = "Standard"
									Amount1               = "#getItem.Total#">
									
								<cfset totalDebit		=	totalDebit + getItem.Total>
								<cfset thisLine			= 	thisLine + 1>
								
							</cfloop>
							
							<!----against the Debit Account, this would be the Production Account ---->
							
							<cf_GledgerEntryLine
							    DataSource            = "AppsMaterials"
								Lines                 = "1"
								DocumentDate	 	  = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
								Journal               = "#ThisJournal#"
								JournalNo             = "#JournalTransactionNo#"
								Currency              = "#get.Currency#"	
								TransactionDate 	  = "#DateFormat(DateEffective, CLIENT.DateFormatShow)#"
							
									TransactionSerialNo1  = "#thisLine#"
									Class1                = "Debit"
									Reference1            = "Warehouse"   
									Memo1				  = "CostDistribution"  
									WorkOrderLineId1	  = "#WorkOrderLineId#"    
									ReferenceId1	  	  = "#WorkOrderLineId#"
									ReferenceName1		  = "#ItemDescription#"   
									ReferenceNo1		  = "#ResourceItemNo#"   
									Description1          = "Distribution"
									GLAccount1            = "#AccountProduction.GLAccount#"
									Costcenter1           = "#OrgUnitImplementer#"						
									TransactionType1      = "Standard"
									Amount1               = "#TotalDebit#">		

					</cfloop>				
					
					<!--- --->
										
				</cftransaction>					
				
			
			</cfif>
						
			<!--- now we trigger a sourcing for any issuance transactions that might have been orphaned for
			its valudation through the above like line 1303 --->
						
			<cfinvoke component = "Service.Process.Materials.Stock"  
			   method           = "RedoIssuanceTransaction" 
			   filtermission    = "#get.Mission#">	   				
				
	</cffunction>
	
	<cffunction name="getWorkOrderProduction"
         access="public"
         returntype="any"
         displayname="Generate stock transactions for a production workorder">
		 
		 <cfargument name="Mission"              type="string" required="true">
		 <cfargument name="OrgUnitImplementer"   type="string" required="true">
		 <cfargument name="WorkOrderYear"        type="string" required="true" default="2017">
   		 <cfargument name="WorkOrderMonth"       type="string" required="true" default="">		 		 
		 <cfargument name="Table"                type="string" required="false" default="">		
						
			
			<cfquery name="getData" 
				datasource="AppsWorkOrder"				 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				
				SELECT        ServiceDomainClass, 
				              OrgUnitImplementer, 
							  OrgUnitName, 
							  HierarchyCode, 
							  WorkOrderYear, 
							  <cfif WorkOrderMonth neq "">
								  WorkOrderMonth, 
							  </cfif>
							  ItemDescription, 
							  UoMDescription, 
							  ItemBarCode, 		
							  Category,					  
			                  SUM(Quantity) AS Quantity, 							 					  
							  ROUND(SUM(CategoryAmount), 2) AS BOMValue							  
							  
				INTO         UserQuery.dbo.#table#
									  
				FROM          (SELECT        TOP (100) PERCENT WLI.WorkOrderItemId, 
				                             WL.ServiceDomainClass, 
											 WL.OrgUnitImplementer, 
											 O.OrgUnitName, 
											 O.HierarchyCode, 
			                                 YEAR(WL.DateEffective)  AS WorkOrderYear,
											 <cfif WorkOrderMonth neq ""> 
											 MONTH(WL.DateEffective) AS WorkOrderMonth, 
											 </cfif>
											 Item.ItemDescription, 
											 UoM.UoMDescription, 
				                             UoM.ItemBarCode, 
											 WLI.Quantity, 											 								 																				  											
											 BOM.Category,
											 WLIR.Amount as CategoryAmount		
																				  
				                FROM         WorkOrderLineItem AS WLI INNER JOIN
			                                 WorkOrderLine AS WL ON WLI.WorkOrderId = WL.WorkOrderId AND WLI.WorkOrderLine = WL.WorkOrderLine INNER JOIN
			                                 WorkOrder AS W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
											 Ref_ServiceItemDomainClass AS SD ON WL.ServiceDomain = SD.ServiceDomain AND WL.ServiceDomainClass = SD.Code INNER JOIN
			                                 Organization.dbo.Organization AS O ON WL.OrgUnitImplementer = O.OrgUnit INNER JOIN
			                                 Materials.dbo.Item AS Item ON WLI.ItemNo = Item.ItemNo INNER JOIN
			                                 Materials.dbo.ItemUoM AS UoM ON WLI.ItemNo = UoM.ItemNo AND WLI.UoM = UoM.UoM INNER JOIN
											 WorkOrderLineItemResource WLIR ON WLIR.WorkOrderItemId = WLI.WorkOrderItemId INNER JOIN
											 Materials.dbo.Item as BOM ON WLIR.ResourceItemNo = BOM.ItemNo
											 
			                    WHERE        W.Mission              = '#Mission#' 
								AND          SD.ServiceType         = 'Produce'
								AND          WL.OrgUnitImplementer  = '#OrgUnitImplementer#'
								AND          YEAR(WL.DateEffective) = '#WorkOrderYear#' 
								AND          WL.Operational         = 1 
								AND          WL.ActionStatus        <> '9' 
								AND          W.ActionStatus         <> '9' 
								AND          WLI.ActionStatus       <> '9') AS Sub
			
				GROUP BY     OrgUnitImplementer, 
				             OrgUnitName, 
							 HierarchyCode, 
							 ServiceDomainClass, 
							 WorkOrderYear, 
							 <cfif WorkOrderMonth neq "">
							 WorkOrderMonth, 
							 </cfif>
							 ItemDescription, 
							 UoMDescription, 
							 ItemBarCode,
							 Category
				
				ORDER BY ServiceDomainClass, 
				         OrgUnitImplementer, OrgUnitName, HierarchyCode, 
						 WorkOrderYear
					     <cfif WorkOrderMonth neq "">, WorkOrderMonth</cfif>	
			
			</cfquery>		 		 
		 
	</cffunction>	 
			
</cfcomponent>	
