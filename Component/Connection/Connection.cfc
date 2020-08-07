
<!--- house keeping empty the prior information of that user for the prior date --->

<cfcomponent>
	
	<cffunction name    = "setConnection" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "initially set the connection object data reference table for checking" 
		    output      = "true">	
															 
			<cf_assignid>
			<cfparam name="ScopeId"            type="string"  default="#rowguid#">	
			<cfparam name="ScopeMode"          type="string"  default="Default">			
			<cfparam name="ScopeFilter"        type="string"  default="">							
			<cfparam name="Object"             type="string"  default="Attachment">				 
			<cfparam name="ControllerNo"       type="string"  default="1">		    			 
			<cfparam name="ObjectContent"      type="query"   default="">					 			 
			<cfparam name="ObjectIdField"      type="string"  default="">	
			<cfparam name="delay"              type="string"  default="5">					 
						 									
			<cfquery name="Site" 
				datasource="AppsInit">
					SELECT * 
					FROM   Parameter
					WHERE  HostName = '#CGI.HTTP_HOST#'
			</cfquery>
											 			 
			<cfquery name="Clean" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE FROM UserConnectionController
				    WHERE  Account = '#SESSION.Acc#'
					AND	   Object  = '#object#'
					AND    (
					         (ScopeId = '#scopeid#' AND SessionId = '#SESSION.SessionId#') OR Created < getDate()-1
						   )										
			</cfquery>	
			
			 <cfquery name="check" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM UserNames
					WHERE Account = '#session.acc#'							  
			</cfquery>
			
			<cfif check.recordcount eq "1">			
			
				<!--- pending for action listing alert --->	 
				 									
				<cfif Object eq "ActionCenter"> 	
				
						<cfset newValue = "#dateformat(now(),'YYYY/MM/DD')# #timeformat(now(),'HH:MM:SS')#">
												
						<cfinvoke component = "Service.Connection.Connection"  
							   method            = "recordobject" 
							   scopeid           = "#scopeid#" 
							   sessionid         = "#Session.sessionid#"
							   object            = "#Object#" 
							   objectid          = "#Session.acc#"
							   ObjectValue       = "#newvalue#"  						   
							   ObjectRefresh     = "actioncenter_refresh">			 
							   
				<cfelseif Object eq "DeliveryCenter"> 	
				
						<cfset newValue = "#dateformat(now(),'YYYY/MM/DD')# #timeformat(now(),'HH:MM:SS')#">
						
						<cfloop query="ObjectContent">
												
							<cfinvoke component = "Service.Connection.Connection"  
								   method            = "recordobject" 
								   scopeid           = "#scopeid#" 
								   scopefilter       = "#scopefilter#"  
								   sessionid         = "#Session.sessionid#"
								   object            = "#Object#" 
								   objectid          = "#OrgUnit#"
								   ObjectValue       = "#Planned#"  						   
								   ObjectRefresh     = "content_#scopeid#_#OrgUnit#_refresh">											   						   
							   
						</cfloop>
						
				<!--- POS picking screen alerter --->			
						
				<cfelseif Object eq "WarehouseBatchCenter"> 
												
					 <cfif quotedValueList(ObjectContent.BatchNo) neq "">
					 
					 	<!--- at this stage we can just take the batchNo in our list as the scope of the date --->
				
						<cfquery name="Last" 
						datasource="AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						
						   <cfif ScopeMode neq "Monitor">
						   
						         SELECT  TOP (1) Created as Updated
								 FROM    Materials.dbo.WarehouseBatch							
								 WHERE   BatchNo IN (#quotedValueList(ObjectContent.BatchNo)#)					 								
								 ORDER BY Created DESC	
								 
							<cfelseif scopeMode eq "Monitor">
							
								 SELECT  TOP (1) Created as Updated
								 FROM    Materials.dbo.WarehouseBatchAction						 
								 WHERE   BatchNo IN (#quotedValueList(ObjectContent.BatchNo)#)					 					 			 
								 ORDER BY Created DESC 		
						   
						   </cfif>												
									 
						</cfquery> 
					
						<cfset lastcreated = last.Updated>
					
					<cfelse>
							
						<cfset lastcreated = "">
					
					</cfif>								
							
					<cfinvoke component    = "Service.Connection.Connection"  
						   method          = "recordobject" 
						   scopeid         = "#scopeid#" 
						   scopemode       = "#scopemode#"					   
						   scopefilter     = "#scopefilter#" 
						   sessionid       = "#Session.sessionid#"
						   object          = "#Object#" 						   
						   ObjectValue     = "#lastcreated#"  						   
						   ObjectRefresh   = "content_refresh">	
					
					<cfquery name="Last" 
					datasource="AppsMaterials"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		   
						 SELECT    T.TransactionBatchNo as BatchNo, 
						           MAX(TA.ActionDate) AS LastStamp
						 FROM      ItemTransactionAction AS TA RIGHT OUTER JOIN
	                    		   ItemTransaction AS T ON TA.TransactionId = T.TransactionId
					     <cfif quotedValueList(ObjectContent.BatchNo) neq "">	
						 WHERE     TransactionBatchNo IN (#quotedValueList(ObjectContent.BatchNo)#)		
						 <cfelse>
						 WHERE     1=0	
						 </cfif>
						 GROUP BY  T.TransactionBatchNo							 			
					</cfquery>	   	
				
					<cfloop query="Last">		
						
						<cfset ObjectId = evaluate("#ObjectIdField#")>
						
						<cfif ObjectId neq "">
																	
							<cfinvoke component = "Service.Connection.Connection"  
								   method            = "recordobject" 
								   scopeid           = "#scopeid#" 
								   sessionid         = "#Session.sessionid#"
								   object            = "#Object#" 
								   objectid          = "#ObjectId#"
								   ObjectValue       = "#lastStamp#"  						   
								   ObjectRefresh     = "content_#ObjectId#_refresh">		
							   
						</cfif>	   
							   
					</cfloop>		
					
				<!--- workflow object --->	   										   
							  					
				<cfelseif Object eq "WorkflowAction"> 				
				
						<cfloop query="ObjectContent">
							
								<cfset ObjectId = evaluate("#ObjectIdField#")>
								
								<!--- check for last action for this workflow object --->
								
								 <cfquery name="Last" 
									datasource="AppsOrganization"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT   TOP 1 OfficerDate  <!--- the last action record fin the workflow --->
										FROM     OrganizationObjectAction
										WHERE    ObjectId = '#ObjectId#'
										AND      ActionStatus IN ('2','2Y','2N')	
										ORDER BY OfficerDate DESC
								</cfquery>														
								
								<cfinvoke component = "Service.Connection.Connection"  
								   method           = "recordobject" 
								   scopeid          = "#scopeid#" 
								   sessionid        = "#Session.sessionid#"
								   object           = "#object#" 
								   objectid         = "#objectid#"
								   ObjectValue      = "#Last.OfficerDate#"
								   ObjectRefresh    = "content_#scopeid#_#ObjectId#_refresh">							   
					
						</cfloop>				
				
				
						
			     <cfelseif Object eq "WorkAction"> 				
				
						<cfloop query="ObjectContent">
							
								<cfset ObjectId = evaluate("#ObjectIdField#")>
								
								<!--- check for last action --->
								
								 <cfquery name="Last" 
									datasource="AppsWorkOrder"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT   MAX(DateTimeActual) AS Action
									FROM     WorkOrderLineAction
									WHERE    WorkOrderId = '#ObjectId#'
								</cfquery>							
								
								<cfinvoke component = "Service.Connection.Connection"  
								   method           = "recordobject" 
								   scopeid          = "#scopeid#" 
								   sessionid        = "#Session.sessionid#"
								   object           = "#object#" 
								   objectid         = "#objectid#"
								   ObjectValue      = "#Last.Action#"
								   ObjectRefresh    = "content_#scopeid#_#ObjectId#_refresh">							   
					
						</cfloop>	
						
				<!--- special mode for the user support widget --->							
						
				<cfelseif Object eq "UserSupport"> 			
				
					<cfloop query="ObjectContent">
										
						<cfquery name="Parameter" 
						datasource="appsSystem">
						SELECT   *
					    FROM     Parameter
						</cfquery>
										
						<cfset ObjectId = evaluate("#ObjectIdField#")>
																	
						<!--- retrieve the last recorded message for this user for any topics ---> 
											
						<cfquery name="Last" 
							datasource="AppsControl"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   MAX(MailDate) AS Action
							FROM     [#Parameter.databaseServer#].Organization.dbo.OrganizationObjectActionMail M
							WHERE    ObjectId IN (						
												SELECT  ObservationId 
						 	                    FROM    Control.dbo.Observation
												WHERE   ObservationClass = 'Inquiry'
												AND     ActionStatus    < '3'		<!--- only pending tickets considered --->			 
							    			    AND	    OfficerUserId   = '#ObjectId#')		
							<cfif getAdministrator("*") eq "0">
							AND     MailScope = 'All'
							</cfif>															
							
						</cfquery>		
						
						<!--- niw we create an instance in the screen as the user sees it --->					
						
						<cfinvoke component = "Service.Connection.Connection"  
						   method           = "recordobject" 
						   scopeid          = "#scopeid#" 
						   sessionid        = "#Session.sessionid#"
						   object           = "#object#" 
						   objectid         = "#objectid#"  <!--- topic reference added for this person = useraccount --->
						   ObjectValue      = "#Last.Action#"
						   ObjectRefresh    = "content_#scopeid#_#ObjectId#_refresh">		
							   
					</cfloop>		   							
				
				<cfelseif Object eq "Attachment">
				 		
						<cfloop query="ObjectContent">
						
							<cfset ObjectId = evaluate("#ObjectIdField#")>
						
							 <!--- check for last action --->
				
							 <cfquery name="Last" 
								datasource="AppsSystem"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								 SELECT TOP 1 AttachmentId
								 FROM         Attachment			
								 WHERE        Reference = '#ObjectId#'	
								 AND          FileStatus != '9'
								 ORDER BY     Created DESC
							</cfquery>												
													
							<cfinvoke component = "Service.Connection.Connection"  
								   method           = "recordobject" 
								   scopeid          = "#scopeid#" 
								   sessionid        = "#Session.sessionid#"
								   object           = "#object#" 
								   objectid         = "#objectid#"
								   ObjectValue      = "#Last.AttachmentId#"
								   ObjectRefresh    = "att_box_#ObjectId#_refresh">							  						
													
						</cfloop>									 
				 
				 </cfif>
			 
				 <!--- --------------------------------------------------------------------------- --->
				 <!--- generate the interval script which performs the server check of the context --->
				 <!--- --------------------------------------------------------------------------- --->
				 
				 <cfset de = delay*1000>			 
				 					
				 <cfoutput>
				 
					<script language="JavaScript">		
									    
					    try { clearInterval ( attachmentrefresh_#controllerno# ); } catch(e) {}		 
						
			   			attachmentrefresh_#controllerno# = setInterval('connectioncontroller("#Object#","#scopeid#")',#de#) 																
											
						<!--- refer to systemscript.cfm line 264 --->
					</script>
				</cfoutput>			
				
			</cfif>	
					
			<!--- container to perform the refreshing checkin --->		
			<div class="hide" id="connection_controller_box"></div>	
						 				
	</cffunction>	 	
	
	<cffunction name     = "recordobject" 
			 access      = "remote" 
			 returntype  = "any" 
			 displayname = "record connection object" 
			 output      = "true">			
			 
			 <cfparam name="ScopeId"            type="string"  default="">	
			 <cfparam name="ScopeMode"          type="string"  default="">	
			 <cfparam name="ScopeFilter"        type="string"  default="">	
			 <cfparam name="Object"             type="string"  default="Attachment">				    
			 <cfparam name="ObjectId"           type="string"  default="">				
			 <cfparam name="delay"              type="string"  default="10">		
			 <cfparam name="ObjectValue"        type="string"  default="">			 
			 <cfparam name="ObjectRefresh"      type="string"  default="">		
						 						
			<cfquery name="Site" 
				datasource="AppsInit">
					SELECT * 
					FROM   Parameter
					WHERE  HostName = '#CGI.HTTP_HOST#'
			</cfquery>
			 
			 <cfquery name="CheckExistence" 
				datasource="AppsSystem"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 	SELECT 	*
				 	FROM  	UserConnectionController			
				 	WHERE	Account           = '#SESSION.acc#'
					AND		ApplicationServer = '#site.applicationserver#'
					AND		SessionId         = '#SessionId#'
					AND		ScopeId           = '#scopeid#'
					AND		Object            = '#object#'
					AND		ObjectId          = '#ObjectId#'
			</cfquery>
						
			<cfif CheckExistence.recordCount eq 0>	
			
			     <cftry>
							 								
				 <cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO UserConnectionController
						(Account,
						 ApplicationServer,
						 SessionId,
						 ScopeId,
						 ScopeMode,
						 ScopeFilter,
						 Object,
						 ObjectId,
						 ObjectScopeValue,
						 ObjectRefreshFunction)
					VALUES
						('#SESSION.acc#',
						 '#site.applicationserver#',
						 '#SessionId#',
						 '#scopeid#',
						 '#ScopeMode#',
						 '#preserveSingleQuotes(scopefilter)#',
						 '#object#',
						 '#ObjectId#',						
						 '#ObjectValue#',						 
						 '#ObjectRefresh#')				  
				 </cfquery>	
				 
				 <cfcatch></cfcatch>
				 
				 </cftry>
				 				 			
			<cfelse>
						
				<cfquery name="updateValues" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE  UserConnectionController
						SET    	ObjectScopeValue      = '#ObjectValue#',														 
						        ObjectScopeStamp      = getDate(),
							    ObjectRefreshFunction = '#ObjectRefresh#'
					    WHERE	Account               = '#SESSION.acc#'
						AND		ApplicationServer     = '#site.applicationserver#'
						AND		SessionId             = '#SessionId#'
						AND		ScopeId               = '#ScopeId#'
						AND		Object                = '#Object#'
						AND		ObjectId              = '#ObjectId#'
				</cfquery>
			
			</cfif>		
						 
	</cffunction>			  	
	
	<cffunction name     = "performcheck" 
			 access      = "remote" 
			 returntype  = "any" 
			 displayname = "perform the check" 
			 output      = "true">								 
						
			 <cfparam name="ScopeId" type="string">	
			 
			 <cfparam name="SESSION.login" default="">
			 
			 <cfif session.login neq "">
			 
			  <cfquery name="getObjects" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT TOP 1 * 
					FROM   UserConnectionController
					WHERE  SessionId = '#SESSION.SessionId#'
					AND    ScopeId   = '#scopeid#'				    
			  </cfquery>	
			  
			  <cfquery name="Site" 
				datasource="AppsInit">
					SELECT * 
					FROM   Parameter
					WHERE  HostName = '#CGI.HTTP_HOST#'
			  </cfquery>			 
			  			    			  
			  <cfswitch expression="#getObjects.Object#">
			  
			      <cfcase value="ActionCenter">
				  			  				  
				    <!--- action took place --->
					
					<cfif getAdministrator("*") eq "0">
												
						<cfquery name="getOrg" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   DISTINCT Mission
							FROM     OrganizationAuthorization
							WHERE    UserAccount = '#session.acc#'
						</cfquery>	

						<cfif getOrg.recordcount eq "0">
						
							<cfset mis = "''">
						
						<cfelse>
						
							<cfset mis = quotedvalueList(getOrg.Mission)>
							
						</cfif>	
					
					</cfif>						
					
				  	<cfquery name="LastDocumentAction" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  
					  	SELECT    TOP 1 OA.OfficerDate
						FROM      OrganizationObjectAction AS OA INNER JOIN
				                  OrganizationObject AS O ON OA.ObjectId = O.ObjectId
						WHERE     OA.OfficerDate <= #now()#			  
						<cfif getAdministrator("*") eq "1">		 
						AND       O.Operational = 1
						<cfelse>
						AND       O.Mission IN (#preserveSingleQuotes(mis)#)
						AND       O.Operational = 1
						</cfif>
						ORDER BY  OA.OfficerDate DESC
												
				   </cfquery>		
				   				   							
				  <!--- action was added --->
				  
				  <cfquery name="LastDocumentAdd" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">			
					
					  	SELECT    TOP 1 OA.Created
						FROM      OrganizationObjectAction AS OA INNER JOIN
				                  OrganizationObject AS O ON OA.ObjectId = O.ObjectId								  
						<cfif getAdministrator("*") eq "1">				 
						WHERE     Operational = 1
						<cfelse>
						WHERE     O.Mission IN (#preserveSingleQuotes(mis)#)
						AND       Operational = 1
						</cfif>
						ORDER BY  OA.Created DESC					
						
				 </cfquery>	
				 
				 <!--- batch was performaced --->
				 
				  <cfquery name="LastBatchAction" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				 
					 	SELECT    TOP 1 LA.ActionDate
						FROM      Purchase.dbo.RequisitionLineAction AS LA INNER JOIN
				                  Purchase.dbo.RequisitionLine AS L ON LA.RequisitionNo = L.RequisitionNo
						WHERE     LA.ActionDate <= #now()#		  
						<cfif getAdministrator("*") eq "0">			  
						AND       L.Mission IN (#preserveSingleQuotes(mis)#)			  
						</cfif>
						ORDER BY  LA.ActionDate DESC
				   </cfquery>	 
				   
				   <cfset newDate = LastDocumentAction.OfficerDate>
				   
				   <cfif LastDocumentAdd.Created gt newDate>
				   	   <cfset newDate = LastDocumentAdd.Created>
				   </cfif>
				   
				   <cfif LastBatchAction.ActionDate gt newDate>
				   	   <cfset newDate = LastBatchAction.ActionDate>
				   </cfif>
				   
				   <cfset newValue = "#dateformat(newDate,'YYYY/MM/DD')# #timeformat(newDate,'HH:MM:SS')#">
				   
				    <cfquery name="getObjects" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  TOP 1 * 
						FROM    UserConnectionController
						WHERE   SessionId = '#SESSION.SessionId#'
						AND     ScopeId   = '#scopeid#'				    
				  </cfquery>				  
				 								  
				  <cfif getObjects.ObjectScopeValue lt newValue>									  	
				  				  
					  	<!--- obtain the new value like 50:40 through component 
						compare	it / if different
							update table UserConnectionController
							trigger jv function and pass the value to be outputted
						--->
						
						<cfquery name="setValues" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    UPDATE  UserConnectionController
								SET     ObjectScopeValue = '#NewValue#',
								        ObjectScopeStamp = getDate()				
							    WHERE   SessionId = '#session.sessionid#'
								AND     ScopeId   = '#ScopeId#'								
							</cfquery>		
							
						<cfset vObjectRefreshFunctionId = replace(getObjects.ObjectRefreshFunction, "-", "", "ALL")>
																				  
						<script>
												
								if  (document.getElementById('#getObjects.ObjectRefreshFunction#')) {										
								     document.getElementById('#getObjects.ObjectRefreshFunction#').click()
								} else {
									  if  (document.getElementById('#vObjectRefreshFunctionId#')) {										
									     document.getElementById('#vObjectRefreshFunctionId#').click()
									} else {
										  //alert("#getObjects.ObjectRefreshFunction# not found")
									} 
								} 
										
						</script>		
											
					</cfif>							
																								  				  
				  </cfcase>				  		  
				  
				   <cfcase value="DeliveryCenter">
				   
				   	   <!--- check for last action for this workflow object --->		
					 															 
					   <cfset dateValue = "">
					   <CF_DateConvert Value="#getObjects.ScopeFilter#">
					   <cfset DTS = dateValue>		
						
					   <cfparam name="url.mission" default="Kuntz">
									  						  
					   <cfquery name="getChangedObjects" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
																			
						    SELECT *, 		
												
								(	
								
									SELECT     
										    SUM(Planned) as NewValue
											  
									FROM (  	   
										  
										<!--- requested and scheduled actions --->   
									
										SELECT   W.OrgUnitOwner as OrgUnit,										 
												 										 	 
												 (
												 SELECT    COUNT(*) 
												 FROM      WorkOrder.dbo.WorkPlan AS W INNER JOIN
							                               WorkOrder.dbo.WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
												 WHERE     D.WorkActionId = A.WorkActionId
												 AND       W.Mission        = '#url.mission#'
												 AND       W.DateEffective  <= #dts# 
												 AND       W.DateExpiration >= #dts#
												 ) as Planned
												
												 
									    FROM     WorkOrder.dbo.WorkOrder AS W INNER JOIN						
								                 WorkOrder.dbo.WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
								                 WorkOrder.dbo.WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine
												 
									    WHERE    W.Mission          = '#url.mission#'
										AND      A.ActionClass      = 'Delivery' 
										AND      A.DateTimePlanning = #dts#  			    	
										AND      WL.Operational     = '1'
										AND      W.ActionStatus    != '9'
									
									) F
									
									WHERE F.OrgUnit = C.ObjectId
									
								    GROUP BY F.OrgUnit
																						
							 ) as NewValue								
								
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'																						
				   </cfquery>						   			  
				  			  				  
				   </cfcase>		
			  
			  	  <cfcase value="WorkflowAction">
				  
				       <!--- check for last action for this workflow object --->				  			  
				  						  
					   <cfquery name="getChangedObjects" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *, 							
								  (	SELECT   TOP 1 OfficerDate  <!--- the last action record fin the workflow --->
									FROM     Organization.dbo.OrganizationObjectAction A
									WHERE    A.ObjectId = C.ObjectId
									AND      A.ObjectId IN (SELECT ObjectId FROM Organization.dbo.OrganizationObject WHERE Objectid = A.ObjectId AND Operational = 1)
									AND      A.ActionStatus IN ('2','2Y','2N')	
									ORDER BY OfficerDate DESC ) as NewValue		
								
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'																						
					  </cfquery>					  				  
				  
				  </cfcase>
				  
				   <cfcase value="WarehouseBatchCenter">	
				  
				 	   <!--- determine if something has happended for the objects in general --->
					   
					   <cfquery name="getHeader" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					   
					        SELECT  *																									
							FROM    UserConnectionController C
							WHERE   Account           = '#session.acc#'
							AND     ApplicationServer = '#site.applicationserver#'
							AND     SessionId         = '#SESSION.SessionId#'
							AND     ScopeId           = '#scopeid#'	
							AND     ObjectId          = '' 							
					    </cfquery>		
					  
					   <cfquery name="getChangedObjects" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
																			
							<cfif getHeader.recordcount eq "1">
						
							<!--- header --->
						
							SELECT *, 							
								(
								<cfif getHeader.scopeMode eq "Monitor">
								
										SELECT   TOP (1) A.Created as Updated
									 	FROM     Materials.dbo.WarehouseBatch B INNER JOIN Materials.dbo.WarehouseBatchAction A ON B.Batchno = A.Batchno				 
										WHERE    #preservesingleQuotes(getHeader.ScopeFilter)#		
										AND      A.ActionCode = 'Monitor'
				                        AND      A.ActionStatus = '1'
										ORDER BY Updated DESC	
																				
								<cfelse>	
								
									<!--- trigger a full refresh --->
								
										SELECT   TOP (1) Created as Updated
										FROM     Materials.dbo.WarehouseBatch B								
										WHERE    #preservesingleQuotes(getHeader.ScopeFilter)# 
										ORDER BY Updated DESC		
												
								
								</cfif>
								
								) as NewValue
																																
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'	
							AND    ObjectId = '' <!--- general scope --->
													
						    UNION ALL
							
							</cfif> 
																					
							<!--- obtain the last date/time something has changed --->		
						
						    SELECT *, 																				
							
								(SELECT   TOP 1 MAX(TA.ActionDate) 
								 FROM     Materials.dbo.ItemTransactionAction AS TA INNER JOIN
					                      Materials.dbo.ItemTransaction AS T ON TA.TransactionId = T.TransactionId
								 WHERE    T.TransactionBatchNo = C.Objectid	) as NewValue
																	
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'	
																					
					  </cfquery>	
					  	  		  
				  
				  </cfcase>
				  
			  
			      <cfcase value="WorkAction">	
				  
				 	   <!--- only objects that have changed --->
					  
					   <cfquery name="getChangedObjects" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *, 							
								(							
								SELECT   MAX(DateTimeActual)
								FROM     WorkOrder.dbo.WorkOrderLineAction
								WHERE    WorkOrderId = C.ObjectId) as NewValue
								
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'	
																					
					  </cfquery>		
					  		  
				  
				  </cfcase>
				  
				  <cfcase value="UserSupport">	
				  
				  		<cfquery name="Parameter" 
						datasource="appsSystem">
						SELECT   *
					    FROM     Parameter
						</cfquery>
				  
				  	   <cfquery name="getChangedObjects" 
						datasource="AppsControl" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *, 	
							    (
								SELECT   MAX(MailDate)
								FROM     [#Parameter.databaseServer#].Organization.dbo.OrganizationObjectActionMail M
								WHERE    ObjectId IN (						
											SELECT  ObservationId 
					 	                    FROM    Observation
											WHERE   ObservationClass = 'Inquiry'
											AND     ActionStatus    < '3'					 
						    			    AND	    OfficerUserId   = C.ObjectId )
								<cfif getAdministrator("*") eq "0">
								AND     MailScope = 'All'
								</cfif>	) as NewValue													
															
							FROM   [#Parameter.databaseServer#].System.dbo.UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'	
																					
					  </cfquery>				  		  		  
				  
				  </cfcase>
				  			  
				  <cfcase value="Attachment">	
				  
				  	  <!--- only objects that have changed --->
					  
					   <cfquery name="getChangedObjects" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *, 
							       (	SELECT TOP 1 IsNull(AttachmentId,'')
										FROM         Attachment			
										WHERE        Reference = C.ObjectId	
										AND          FileStatus != '9'
										ORDER BY     Created DESC ) as NewValue
							
							FROM   UserConnectionController C
							WHERE  SessionId = '#SESSION.SessionId#'
							AND    ScopeId   = '#scopeid#'	
							
							<!---	was not immediately working so I loop through it 
								
							AND    ObjectScopeValue <> (SELECT TOP 1 IsNull(AttachmentId,'')
														FROM         Attachment			
														WHERE        Reference = CONVERT(varchar,C.ObjectId)
														AND          FileStatus != '9'
														ORDER BY     Created DESC )  
														
														--->
														
														
					  </cfquery>										  
													
				  </cfcase> 
			  			  
			 </cfswitch>  
						 
			 <cfif isDefined("getChangedObjects")>
			 			 			 			 			 
				 <cfloop query="getChangedObjects">	
				 								 																	  
			  		<cfif NewValue neq ObjectScopeValue and NewValue neq "">											
					      																				 						  																																		
						   <cfquery name="setValues" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    UPDATE   UserConnectionController
								SET      ObjectScopeValue = '#NewValue#',
								         ObjectScopeStamp = getDate(),		
										 ObjectScopeFired = ObjectScopeFired+1		
							    WHERE    SessionId = '#session.sessionid#'
								AND      ScopeId   = '#ScopeId#'
								AND      ObjectId  = '#ObjectId#'								
							</cfquery>		
														
							<!--- now we find the right spot on the screen to refresh through the function --->
							
							<cfoutput>
							
								<cfif getObjects.ScopeMode eq "Listing">
								
									<!--- listing --->	
						
									<script>																	
										applyfilter('1','','#ObjectId#')								
									</script>
						
								<cfelse>
							
									<cfset vObjectRefreshFunctionId = replace(ObjectRefreshFunction, "-", "", "ALL")>							
								
									<script language="JavaScript">
																																																											   
										if  (document.getElementById('#ObjectRefreshFunction#')) {																			
										     document.getElementById('#ObjectRefreshFunction#').click()
										} else {
										   if  (document.getElementById('#vObjectRefreshFunctionId#')) {										
											     document.getElementById('#vObjectRefreshFunctionId#').click()
											} else {
											   //alert("#vObjectRefreshFunctionId# not found2")
											} 
										} 
															
									</script>	
									
								</cfif>								
							
							</cfoutput>
						
					</cfif>					
					
				</cfloop>
			
			</cfif>
			
			</cfif>
						
	</cffunction>	
		
</cfcomponent>	
