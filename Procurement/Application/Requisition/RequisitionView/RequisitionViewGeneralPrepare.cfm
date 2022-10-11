
<!--- get the scope of the requistions that a user has access for --->

<cfinvoke component = "Service.Process.Procurement.Requisition"  
	   method           = "getQueryScope" 
	   role             = "#url.role#" 
	   mode             = "both"
	   returnvariable   = "UserRequestScope">	
	

<!--- additional query script --->

<cfsavecontent variable="SubInfo">


	  (  SELECT count(*) 
		 FROM RequisitionLineTravel
		 WHERE RequisitionNo = L.RequisitionNo						 
	  )  as IndTravel,			  
	  
	  (  SELECT count(*)
		 FROM Employee.dbo.PositionParentFunding
         WHERE RequisitionNo = L.RequisitionNo
	  )  as IndPosition,
	  	
	  (  SELECT count(*)
         FROM RequisitionLineService
         WHERE RequisitionNo = L.RequisitionNo
      )  as IndService,		
	  
	  (  SELECT CustomDialog
         FROM   Ref_EntryClass S2, ItemMaster S1
         WHERE  S2.Code = S1.EntryClass
		 AND    S1.Code = L.ItemMaster
         )  as CustomDialog,	
		 
	  (  SELECT count(*)
		 FROM   RequisitionLineTopic R, Ref_Topic S
		 WHERE  R.Topic = S.Code
		  AND    S.Operational   = 1
		  AND    R.RequisitionNo = L.RequisitionNo) as CountedTopics,	 
			 
	 (  SELECT CustomForm
         FROM ItemMaster
         WHERE Code = L.ItemMaster
         )  as CustomForm			 
				  
</cfsavecontent>

<cfsavecontent variable="AnnotationFilter">

	<cfoutput>

	<cfif url.annotationid neq "">
			
		<cfif url.annotationid eq "None">
			
			AND  L.RequisitionNo NOT IN (SELECT ObjectKeyValue1
			                         FROM   System.dbo.UserAnnotationRecord
									 WHERE  Account = '#SESSION.acc#' 
									 AND    EntityCode = 'ProcReq')	
			
		<cfelse>

			AND  L.RequisitionNo IN (SELECT ObjectKeyValue1
			                         FROM   System.dbo.UserAnnotationRecord
									 WHERE  Account = '#SESSION.acc#' 
									 AND    EntityCode = 'ProcReq' 
									 AND    AnnotationId = '#url.annotationid#')	
									 
		</cfif>						 
			
	</cfif>
	
	</cfoutput>
		
</cfsavecontent>	

<cfsavecontent variable="ScreenFilter">	

	<cfoutput>
	
		<cfif url.programcode neq "">				
		AND   L.RequisitionNo IN (SELECT RequisitionNo 
		                          FROM   RequisitionLineFunding 
								  WHERE  ProgramCode = '#url.programcode#'
								  AND    RequisitionNo = L.RequisitionNo)
		</cfif>
														
		<cfif url.filter eq "me">		 
		AND   L.OfficerUserId = '#SESSION.acc#'
		<cfelseif url.filter neq "">
		AND   L.OfficerUserId = '#url.filter#' 
		</cfif>
		
		<cfif url.find neq "">
		AND (L.Reference        LIKE '%#URL.find#%'  OR 
	       L.RequisitionNo      LIKE '%#URL.find#%'  OR 
		   L.RequestDescription LIKE '%#URL.find#%'  OR 
		   <cfif url.id neq "Loc">
		   I.Description        LIKE '%#URL.find#%'  OR 
		   </cfif>
		   L.OfficerLastName    LIKE '%#URL.find#%'  OR
		   L.OfficerFirstName   LIKE '%#URL.find#%') OR
		   L.RequisitionNo IN (SELECT RequisitionNo 
		                       FROM RequisitionLineTopic
							   WHERE RequisitionNo = L.RequisitionNo
							   AND   (CAST(TopicValue AS varchar(100)) LIKE '%#URL.find#%'))
							   
	     </cfif>	   
												
			
	</cfoutput>
		
</cfsavecontent>	


<cfswitch expression="#URL.ID#">

