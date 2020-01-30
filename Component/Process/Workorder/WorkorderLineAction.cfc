
<!--- ----------------------------------------------------------------------------------------------- --->
<!--- Component to serve requests that relate to the actions associated to a service or production -- ---> 
<!--- ----------------------------------------------------------------------------------------------- --->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<!--- internal method to get actions, used by the Portal --->
	<cffunction name="getActions"
        access="public"
        returntype="any" 
        displayname="getActions">
				
			<cfargument name="workOrderId" 				type="string" required="true" 	default="">
			<cfargument name="date" 					type="string" required="true" 	default=""> 
			<cfargument name="entryMode"			 	type="string" required="false" 	default="Batch">
			<cfargument name="getOnlyVisibleActions" 	type="string" required="false" 	default="1">
			<cfargument name="ActionTopic"			 	type="string" required="false" 	default="AC001">
			<cfargument name="ActionTopicValue"		 	type="string" required="false" 	default="true">
			
			<CF_DateConvert Value="#date#" output="no">
			<cfset DTE = dateValue>			
						
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT  WA.ActionClass,
		   					A.Description  as ActionDescription,
							A.ListingOrder as ActionListingOrder,
							R.Code,
				   		    R.Description,
						    R.ListingOrder,
						    WL.Reference,
						    S.Description as ReferenceDescription,			  
				            WA.DateTimePlanning, 
							CONVERT(VARCHAR(10),WA.DateTimePlanning,120) AS DateDatetimePlanning,
							SUBSTRING(CONVERT(VARCHAR(20),WA.DateTimePlanning,120), 12, 5) AS HourDateTimePlanning,
						    WA.DateTimeActual,
							CONVERT(VARCHAR(10),WA.DateTimeActual,120) AS DateDateTimeActual,
							YEAR(WA.DateTimeActual)   AS YearDateTimeActual,
							MONTH(WA.DateTimeActual)  AS MonthDateTimeActual,
							DAY(WA.DateTimeActual)    AS DayDateTimeActual,
							SUBSTRING(CONVERT(VARCHAR(20),WA.DateTimeActual,120), 12, 5) AS HourDateTimeActual,
						    WA.ActionMemo,
						    WA.ActionStatus,
						    WA.ActionOfficerUserId,
						    WA.ActionOfficerFirstName,
						    WA.ActionOfficerLastName,			  
						    WA.WorkActionId,				
							WA.WorkOrderLine,
							WA.ScheduleId,							
							Ac.Description AS ActionClassDescription,
							
							CASE 
								WHEN (WA.DateTimeActual IS NOT NULL AND WA.ActionStatus = '3') THEN 1 ELSE 0 END as Completed,
							
							(
								SELECT	COUNT(*)
								FROM	System.dbo.Attachment P with (nolock)
								WHERE 	P.Reference = CONVERT(VARCHAR(36),WA.WorkActionId)
								AND 	P.FileStatus <> '9'
								AND		SUBSTRING(P.FileName,LEN(P.FileName)-2,LEN(P.FileName)) IN ('JPG', 'PNG', 'GIF')
								AND		DATEADD(dd, 0, DATEDIFF(dd, 0, WA.DateTimePlanning)) = #DTE#
							) Pictures,							
											
							<!--- determine manual actions --->
							
							(SELECT count(*) 
							 FROM  WorkorderLineAction SL with (nolock) INNER JOIN Ref_Action SR with (nolock) ON SL.ActionClass = SR.Code
							 WHERE SL.WorkOrderId   = WL.WorkOrderId 
							 AND   SL.WorkOrderLine = WL.WorkOrderLine
							 AND   SR.EntryMode     = 'Manual'
							 AND   SL.ActionStatus = '1') as Manual							 
						  
				   FROM     WorkOrderLine WL WITH (NOLOCK)
				   			INNER JOIN WorkOrderLineAction WA  WITH (NOLOCK)       ON WL.WorkOrderId = WA.WorkorderId AND WL.WorkOrderLine = WA.WorkorderLine 
							INNER JOIN Ref_Action A 		   WITH (NOLOCK)       ON WA.ActionClass = A.Code 
							INNER JOIN Ref_ServiceItemDomainClass R  WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain 	AND WL.ServiceDomainClass = R.Code 		
							INNER JOIN WorkOrderService S 			 WITH (NOLOCK) ON WL.ServiceDomain = S.ServiceDomain 	AND WL.Reference = S.Reference
							INNER JOIN Ref_Action Ac				 WITH (NOLOCK) ON WA.ActionClass = Ac.Code
														
							<cfif trim(lcase(entryMode)) eq "batch">
							<!--- this will show scheduled actions only --->
							INNER JOIN WorkOrderLineSchedule WOLS WITH (NOLOCK) ON WA.ScheduleId = WOLS.ScheduleId AND WOLS.ActionStatus = '1'
							</cfif>
						  
				   WHERE    WL.WorkOrderId   = '#workorderid#'		
				   AND      WL.Operational   = 1
				   AND      WL.DateEffective <= #DTE# AND (WL.DateExpiration is NULL or WL.DateExpiration >= #DTE#)
				   AND		WA.ActionStatus <> '9'
				  			  
				   <cfif entryMode eq "Manual">		
				   				   		
				   <!--- pending or selected date --->		  
				   AND	  (WA.ActionStatus = '1' or DATEADD(dd, 0, DATEDIFF(dd, 0, WA.DateTimePlanning)) = #DTE#)
				   AND    WA.ActionClass IN (SELECT Code 
				                             FROM   Ref_Action 
											 WHERE  Code      = WA.ActionClass
											 AND    EntryMode = '#entryMode#')
											 
																						 
				   <cfelseif entryMode eq "Batch">					   
				 
					AND    DATEADD(dd, 0, DATEDIFF(dd, 0, WA.DateTimePlanning)) = #DTE# <!--- selected date only --->		
				    AND    WA.ActionClass IN (SELECT Code 
				                             FROM   Ref_Action 
											 WHERE  Code      = WA.ActionClass
											 AND    EntryMode = '#entryMode#')
											 
				   					 
				   </cfif>					
							
									 
				   <cfif getOnlyVisibleActions eq "1">
				   
				   <!--- only visible actions --->
				   AND		EXISTS
				   			(
								SELECT 	'X'
								FROM	WorkOrderLineActionTopic WITH (NOLOCK)
								WHERE	Topic        = '#actiontopic#'
								AND		TopicValue   = '#actiontopicvalue#'
								AND		WorkActionId = WA.WorkActionId
							)
				   </cfif>
				   
					
				   <!--- sort by class, object and activity time --->
				   ORDER BY  A.ListingOrder,
				   			 WA.ActionClass,
				   			 R.ListingOrder, 
				             R.Description, 
							 WL.Reference, 
							 WA.DateTimePlanning ASC
			</cfquery>
			
			<cfreturn get>
		
	</cffunction>
	
	<!--- public method used in the app to get actions --->
	
	<cffunction name="getActionsByIdDate"
	        access="remote"
	        returntype="any" 
			returnformat="plain" 
			output="No"
	        displayname="getActionsByIdDate">
		
			<cfargument name="callback" 	type="string" required="false">
			<cfargument name="workOrderId" 	type="string" required="true" default="">
			<cfargument name="date" 		type="string" required="true" default=""> <!--- must be in yyyy-mm-dd format --->
			
			<cfset vDate = createDate(mid(date,1,4), mid(date,6,2), mid(date,9,2))>
			<!--- sets basic application and client variables --->
			<cf_MobileInit>
			
			<cfinvoke component 	= "Service.Process.WorkOrder.WorkOrderLineAction"  
				   method           = "getActions" 
				   workOrderId      = "#WorkOrderId#" 
				   date				= "#dateFormat(vDate, client.DateFormatShow)#"
				   returnvariable   = "get">
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="getCustomersWorkOrders"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getCustomersWorkOrders">
		
			<cfargument name="callback" type="string" required="false">
		
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	ISNULL(PO.OrgUnit,-1) as ParentCustomerId,
							ISNULL(PO.OrgUnitName,'Otros') as ParentCustomer,
							W.CustomerId,
							C.CustomerName,
							W.WorkOrderId,
							W.Reference,
							W.OrderMemo
					FROM	Workorder W WITH (NOLOCK)
							INNER JOIN Customer C WITH (NOLOCK)
								ON W.CustomerId = C.CustomerId
							INNER JOIN Organization.dbo.Organization O WITH (NOLOCK)
								ON C.OrgUnit = O.OrgUnit
							LEFT OUTER JOIN Organization.dbo.Organization PO WITH (NOLOCK)
								ON O.ParentOrgUnit = PO.OrgUnitCode
					WHERE	EXISTS (SELECT 'X' FROM WorkOrderLineAction WITH (NOLOCK) WHERE WorkOrderId = W.WorkOrderId)
					ORDER BY PO.OrgUnit, PO.OrgUnitName ASC, C.CustomerName ASC, W.ListingOrder ASC
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="getCustomersWorkOrdersByUser"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getCustomersWorkOrdersByUser">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="hostSessionId" 	type="string" required="true">
			<cfargument name="mission"		 	type="string" required="true">
			
			<cfset SESSION.isAdministrator = "No">
			<cfset vAccessCondition = "AND 	1=0">
			
			<cfquery name="User" 
				datasource="appsSystem"> 
					SELECT TOP 1
							U.*
					FROM    UserNames U
							INNER JOIN UserStatus S
								ON U.Account = S.Account
					WHERE   S.HostSessionId = '#hostSessionId#'
					AND 	S.ActionExpiration = 0
			</cfquery>
			
			<cfif User.recordCount eq 1>
			
				<cfset SESSION.acc = User.Account>
				
				<cfif SESSION.acc eq "administrator">
					<cfset SESSION.isAdministrator = "Yes">   
				<cfelse>     
					<cfquery name="Support" 
						datasource="AppsOrganization">
						SELECT    UserAccount
						FROM      OrganizationAuthorization
						WHERE     Role        = 'Support'
						AND       UserAccount = '#SESSION.acc#'
					</cfquery>
					<cfif Support.recordcount eq "1">
						<cfset SESSION.isAdministrator = "Yes">  
					</cfif>
				</cfif>
			
				<cfquery name="Roles" 
					datasource="appsOrganization"> 
					SELECT    Role
					FROM      Ref_AuthorizationRole
					WHERE     SystemModule = 'WorkOrder'	
				</cfquery>
				
				<cfinvoke component = "Service.Access"  
				    method           = "WorkorderAccessList" 
					mission          = "#mission#" 	  
					Role             = "#QuotedvalueList(Roles.Role)#"
					returnvariable   = "AccessList">
			
				<cfif len(AccessList) neq 0>
					<cfset vAccessCondition = "AND W.WorkOrderId IN (#preserveSingleQuotes(AccessList)#)">
				</cfif>
			
			</cfif>
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	ISNULL(PO.OrgUnit,-1) as ParentCustomerId,
							ISNULL(PO.OrgUnitName,'Otros') as ParentCustomer,
							W.CustomerId,
							C.CustomerName,
							W.WorkOrderId,
							W.Reference,
							W.OrderMemo
					FROM	Workorder W WITH (NOLOCK)
							INNER JOIN Customer C WITH (NOLOCK)
								ON W.CustomerId = C.CustomerId
							INNER JOIN Organization.dbo.Organization O WITH (NOLOCK)
								ON C.OrgUnit = O.OrgUnit
							LEFT OUTER JOIN Organization.dbo.Organization PO WITH (NOLOCK)
								ON O.ParentOrgUnit = PO.OrgUnitCode
					WHERE	EXISTS (SELECT 'X' FROM WorkOrderLineAction WITH (NOLOCK) WHERE WorkOrderId = W.WorkOrderId)
					<cfif SESSION.isAdministrator neq "Yes">
						#preserveSingleQuotes(vAccessCondition)#
					</cfif>
					ORDER BY PO.OrgUnit, PO.OrgUnitName ASC, C.CustomerName ASC, W.ListingOrder ASC
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="getPicturesByWorkOrderDate"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getPicturesByWorkOrderDate">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="workOrderId" 		type="string" required="true" default="">
			<cfargument name="date" 			type="string" required="true" default=""> <!--- must be in yyyy-mm-dd format --->
			<cfargument name="hostSessionId" 	type="string" required="true">
			
			<cfquery name="User" 
				datasource="appsSystem"> 
					SELECT TOP 1
							U.*
					FROM    UserNames U
							INNER JOIN UserStatus S
								ON U.Account = S.Account
					WHERE   S.HostSessionId = '#hostSessionId#'
					AND 	S.ActionExpiration = 0
			</cfquery>
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	'#hostSessionId#' as HostSessionId
			</cfquery>
			
			<cfif User.recordCount eq 1>
			
				<cfset isAdministrator = 0>
				<cfif User.Account eq "administrator">
					<cfset isAdministrator = 1>
				<cfelse>     
					<cfquery name="Support" 
						datasource="AppsOrganization">
						SELECT    UserAccount
						FROM      OrganizationAuthorization
						WHERE     Role        = 'Support'
						AND       UserAccount = '#User.Account#'
					</cfquery>
					<cfif Support.recordcount eq "1">
						<cfset isAdministrator = 1>
					</cfif>
				</cfif>
			
				<cfquery name="get"
					datasource="AppsWorkOrder">
					    SELECT	P.Reference,
								P.AttachmentId,
								(P.ServerPath + P.FileName) as PicturePath,
								P.AttachmentMemo,
								P.OfficerFirstName,
								P.OfficerLastName,
								P.Created,
								CONVERT(VARCHAR(10),P.Created,120) as DateCreated,
								YEAR(P.Created) AS YearCreated,
								MONTH(P.Created) AS MonthCreated,
								DAY(P.Created) AS DayCreated,								
								SUBSTRING(CONVERT(VARCHAR(20),P.Created,120), 12, 5) AS HourCreated,
								<cfif isAdministrator eq 1>
									1 
								<cfelse>
									ISNULL((
										SELECT	COUNT(*)
										FROM	System.dbo.UserStatus
										WHERE 	HostSessionId = '#hostSessionId#'
										AND		Account = P.OfficerUserId
									),0)
								</cfif> AS AllowRemove
						FROM	System.dbo.Attachment P WITH (NOLOCK)
								INNER JOIN WorkOrderLineAction A WITH (NOLOCK)
									ON P.Reference = CONVERT(VARCHAR(36),A.WorkActionId)
								INNER JOIN Workorder W WITH (NOLOCK)
									ON A.WorkOrderId = W.WorkOrderId
						WHERE	P.FileStatus <> '9'
						AND		SUBSTRING(P.FileName,LEN(P.FileName)-2,LEN(P.FileName)) IN ('JPG', 'PNG', 'GIF')
						AND		A.WorkOrderId = '#workorderid#'
						AND		CONVERT(VARCHAR(10),A.DateTimePlanning,120) = '#date#'
						ORDER BY P.Reference, P.Created ASC
				</cfquery>
			
			</cfif>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="getPersonsByWorkOrderDate"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getPersonsByWorkOrderDate">
		
			<cfargument name="callback" type="string" required="false">
			<cfargument name="workOrderId" type="string" required="true" default="">
			<cfargument name="date" type="string" required="true" default=""> <!--- must be in yyyy-mm-dd format --->
		
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	A.WorkActionId,
							Pe.PersonNo,
							Pe.IndexNo,
							rtrim(ltrim(Pe.LastName)) as LastName,
							rtrim(ltrim(Pe.FirstName)) as FirstName,
							Pe.Gender,
							CASE
								WHEN P.IsActor = 1 THEN 'A'
								WHEN P.IsActor = 2 THEN 'R'
							END AS IsActor,
							(
								SELECT	SUBSTRING(CONVERT(VARCHAR(20),(MIN(DateTimePlanning)),120), 12, 5)
								FROM	WorkOrderLineSchedulePosition Pa WITH (NOLOCK)
										INNER JOIN WorkOrderLineAction Aa WITH (NOLOCK)
											ON Pa.ScheduleId = Aa.ScheduleId
								WHERE	Pa.PersonNo = P.PersonNo
								AND		Aa.WorkOrderId = A.WorkOrderId
								AND		YEAR(Aa.DateTimePlanning) = YEAR(A.DateTimePlanning)
								AND		MONTH(Aa.DateTimePlanning) = MONTH(A.DateTimePlanning)
								AND		DAY(Aa.DateTimePlanning) = DAY(A.DateTimePlanning)
							) AS FromSchedule,
							(
								SELECT	SUBSTRING(CONVERT(VARCHAR(20),(MAX(DateTimePlanning)),120), 12, 5)
								FROM	WorkOrderLineSchedulePosition Pa WITH (NOLOCK)
										INNER JOIN WorkOrderLineAction Aa WITH (NOLOCK)
											ON Pa.ScheduleId = Aa.ScheduleId
								WHERE	Pa.PersonNo = P.PersonNo
								AND		Aa.WorkOrderId = A.WorkOrderId
								AND		YEAR(Aa.DateTimePlanning) = YEAR(A.DateTimePlanning)
								AND		MONTH(Aa.DateTimePlanning) = MONTH(A.DateTimePlanning)
								AND		DAY(Aa.DateTimePlanning) = DAY(A.DateTimePlanning)
							) AS ToSchedule,
							(
								SELECT	FunctionDescription
								FROM	Employee.dbo.Position WITH (NOLOCK)
								WHERE	PositionNo = P.PositionNo
							) AS FunctionDescription
					FROM	WorkOrderLineActionPerson P WITH (NOLOCK)
							INNER JOIN WorkOrderLineAction A WITH (NOLOCK)
								ON P.WorkActionId = A.WorkActionId
							INNER JOIN Workorder W WITH (NOLOCK)
								ON A.WorkOrderId = W.WorkOrderId
							INNER JOIN Employee.dbo.Person Pe WITH (NOLOCK)
								ON P.PersonNo = Pe.PersonNo
					WHERE	A.WorkOrderId = '#workorderid#'
					AND		P.Operational = 1
					AND		CONVERT(VARCHAR(10),A.DateTimePlanning,120) = '#date#'
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="completeWorkAction"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="completeWorkAction">
		
			<cfargument name="callback" 	  type="string" required="false">
			<cfargument name="workActionId"   type="string" required="true" default="">
			<cfargument name="sessionid" 	  type="string" required="false" default="">
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	(SELECT CONVERT(VARCHAR(10),DateTimePlanning,120) FROM WorkOrderLineAction WHERE WorkActionId = '#workActionId#') AS DateDateTimePlanning,
							getDate() as CompletedDate,
							CONVERT(VARCHAR(10),getDate(),120) AS DateCompletedDate,
							YEAR(getDate()) AS YearCompletedDate,
							MONTH(getDate()) AS MonthCompletedDate,
							DAY(getDate()) AS DayCompletedDate,
							SUBSTRING(CONVERT(VARCHAR(20),getDate(),120), 12, 5) AS HourCompletedDate
			</cfquery>
			
			<cfif sessionid eq "">
			
				<cfquery name="update"
					datasource="AppsWorkOrder">
					    UPDATE	WorkOrderLineAction
						SET		DateTimeActual = '#get.CompletedDate#',
								ActionStatus = '3',
								ActionOfficerUserId  = 'remote',
								ActionOfficerDate    = getDate()
						WHERE	WorkActionId         = '#workActionId#'
				</cfquery>
			
			<cfelse>
			
				<cfquery name="usersession"
					datasource="AppsSystem">
					    SELECT  * 
						FROM    UserStatus S, UserNames U
						WHERE   HostSessionId = '#sessionid#'						
						AND     S.Account = U.Account
				</cfquery>				
									
				<cfquery name="update"
					datasource="AppsWorkOrder">
					    
						UPDATE	WorkOrderLineAction
						
						SET		DateTimeActual = '#get.CompletedDate#',
								ActionStatus = '3',
								ActionOfficerUserId    = '#usersession.account#',
								ActionOfficerFirstName = '#usersession.firstname#',
								ActionOfficerLastName  = '#usersession.lastname#',
								ActionOfficerDate      = getDate()
								
						WHERE	WorkActionId = '#workActionId#'
						
				</cfquery>
						
			</cfif>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="updateAttachmentMemo"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="updateAttachmentMemo">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="attachmentId" 	type="string" required="true" default="">
			<cfargument name="memo"			 	type="string" required="true" default="">
			
			<cfquery name="update"
				datasource="AppsSystem">
				    UPDATE	Attachment
					SET		AttachmentMemo = '#memo#'
					WHERE	AttachmentId = '#attachmentId#'
			</cfquery>
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	'1' as Result,
							'#attachmentId#' as AttachmentId
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="updateWorkActionMemo"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="updateWorkActionMemo">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="workActionId" 	type="string" required="true" default="">
			<cfargument name="memo"			 	type="string" required="true" default="">
			
			<cfquery name="update"
				datasource="AppsWorkOrder">
				    UPDATE	WorkOrderLineAction
					SET		ActionMemo = '#memo#'
					WHERE	WorkActionId = '#workActionId#'
			</cfquery>
			
			<cfquery name="get"
				datasource="AppsWorkOrder">
				    SELECT	'1' as Result,
							'#workActionId#' as WorkActionId
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<!--- public method used in the app --->
	<cffunction name="removePicture"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="removePicture">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="hostSessionId" 	type="string" required="true">
			<cfargument name="attachmentId" 	type="string" required="true">
			
			<cfset UserAcc = "MobileApp">
			<cfset UserFirst = "MobileApp">
			<cfset UserLast = "MobileApp">
			
			<!--- return the attachment deleted empty by default --->
			<cfquery name="get"
				datasource="AppsSystem">
				    SELECT 	'' AS AttachmentId
			</cfquery>
			
			<!--- get user from the session --->
			<cfif hostSessionId neq "">
				<cfquery name="getUser" 
					datasource="AppsSystem">
					
						SELECT TOP 1 	
								U.*
						FROM 	UserNames U
								INNER JOIN UserStatus S
									ON U.Account = S.Account
						WHERE	S.HostSessionId = '#hostSessionId#'
					
				</cfquery>
				
				<cfif getUser.recordCount eq 1>
					<cfset UserAcc = getUser.Account>
					<cfset UserFirst = getUser.FirstName>
					<cfset UserLast = getUser.LastName>
				</cfif>
				
			</cfif>
			
			<!--- get the attachment to be deleted --->
			<cfquery name="getAttachment"
				datasource="AppsSystem">
				    SELECT 	*
					FROM	Attachment
					WHERE	AttachmentId = '#attachmentId#'
			</cfquery>
			
			<cfif getAttachment.recordCount gt 0>
			
				<!--- set attachment as 9 = deleted --->
				<cfquery name="updateAttachment"
					datasource="AppsSystem">
					    UPDATE	Attachment
						SET		FileStatus = '9'
						WHERE	AttachmentId = '#attachmentId#'
				</cfquery>
				
				<cfquery name="getAttachmentLog"
					datasource="AppsSystem">
					    SELECT TOP 1 *
						FROM	AttachmentLog
						WHERE	AttachmentId = '#attachmentId#'
						ORDER BY SerialNo DESC
				</cfquery>
				
				<cfset vSerialNo = 1>
				<cfif getAttachmentLog.recordCount eq 1>
					<cfset vSerialNo = getAttachmentLog.serialNo + 1>
				</cfif>
				
				<cfif CGI.HTTPS eq "off">
			      <cfset protocol = "http">
				<cfelse> 
				  <cfset protocol = "https">
				</cfif>
				
				<!--- log delete --->
				<cfquery name="LogAction" 
					datasource="AppsSystem">
					
					INSERT INTO AttachmentLog
						(
							AttachmentId,
						 	SerialNo, 
						 	FileAction, 	
						 	FileActionMemo,	
						 	FileActionServer,	
						 	OfficerUserid, 
						 	OfficerLastName, 
						 	OfficerFirstName
						)
					VALUES
						(
							'#attachmentId#',
						 	'#vSerialNo#',
							'delete',		
						 	'',	
						 	'#protocol#://#CGI.HTTP_HOST#/',
						 	'#UserAcc#',
							'#UserLast#',
							'#UserFirst#'
						) 
						 
				</cfquery>
				
				<!--- remove the file phisically if exists--->
				<cfset destination = "D:\Prosis\MANTINSA\Document\#replace(getAttachment.serverPath,'/','\','ALL')##getAttachment.fileName#">
				<cfif FileExists(destination)>
					<cffile 
						action="delete" 
						file="#destination#">
				</cfif>
					
				<!--- return the attachment deleted --->
				<cfquery name="get"
					datasource="AppsSystem">
					    SELECT 	'#attachmentId#' AS AttachmentId
				</cfquery>
				
			</cfif>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>	
	
</cfcomponent>	