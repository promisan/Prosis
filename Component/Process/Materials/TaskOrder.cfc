
<cfcomponent>
	
	<cffunction name = "RequestPurchase" returnType = "string">
	
		<cfargument name="mission"    type="string" required="false" default="">	
		<cfargument name="warehouse"  type="string" required="false" default="">	
		<cfargument name="select"     type="string" required="false" default="">		
	
		<!--- pass the query for external taskorder requests --->
		
		<cfoutput>
		
			<cfsavecontent variable = "qQuery">
			
					  	SELECT      #select#
						FROM        RequestHeader H 
									INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
									INNER JOIN RequestTask RT ON R.RequestId = RT.RequestId 
									
								 
		 				WHERE        H.Mission        = '#mission#' 
						AND          H.ActionStatus IN ('2p', '3','5')  	
						
						<!--- this is in the mian query removed 16/6
						AND          RT.SourceWarehouse = '#warehouse#'
						--->
						
						AND          R.Status IN ('1','2','3') 			
						AND          R.RequestType IN ('Regular','TaskOrder')	
						
						<!--- links to the stockorder id of the parent query --->					
						AND          RT.StockOrderid  = T.StockOrderId						
						AND          RT.RecordStatus != '9'
						AND          RT.TaskType      = 'Purchase'																		
						
			</cfsavecontent>
			
		</cfoutput>
	
		<cfreturn qQuery>
		
	</cffunction>
		
	
	<cffunction name = "RequestInternal" returnType = "string">
	
		<cfargument name="mission"    type="string" required="false" default="">	
		<cfargument name="warehouse"  type="string" required="false" default="">	
		<cfargument name="select"     type="string" required="false" default="">		
		
		<!--- pass the query for internal taskorder requests --->
		
		<cfoutput>
		
		<cfsavecontent variable = "qQuery">
		
				  	SELECT      #select#
					FROM        RequestHeader H 
								INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
								INNER JOIN RequestTask RT ON R.RequestId = RT.RequestId 

					WHERE       H.Mission  = '#mission#'  					    
					AND         H.ActionStatus IN ('2p','3','5')  
					
					<!--- this is in the mian query removed 16/6
					AND         RT.SourceWarehouse = '#warehouse#'
					--->
					
					AND         R.Status IN ('1','2','3') 
					AND         R.RequestType IN ('Regular','TaskOrder')	
					
					AND         RT.RecordStatus != '9'
					<!--- links to the stockorder id of the parent query --->
					AND         RT.StockOrderid = T.StockOrderId					
					AND         RT.TaskType     = 'Internal' 					
					
		</cfsavecontent>
		</cfoutput>
	
		<cfreturn qQuery>
		
	</cffunction>
	
	
	<cffunction name = "Restrictions" returnType = "string">
	
		<cfargument name="mission"    type="string" required="false" default="">	
		<cfargument name="warehouse"  type="string" required="false" default="">	
		<cfargument name="tasktype"   type="string" required="false" default="">	
		<cfargument name="sta"        type="string" required="false" default="">		
	
		<cfif tasktype eq "purchase">
		
			<cfset getDetails = RequestPurchase(mission,warehouse,"'X'")/>			
			
		<cfelse>
		
			<cfset getDetails = RequestInternal(mission,warehouse,"'X'")/>				
			
		</cfif>
		
		<cfoutput>
		
		<cfswitch expression = "#sta#">
		
			<cfcase value = "0">
			
			<!--- Pending --->
				<cfsavecontent variable = "cStatus">
				
						<!--- has not receipt recorded against any of its lines --->	
						AND NOT EXISTS
						(
							#getDetails#
							<!--- show be 0 ? hanno --->
							AND    RT.DeliveryStatus != '0'					
							AND    RT.RecordStatus   != '9'
						)
				</cfsavecontent>
		
			</cfcase>		
			
			<cfcase value = "0p">
			
			<!--- Pending --->
				<cfsavecontent variable = "cStatus">
				
						<!--- has not receipt recorded against any of its lines --->	
						AND NOT EXISTS
						(
							#getDetails#
							<!--- show be 0 ? hanno --->
							AND    RT.DeliveryStatus != '0'					
							AND    RT.RecordStatus   != '9'
						)
				</cfsavecontent>
		
			</cfcase>		
				
			<cfcase value = "1">
			

				<!--- Partial --->
				<cfsavecontent variable = "cStatus">
						<!--- has not receipt recorded against any of its lines --->	
						
						AND
						(
						(
						EXISTS
						(
							#getDetails#
							AND    RT.DeliveryStatus in ('0','1')		
							AND    RT.RecordStatus != '9'								
						)		
						AND EXISTS
						(
							#getDetails#						
							AND    RT.DeliveryStatus = '3'					
							AND    RT.RecordStatus != '9'					
						)
						)
						
						OR
						EXISTS
						(
							#getDetails#
							AND    RT.DeliveryStatus in ('1')					
							AND    RT.RecordStatus != '9'					
						)	
								
						)					
						
						
				</cfsavecontent>
		
			</cfcase>		
		
			<cfcase value="3">
			
				<!--- Completed --->
				<cfsavecontent variable = "cStatus">
					AND NOT EXISTS
					(
						#getDetails#
						AND    RT.DeliveryStatus != '3'
						AND    RT.RecordStatus != '9'									
					)
				</cfsavecontent>	
									
			</cfcase>		
		
			<cfdefaultcase>
			
				<!--- Cancelled --->
				<cfsavecontent variable = "cStatus">
					AND EXISTS
					(
						#getDetails#
						AND    RT.RecordStatus = '9'						
					)
				</cfsavecontent>					
				
			</cfdefaultcase>
			
		</cfswitch>
	
		</cfoutput>
		
		<cfreturn cStatus>
	
	</cffunction>
	
	
	<cffunction name="CountStatus" returnType="any" output="true">
	
		<cfargument name="mode"        type="string" required="true"  default="listing">	
		<cfargument name="mission"     type="string" required="false" default="">	
		<cfargument name="tasktype"    type="string" required="false" default="">	
		<cfargument name="warehouse"   type="string" required="false" default="">			
		<cfargument name="STA"         type="string" required="false" default="">	
		<cfargument name="Shiptomode"  type="string" required="false" default="">		
				
		<cfif STA eq "0">	
		
			<!--- only for status = 0 we show the workflow and get the records of workflow in a table to be shown  --->	
			<cf_wfpending entityCode="WhsTaskOrder"  
		      table="#SESSION.acc#wfTaskOrder" mailfields="No" includeCompleted="No">								  	
			  
		</cfif>	 
						
		<cfif warehouse eq "">
				
			<cfinvoke component = "Service.Access"  
				   method           = "WarehouseAccessList" 
				   mission          = "#url.mission#" 					   					 
				   Role             = "'WhsShip'"
				   accesslevel      = "" 					  
				   returnvariable   = "Access">
					
		<cfelse>
		
			<cfset access = "'#warehouse#'">	 
 		
		</cfif>
		
		<!--- 
		   usage : 
		   Listing : used to pass info into the standard listing once selected from the shipping tree 
		   Counted : used to show the counted quantity, prior to the listing
		--->
		
		<cfif mode eq "listing">	
		    
			<!--- revoke taskorders without lines found --->
			
			<cfquery name="GetTask" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  
			    UPDATE TaskOrder 
				SET    ActionStatus = '9'
				FROM   Taskorder T	
				WHERE  StockOrderid NOT IN (SELECT StockOrderId
				                            FROM   RequestTask 
										    WHERE  StockOrderId is not NULL)				
			</cfquery>	
		
		</cfif>
			
		<cfoutput>
		
		<cfset cStatus = Restrictions(mission, warehouse, tasktype, sta)> 
		
		<cfif tasktype eq "purchase">
		
			<cfset getDetails = RequestPurchase(mission,warehouse,"COUNT(1)")/>			
			
			<cfsavecontent variable="myquery">
			
				SELECT 	
						<cfif mode eq "listing">
							'#URL.STA#' as Sta,
							T.StockOrderId,
							O.OrgUnit,
							O.OrgUnitName,
							Reference,
							OrderDate,
							DeliveryDate,
							T.Remarks,
							(   
								 #getDetails#
								 AND   RecordStatus != '9'								 						 
							) as TotalLines,							
							(
							    #getDetails#
								AND     RecordStatus != '9'
								AND     DeliveryStatus = '3'
							) 			
							as TotalReceived,
							<cfif sta eq "0">
							ISNULL(V.ActionDescriptionDue,'Shipment') as ActionDescriptionDue,
							</cfif>
							
							(
							SELECT   TOP 1 CASE COUNT(DISTINCT WarehouseName) WHEN 1 THEN SW.WarehouseName ELSE 'Multiple' END
							FROM      RequestTask RT INNER JOIN
					                  Warehouse SW ON RT.ShipToWarehouse = SW.Warehouse
							WHERE     RT.StockOrderId = T.StockOrderId
							GROUP BY  SW.WarehouseName ) as Destination,
																				
							T.OfficerLastName,
							T.OfficerFirstName,
							T.Created
							
						<cfelse>
						
							COUNT(*) as Total	
							
						</cfif>	
						
				FROM    TaskOrder T 
				
				        <cfif Mode eq "Listing">			
				            LEFT OUTER JOIN Organization.dbo.Organization O ON O.OrgUnit = T.OrgUnit								       
						</cfif>
						
						<cfif STA eq "0">
							   <!--- the workflow only returns pending tracks --->
			        		   INNER JOIN userquery.dbo.#SESSION.acc#wfTaskOrder V ON ObjectkeyValue4 = T.StockOrderId	
						</cfif>
							
				WHERE 	T.Mission    = '#Mission#'
				
				--Condition
				
				<cfif warehouse neq "">
				
				<!--- limit access to only valid stockorders to be shown for the external receipt warehouse --->
				
				AND    T.StockOrderId IN (SELECT StockOrderId
				                          FROM   RequestTask RT, Request R
										  WHERE  RT.RequestId        = R.RequestId
										  AND    RT.StockOrderId     = T.StockOrderId
										  <!--- this is the request warehouse --->
										  AND    R.Warehouse         IN (#preservesingleQuotes(access)#)
										  AND    RT.RecordStatus    != '9')
				</cfif>
				
				AND     T.TaskType   = '#tasktype#'		
								
				AND     T.ActionStatus != '8' <!--- we never show , this can be revisted in due course 18/6/2013 --->
				
				<cfif sta eq "0p">
				<!--- was completed workflow --->
				AND     T.StockOrderId NOT IN (SELECT ObjectKeyValue4 FROM userquery.dbo.#SESSION.acc#wfTaskOrder V WHERE ObjectkeyValue4 = T.StockOrderId)	 				
				</cfif>
				
				<cfif ShipToMode neq "">
					AND T.StockOrderId IN (SELECT StockOrderId 
					                       FROM   RequestTask  
										   WHERE  StockOrderId = T.StockOrderId 
										   AND    ShipToMode = '#ShipToMode#') 
				</cfif>	
			
			
			    <cfif sta neq "">
			    <!--- ------------------------------------------------------------------------------------------------------- --->
			    <!--- this is an additional condition to show tasks that meet a certain requirement for pending, partial etc. --->			
				#cStatus#			
				<!--- ------------------------------------------------------------------------------------------------------- --->
				</cfif>
				
			</cfsavecontent>
		
		<cfelse>		
		
			<cfset getDetails = RequestInternal(mission,warehouse,"COUNT(1)")/>			
			
			<cfsavecontent variable="myquery">
			
				SELECT 
					<cfif mode eq "listing">
					    W.WarehouseName,
						W.City,
						T.StockOrderId,
						O.Description,
						O.StorageCode,
						Reference,
						OrderDate,
						DeliveryDate,
						T.Remarks,
						(   
							 #getDetails#
							 AND   RecordStatus != '9'
							 
						) as TotalLines,
						
						(
							#getDetails#
							AND     RecordStatus != '9'
							AND     DeliveryStatus = '3'
						) 			
						as TotalReceived,
						<cfif sta eq "0">
						ISNULL(V.ActionDescriptionDue,'Shipment') as ActionDescriptionDue,
						</cfif>
						
						(   SELECT  TOP 1  CASE COUNT(DISTINCT WarehouseName) WHEN 1 THEN SW.WarehouseName ELSE 'Multiple' END
							FROM      RequestTask RT INNER JOIN
					                  Warehouse SW ON RT.ShipToWarehouse = SW.Warehouse
							WHERE     RT.StockOrderId = T.StockOrderId
							GROUP BY  SW.WarehouseName ) as Destination,
						
						T.OfficerLastName,
						T.OfficerFirstName,
						T.Created
					<cfelse>
						COUNT(*) as total	
					</cfif>	
						
				FROM    TaskOrder T INNER JOIN Warehouse W ON T.Warehouse = W.Warehouse
				
						<cfif Mode eq "Listing">	
							LEFT OUTER JOIN WarehouseLocation O ON O.Warehouse  = T.Warehouse AND O.Location = T.Location
						</cfif>
						
						<cfif sta eq "0">
							<!--- the workflow only returns pending tracks --->
		    	    		INNER JOIN userquery.dbo.#SESSION.acc#wfTaskOrder V ON ObjectkeyValue4 = T.StockOrderId																		
						</cfif>
				
				WHERE 	T.Mission       = '#Mission#'					
				AND     T.TaskType      = '#tasktype#'
				
				<cfif sta eq "9">
				
					AND     T.ActionStatus IN ('8','9')				
					AND     T.Warehouse IN (#preservesingleQuotes(access)#)	
					
				<cfelse>
				
					AND     T.ActionStatus != '8'		
					
					<cfif warehouse neq "">
					
						<!--- limit access to only valid stockorders to be shown --->
						
						AND    T.StockOrderId IN (
						                          SELECT StockOrderId
						                          FROM   RequestTask RT, Request R
												  WHERE  RT.RequestId        = R.RequestId
												  AND    RT.StockOrderId     = T.StockOrderId
												  AND    RT.SourceWarehouse  IN (#preservesingleQuotes(access)#) 
												  AND    RT.RecordStatus != '9'
						                         )
					</cfif>				
						
				</cfif>
				
				--Condition
				
				<cfif sta eq "0p">
				<!--- was completed workflow --->
				AND     T.StockOrderId NOT IN (SELECT ObjectKeyValue4 FROM userquery.dbo.#SESSION.acc#wfTaskOrder V WHERE ObjectkeyValue4 = T.StockOrderId)	 				
				</cfif>							
				
				<!--- additional filter --->
				
				<cfif ShipToMode neq "">
					AND T.StockOrderId IN (SELECT StockOrderId
					                       FROM   RequestTask 
										   WHERE  StockOrderId = T.StockOrderId
										   AND    ShipToMode   = '#ShipToMode#') 
				</cfif>	
				
				<cfif sta neq "" and sta neq "9">
				#cStatus# 
				</cfif>
				
			</cfsavecontent>
		
		</cfif>
		</cfoutput>
	
		<cfif mode eq "listing">
		
		 	<cfreturn myQuery>	
			
		<cfelse>
		
			<cfquery name  = "qQuery" 
			    datasource = "AppsMaterials"  
		        username   = "#SESSION.login#" 
		        password   = "#SESSION.dbpw#">								
				 #PreserveSingleQuotes(myQuery)#						  
			</cfquery>			
									
			<cfreturn qQuery.Total>		
						
		</cfif>		
		
	</cffunction>
	
	<!--- 
	
	<cffunction name="getSummary" returnType="query" output="false">
			
		<cfargument name="mission"      type="string" required="false" default="">	
		<cfargument name="warehouse"    type="string" required="false" default="">
		
		<cfquery name ="qTotals" datasource = "AppsMaterials">
			SELECT 'Purchase', 
			<cfloop index="F" list="0,1,3,9">
				(
					SELECT  COUNT(*)
					FROM    TaskOrder T 
					WHERE 	T.Mission       = '#Mission#'					
					AND     T.TaskType      = 'Purchase'
					AND     T.ActionStatus != '8'			
					#Restrictions(mission, warehouse, 'Purchase', F)#
					AND     T.StockOrderId IN (SELECT StockOrderId
				                          FROM   RequestTask RT, Request R
										  WHERE  RT.RequestId    = R.RequestId
										  AND    RT.StockOrderId = T.StockOrderId
										  AND    RT.SourceWarehouse   = '#warehouse#' 
										  AND    RT.RecordStatus != '9')
				)
				as STA_#F#, 
			</cfloop>
			1
			
			UNION
			
			SELECT 'Internal', 
			<cfloop index="F" list="0,1,3,9">
				(
					SELECT COUNT(*)
					FROM TaskOrder T 
					WHERE 	T.Mission       = '#Mission#'					
					AND     T.TaskType      = 'Internal'
					AND     T.ActionStatus != '8'			
					#Restrictions(mission, warehouse, 'Internal', F)#
					AND    T.StockOrderId IN (
					                          SELECT StockOrderId
					                          FROM   RequestTask RT, Request R
											  WHERE  RT.RequestId     = R.RequestId
											  AND    RT.StockOrderId  = T.StockOrderId
											  AND    RT.SourceWarehouse  = '#warehouse#'
											  AND    RT.RecordStatus != '9'
					                         )			
				)
				as STA_#F#, 
			</cfloop>
			1

		</cfquery>
	
		<cfreturn qTotals>
	
	</cffunction>
	
	--->
	
	
	<cffunction name="TaskorderList" returnType="query" output="true">
	
		<cfargument name="mission"      type="string" required="false"  default="">	
		<cfargument name="warehouse"    type="string" required="false" default="">
		<cfargument name="tasktype"     type="string" required="false" default="">				
		<cfargument name="mode"         type="string" required="false" default="">	
		<cfargument name="stockorderid" type="string" required="false" default="">	
		<cfargument name="selected"     type="string" required="false" default="">			
		<cfargument name="search"       type="string" required="false" default="">	
		<cfargument name="shiptodate"   type="string" required="false" default="">	
		<cfargument name="shiptomode"   type="string" required="false" default="">	
		<cfargument name="deliverydate" type="string" required="false" default="">	
				
		<!--- --------------------------------------------- --->
		<!--- this is a detail list of lines for processing --->
		<!--- --------------------------------------------- --->
						
		<cfquery name="getWarehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Warehouse
		   WHERE     Warehouse = '#warehouse#'  
		</cfquery>
		
		<cfif mission eq "">
		 <cfset mission = getWarehouse.Mission>
		</cfif>
				
		<cfquery name="param" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_ParameterMission
		   WHERE     Mission = '#mission#'  
		</cfquery>
		
		<cfset diff = (100+param.taskorderdifference)/100>  
			
			<cfif tasktype eq "Purchase">
			
				<cfquery name="getTask" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  	  
				  	SELECT   O.OrgUnitName, 
				             H.Contact, 
							 H.DateDue, 
							 H.RequestHeaderId,
							 H.Reference, 
							 H.RequestType,
							 RT.Description as RequestTypeName,
							 RT.StockOrderMode,
							 R.Warehouse,
							 R.RequestDate, 
							 R.ItemNo, 
							 I.ItemDescription, 
							 I.Category,
							 I.ItemPrecision,
							 I.ItemShipmentMode,
							 R.UoM, 
							 U.UoMDescription, 
							 R.RequestedQuantity,            
							 W.WarehouseName,			 	
							 T.TaskQuantity, 
							 							 
							 (SELECT ISNULL(SUM(TransactionQuantity),0)
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo											
								 AND     TransactionQuantity > 0													 
								 AND     ActionStatus != '9') as Receipt,							 
								 
							 (SELECT ISNULL(SUM(TransactionQuantity),0)
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo											
								 AND     TransactionQuantity > 0													 
								 AND     ActionStatus = '0') as PendingConfirmation,					 
							 
							 T.ShipToDate, 
							 
							 (SELECT DeliveryDate 
							  FROM   Taskorder 
							  WHERE  StockOrderId = T.StockorderId) as DeliveryDate,	
							  
							 T.SourceRequisitionNo,
							 T.ShipToWarehouse, 
							 W.WarehouseName as ShipToWarehouseName,					
							 T.RequestId,
							 T.TaskSerialNo,
							 T.RecordStatus,
							 T.RecordStatusDate,
							 T.RecordStatusOfficer,
							 T.DeliveryStatus,
							 T.TaskId,		
							 T.TaskUoM,
							 T.TaskUoMQuantity,
							 T.ShipToMode,
							 PL.PurchaseNo,
							 P.OrgUnitVendor,
							 (SELECT OrgUnitName 
							  FROM   Organization.dbo.Organization 
							  WHERE  OrgUnit = P.OrgUnitvendor) as Vendor,	 			
							 T.Created as TaskedOn,
							 T.OfficerLastName as TaskedBy
							 
					FROM     RequestHeader H INNER JOIN
				             Request R                       ON H.Mission = R.Mission AND H.Reference = R.Reference INNER JOIN
				             RequestTask T                   ON R.RequestId = T.RequestId INNER JOIN
				             Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
				             ItemUoM U                       ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM INNER JOIN
				             Item I                          ON R.ItemNo = I.ItemNo INNER JOIN
							 Warehouse W                     ON T.ShipToWarehouse = W.Warehouse INNER JOIN
							 Purchase.dbo.PurchaseLine PL    ON T.SourceRequisitionNo = PL.RequisitionNo INNER JOIN 
							 Purchase.dbo.Purchase P         ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
							 Ref_Request RT                  ON H.RequestType = RT.Code
							 
					<!--- request header is cleared/tasked/completed --->			 
					WHERE        H.ActionStatus IN ('2p','3','5')  		
					

					
					<cfif mode eq "Pending">
						
							<!--- added 13/8 to show the pending for receipt or pending for conformation transactions --->
							
							<cfif search eq "">
						
							AND     T.SourceWarehouse = '#warehouse#'
							
							<cfelse>
														
							
							AND     (
							          H.Reference LIKE ('%#Search#%') 
							            OR T.StockorderId IN (SELECT StockorderId FROM TaskOrder WHERE Reference LIKE ('%#Search#%'))
									)
							
							</cfif>
							
							AND     T.TaskQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
							                             FROM    ItemTransaction S
										 			     WHERE   RequestId    = T.RequestId									
														 AND     TaskSerialNo = T.TaskSerialNo
														 
														 AND     ( TransactionId IN (SELECT TransactionId 
									                    					         FROM   ItemTransactionShipping
																				     WHERE  TransactionId = S.TransactionId
																				     AND    ActionStatus = 1) 	
																				   
																	OR ActionStatus = '1'			   
																 )				   							
														 AND     TransactionQuantity > 0													 
														 AND     ActionStatus != '9')
														 
						    AND     RecordStatus <> '3' <!--- manual closing --->
							
							     								 
							
					<cfelseif stockorderid eq "">
					
						AND      T.SourceWarehouse = '#warehouse#'
						<!--- was not planned already, then it is part of the listing --->	
						AND      (T.StockOrderId is NULL and T.RecordStatus != '3')
					
					<cfelse>
					
						AND      T.StockOrderid = '#stockorderid#'
					
					</cfif>
					
					<cfif selected neq "">
					
						AND      T.TaskId IN (#preservesinglequotes(selected)#)
						
					</cfif>
					
					
					
					<!--- request line itself is not cancelled --->			 
					AND          R.Status IN ('1','2','3') 
					AND          T.RecordStatus != '9'
					<!--- external processing  --->
					AND          T.TaskType = 'Purchase'
					AND          R.Mission  = '#mission#' 
					
					AND          R.RequestType IN ('Regular','TaskOrder')
						
					ORDER BY P.PurchaseNo, ShipToDate, T.ShipToWarehouse
					
				</cfquery>
							
			<cfelse>
			
						
				<cfquery name="getTask" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					 
					 
					  	SELECT   R.Mission,
						         O.OrgUnitName, 
					             H.Contact, 
								 H.DateDue, 
								 H.Reference, 
								 H.RequestHeaderId,
								 R.Warehouse,
								 R.RequestDate, 
								 H.RequestType,
								 RT.Description as RequestTypeName,
								 RT.StockOrderMode,
								 R.ItemNo, 
								 I.ItemDescription, 
								 I.Category,
								 I.ItemPrecision,
								 I.ItemShipmentMode,
								 R.UoM, 
								 U.UoMDescription, 
								 R.RequestedQuantity,            
								 W.WarehouseName,			 	
								 T.TaskQuantity, 
								 
								  (SELECT ISNULL(SUM(TransactionQuantity),0)
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo											
								 AND     TransactionQuantity > 0													 
								 AND     ActionStatus != '9') as Receipt,			
								 
								  (SELECT ISNULL(SUM(TransactionQuantity),0)
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo											
								 AND     TransactionQuantity > 0													 
								 AND     ActionStatus = '0') as PendingConfirmation,						
								 
								 T.ShipToDate, 
								 
								 (SELECT DeliveryDate 
								  FROM   Taskorder 
								  WHERE  StockOrderId = T.StockorderId) as DeliveryDate,
								  
								 T.ShipToWarehouse, 
								 W.WarehouseName as ShipToWarehouseName,					
								 T.RequestId,
								 T.StockOrderId,
								 
								(SELECT  ActionStatus
					              FROM    TaskOrder 
								  WHERE   StockOrderId  = T.StockorderId									
								  ) as StockOrderStatus, 
								 
								 OT.Reference    as TaskOrderReference,
								 OT.ActionStatus as TaskOrderStatus,
								 
								 <!--- receipt stuff --->
								 
								 (SELECT  ISNULL(SUM(TransactionQuantity),0)
					              FROM    ItemTransaction S
								  WHERE   RequestId    = T.RequestId									
								  AND     TaskSerialNo = T.TaskSerialNo	
								  AND     TransactionQuantity > 0
								  <!--- prevent direct issues to bother the total --->			  		
								  AND     ActionStatus != '9') as PickedQuantity, 
								  
								 (SELECT  count(*)
					              FROM    ItemTransaction S
								  WHERE   RequestId    = T.RequestId									
								  AND     TaskSerialNo = T.TaskSerialNo	
								  <!--- prevent direct issues to bother the total --->			  		
								  AND     ActionStatus != '9') as PickedQuantityCount, 								 
								 							  
								  T.TaskSerialNo,
								  T.RecordStatus,
								  T.RecordStatusDate,
								  T.RecordStatusOfficer,
								  T.DeliveryStatus,
								  T.TaskId,		
								  T.TaskUoM,
								  T.TaskUoMQuantity,
								  T.ShipToMode,
								  S.Warehouse        as SourceWarehouse,
								  S.WarehouseName    as SourceWarehouseName,							
								  T.Created          as TaskedOn,
								  T.OfficerLastName  as TaskedBy
								 
						FROM     RequestHeader H 
								 INNER JOIN Request R ON H.Mission = R.Mission AND H.Reference = R.Reference 
								 INNER JOIN RequestTask T ON R.RequestId = T.RequestId 
								 INNER JOIN Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit 
								 INNER JOIN ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM 
								 INNER JOIN Item I ON R.ItemNo = I.ItemNo 
								 INNER JOIN Warehouse W ON T.ShipToWarehouse = W.Warehouse 
								 INNER JOIN Warehouse S ON T.SourceWarehouse = S.Warehouse
								 LEFT OUTER JOIN TaskOrder OT ON OT.StockOrderId = T.StockOrderId
								 INNER JOIN Ref_Request RT  ON H.RequestType = RT.Code
							 
								 
						
						<!--- internal processing --->
						WHERE        T.TaskType = 'Internal' 										
						AND          R.Mission  = '#mission#' 						
						AND          R.RequestType IN ('Regular','TaskOrder')		
												
						<!--- request header is cleared (2p) or tasked (3) or completed (5) --->													
						AND          H.ActionStatus IN ('2p','3','5')  
						
						<!--- request line itself is not cancelled --->			 						
						AND          R.Status IN ('1','2','3') 
						
						<!--- task line itself is not cancelled --->								
						AND          T.RecordStatus != '9'
						
						
						<cfif mode eq "Pending">
												
							<!--- added 13/8 to show the pending for receipt or pending for conformation transactions --->
							
							<cfif search eq "">
						
							AND     T.SourceWarehouse = '#warehouse#'
							
							<cfelse>
							
							
							AND     (
							          H.Reference LIKE ('%#Search#%') 
							            OR T.StockorderId IN (SELECT StockorderId FROM TaskOrder WHERE Reference LIKE ('%#Search#%'))
									)
							
							</cfif>
							
							AND     T.TaskQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
							                             FROM    ItemTransaction S
										 			     WHERE   RequestId    = T.RequestId									
														 AND     TaskSerialNo = T.TaskSerialNo
														 
														 AND     ( TransactionId IN (SELECT TransactionId 
									                    					         FROM   ItemTransactionShipping
																				     WHERE  TransactionId = S.TransactionId
																				     AND    ActionStatus = 1) 	
																				   
																	OR ActionStatus = '1'			   
																 )				   							
														 AND     TransactionQuantity > 0													 
														 AND     ActionStatus != '9')
														 
							 AND     RecordStatus <> '3'	
							 
						<cfelseif mode eq "Confirmation">	
						
						<!--- show only tasklines that are pending to be confirmed --->
						
						AND  T.Requestid IN (
						                    SELECT  S.RequestId
							                FROM    ItemTransaction S
										 	WHERE   RequestId    = T.RequestId									
											AND     TaskSerialNo = T.TaskSerialNo
											AND     ActionStatus = '0'	
											)
													
						<cfelseif stockorderid eq "">
							
							AND     T.SourceWarehouse = '#warehouse#'
							<!--- was not scheduled already, then it is part of the listing --->
							  
							AND     T.StockOrderId is NULL 
							AND     T.RecordStatus = '1'
							
							<!--- unless 8/8/2013 it appears to be shipped which is possible with the direct shipment option --->	
							AND     T.TaskQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
							                             FROM    ItemTransaction S
										 			     WHERE   RequestId    = T.RequestId									
														 AND     TaskSerialNo = T.TaskSerialNo
														 
														 <!---
														 AND     ( TransactionId IN (SELECT TransactionId 
									                    					         FROM   ItemTransactionShipping
																				     WHERE  TransactionId = S.TransactionId
																				     AND    ActionStatus = 1) 	
																				   
																	OR ActionStatus = '1'			   
																 )				   							
																 --->
														 AND     TransactionQuantity > 0													 
														 AND     ActionStatus != '9')
														
						
						<cfelse>
						
							AND     T.StockOrderid = '#stockorderid#'   
						
						</cfif>		
						
						<cfif ShipToMode neq "">
							AND     T.ShipToMode = '#shiptomode#' 
						</cfif>
						
						<cfif shiptodate neq "">												
						    AND     ShipToDate = '#dateformat(ShipToDate,client.dateSQL)#' 
						</cfif>					
						
						
						<cfif deliverydate neq "">												
						    AND     T.StockorderId IN (SELECT  StockOrderId
									                   FROM    TaskOrder 
											  	       WHERE   StockOrderId  = T.StockorderId	
													   AND     DeliveryDate = '#dateformat(DeliveryDate,client.dateSQL)#' )
						</cfif>						
											
						<cfif selected neq "">
						
						    AND     T.TaskId IN (#preservesinglequotes(selected)#)
							
						</cfif>
																		
						ORDER BY T.ShipToMode, 
						         T.SourceWarehouse, 
								 ShipToDate, 
								 OT.Reference, 
								 T.ShipToWarehouse	
						
					</cfquery>
			
			</cfif>	
			
			<cfreturn getTask>
			
	</cffunction>
	
	<cffunction name="CheckCompleted" returnType="numeric" output="true">
	
		<cfargument name="mission"      type="string"   required="false" default="">	
		<cfargument name="tasktype"     type="string"   required="false" default="">	
		<cfargument name="warehouse"    type="string"   required="false" default="">
		<cfargument name="mode"         type="string"   required="false" default="Completed">
		<cfargument name="stockorderid" type="string"   required="false" default="">	
		<cfargument name="selected"     type="string"   required="false" default="">		
	
		<cfset getTask = TaskorderList(mission,warehouse,tasktype,mode,stockorderid,selected)/>		
		
		<cfif getTask.recordcount eq "0">
		
			<cfset i = 0>
		
		<cfelse>
		
			<cfset i = 0>
									
			<cfloop query = "getTask">

			    <!--- count complated --->
				<cfif GetTask.RecordStatus neq "3" and GetTask.DeliveryStatus neq "3">
					<cfset i = i + 1>
				</cfif>
			</cfloop>
			
		</cfif>	
		
		<cfreturn i>
		
	</cffunction>	
	
	
</cfcomponent>		