<cfcase value="LOC">

	<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Requisition#FileNo#">	

	<cfquery name="Set" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *				  
			INTO  userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#
			FROM  userQuery.dbo.loc#SESSION.acc#Requisition#fileNo# L
			WHERE 1=1
			
			<!--- screen filter --->
			#preservesinglequotes(screenfilter)#							
							 
			ORDER BY #URL.Sort# #URL.ID2# 
	   </cfquery>
	   
	   	
	<cfset title = "Search Result">		
				
</cfcase>

<cfcase value="AUDIT">

<!--- special view : invalid funding --->

	   <cfquery name="Mandate" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_MissionPeriod
	   WHERE  Mission = '#URL.Mission#' 
	   AND    Period  = '#URL.Period#'
	   </cfquery>
	   	   	   
		<cfif url.id1 eq "MPR">	   
		    <cfset Title="<font color='FF0000' size='5'>Program Code does not longer exist">		
		<cfelseif url.id1 eq "PRG">	   
		    <cfset Title="<font color='FF0000' size='5'>UNLIKELY program/fund/object combination">
		<cfelseif url.id1 eq "IOR">	
	   	    <cfset Title="<font color='FF0000' size='5'>OrgUnit assigned to different staffing period">
		<cfelseif url.id1 eq "FND">			
			<cfset Title="<font color='FF0000' size='5'>Incompletely Funded">
		<cfelseif url.id1 eq "IST">			
			<cfset Title="<font color='FF0000' size='3'>Invalid Status Code">	
		</cfif>	
	 	    
	    <cfquery name="Role" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_AuthorizationRole
				 WHERE  Role = '#URL.Role#' 
	    </cfquery>				

		<cfquery name="Set" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT L.*, 				
				      (SELECT Description 
					   FROM   Status 
					   WHERE  Status = L.ActionStatus
					   AND    StatusClass       = 'Requisition') as StatusDescription, 
				      
					   #preservesinglequotes(subinfo)#,
					   
				      (SELECT  RequisitionPurpose 
					   FROM    Requisition
					   WHERE   Reference = L.Reference) as RequisitionPurpose,										     
					
					  ' ' as PurchaseNo, 
					  ' ' as PurchaseStatus, 
					  ' ' as Receipt
					  
				INTO  userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#
				FROM  RequisitionLine L, 
				      Organization.dbo.Organization Org,
					  ItemMaster I 
				WHERE 1=1
				
				AND   I.Code = L.ItemMaster 	
				
				<cfif url.id1 eq "MPR">
				
					<!--- missing program --->
					AND L.RequisitionNo NOT IN  (
					                         SELECT RL.RequisitionNo
											 FROM   RequisitionLineFunding RL INNER JOIN Program.dbo.Program A ON  RL.ProgramCode = A.ProgramCode 															
											 WHERE  RL.RequisitionNo = L.RequisitionNo	
											 )		
					<!--- has a funding --->
												  
					AND  L.RequisitionNo IN (SELECT RequisitionNo 
					                         FROM   RequisitionLineFunding 
											 WHERE  RequisitionNo = L.RequisitionNo)	
										 
										 
				<cfelseif url.id1 eq "PRG">
				
					<!--- unlikely funding here as there is not budget --->
				
				    AND L.RequisitionNo NOT IN (	
					                           
						    SELECT     RL.RequisitionNo
							FROM       RequisitionLineFunding RL INNER JOIN
							           Program.dbo.ProgramAllotmentDetail A 
									     ON  RL.RequisitionNo = L.RequisitionNo
										 AND RL.ProgramCode = A.ProgramCode 
										 AND RL.Fund        = A.Fund 
										 AND RL.ObjectCode  = A.ObjectCode 
										 AND A.EditionId    = '#Mandate.EditionId#'
							WHERE      L.Mission   = '#URL.Mission#'	
							AND        L.Period    = '#URL.Period#'	 
							
							<!--- 15/4/2012 add validation for the ProgramAllocation table --->
							
							<!--- it is allowed to record these --->
							
							UNION
							
							SELECT     L.RequisitionNo
							FROM       RequisitionLine L INNER JOIN
						               RequisitionLineFunding RL ON L.RequisitionNo = RL.RequisitionNo INNER JOIN
							           Program.dbo.ProgramObject A 
									     ON  RL.ProgramCode = A.ProgramCode 
										 AND RL.Fund = A.Fund 
										<!--- AND RL.ObjectCode = A.ObjectCode --->
							WHERE      L.Mission   = '#URL.Mission#'	
							AND        L.Period    = '#URL.Period#'												
												 											 
											  )		
											  
					 <!--- has a funding record --->						  
											  
				     AND  L.RequisitionNo IN (SELECT RequisitionNo 
				                              FROM RequisitionLineFunding 
										      WHERE RequisitionNo = L.RequisitionNo)	
											  
				<cfelseif url.id1 eq "FND">
				
				<!--- not 100% funded yet but status higher than 1 --->	  
					 
				 AND L.RequisitionNo NOT IN  (SELECT   RequisitionNo
						                      FROM     RequisitionLineFunding
											  WHERE    RequisitionNo = L.RequisitionNo
						                      GROUP BY RequisitionNo
						                      HAVING   SUM(Percentage) = 1.0)							  	
										 
				<cfelseif url.id1 eq "IST">
				
				 <!--- has a funding record --->						  
											  
				 AND  L.ActionStatus NOT IN (SELECT Status 
				                              FROM Status 
										      WHERE StatusClass = 'Requisition')	
										 
				</cfif>						 						  
								
				AND   Org.Mission         = '#URL.Mission#'
				AND   L.Period            = '#URL.Period#'
				
				<cfif url.id1 eq "IOR">
					<!--- invalud orgunit --->
				AND   Org.MandateNo      != '#Mandate.MandateNo#' <!--- different mandate --->
				<cfelse>
				AND   Org.MandateNo       = '#Mandate.MandateNo#'
				</cfif>
				
				AND   Org.OrgUnit         = L.OrgUnit				
				AND   L.ActionStatus NOT IN ('0','1','0z','9')		    	
				AND   L.ItemMaster is not NULL
				AND   L.RequestType       IN ('Regular','Warehouse')  				
								
				<!--- screen filter --->
				#preservesinglequotes(screenfilter)#
								
				<!--- annotation filter --->
				#preservesinglequotes(annotationfilter)#					
				
				<cfif getAdministrator(url.mission) eq "1">
					<!--- no filtering --->					
				<cfelse>
					AND  #preserveSingleQuotes(UserRequestScope)# 					
				</cfif>					
				 
				ORDER BY #URL.Sort# #URL.ID2#
		   </cfquery>

