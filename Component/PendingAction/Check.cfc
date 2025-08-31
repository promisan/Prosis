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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Presentation Functions">
	
	<cffunction name="PendingAction" access="public" returntype="struct" displayname="VerifyPending">		
		
	    <cfargument name="Scope"   default="backoffice">
		<cfargument name="Batches" default="0"> 
		
		<cf_myClearancesPrepare mode="table" role="1" scope="#scope#">
		
		 <cfset due = dateAdd("d","30",now())>
		
		<cfquery name="getAction" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		  
			 SELECT     OA.ActionId
			 FROM       OrganizationObjectAction OA 
			            INNER JOIN    OrganizationObject O                ON OA.ObjectId  = O.ObjectId 
						INNER JOIN    userQuery.dbo.#SESSION.acc#Action D  ON OA.ActionId  = D.ActionId 
						INNER JOIN    Ref_Entity E                        ON O.EntityCode = E.EntityCode 
						INNER JOIN    Ref_EntityActionPublish P           ON OA.ActionPublishNo = P.ActionPublishNo AND OA.ActionCode = P.ActionCode 				
			 WHERE      P.EnableMyClearances = 1 
			  AND       O.ObjectStatus       = 0
			  AND       O.Operational        = 1  
			  AND       E.ProcessMode != '9'		
			  AND       (O.ObjectDue is NULL or O.ObjectDue <= #due#)
			  <cfif scope eq "portal">
		      AND       E.EnablePortal = 1
		      </cfif>	
			  <!--- hide concurrent actions that were completed --->
			  AND       OA.ActionStatus     != '2'		  	 
		</cfquery>
		
				
		<cfset pending.workflow = getAction.recordcount>
		
		<cfif batches eq "1">
		
			<cfquery name="Roles" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT   *
					FROM     Ref_AuthorizationRole
					WHERE    Role IN ('ProcReqCertify','ProcReqObject','ProcReqReview','ProcReqApprove','ProcReqBudget','ProcManager','ProcBuyer')	
					ORDER BY ListingOrder
				</cfquery>	
				
				<cfset tot = 0>
				
				<cfloop query="Roles">
					
					<cfinvoke component = "Service.PendingAction.Check"  
					   	method           = "#Role#"
					   	returnvariable   = "batch">
							
					<cfquery name="getBatch" dbtype="query">
						SELECT   SUM(Total) as Total
						FROM     batch
					</cfquery>	
								
					<cfif getBatch.total neq "">			
						<cfset tot = tot+getBatch.Total>
					</cfif>
				
				</cfloop>
				
				<cfset pending.batch = tot>		
				
		<cfelse>
		
				<cfset pending.batch = "">		
		
		</cfif>
		
		<cfreturn pending>
				
	</cffunction>
	
	<!--- 0.9 Requisitioner --->	
		
	<cffunction access="public" 
	    name="ProcReqEntry" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
		
		<!--- check pending exist --->
				
		<cfset role = "ProcReqEntry">
				
		<cfquery name="RoleData" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_AuthorizationRole
					WHERE Role = '#role#' 
		</cfquery>
		
		<!--- check pending exist --->
		
			<cftransaction isolation="READ_UNCOMMITTED">
			
				<cfquery name="Check" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT    L.Mission, 
					          L.Period, 
							  count(*) as Total
					
					FROM      RequisitionLine L, 
					          ItemMaster I 						  
							  
					WHERE     (
					            (L.ActionStatus > '1' and L.ActionStatus < '9' and L.Reference is NULL) OR (L.ActionStatus = '1')
							  )
													
					<cfif SESSION.isAdministrator eq "No">
					AND      ( 
					          
								L.RequisitionNo IN (
								                    SELECT RequisitionNo 
					                                FROM   RequisitionLineActor 
												    WHERE  ActorUserId = '#SESSION.acc#'
												    AND    Role = '#role#' 
												   )
												      	
								OR	L.OfficerUserid = '#SESSION.acc#'
								
							 )			  					 
					
					</cfif>				
					AND      OrgUnit is not NULL
					<cfif Period neq "">	
					AND      L.Period     = '#Period#'	
					AND      L.Mission  = '#Mission#'			
					</cfif>
					AND      RequestType != 'Purchase'		
					AND      I.Code = L.ItemMaster 
					AND      L.RequestDescription > ''					
					GROUP BY L.Mission, L.Period	
								
				</cfquery>		
			
			</cftransaction>		
				
		<cfreturn check>
		
	</cffunction>	
	
	<!--- 1.0 Procurement Reviewer --->
		
	<cffunction access="public" 
	    name="ProcReqReview" 
		output="true" 
		returntype="query" 		
		displayname="VerifyPending">		
				
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
		
		<!--- check pending exist --->
				
		<cfset role = "ProcReqReview">
				
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			mode             = "orgunitimplement"
			accesslevel      = "'1','2'"
			returnvariable   = "UserRequestScope">	
															
			<!--- check pending exist --->	
			
			<cftransaction isolation="READ_UNCOMMITTED">		
			
			<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    L.Mission, L.Period, count(*) as Total
					FROM      RequisitionLine L,
					          ItemMaster I, 
			  				  Organization.dbo.Organization Org
					WHERE     L.OrgUnit = Org.OrgUnit
					AND       I.Code = L.ItemMaster 		   
					AND       L.OrgUnit is not NULL
					<cfif Period neq "">	
					AND       L.Mission = '#URL.Mission#' 			
					</cfif>			
												
					AND       L.ActionStatus IN ('1p') and Reference is not NULL		
							
					<!--- user has scope access to this request --->	
					<cfif getAdministrator(mission) eq "0">									
					AND  	  #preserveSingleQuotes(UserRequestScope)# 					
					</cfif>										
								
					<cfif Period neq "">		
					AND     L.Period  = '#URL.Period#'			  						
					</cfif>
					GROUP BY L.Mission, L.Period
			</cfquery>		
						
			</cftransaction>
			
				
		<cfreturn check>
		
	</cffunction>	
		
	<!--- 1.1a Procurement Approver --->
		
	<cffunction access="public" 
	    name="ProcReqApprove" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
		
		<!--- check pending exist --->
				
		<cfset role = "ProcReqApprove">
		
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			accesslevel      = "'1','2'"
			mode             = "orgunitimplement"
			returnvariable   = "UserRequestScope">	
			
			<cftransaction isolation="READ_UNCOMMITTED">				
				
			<!--- check pending exist --->
			
			<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    L.Mission, L.Period, count(*) as Total
					FROM      RequisitionLine L,
					          ItemMaster I, 
			  				  Organization.dbo.Organization Org
					WHERE     L.OrgUnit = Org.OrgUnit
					AND       I.Code = L.ItemMaster 		   
					<cfif Period neq "">	
					AND       L.Mission = '#URL.Mission#' 			
					</cfif>			
												
					AND       L.ActionStatus IN ('2') and Reference is not NULL		
					
					<!--- user has scope access to this request --->					
					<cfif getAdministrator(mission) eq "0">	
					AND  	  #preserveSingleQuotes(UserRequestScope)# 					
					</cfif>		
							
					<cfif Period neq "">		
					AND     L.Period  = '#URL.Period#'			  						
					</cfif>
					GROUP BY L.Mission, L.Period
					
			</cfquery>		
			
			</cftransaction>		
				
		<cfreturn check>
		
	</cffunction>	
		
	<!--- 1.1b Procurement Approver Level 2 Budget --->
		
	<cffunction access="public" 
	    name="ProcReqBudget" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
		
		<!--- check pending exist --->
				
		<cfset role = "ProcReqBudget">
		
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			mode             = "orgunitimplement"
			accesslevel      = "'1','2'"
			returnvariable   = "UserRequestScope">	
		
		
			<cftransaction isolation="READ_UNCOMMITTED">
						
			<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    L.Mission, L.Period, count(*) as Total
					
					FROM      RequisitionLine L INNER JOIN 
					          ItemMaster I ON I.Code = L.ItemMaster 
							  INNER JOIN Ref_ParameterMissionEntryClass S ON L.Mission = S.Mission AND L.Period = S.Period AND I.EntryClass = S.EntryClass
					WHERE     1=1		  
					<cfif Period neq "">	
					AND       L.Mission = '#URL.Mission#' 			
					</cfif>		
					AND      L.OrgUnit is not NULL
					
					<!--- pickup for processing dependent on the value of the flow setting --->
					
					AND      ( L.ActionStatus = '2a' AND S.EnableBudgetReview = '1' )	
					
					<!--- user has scope access to this request --->					
					<cfif getAdministrator(mission) eq "0">	
					AND  	  #preserveSingleQuotes(UserRequestScope)# 					
					</cfif>									
								
					<cfif Period neq "">		
					AND     L.Period  = '#URL.Period#'			  						
					</cfif>
					GROUP BY L.Mission, L.Period
					
			</cfquery>	
			
			</cftransaction>			
				
		<cfreturn check>
		
	</cffunction>	
	
	
	<!--- 1.2. Procurement Object --->
	
	<cffunction access="public" 
	    name="ProcReqObject" 
		output="true" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
				
		<!--- check pending exist --->
				
		<cfset role = "ProcReqObject">
		
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			accesslevel      = "'1','2'"
			mode             = "orgunitimplement"
			returnvariable   = "UserRequestScope">	
					
			<cftransaction isolation="READ_UNCOMMITTED">
			
			<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT    L.Mission, L.Period, count(*) as Total
					
					FROM      RequisitionLine L INNER JOIN 
					          ItemMaster I ON I.Code = L.ItemMaster 
							  INNER JOIN Ref_ParameterMissionEntryClass S ON L.Mission = S.Mission AND L.Period = S.Period AND I.EntryClass = S.EntryClass
				
					<cfif Period neq "">	
					WHERE     L.Mission = '#URL.Mission#' 					
					<cfelse>
					WHERE     1 = 1 
					</cfif>
					AND      L.OrgUnit is not NULL
					
					<!--- pickup for processing dependent on the value of the flow setting --->
		
					AND      ( 
					
				          ( L.ActionStatus IN ('2a','2b') AND S.EnableBudgetReview = '0' )
						  
						                            OR
													
						  ( L.ActionStatus = '2b' AND S.EnableBudgetReview = '1' )	
					  
			         )		
					 
					<!--- user has scope access to this request --->					
					<cfif getAdministrator(mission) eq "0">	
					AND  	  #preserveSingleQuotes(UserRequestScope)# 					
					</cfif>									
						
					<cfif Period neq "">		
					AND     L.Period  = '#URL.Period#'			  						
					</cfif>
					GROUP BY L.Mission, L.Period
			</cfquery>	
			
			</cftransaction>			
				
		<cfreturn check>
		
	</cffunction>		
			
	<!--- 1.2 Procurement Certification --->
	
	<cffunction access="public" 
	    name="ProcReqCertify" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period" default="">
		
		<!--- check pending exist --->
		
		<cfset role = "ProcReqCertify">
		
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			accesslevel      = "'1','2'"
			mode             = "orgunitimplement"
			returnvariable   = "UserRequestScope">	
				
					
		<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    L.Mission, L.Period, count(*) as Total
					FROM      RequisitionLine L,  
					          ItemMaster I, 
							  Ref_ParameterMission R
					WHERE     L.Mission = R.Mission
					AND       I.Code    = L.ItemMaster 
					AND       L.OrgUnit is not NULL
					
					<cfif Mission neq "">
					AND       L.Mission = '#URL.Mission#' 					
					</cfif>		
					
					AND       L.ActionStatus IN ('2f') 
					
					<!--- user has scope access to this request --->					
					<cfif getAdministrator(mission) eq "0">	
					AND  	  #preserveSingleQuotes(UserRequestScope)# 					
					</cfif>	
										
					<cfif Period neq "">	
					AND     L.Period  = '#Period#'			  						
					</cfif>
					GROUP BY L.Mission, L.Period
					
			</cfquery>
		
				
		<cfreturn check>
		
	</cffunction>
	
	<!--- procurement buyer assignment --->
	
	<cffunction access="public" 
	    name="ProcManager" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period"  default="">
		<cfargument name="Role"    default="ProcManager">
						
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			accesslevel      = "'1','2'"
			mode             = "orgunitimplement"
			returnvariable   = "UserRequestScope">		
							
		<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    L.Mission, L.Period, count(*) as Total
				FROM      RequisitionLine L, Ref_ParameterMission R, ItemMaster I
				WHERE     L.Mission = R.Mission
				AND       L.ItemMaster = I.Code
				
				<cfif Mission neq "">
				AND       L.Mission = '#URL.Mission#' 					
				</cfif>		
				
				AND       L.ActionStatus IN ('2i') 
				
				<!--- user has scope access to this request --->					
				<cfif getAdministrator(mission) eq "0">	
				AND  	  #preserveSingleQuotes(UserRequestScope)# 					
				</cfif>					
								
				<cfif Period neq "">	
				AND     L.Period  = '#Period#'			  						
				</cfif>
				
				GROUP BY L.Mission, L.Period
					
			</cfquery>		
				
		<cfreturn check>
		
	</cffunction>
	
	<!--- procurement buyer assignment --->
	
	<cffunction access="public" 
	    name="ProcBuyer" 
		output="false" 
		returntype="query" 		
		displayname="VerifyPending">
		
		<cfargument name="Mission" default="">
		<cfargument name="Period"  default="">
		<cfargument name="Role"    default="ProcManager">
						
		<cfinvoke component = "Service.Process.Procurement.Requisition"  
			method           = "getQueryScope" 
			role             = "#role#" 
			accesslevel      = "'1','2'"
			mode             = "orgunitimplement"
			returnvariable   = "UserRequestScope">		
							
		<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    L.Mission, L.Period, count(*) as Total
				FROM      RequisitionLine L, Ref_ParameterMission R, ItemMaster I
				WHERE     L.Mission = R.Mission
				AND       L.ItemMaster = I.Code
				
				<cfif Mission neq "">
				AND       L.Mission = '#URL.Mission#' 					
				</cfif>		
				
				AND       L.ActionStatus IN ('2k','2q') 
								
				AND       L.RequisitionNo IN (SELECT RequisitionNo 
				                              FROM   RequisitionLineActor 
											  WHERE  RequisitionNo = L.RequisitionNo
											  AND    Role = 'ProcBuyer' 
											  AND    ActorUserId = '#session.acc#')						
											
				<cfif Period neq "">	
				AND     L.Period  = '#Period#'			  						
				</cfif>
				
				GROUP BY L.Mission, L.Period
					
			</cfquery>		
				
		<cfreturn check>
		
	</cffunction>
	
</cfcomponent>	