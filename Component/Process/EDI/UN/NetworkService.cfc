<cfcomponent>

    <cfproperty name="name" type="string">
	
    <cfset this.name = "UN Prcoessing of Network Services">	
	
	 <cffunction name="SharedEmail" access="public">
	 
	 	 <cfset vService    		= "WO001">
		 <cfset vTopicEmail 		= "T057">
		 <cfset vServiceItemUnit 	= "SLA11">
		 <cfset vServiceDomain      = "UserAccount">
		
	
		 <cfquery name="qServices" 
			datasource="AppsWorkOrder"
	 		username="#SESSION.login#"
	 		password="#SESSION.dbpw#">

			SELECT  * ,  
				(SELECT TOP 1 CustomerId
					FROM stCustomerMapping M
					WHERE M.MappingCode = N.Organization  
						AND M.CustomerID IS NOT NULL 
						AND (M.serviceItem = '#vService#' 
							OR M.serviceItem IS NULL) 
						ORDER BY serviceItem desc, created desc
				) as CustomerId,
			
				(SELECT TOP 1 ServiceDomain 
					FROM ServiceItem WHERE Code = '#vService#') as ServiceDomain
			
			
			FROM [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email N
			WHERE eMailAddress<>''
			AND eMailAddress IS NOT NULL
			AND IndexNo IS NULL
			AND Country IS NULL
			AND RecordStatus = '1'
		</cfquery>
		
		
		<cfset  i = 0>
		
		<cfloop query="qServices">
		
			<cfset i = i + 1>	
			<cfoutput>
			#i#. #qServices.EmailAddress#
			</cfoutput>

		 		<cfquery name="qCheck" 
					datasource="AppsWorkOrder"
	 				username="#SESSION.login#"
	 				password="#SESSION.dbpw#">
				SELECT	DISTINCT M.MappingCode,
	  							W.ServiceItem
	  			FROM stCustomerMapping M 
	  			INNER JOIN WorkOrder W on M.CustomerId = W.CustomerId 
	  			INNER JOIN ServiceItemUnitMission S ON W.ServiceItem = S.ServiceItem and S.Mission = 'OICT' 
	  			INNER JOIN ServiceItemUnit U ON U.ServiceItem = S.ServiceItem AND U.Unit = S.ServiceItemUnit
	  			WHERE 
   					M.MappingCode = '#qServices.Organization#'
   					AND M.CustomerID IS NOT NULL 
   					AND S.DateEffective <= getdate() 
   					AND S.DateExpiration > getdate() 
   					AND U.BillingMode = 'Line' 
   					AND S.Operational=1 
   					AND U.Operational=1	  	
   					AND W.ServiceItem = '#vService#'		
	  			</cfquery> 

				
				<cfset proceed = 1>
				<cfif qCheck.recordcount eq 0>
					<cfoutput>
					#qServices.Organization# is not related to #vService#
					<br> 		
					</cfoutput>
					
			 		<cfquery name="qCustomer" 
						datasource="AppsWorkOrder"
		 				username="#SESSION.login#"
		 				password="#SESSION.dbpw#">
						SELECT M.*,C.OrgUnit
		  				FROM stCustomerMapping M INNER JOIN Customer C
		  				ON M.CustomerId = C.CustomerId
		  				WHERE M.MappingCode = '#qServices.Organization#'
			 		</cfquery>
			 		
			 		<cfif qCustomer.recordcount neq 0>	 					
						
			 			<cfquery name="qInsert" 
						datasource="AppsWorkOrder"
		 				username="#SESSION.login#"
		 				password="#SESSION.dbpw#">
							INSERT INTO WorkOrder(
									Mission,
									ServiceItem,
									CustomerId,
									OrgUnitOwner,
									OrderDate,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
									)
							VALUES
							('OICT',
							 '#vService#',
							 '#qCustomer.CustomerId#',
							 '#qCustomer.OrgUnit#',
							 '2018-01-01',
							 'jamazariegosr',
							 'jamazariegosr',
							 'jamazariegosr'	
							)
						</cfquery>
					<cfelse>
						<cfset proceed = 0>
						<cfoutput>
							Customer not found #qServices.Organization#
						</cfoutput>	
			 		</cfif>	
					
				</cfif>		
				
				<cfif proceed eq 1>

					<cfset NewAdditionalRecord( vService 	  = vService, 
							vEmailAddress = qServices.EmailAddress,
							vTopicEmail   = vTopicEmail,
							vCustomerId   = qServices.CustomerId,
							vOrganization = qServices.Organization,
							vServiceDomain = vServiceDomain,
							vServiceItemUnit = vServiceItemUnit,
							SharedAccount = 1)>
				</cfif>			


				
							
		</cfloop>
	
	
	 </cffunction>		
	
	
	
	 <cffunction name="Email" access="public">
	 
	 	 <cfset vService    		= "WO001">
		 <cfset vTopicEmail 		= "T057">
		 <cfset vServiceItemUnit 	= "SLA06">
		
	
		 <cfquery name="qServices" 
			datasource="AppsWorkOrder"
	 		username="#SESSION.login#"
	 		password="#SESSION.dbpw#">

			SELECT  * ,  
				(SELECT TOP 1 CustomerId
					FROM stCustomerMapping M
					WHERE M.MappingCode = N.Organization  
						AND M.CustomerID IS NOT NULL 
						AND (M.serviceItem = '#vService#' 
							OR M.serviceItem IS NULL) 
						ORDER BY serviceItem desc, created desc
				) as CustomerId,
			
				(SELECT TOP 1 ServiceDomain 
					FROM ServiceItem WHERE Code = '#vService#') as ServiceDomain
			
			
			FROM [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email N
			WHERE eMailAddress<>''
			AND eMailAddress IS NOT NULL
			AND RecordStatus = 1	
			AND Licensed = 'Yes'
			AND Country = 'United States'
			AND IndexNo NOT IN 
			(
				SELECT IndexNo
				FROM Usertransaction.dbo._5_18_2018_EIDMS_DUPLICATES
				
			)
		</cfquery>
		
		<cfset  i = 0>
		
		<cfloop query="qServices">
		
			<cfset i = i + 1>	
			<cfoutput>
			#i#. #qServices.EmailAddress#
			</cfoutput>

			<cfif qServices.IndexNo neq "">
			
				 <cfquery name="qPerson" 
					datasource="AppsWorkOrder"
			 		username="#SESSION.login#"
			 		password="#SESSION.dbpw#">
						SELECT PersonNo 
						FROM Employee.dbo.Person  
						WHERE IndexNo = '#qServices.IndexNo#'
						AND IndexNo is not null 
						AND IndexNo !=''
				</cfquery>		
				
				<cfif qPerson.PersonNo neq "">

				 	<cfquery name="qLine" 
						datasource="AppsWorkOrder"
			 			username="#SESSION.login#"
				 		password="#SESSION.dbpw#">
							SELECT *
							FROM WorkOrder W INNER JOIN WorkOrderLine L
								ON L.WorkOrderId = W.WorkOrderId 
							WHERE 
							    W.ServiceItem = '#vService#'	
							AND L.PersonNo    = '#qPerson.PersonNo#'
							AND ((L.DateExpiration > getdate()) OR (L.DateExpiration is null))
							AND L.Operational = '1'
							AND L.ServiceDomainClass <> 'Email'
							AND NOT EXISTS (
								SELECT *
								FROM WorkOrderLine LL
								WHERE LL.Reference = L.Reference
								AND LL.ParentWorkOrderId = L.WorkorderId
								AND LL.ParentWorkorderLine = L.WorkorderLine)
					</cfquery>			
					
					<cfif qLine.recordcount neq 0>

					 	<cfquery name="qTopic" 
							datasource="AppsWorkOrder"
				 			username="#SESSION.login#"
					 		password="#SESSION.dbpw#">
								SELECT *
								FROM WorkOrderLineTopic 
								WHERE WorkOrderId = '#qLine.WorkOrderId#'
								AND WorkOrderline = '#qLine.WorkOrderLine#'
								AND Topic = '#vTopicEmail#'
								AND Operational = 1
								AND TopicValue = '#qServices.EmailAddress#'
						</cfquery>		
						
						
						<cfif qTopic.recordcount eq 0>
							 	<cfquery name="qAlternateTopic" 
									datasource="AppsWorkOrder"
						 			username="#SESSION.login#"
							 		password="#SESSION.dbpw#">
										SELECT *
										FROM WorkOrderLineTopic 
										WHERE WorkOrderId = '#qLine.WorkOrderId#'
										AND WorkOrderline = '#qLine.WorkOrderLine#'
										AND Topic = '#vTopicEmail#'
										AND Operational = 1
										AND TopicValue != '#qServices.EmailAddress#'
								</cfquery>		
							
								<cfif qAlternateTopic.recordcount neq 0>
									<cfoutput>
									<br>
									Another email address already mapped to this network account.  
									A new network account must be created as additional email (servicedomainclass=email)
									<br>
									
									<cfset NewAdditionalRecord( vService 	  = vService, 
																vEmailAddress = qServices.EmailAddress,
																vTopicEmail   = vTopicEmail,
																vCustomerId   = qServices.CustomerId,
																vOrganization = qServices.Organization )>

									
									</cfoutput>
								<cfelse>
									<cfoutput>
									<br>
									Email address not associated we need to add a new topic
									<br>	
									<cfset UpdateTopic( vWorkOrderId   = qLine.WorkOrderId, 
														vWorkOrderLine = qLine.WorkOrderLine,
														vTopic	     = vTopicEmail,
														vTopicValue	 = qServices.EmailAddress
														 )>
									
									
									</cfoutput>
								</cfif>
							
						
						<cfelse>
							<!---- The email is assigned already ---->
							<br>
							Email is assigned already
							<br>
							<hr>
						
						</cfif>
						
					
					
					<cfelse>
						<!---
						cfdump var="#qLine#"
						--->
						<br>
						Ignore
						<br>
						<hr>
					
					
					</cfif>

				<cfelse>
					<br>
					PersonNo is not defined
					<br>
					<cfset NewAdditionalRecord( vService 	  = vService, 
												vEmailAddress = qServices.EmailAddress,
												vTopicEmail   = vTopicEmail,
												vCustomerId   = qServices.CustomerId,
												vOrganization = qServices.Organization,
												vPersonNo	  = qPerson.PersonNo,
												vServiceDomain = qServices.ServiceDomain,
												vFirstName	   = qServices.CustomerFirstName,
												vLastName	   = qServices.CustomerLastName)>
					
				</cfif>
			
		
			<cfelse>
				<br>
				IndexNo is blank
				<br>		
				
				
				
			</cfif>	
		
		
		
		
		</cfloop>
	
	
	 </cffunction>	
	 
	 
	 
	 <cffunction name="UpdateTopic">

			<cfargument name="vWorkOrderId"  	type="string"  required="true"   default=""> 
			<cfargument name="vWorkOrderLine"  	type="string"  required="true"   default="">
			<cfargument name="vTopic"  			type="string"  required="true"   default="">
			<cfargument name="vTopicValue"  	type="string"  required="true"   default="">
			<cfargument name="vDateEffective"  	type="string"  required="true"   default="">
			
	 	
	 	
	 	
			<cfif vDateEffective eq "">
				<cfset vDateEffective = DateFormat(now(),CLIENT.DateSQL)>
			</cfif>

			<cfif vTopic neq "">
			
			 	<cfquery name="qCheck" 
				datasource="AppsWorkOrder"
	 			username="#SESSION.login#"
		 		password="#SESSION.dbpw#">
					SELECT *
					FROM 	WorkOrderLineTopic
					WHERE 	WorkOrderId 	= '#vWorkOrderId#'
					AND		WorkOrderLine 	= '#vWorkOrderLine#'
					AND 	Topic 			= '#vTopic#'
			 	</cfquery>			

				<cfif qCheck.recordcount eq 0>		

					 	<cfquery name="qInsertTopic" 
						datasource="AppsWorkOrder"
			 			username="#SESSION.login#"
				 		password="#SESSION.dbpw#">
							INSERT INTO dbo.WorkOrderLineTopic (
								WorkOrderId,
								WorkOrderLine,
								DateEffective,
								Topic,			
								TopicValue,
								Operational,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
								)
							VALUES 
								(
								'#vWorkOrderId#',
								'#vWorkOrderLine#',		
								'#vDateEffective#',
								'#vTopic#',
								'#vTopicValue#',
								1,
								'jamazariegosr',
								'jamazariegosr',
								'jamazariegosr'
								)
					 	</cfquery>		
								<br>
				<cfelse>
					 	<cfquery name="qUpdateTopic" 
						datasource="AppsWorkOrder"
			 			username="#SESSION.login#"
				 		password="#SESSION.dbpw#">
							UPDATE 	WorkOrderLineTopic
							SET		TopicValue = '#vTopicValue#'
							WHERE WorkOrderId = '#vWorkOrderId#'
							AND	WorkOrderLine = '#vWorkOrderLine#'
							AND Topic = '#vTopic#'
						</cfquery>
						<br>
				</cfif>
			</cfif>
			
			<br>
			<hr>
			<br>
	 	
	 	
	 	
	 	
	 </cffunction>	 	
	 
	 
	 
	 
	 <cffunction name="NewAdditionalRecord">
	 	
			<cfargument name="vService"  		type="string"  required="true"   default=""> 
			<cfargument name="vEmailAddress" 	type="string"  required="true"   default="">
			<cfargument name="vTopicEmail"  	type="string"  required="true"   default="">
			<cfargument name="vCustomerId"  	type="string"  required="true"   default="">
			<cfargument name="vOrganization"  	type="string"  required="true"   default="">
			<cfargument name="vPersonNo"  		type="string"  required="true"   default="">
			<cfargument name="vServiceDomain"  	type="string"  required="true"   default="">
			<cfargument name="vFirstName"		type="string"  required="true"   default="">			
			<cfargument name="vLastName"		type="string"  required="true"   default="">
			<cfargument name="vServiceItemUnit" type="string"  required="true"	 default="'SLA06'">
			<cfargument name="SharedAccount"    type="string"  required="true"	 default="0">	 	
			
			
				 	
	 	
			<!--- Person was not found, then we look into all--->
			
		 	<cfquery name="qLine" 
			datasource="AppsWorkOrder"
 			username="#SESSION.login#"
	 		password="#SESSION.dbpw#">
					SELECT L.WorkOrderId,L.WorkOrderLine, W.CustomerId
					FROM WorkOrder W INNER JOIN WorkOrderLine L
						ON L.WorkOrderId = W.WorkOrderId
					WHERE 
					    L.Reference = '#vEmailAddress#'
					AND W.ServiceItem = '#vService#'
					AND L.ServiceDomainClass = 'Email'
					AND L.Operational = '1'
					AND NOT EXISTS (
						SELECT *
						FROM WorkOrderLine LL
						WHERE LL.Reference = L.Reference
						AND LL.ParentWorkOrderId = L.WorkorderId
						AND LL.ParentWorkorderLine = L.WorkorderLine)				
	
		 	</cfquery>	
		 	
		 	<cfif qLine.recordCount neq 0>
		 		
		 		<cfif qLine.CustomerId eq qServices.CustomerId>
		 			<br>
		 			email already recorded as additional.  No action taken
		 			<br>
		 				
		 			<cfif SharedAccount eq "1">	
					 	<cfquery name="qCheckBilling" 
						datasource="AppsWorkOrder"
			 			username="#SESSION.login#"
				 		password="#SESSION.dbpw#">
							SELECT WLB.* 
							FROM 
								WorkOrderLineBilling WB INNER JOIN
									WorkOrderLineBillingDetail WLB ON 
										WB.WorkOrderId = WLB.WorkOrderId 
										AND 
										WB.WorkOrderLine = WLB.WorkOrderLine
										AND WB.BillingEffective = WLB.BillingEffective
							WHERE WB.WorkOrderId='#qLine.WorkorderId#'
							AND WB.WorkOrderLine='#qLine.WorkOrderLine#'
							AND WB.BillingEffective<GETDATE()
							AND (WB.BillingExpiration>GETDATE() OR WB.BillingExpiration IS NULL)
							AND WLB.ServiceItem ='#vService#'		
							AND WLB.ServiceItemUnit = '#vServiceItemUnit#'	 		
					 	</cfquery>		 				
					 	
					 	<cfif qCheckBilling.recordcount eq 0>
					 		<cfset vToExpire = "2017-12-31">
					 		<cfset vNewEffective = "2018-01-01">
					 		<br>
					 		<cfoutput>
					 		#vService#/#vServiceItemUnit# not found
					 		<br>
					 		Expire : #vToExpire#
					 		<br>
					 		New one from #vNewEffective# to NULL 
					 		</cfoutput>
					 		<br>
					 		
	
						 	<cfquery name="qCheckExisting" 
							datasource="AppsWorkOrder"
				 			username="#SESSION.login#"
					 		password="#SESSION.dbpw#">
								SELECT WB.BillingId 
								FROM 
									WorkOrderLineBilling WB INNER JOIN
										WorkOrderLineBillingDetail WLB ON 
											WB.WorkOrderId = WLB.WorkOrderId 
											AND 
											WB.WorkOrderLine = WLB.WorkOrderLine
											AND WB.BillingEffective = WLB.BillingEffective
								WHERE WB.WorkOrderId='#qLine.WorkorderId#'
								AND WB.WorkOrderLine='#qLine.WorkOrderLine#'
								AND WB.BillingEffective<GETDATE()
								AND (WB.BillingExpiration>GETDATE() OR WB.BillingExpiration IS NULL)
								AND WLB.ServiceItem ='#vService#'		
								AND WLB.ServiceItemUnit != '#vServiceItemUnit#'	 		
						 	</cfquery>
						 	
						 	<cfif qCheckExisting.recordcount neq 0>
						 		<br>
						 		<cfoutput>
						 		We need to update #qCheckExisting.BillingId# to #vToExpire#
						 		</cfoutput>	 
						 		<br>
						 		<cfquery name="qExpireExisting" 
								datasource="AppsWorkOrder"
				 				username="#SESSION.login#"
					 			password="#SESSION.dbpw#">
					 				UPDATE WorkOrderLineBilling
					 				SET BillingExpiration = '#vToExpire#'
					 				WHERE BillingId = '#qCheckExisting.BillingId#'
						 		</cfquery>
						 		
						 		
						 	</cfif>	
						 	
						 	<cfquery name="qItemUnit" 
							datasource="AppsWorkOrder"
				 			username="#SESSION.login#"
					 		password="#SESSION.dbpw#">
								SELECT *						 	
						 		FROM ServiceItemUnitMission
						 		WHERE ServiceItem     = '#vService#'
						 		AND   ServiceItemUnit = '#vServiceItemUnit#'
						 		AND   DateEffective <= GetDate()
						 		AND   (DateExpiration >= GetDate() OR DateExpiration IS NULL)
						 	</cfquery>
						 	
						 	
						 	<cfif qItemUnit.recordcount neq 0>
								<cfset CreateBilling(
												 NewWorkOrderId		= qLine.WorkorderId,
												 NewWorkOrderLine   = qLine.WorkOrderLine,
												 vService 	  		= vService, 
												 vServiceItemUnit   = vServiceItemUnit,
												 vFrequency         = qItemUnit.Frequency,
												 vBillingMode       = qItemUnit.BillingMode,
												 vStandardCost      = qItemUnit.StandardCost,
	 											 vUnitDateEffective = vNewEffective ,
	 											 vUnitDateExpiration = ""  
												 )>						 	
						 	</cfif>
	
							<cfquery name="qUpdate" 
								datasource="AppsWorkOrder"
	 							username="#SESSION.login#"
	 							password="#SESSION.dbpw#">
	 			 				UPDATE [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email
	 			 				SET RecordStatus ='0'
	 			 				WHERE EmailAddress = '#vEmailAddress#'
			 				</cfquery>
	
						<cfelse>
							<cfquery name="qUpdate" 
								datasource="AppsWorkOrder"
	 							username="#SESSION.login#"
	 							password="#SESSION.dbpw#">
	 			 				UPDATE [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email
	 			 				SET RecordStatus ='0'
	 			 				WHERE EmailAddress = '#vEmailAddress#'
			 				</cfquery>
			 				<br>
			 				Ignore							
					 		<br>
					 	</cfif>
				 	</cfif>	
		 				
		 			<hr>	
		 				
		 		<cfelse>
		 			
		 			<br>
		 			Disabling the topic
		 			<br>
				 	<cfquery name="qInsertTopic" 
					datasource="AppsWorkOrder"
		 			username="#SESSION.login#"
			 		password="#SESSION.dbpw#">
						UPDATE WorkOrderLineTopic
						SET Operational = 0
						WHERE WorkOrderId = '#qLine.WorkOrderId#'
						AND WorkOrderline = '#qLine.WorkOrderLine#'
						AND Topic         = '#vTopicEmail#'
						AND Operational   = 1
						AND TopicValue    = '#qServices.EmailAddress#'
	 				</cfquery>
		 			
					<cfset NewRecord( vService 	  		= vService, 
									  vOrganization 	= vOrganization,
									  vEmailAddress 	= qServices.EmailAddress,
									  vTopicEmail   	= vTopicEmail,
									  vMode				= "Add",
									  vServiceDomain	= vServiceDomain,
									  vPersonNo			= vPersonNo,
									  vFirstName		= vFirstName,
									  vLastName			= vLastName,
									  vServiceItemUnit  = vServiceItemUnit)>		 			
		 			
		 			
		 			<hr>
		 			
		 		</cfif>	
		 	
		 	<cfelse>
		 	
				<!--- If network account is matched determine if the email Address is already assigned --->
		 			<cfquery name="qTopic" 
					datasource="AppsWorkOrder"
 					username="#SESSION.login#"
	 				password="#SESSION.dbpw#">
						SELECT *
						FROM WorkOrderLineTopic T
						INNER JOIN WorkOrderLine L ON L.WorkOrderId = T.WorkOrderId and L.WorkOrderLine = T.WorkOrderLine
						INNER JOIN WorkOrder W ON W.WorkOrderId = l.WorkOrderId
						WHERE W.ServiceItem 	 =  '#vService#'
						AND L.ServiceDomainClass = 'Account'
						AND T.Topic 			 = '#vTopicEmail#'
						AND T.Operational 		 = 1
						AND T.TopicValue 		 = '#vEmailAddress#'
						AND L.Reference 		 <> '#vEmailAddress#'
		 			</cfquery>	
								
					<cfif qTopic.recordCount neq 0>
						<!--- The email is found related to an account--->
						<br>
						The email is found related to an account already
						<br>
						
						<cfquery name="qUpdate" 
							datasource="AppsWorkOrder"
 							username="#SESSION.login#"
 							password="#SESSION.dbpw#">
 			 				UPDATE [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email
 			 				SET RecordStatus ='0'
 			 				WHERE EmailAddress = '#vEmailAddress#'
		 				</cfquery>						
						
					<cfelse>	
						
						<cfif vCustomerId eq "">
							<!--- Error --->
							Error no CustomerId defined
							<br>
							The record can not be mapped
							<br>
								
						<cfelse>
								<br>
								Calling NewRecord routine
								<br>
								<cfset NewRecord( vService 	  		= vService, 
												  vOrganization 	= vOrganization,
												  vEmailAddress 	= qServices.EmailAddress,
												  vTopicEmail   	= vTopicEmail,
												  vMode				= "Add",
												  vServiceDomain	= vServiceDomain,
												  vPersonNo			= vPersonNo,
												  vFirstName		= vFirstName,
												  vLastName			= vLastName,
												  vServiceItemUnit  = vServiceItemUnit)>
							
							
						</cfif>	
						
						
					</cfif>						 		
		 		
		 		
		 		
		 	</cfif>			 	
	 	
			<br>
			<hr>
			<br>	 	
	 	
	 	
	 </cffunction>	
	 
	 
	 <cffunction name="NewRecord">
	 		<cfargument name="vService"  		type="string"  required="true"   default="">
	 		<cfargument name="vOrganization" 	type="string"  required="true"   default="">
	 		<cfargument name="vEmailAddress" 	type="string"  required="true"   default="">
			<cfargument name="vTopicEmail"  	type="string"  required="true"   default="">
			<cfargument name="vMode"		  	type="string"  required="true"   default="">
			<cfargument name="vServiceDomain"	type="string"  required="true"   default="">
			<cfargument name="vPersonNo"		type="string"  required="true"   default="">
			<cfargument name="vFirstName"		type="string"  required="true"   default="">			
			<cfargument name="vLastName"		type="string"  required="true"   default="">	 
			<cfargument name="vServiceItemUnit" type="string"  required="true"   default="'SLA06'">	
	 	

 			<cfquery name="qItemUnit" 
			datasource="AppsWorkOrder"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT	WorkOrderId	as NewWorkOrderId,
						(SELECT isnull(Max(WorkOrderLine),0) + 1 FROM WorkOrderLine L Where L.WorkOrderId = W.WorkOrderId) as NewWorkOrderLine,
						S.ServiceItemUnit,
						S.StandardCost,
						W.CustomerId,
						S.DateEffective,
						S.DateExpiration,
						S.BillingMode,
						S.Frequency							
				FROM stCustomerMapping M
				INNER JOIN WorkOrder W on  M.CustomerId = W.CustomerId
				INNER JOIN ServiceItemUnitMission S ON W.ServiceItem = S.ServiceItem and S.Mission = 'OICT' 
				INNER JOIN ServiceItemUnit U ON U.ServiceItem = S.ServiceItem AND U.Unit = S.ServiceItemUnit
				WHERE W.ServiceItem = '#vService#'
					AND M.MappingCode 	= '#vOrganization#'
					AND M.CustomerID IS NOT NULL
					AND S.DateEffective <= getdate()
					AND S.DateExpiration > getdate()
					AND U.BillingMode = 'Line'
					AND s.Operational=1
					AND U.Operational=1
					AND (M.ServiceItem = '#vService#' or M.ServiceItem IS NULL)
					AND U.Unit = '#vServiceItemUnit#'
				ORDER BY M.ServiceItem, M.created
 			</cfquery>
	 	

			<cfif qItemUnit.recordcount eq 0>
					<br>
					Error defining itemUnit
					<br>
					<cfdump var="#qItemUnit#">
					<hr>
					
			<cfelse>	
	 				<br>
	 				<cfoutput>
	 					Item Unit found : #qItemUnit.ServiceItemUnit#
	 				</cfoutput>
	 				<br>
	 				
		 			<cfquery name="qCheck" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">	 				
						SELECT Count(*) as Counter
						FROM WorkOrderLineTopic 
						WHERE WorkOrderId 	= '#qItemUnit.NewWorkOrderId#'
						AND Topic 			= '#vTopicEmail#' 
						AND Operational 	= 1
						AND TopicValue		= '#vEmailAddress#'
		 			</cfquery>	
		 			
		 			
		 			<cfif qCheck.Counter eq 0>
		 				
		 				
			 			<cfquery name="qPrevious" 
						datasource="AppsWorkOrder"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT *
							FROM WorkOrder W INNER JOIN WorkOrderLine L
							ON L.WorkOrderId = W.WorkOrderId
							WHERE L.WorkOrderId = W.WorkOrderId
							AND L.Reference 	= '#vEmailAddress#'
							AND W.ServiceItem 	= '#vService#'
							AND L.DateExpiration < getdate()						
							AND L.Operational = '1'						
			 			</cfquery>
		 				
		 				<cfif qPrevious.recordCount neq 0 and vMode neq "Move-Add">
		 					<cfset vMode = "Reinstated">
		 					<cfset vWorkOrderId = "">
		 					<cfset vWorkOrderLine = "">
		 					
		 				<cfelse>

							<!--- Determine if exists already associated to another workorder. In this case determine parent wo and woline --->
				 			<cfquery name="qParent" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
								SELECT	L.WorkOrderId,
										L.WorkOrderLine
								FROM WorkOrder W INNER JOIN WorkOrderLine L
									ON L.WorkOrderId = W.WorkOrderId 
								WHERE L.Reference = '#vEmailAddress#'
								AND W.ServiceItem = '#vService#'
								AND L.DateExpiration IS NULL				
								AND L.Operational = '1'
								AND W.WorkOrderId <> '#qItemUnit.NewWorkOrderId#'
				 			</cfquery>							
							
		 					<cfset vWorkOrderId = qParent.WorkOrderId>
		 					<cfset vWorkOrderLine = qParent.WorkOrderLine>							
							
							<cfif qParent.recordCount neq 0>
								<!--- set @NewDateEffective = @CurrentMonthEffective
								execute dbo.spDisableWorkOrderLine @WorkOrderId,@WorkOrderLine,@eMailAddress, @CurrentMonthExpiration  -- expire current record
								--->
								<br>
								We need to disable the workorderId and workOrderline
								<br>
								<hr>
							</cfif>	

		 				</cfif>	
		 				
			 			<cfquery name="qUserAccount" 
						datasource="AppsWorkOrder"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT *
							FROM WorkOrderService
							WHERE ServiceDomain = 'UserAccount'
							AND Reference = '#vEmailAddress#'		 				
			 			</cfquery>
			 			
			 			<cfif qUserAccount.recordcount eq 0>

				 			<cfquery name="qInsertWorkOrderService" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
								INSERT INTO dbo.WorkOrderService (
									ServiceDomain,
									Reference,
									OfficerUserId, 
									OfficerLastName, 
									OfficerFirstName, 
									Created)
								VALUES (
									'UserAccount',
									'#vEmailAddress#',
									'jamazariegosr',
									'jamazariegosr',
									'jamazariegosr',
									getdate()
									)
				 			</cfquery>						 				
			 				
			 			</cfif>	


							<cfset vServiceDomainClass = "Email">	
							
							<cfset vNewDateEffective = "2018-01-01">	 	
							<cfset vNewDateExpiration = "">
							
							<cfset vUnitDateEffective = qItemUnit.DateEffective>
							<cfset vUnitDateEffective = qItemUnit.DateExpiration>			

				 			<cfquery name="qInsertWorkOrderLine" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							INSERT INTO dbo.WorkOrderLine (
								WorkOrderId, 
								WorkOrderLine, 
								ServiceDomain,
								ServiceDomainClass,
								Reference, 
								DateEffective, 
								DateExpiration,
								PersonNo, 
								Operational, 
								ParentWorkOrderId,
								ParentWorkOrderLine,
								OfficerUserId, 
								OfficerLastName, 
								OfficerFirstName, 
								Created, 
								_Name)
							VALUES (
								'#qItemUnit.NewWorkOrderId#',
								'#qItemUnit.NewWorkOrderLine#',
								'#vServiceDomain#',
								'#vServiceDomainClass#',
								'#vEmailAddress#',
								'#vNewDateEffective#',
								<cfif vNewDateExpiration neq "">
									'#vNewDateExpiration#',
								<cfelse>
									NULL,	
								</cfif>	
								'#vPersonNo#',
								1,
								<cfif vWorkOrderId neq "">
									'#vWorkOrderId#',
									'#vWorkOrderLine#',
								<cfelse>
									NULL,
									NULL,
								</cfif>	
								'jamazariegosr',
								'jamazariegosr',
								'jamazariegosr',
								getdate(),
								'#vFirstName# #vLastName#')
				 			</cfquery>	
						
							<cfif qItemUnit.NewWorkOrderId neq "">
								<cfset CreateBilling(
												 NewWorkOrderId		= qItemUnit.NewWorkOrderId,
												 NewWorkOrderLine   = qItemUnit.NewWorkOrderLine,
												 vService 	  		= vService, 
												 vServiceItemUnit   = qItemUnit.ServiceItemUnit,
												 vFrequency         = qItemUnit.Frequency,
												 vBillingMode       = qItemUnit.BillingMode,
												 vStandardCost      = qItemUnit.StandardCost
												 )>
							<cfelse>
								<cfdump var="#qItemUnit#">
								<cfabort>
									
							</cfif>					 					

							<!---
							-- Add email address topic
							execute spUpdateWorkOrderLineTopic @NewWorkOrderId, @NewWorkOrderLine,@TopicEmail,@eMailAddress,@NewDateEffective 		
							execute spUpdateWorkOrderLineTopic @NewWorkOrderId, @NewWorkOrderLine,@TopicNotesId,@NotesId,@NewDateEffective
							----> 
							<br>
		 					Billing Inserted
		 					<br>
		 				
		 				
	 				<cfelse>
	 					Topic was found already. Record already mapped, no action taken
	 					<br>
						<cfquery name="qUpdate" 
							datasource="AppsWorkOrder"
 							username="#SESSION.login#"
 							password="#SESSION.dbpw#">
 			 				UPDATE [NYVM1618].STG_WarehouseOICT.dbo.IMP_OICT_WO001_email
 			 				SET RecordStatus ='0'
 			 				WHERE EmailAddress = '#vEmailAddress#'
		 				</cfquery>	 							 				
		 			</cfif>	
	 				
	 				
	 				
	 				
	 	
			</cfif>
	 	
	 	
	 </cffunction>	
	 
	 
	 <cffunction name="CreateBilling">
	 		<cfargument name="vService"  		type="string"  required="true"   default="">
			<cfargument name="NewWorkOrderId"  		type="string"  required="true"   default="">
	 		<cfargument name="NewWorkOrderLine"		type="string"  required="true"   default="">
	 		<cfargument name="vUnitDateEffective" type="string"  required="true"   default="">
	 		<cfargument name="vUnitDateExpiration" type="string"  required="true"   default="">
	 		<cfargument name="vServiceItemUnit" type="string"  required="true"   default="">
	 		<cfargument name="vFrequency" 		type="string"  required="true"   default="">
	 		<cfargument name="vBillingMode" 	type="string"  required="true"   default="">
	 		<cfargument name="vStandardCost" 	type="string"  required="true"   default="">
	 		
	 		

				 			<cfquery name="qInsertWorkOrderLineBilling" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							INSERT INTO dbo.WorkOrderLineBilling (
								WorkOrderId,
								WorkOrderLine,
								BillingEffective,
								<cfif vUnitDateExpiration neq "">
									BillingExpiration,
								</cfif>	
								OfficerUserId, 
								OfficerLastName, 
								OfficerFirstName, 
								Created)
							VALUES (
								'#NewWorkOrderId#',
								'#NewWorkOrderLine#',
								'#vUnitDateEffective#',
								<cfif vUnitDateExpiration neq "">
									'#vUnitDateExpiration#',
								</cfif>	
								'jamazariegosr',
								'jamazariegosr',
								'jamazariegosr',
								getdate())
				 			</cfquery>	

				 			<cfquery name="qInsertWorkOrderLineBillingDetail" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
								
							INSERT INTO dbo.WorkOrderLineBillingDetail (
								WorkOrderId,
								WorkOrderLine,
								BillingEffective,
								ServiceItem,
								ServiceItemUnit,
								Frequency,
								BillingMode,
								Quantity,
								Currency,
								Rate,
								OfficerUserId, 
								OfficerLastName, 
								OfficerFirstName, 
								Created)
							VALUES (
								'#NewWorkOrderId#',
								'#NewWorkOrderLine#',
								'#vUnitDateEffective#',
								 '#vService#',
								'#vServiceItemUnit#',
								'#vFrequency#',
								'#vBillingMode#',
								1,
								'USD',
								'#vStandardCost#',
								'jamazariegosr',
								'jamazariegosr',
								'jamazariegosr',
								getdate())		
				 			</cfquery>	


	 	
	 	
	 </cffunction>	
	 
	 
	 
	  <cffunction name="AD" access="public">
	<!----
		[NYVM1618].STG_warehouseOICT.dbo.IMP_OICT_WO001
		
		1. Normalize the index numbers to 8 digits.
		2. 
	---->
		
	
	
	 </cffunction>	

</cfcomponent>	