</cfcase>

<!--- ------------------- --->
<!--- Main view by status --->
<!--- ------------------- --->


<cfcase value="STA">
	
	   <cfquery name="Mandate" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT MandateNo
		   FROM   Ref_MissionPeriod
		   WHERE  Mission = '#URL.Mission#' 
		   AND    Period  = '#URL.Period#'
	   </cfquery>
	   		
	   <cfquery name="status"
   		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT StatusDescription
			FROM   Status
			WHERE  StatusClass = 'Requisition'
			AND    Status      = '#URL.ID1#'
		</cfquery>		
			 
       <cfset Title="#Status.StatusDescription#">
	   
	   <cfparam name="URL.ID2" default="">
	   	   			 
	   <cfif URL.ID2 eq "">	
	       			
	   	     <cfquery name="Set" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT L.*, 
						
							  (SELECT Description 
							   FROM   Status 
							   WHERE  Status = L.ActionStatus
							   AND    StatusClass       = 'Requisition') as StatusDescription, 
						
							   #preservesinglequotes(subinfo)#,							   
						
							   (SELECT  RequisitionPurpose 
						     	  FROM  Requisition
								 WHERE  Reference = L.Reference) as RequisitionPurpose,
						
							       (SELECT TOP 1  left(U.FirstName,1)+'. '+U.LastName 
								     FROM  RequisitionLineActor A, System.dbo.UserNames U
								     WHERE RequisitionNo = L.RequisitionNo
									 AND   A.ActorUserId = U.Account
								     AND   A.Role = 'ProcBuyer') as Buyer,
						      							  
							   ' ' as PurchaseNo, 
							   ' ' as PurchaseStatus, 
							   ' ' as Receipt
							   
						INTO    UserQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#
						
						FROM    RequisitionLine L INNER JOIN
                      			Organization.dbo.Organization Org ON L.OrgUnit = Org.OrgUnit  INNER JOIN
								ItemMaster I ON I.Code = L.ItemMaster 	         
																	 
						WHERE L.ActionStatus = '#URL.ID1#'
						
						<!--- ensure line belong to the orgunit of the mandate which is selected --->										
						
						AND   Org.Mission         = '#URL.Mission#'   
				    	AND   Org.MandateNo       = '#Mandate.MandateNo#'			
						AND   L.Period            = '#URL.Period#'							
				    	
						AND   L.RequestType IN ('Regular','Warehouse')  <!--- exclude purchase generated lines --->						
	
						<!--- disabled for now 									
						<cfif URL.Role eq "ProcManager" or URL.Role eq "ProcCertify">
						AND   L.ActionStatus >= '1p'  
						</cfif>
						--->
						
						<!--- limits the request only to line to which the user has some access, including inquiry access --->
						
						<cfif getAdministrator(url.mission) eq "1">
						   <!--- no filtering --->
						<cfelse>
							AND  #preserveSingleQuotes(UserRequestScope)# 					
						</cfif>
						
						<!--- screen filter --->
						#preservesinglequotes(screenfilter)#						
													
						<!--- annotation filter --->
						#preservesinglequotes(annotationfilter)#
																		 
						ORDER BY #URL.Sort# <cfif url.sort eq "RequestDate">DESC</cfif> #URL.ID2# 
				   </cfquery>				   				   
				  				 							   
	   <cfelse>
	   	   	   
		   <!--- purchase --->	
		 		 		  		   		   
		  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Requisition_N#FileNo#"> 	
		  
		  <cftransaction isolation="READ_UNCOMMITTED">
		  
	      <cfquery name="Set" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
			
			SELECT L.*, 	
			
				   (SELECT Description 
					FROM   Status 
					WHERE  Status = L.ActionStatus
					AND    StatusClass       = 'Requisition') as StatusDescription, 
					
				   #preservesinglequotes(subinfo)#,								
				   
				   (SELECT  RequisitionPurpose 
			     	  FROM  Requisition
					 WHERE  Reference = L.Reference) as RequisitionPurpose,											 
			      
				   P.PurchaseNo, 
				   PH.ActionStatus   as PurchaseStatus, 
				   PH.ObligationStatus,
				   P.OrderQuantity   as PurchaseQuantity,
				   P.OrderAmount     as PurchaseLineValue,
				   P.OrderAmountBase as PurchaseValue,
				   R.ReceiptEntry,				   
				   R.InvoiceWorkflow,
				   
				     (SELECT count(*) 
				     FROM   PurchaseLineReceipt
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as Receipt,
					 
					 (SELECT sum(ReceiptAmountBase) 
				     FROM   PurchaseLineReceipt
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as ReceiptValue, 
					 
					 (SELECT sum(ReceiptQuantity) 
				     FROM   PurchaseLineReceipt
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as ReceiptQuantity, 
					 
					 (SELECT count(*) 
				     FROM   InvoicePurchase
					 WHERE  PurchaseNo = P.PurchaseNo) as Invoiced,
					 
					 <!--- CMP mode, invoices are matched on the line --->
					 
					 (SELECT SUM(AmountMatched) 
				     FROM   InvoicePurchase
					 WHERE  RequisitionNo = P.RequisitionNo) as InvoiceLineValue										 
					 					 
			INTO   userQuery.dbo.tmp#SESSION.acc#Requisition_N#fileNo#
			
			FROM            RequisitionLine AS L INNER JOIN
                         PurchaseLine AS P ON L.RequisitionNo = P.RequisitionNo INNER JOIN
                         Purchase AS PH ON P.PurchaseNo = PH.PurchaseNo INNER JOIN
                         Ref_OrderType AS R ON PH.OrderType = R.Code INNER JOIN
                         Organization.dbo.Organization AS Org ON L.OrgUnit = Org.OrgUnit INNER JOIN
                         ItemMaster AS I ON L.ItemMaster = I.Code INNER JOIN
                         Status AS S ON L.ActionStatus = S.Status
			
							 
			WHERE  Org.Mission         = '#URL.Mission#'
	    	AND    Org.MandateNo       = '#Mandate.MandateNo#'
			
			AND    L.ActionStatus      = '#URL.ID1#'  <!--- 3 --->			
			AND    L.RequestType       IN ('Regular','Warehouse') 										
	    	AND    S.StatusClass       = 'Requisition'
			AND    L.Period            = '#URL.Period#'
			
			<!--- screen filter --->
			#preservesinglequotes(screenfilter)#			
											
			<!--- annotation filter --->
			#preservesinglequotes(annotationfilter)#
						
			<cfif getAdministrator(url.mission) eq "1">
			    <!--- no filtering --->
			<cfelse>
				AND  #preserveSingleQuotes(UserRequestScope)# 					
			</cfif>				
											
			ORDER BY #URL.Sort# <cfif url.sort eq "RequestDate">DESC</cfif>
						
			</cfquery>				
									
			<!---		
				<cfoutput>#cfquery.executiontime#</cfoutput>									
				<cftry>			
			--->
			
			
												   		   
		   <cfquery name="Set" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
			SELECT DISTINCT RequisitionNo, 
			                RequestDescription,
							RequisitionPurpose,
							RequestType,
							RequestDate,
							RequestDue,
							Reference,
							PersonNo,
							RequestPriority,
							ActionStatus,
							ItemMaster,
							IndTravel,
							IndPosition,
							IndService,
							countedTopics,
							CustomDialog,
							Warehouse,
							WarehouseItemNo,
							WarehouseUoM,
							CustomForm,
							PurchaseNo,
							PurchaseStatus,
							RequestQuantity,
							RequestCostPrice,
							RequestAmountBase,
							OfficerUserId,
							OfficerFirstName,
							OfficerLastName,
							Created
							
			INTO   userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#
			
			FROM   userQuery.dbo.tmp#SESSION.acc#Requisition_N#fileNo#
							
			<cfif URL.ID2 eq "ReceiptPartial"> 
			
			WHERE  Receipt > 0 
					AND 
					
					(
						    <!--- open contract --->
						
				    	(PurchaseValue > ReceiptValue and ReceiptEntry = 1)
						
								      OR
										   
							<!--- reqular purchase --->
										   
						(PurchaseQuantity > ReceiptQuantity and ReceiptEntry = 0)
					
					)
					
			<cfelseif URL.ID2 eq "ReceiptFull"> 
				
			WHERE  Receipt > 0 AND
			
			      (
						    <!--- open contract --->
						
				    	(PurchaseValue <= ReceiptValue and ReceiptEntry = 1)
						
								      OR
										   
							<!--- reqular purchase --->
										   
						(PurchaseQuantity <= ReceiptQuantity and ReceiptEntry = 0)
					
					)
			
					
			<cfelseif URL.ID2 eq "Invoice" and Parameter.InvoiceRequisition eq "0">
			
			WHERE  Invoiced > 0 and PurchaseStatus != '4' and ObligationStatus = '1'						
			
			<cfelseif URL.ID2 eq "InvoiceFull" and Parameter.InvoiceRequisition eq "0">
			
			WHERE  ((Invoiced > 0 and PurchaseStatus = '4') or ObligationStatus = '0')
			
			<cfelseif URL.ID2 eq "Invoice" and Parameter.InvoiceRequisition eq "1">  <!--- UN Mode --->
			
			WHERE  Invoiced > 0 and PurchaseLineValue > InvoiceLineValue 						
			
			<cfelseif URL.ID2 eq "InvoiceFull" and Parameter.InvoiceRequisition eq "1"> <!--- UN mode --->
			
			WHERE  Invoiced > 0 and PurchaseLineValue <= InvoiceLineValue
			
			<cfelse>	
			
			<!--- default mode, only a purchase order, no receipt, no invoice at all --->		
			WHERE Receipt = 0 AND Invoiced = 0
			
			</cfif>	
											
		   </cfquery>
		   
		   </cftransaction>
		   
		   <!---
		   
		   <cfcatch>
		   
		   		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Requisition_N#FileNo#">
			    <cfabort>
				
		   </cfcatch>
		   
		   </cftry>
		   
		   <cfoutput>#cfquery.executiontime#</cfoutput>			
		   
		   --->		 		     
    	   
	   </cfif>
	   
	   <cfquery name="SearchResult" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		    SELECT  Description
		    FROM    Status
		    WHERE   Status     = '#URL.ID1#' 
			AND     StatusClass= 'Requisition'
	   </cfquery>
	  	      
</cfcase>

<!--- ------------------- --->
<!--- Main view by orguni --->
<!--- ------------------- --->

<cfcase value="ORG">

   <cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM Organization
   WHERE OrgUnit = '#URL.ID1#' 
   </cfquery>
     
   <cfset Title="#Org.OrgUnitName#">
       
   <cf_OrganizationSelect OrgUnit = "#URL.ID1#">
   
    <cfquery name="Role" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AuthorizationRole
			WHERE Role = '#URL.Role#' 
	</cfquery>
	      
   <cfquery name="Set" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT L.*, 
		
			   (SELECT Description 
				FROM   Status 
				WHERE  Status = L.ActionStatus
				AND    StatusClass       = 'Requisition') as StatusDescription, 
				
				#preservesinglequotes(subinfo)#,		
				
			   (SELECT  RequisitionPurpose 
		     	  FROM  Requisition
				 WHERE  Reference = L.Reference) as RequisitionPurpose,
					      
			   (SELECT PurchaseNo 
				     FROM   PurchaseLine
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as PurchaseNo,
			   (SELECT ActionStatus 
				     FROM   PurchaseLine
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as PurchaseStatus			
		INTO   UserQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#	 
		FROM   RequisitionLine L, 		      
		       Organization.dbo.Organization MO,
			   ItemMaster I
		WHERE  MO.Mission         = '#Org.Mission#'
		 AND   MO.MandateNo       = '#Org.MandateNo#'
		 AND   MO.HierarchyCode  >= '#HStart#' 
		 AND   MO.HierarchyCode   < '#HEnd#'
		 AND   L.OrgUnit         = MO.OrgUnit
		 AND   I.Code            = L.ItemMaster 	         
		 AND   L.Period          = '#URL.Period#'
		 
		 AND   L.ActionStatus != '0'				
		 AND   L.RequestType IN ('Regular','Warehouse')				
		 
		 <!--- 10/4/2012 unclear why this was added but it is also used in the nodes --->
		 
		 <cfif URL.Role eq "ProcManager" or URL.Role eq "ProcCertify">
		 AND   L.ActionStatus >= '1p'   
		 </cfif>		 
		 		 
		 <cfif getAdministrator(url.mission) eq "1">
		        <!--- no filter --->
		  <cfelse>
				AND  #preserveSingleQuotes(UserRequestScope)# 					
		 </cfif>	
		 
		 <!--- screen filter --->
		 #preservesinglequotes(screenfilter)#		 
		 		 	 	
		 <!--- annotation filter --->
		 #preservesinglequotes(annotationfilter)#
		 		 
		 ORDER BY #URL.Sort#
   </cfquery>
      
   <!--- staffing mandate --->
   
   <cfquery name="SearchResult" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT distinct O.*
		FROM #CLIENT.LanPrefix#Organization O
		WHERE O.Mission        = '#Org.Mission#'
		 AND O.MandateNo       = '#Org.MandateNo#'
		 AND O.HierarchyCode  >= '#HStart#' 
		 AND O.HierarchyCode   < '#HEnd#'
		 <!---
		 AND (O.DateExpiration > '#DateFormat(DisplayPeriod.DateEffective,client.dateSQL)#' OR O.DateExpiration is NULL)
		 AND  O.DateEffective  < '#DateFormat(DisplayPeriod.DateExpiration,client.dateSQL)#'
		 --->
		 AND O.OrgUnit IN (SELECT OrgUnit FROM UserQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#)
		ORDER BY O.HierarchyCode
   </cfquery>
      	
</cfcase>

<cfcase value="WRF">



</cfcase>

<cfcase value="WOR">

   <cfquery name="Ser" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   ServiceItem
   WHERE Code = '#URL.ID1#' 
   </cfquery>
     
   <cfset Title="#Ser.Description#">   
   
    <cfquery name="Role" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AuthorizationRole
			WHERE Role = '#URL.Role#' 
	</cfquery>
      
   <cfquery name="Set" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT L.*, 
		
			   (SELECT Description 
				FROM   Status 
				WHERE  Status = L.ActionStatus
				AND    StatusClass       = 'Requisition') as StatusDescription, 
				
				#preservesinglequotes(subinfo)#,		
				
			   (SELECT  RequisitionPurpose 
		     	  FROM  Requisition
				 WHERE  Reference = L.Reference) as RequisitionPurpose,
					      
			   (SELECT PurchaseNo 
				     FROM   PurchaseLine
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as PurchaseNo,
			   (SELECT ActionStatus 
				     FROM   PurchaseLine
					 WHERE  RequisitionNo = L.RequisitionNo
					 AND    ActionStatus != '9') as PurchaseStatus			
					 
		INTO   userQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#	 
		
		FROM   RequisitionLine L, 		      
		       Organization.dbo.Organization MO,
			   ItemMaster I
			   
		WHERE  L.WorkOrderid IN (SELECT WorkOrderId 
		                         FROM   Workorder.dbo.WorkOrder 
								 WHERE  WorkOrderid = L.WorkOrderId
								 AND    ServiceItem = '#url.id1#')
								 
		<cfif url.id2 eq "FP">
			AND    L.RequirementId NOT IN (SELECT ResourceId FROM WorkOrder.dbo.WorkOrderLineResource WHERE ResourceId = L.RequirementId)
		<cfelseif url.id2 eq "RAW">
	        AND    L.RequirementId IN (SELECT ResourceId FROM WorkOrder.dbo.WorkOrderLineResource WHERE ResourceId = L.RequirementId)	
		</cfif>						 
				
		 AND   L.OrgUnit       = MO.OrgUnit
		 AND   L.Period        = '#URL.Period#'		 
		 AND   I.Code          = L.ItemMaster 	         
		 
		 AND   L.ActionStatus != '0'				
		 AND   L.RequestType IN ('Regular','Warehouse')				
		 
		 <!--- 10/4/2012 unclear why this was added but it is also used in the nodes --->
		 
		 <cfif URL.Role eq "ProcManager" or URL.Role eq "ProcCertify">
		 AND   L.ActionStatus >= '1p'   
		 </cfif>		 
		 		 
		 <cfif getAdministrator(url.mission) eq "1">
		        <!--- no filter --->
		 <cfelse>
				AND  #preserveSingleQuotes(UserRequestScope)# 					
		 </cfif>	
		 
		 <!--- screen filter --->
		 #preservesinglequotes(screenfilter)#		 
		 		 	 	
		 <!--- annotation filter --->
		 #preservesinglequotes(annotationfilter)#
		 		 
		 ORDER BY #URL.Sort#
   </cfquery>
    
      	
</cfcase>

<!--- -------------------------------------------------------------- --->
<!--- called from the stock or whs item dialog to show ordered items --->
<!--- -------------------------------------------------------------- --->

<cfcase value="WHS">

   <cfset Title="">    
   
   <cfparam name="url.itemno" default="">    
   <cfparam name="url.uom" default="">   
   	
   <cfquery name="Set" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    <!--- lines with purchaseno --->
		
		SELECT L.*, 	
		
			   #preservesinglequotes(subinfo)#,			
			
			   (SELECT  RequisitionPurpose 
		     	  FROM  Requisition
				 WHERE  Reference = L.Reference) as RequisitionPurpose,
								 
		       S.Description as StatusDescription, 
			   P.PurchaseNo, 
			   P.ActionStatus as PurchaseStatus
		INTO   UserQuery.dbo.tmp#SESSION.acc#Requisition#fileNo#	 
		FROM   RequisitionLine L, 
		       PurchaseLine P,
		       Organization.dbo.Organization O, 
			   Status S,
			   ItemMaster I
		WHERE  L.Mission = '#URL.mission#' 
		 AND   L.RequisitionNo = P.RequisitionNo			
		 AND   S.Status      = L.ActionStatus
		 AND   I.Code = L.ItemMaster 	         
		 
		 AND   S.StatusClass = 'Requisition'		 
		 <!--- in purchase status --->	 	
		 
		 AND   L.ActionStatus = '3'	
		 AND   L.RequestType IN ('Warehouse')	 
		 		 
		 <!--- not cancelled --->
		 AND   P.ActionStatus != '9'	
		 AND   L.OrgUnit     = O.OrgUnit
		 AND   P.DeliveryStatus < '3' <!---  partial delivery or pending --->			 
		 
		 <!--- not likely for this --->
		 <cfif url.period neq "">
		 AND   L.Period      = '#URL.Period#'
		 </cfif>
		 
		 <!--- we might have to drop this requirement in some cases as warehouse is not defined --->
		 <cfif url.warehouse neq "">
		 AND   (L.Warehouse       = '#URL.Warehouse#' or L.Warehouse is NULL)
		 </cfif>
		 		 
		 <cfif url.itemno neq "">
		 AND   L.WarehouseItemNo = '#URL.ItemNo#'		
		 AND   L.WarehouseUoM    = '#URL.UoM#'							 						 
		 </cfif>
		 
		 AND   L.WarehouseItemNo IN (SELECT ItemNo
		                             FROM   Materials.dbo.Item
									 WHERE  ItemNo = L.WarehouseItemNo)
		 
				 		 
		 UNION ALL
		 
		 <!--- lines without purchaseno --->
		 
		 SELECT L.*, 	
		 
		 		#preservesinglequotes(subinfo)#,			 
		 	
			   (SELECT  RequisitionPurpose 
		     	  FROM  Requisition
				 WHERE  Reference = L.Reference) as RequisitionPurpose,
								 	
		       S.Description as StatusDescription, 
			   '' as PurchaseNo, 
			   '' as PurchaseStatus		
		FROM   RequisitionLine L, 		    
		       Organization.dbo.Organization O, 
			   Status S,
			   ItemMaster I
			   
		 WHERE L.Mission       = '#URL.mission#' 
		 AND   S.Status        = L.ActionStatus
		 AND   S.StatusClass   = 'Requisition'
		 AND   I.Code          = L.ItemMaster 	         
		 <!--- in requisition status --->
		 AND   (L.ActionStatus > '0' AND L.ActionStatus < '2q')
		 AND   L.ActionStatus != '0'	
		 AND   L.OrgUnit       = O.OrgUnit		 
		 AND   L.RequestType IN ('Warehouse')
		 <cfif url.period neq "">
		 AND   L.Period        = '#URL.Period#'
		 </cfif>		 
		  <!--- not likely for this --->
		 <cfif url.warehouse neq "">
		 AND   (L.Warehouse    = '#URL.Warehouse#' or L.Warehouse is NULL)
		 </cfif>
		 		 
		 <cfif url.itemno neq "">
		 AND   L.WarehouseItemNo = '#URL.ItemNo#'
		 AND   L.WarehouseItemNo IN (SELECT ItemNo
		                             FROM Materials.dbo.Item
									 WHERE ItemNo = L.WarehouseItemNo)
		 AND   L.WarehouseUoM    = '#URL.UoM#'							 
		 <cfelse>
		 AND   L.WarehouseItemNo IN (SELECT ItemNo
		                             FROM Materials.dbo.Item
									 WHERE ItemNo = L.WarehouseItemNo)						 
		 </cfif>
		
		
		 AND   L.RequisitionNo NOT IN (SELECT RequisitionNo	
		                               FROM   PurchaseLine 
									   WHERE  RequisitionNo = L.RequisitionNo
									   AND    ActionStatus != '9')
		 ORDER BY #URL.Sort# <cfif url.sort eq "RequestDate">DESC</cfif>, L.ActionStatus		 
		 		
   </cfquery>   
                  	
</cfcase>

</cfswitch>


