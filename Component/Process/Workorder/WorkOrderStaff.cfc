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
    <cfset this.name = "Execution Queries">
	
	<cffunction name="GetWorkOrderStaff"
        access="public"
        returntype="any" 
        displayname="GetWorkOrderStaff">
		
			<!--- the purpose of this query is to extract for a mission, (any or a) staff validly assigned on a certain moment (date or during a month) to a position
			of which the unit has been enabled for that workorder/customer --->
			
			<cfargument name="initialDate" 			type="date" 	required="true" 	default="">
			<cfargument name="endDate" 				type="date" 	required="true" 	default="">
			
			<cfargument name="mission" 				type="string" 	required="false" 	default="">
			<cfargument name="workorderid" 			type="string" 	required="false" 	default="">	
			<cfargument name="customerId" 			type="string" 	required="false" 	default="">			
			<cfargument name="serviceItem" 			type="string" 	required="false" 	default="">
			<cfargument name="workSchedule" 		type="string" 	required="false" 	default="">
			<cfargument name="orgUnit" 				type="string" 	required="false" 	default="">
			<cfargument name="PersonNo" 			type="string" 	required="false" 	default="">	
			<cfargument name="Mode" 	    		type="string" 	required="true" 	default="View">	<!--- view | table | subquery --->
			<cfargument name="Table"        		type="string"   required="false"    default="#SESSION.acc#Workstaff">
			<cfargument name="getPositionData" 	    type="string" 	required="false" 	default="true">
			<cfargument name="getWorkScheduleData" 	type="string" 	required="false" 	default="false">
			<cfargument name="incumbencyCondition" 	type="string" 	required="false" 	default="> 0">
			
			<cfif mode eq "Table">
				<CF_DropTable dbName="AppsQuery" tblName="#table#">
			</cfif>	
			
			<cfset vMission 		= ListQualify(mission,"'")>
			<cfset vWorkOrderId		= ListQualify(workorderid,"'")>
			<cfset vCustomerId 		= ListQualify(customerId,"'")>
			<cfset vServiceItem 	= ListQualify(serviceItem,"'")>
			<cfset vWorkSchedule 	= ListQualify(workSchedule,"'")>
			<cfset vOrgUnit 		= ListQualify(orgUnit,"'")>
						
			<cfsavecontent variable="querystring">
			
				<cfoutput>
						   	
				    SELECT  P.PersonNo,
							P.FirstName,
							P.IndexNo,
							P.BirthDate,
							P.LastName,
							P.Nationality,
							P.FullName,
							P.Gender,									
							MAX(PA.DateExpiration) as AssignmentDateExpiration,	
										  
					        <cfif lcase(getPositionData) eq "true">								    							  				  
							    PA.PositionNo,							   
							    PS.SourcePostNumber,
								PA.AssignmentNo,		
							</cfif>
						    
						    <cfif lcase(getWorkScheduleData) eq "true">
							    WS.Code           as WorkSchedule,							  
							    WS.Description    as WorkScheduleDescription,
							    WS.ListingOrder   as WorkScheduleListingOrder,
						    </cfif>		
								
						   	G.PostOrder  <!--- Hanno : used for sorting of the list, which can have duplicated in rare cases --->				
							
					FROM   	Employee.dbo.Person P
							INNER JOIN Employee.dbo.PersonAssignment PA	     ON P.PersonNo      = PA.PersonNo
							INNER JOIN Employee.dbo.WorkSchedulePosition WP  ON PA.PositionNo   = WP.PositionNo
							INNER JOIN Employee.dbo.WorkSchedule WS          ON WP.WorkSchedule = WS.Code
							INNER JOIN Employee.dbo.Position PS 			 ON PA.PositionNo   = PS.PositionNo
							INNER JOIN Employee.dbo.Ref_PostGrade G			 ON PS.PostGrade    = G.PostGrade
					
					<!--- 1. valid assignment for the date and active --->
							
					WHERE 	PA.AssignmentStatus IN ('0', '1')
											
					AND     PA.DateEffective <= #enddate# AND PA.DateExpiration >= #initialdate#
					
					<!--- assignment is valid 					
					AND		(   #initialDate# BETWEEN PA.DateEffective AND PA.DateExpiration
				                						OR
				                #endDate# BETWEEN PA.DateEffective AND PA.DateExpiration
							)
					--->		

					<!--- cross check to workorder actions --->
					AND		EXISTS (
								SELECT	'X' 
								FROM	WorkOrder.dbo.WorkOrderLineSchedule Sx
										INNER JOIN WorkOrder.dbo.WorkOrderLineSchedulePosition SPx 
											ON SPx.ScheduleId = Sx.ScheduleId
										INNER JOIN WorkOrder.dbo.WorkOrderLineScheduleDate SDx
											ON Sx.ScheduleId = SDx.ScheduleId
								WHERE	SPx.PositionNo = WP.PositionNo 
								AND		Sx.WorkSchedule = WS.Code
								AND		SPx.Operational = '1'
								AND		SPx.isActor IN ('1','2')
								AND		SDx.ScheduleDate BETWEEN #initialdate# AND #enddate#
							)
						
					AND		PA.AssignmentType = 'Actual'
					AND		PA.Incumbency #incumbencyCondition#	
							
					<!--- 2. to a position associated to a schedule on that date --->		
					
					AND		WP.CalendarDate BETWEEN #initialDate# AND #endDate#		
					
					<!--- 3. and the position is associated to the work of the customer --->		
									
					AND     PA.OrgUnit IN
					
							(              
				                SELECT  I.OrgUnit
								
				                FROM    WorkOrder.dbo.WorkOrderImplementer I
                                        INNER JOIN WorkOrder.dbo.WorkOrder W       ON W.WorkOrderId = I.WorkOrderId  
                                        INNER JOIN WorkOrder.dbo.Customer C        ON W.CustomerId  = C.CustomerId
                                        INNER JOIN Organization.dbo.Organization O ON I.OrgUnit     = O.OrgUnit AND W.Mission = O.Mission
                                        INNER JOIN Organization.dbo.Ref_Mandate M  ON O.Mission     = M.Mission AND O.MandateNo = M.MandateNo
										
				                WHERE	W.ActionStatus = 1  <!--- active workorder 0 quotation , 1 = open, 3 = completed/closed and 9 = cancelled --->
				                
				                <cfif mission neq "">
				               		AND		W.Mission IN (#preserveSingleQuotes(vMission)#)
								</cfif>
								
								<cfif orgUnit neq "">
				   					AND		I.OrgUnit IN (#preserveSingleQuotes(vOrgUnit)#)
								</cfif>
								
								<cfif workorderid neq "">
				                	AND		W.WorkOrderId IN (#preserveSingleQuotes(vWorkOrderId)#)
								</cfif>
								
				                <cfif customerId neq "">
				                	AND		C.CustomerId IN (#preserveSingleQuotes(vCustomerId)#)
								</cfif>
								
								<cfif serviceItem neq "">
									AND		W.ServiceItem IN (#preserveSingleQuotes(vServiceItem)#)
								</cfif>
								
							)				
					
					<cfif PersonNo neq "">
						AND     P.PersonNo = '#PersonNo#'
					</cfif>
								
					<cfif workSchedule neq "">
				   		AND		WS.Code IN (#preserveSingleQuotes(vWorkSchedule)#)
					</cfif>	
					
					GROUP BY  P.PersonNo,
					
						  <cfif lcase(getPositionData) eq "true">								    							  				  
							    PA.PositionNo,							   
							    PS.SourcePostNumber,
								PA.AssignmentNo,		
						  </cfif>		  	
							
						  <cfif lcase(getWorkScheduleData) eq "true">
							    WS.Code,							  
							    WS.Description,
							    WS.ListingOrder,
						  </cfif>		
												
						  P.FirstName,
						  P.LastName,
						  P.BirthDate,
						  P.IndexNo,
						  P.Nationality,
						  P.FullName,
						  P.Gender,
						  G.PostOrder						
					
					<cfif mode neq "subquery">
					
					ORDER BY  <cfif lcase(getWorkScheduleData) eq "true">WS.ListingOrder ASC, WS.Code ASC,</cfif> 
					          G.PostOrder ASC 
												
					</cfif>
					
				</cfoutput>	

			</cfsavecontent>
						
			<cfif mode eq "view">
			
				<cfquery name="get"
					datasource="AppsEmployee"
				   	username="#SESSION.login#"
				   	password="#SESSION.dbpw#">
						#preserveSingleQuotes(querystring)#
				</cfquery>	
				
				<cfreturn get>
				
			<cfelseif mode eq "subquery">
						
				<cfreturn querystring>
							
			</cfif>				
		
	</cffunction>
	
	
	<!---

		 Future : current month and after 
		 
	     Hanno we show the relevant areas of cleaning for this customer 
	     that were indeed scheduled during this selected month for one or more days 
		 and to which the SELECTED person has also been tasked (isActor) 
		 UNLESS he fell of the staffing table BEFORE this month
		 
		 Past : prior month
		 
		 We show any area/lines  to which this person was indeed recorded 
		 in the table WorkOrderLineActionPerson
		 
	--->	
	
	<cffunction name="GetWorkOrderScheduledActions"
        access="public"
        returntype="any" 
        displayname="GetWorkOrderScheduledActions">
			
			<cfargument name="mission" 				type="string" 	required="false" 	default="">
			<cfargument name="workorderid" 			type="string" 	required="false" 	default="">
				
			<cfargument name="customerId" 			type="string" 	required="false" 	default="">			
			<cfargument name="serviceItem" 			type="string" 	required="false" 	default="">
			
			<cfargument name="tense" 				type="string" 	required="true" 	default="present">		
			<cfargument name="initialDate" 			type="date" 	required="true" 	default="#dateformat(now(),client.dateformatshow)#">
			<cfargument name="endDate" 				type="date" 	required="true" 	default="#dateformat(now(),client.dateformatshow)#">
							
			<cfargument name="workSchedule" 		type="string" 	required="false" 	default="">
			<cfargument name="PersonNo" 			type="string" 	required="false" 	default="">
			<cfargument name="Operational" 			type="string" 	required="false" 	default="">
			<cfargument name="ActorType" 			type="string" 	required="false" 	default="">
			<cfargument name="Mode" 	    		type="string" 	required="true" 	default="View">	<!--- view | table | subquery --->			
			
			<cfargument name="IncludePersonInfo" 	type="string" 	required="false" 	default="false">
			<cfargument name="IncludeHourInfo" 		type="string" 	required="false" 	default="false">	
			<cfargument name="OrderColumns" 		type="string" 	required="false" 	default="ActionClass, Reference, ServiceDomainClass">			
			
			<cfargument name="Table"        		type="string"   required="false"    default="#SESSION.acc#WorkSchedule">
			
			<cfif mode eq "Table">
				<CF_DropTable dbName="AppsQuery" tblName="#table#">
			</cfif>	
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#initialDate#">
			<cfset initialDate = dateValue>
			
			<cfset dateValue = "">
			<CF_DateConvert Value="#enddate#">
			<cfset endDate = dateValue>
					
			<cfset vWorkOrderId		= ListQualify(workorderid,"'")>			
			<cfset vCustomerId 		= ListQualify(customerId,"'")>
			<cfset vServiceItem 	= ListQualify(serviceItem,"'")>
			<cfset vWorkSchedule 	= ListQualify(workSchedule,"'")>
			<cfset vPersonNo	 	= ListQualify(PersonNo,"'")>
			<cfset vActorType	 	= ListQualify(ActorType,"'")>

			<!--- present and future --->
			
			<cfset vActionTable = "">
			<cfset vPersonTable = "WorkOrderLineSchedulePosition">
			
			<cfoutput>
				<cfsavecontent variable="vHourTable">
				
					INNER JOIN
					(
						SELECT 	ScheduleId,
								(System.dbo.ConvertTime(ScheduleDate, ScheduleHour)) AS DateTimePlanning,
								Memo AS ActionMemo
						FROM	WorkOrderLineScheduleDate
						WHERE   Operational = 1
					) DH ON S.ScheduleId = DH.ScheduleId 
					
				</cfsavecontent>
			</cfoutput>
			<cfset vHourAlias = "DH">
			
			<!---past--->
			<cfif lcase(tense) eq "past">
			
				<cfoutput>
					<cfsavecontent variable="vActionTable">
						INNER JOIN WorkOrderLineAction A ON S.ScheduleId = A.ScheduleId
					</cfsavecontent>
				</cfoutput>
				
				<cfoutput>
					<cfsavecontent variable="vPersonTable">
						(
							SELECT DISTINCT	
									xA.ScheduleId,
									xP.*
							FROM	WorkOrderLineAction xA
									INNER JOIN WorkOrderLineActionPerson xP
										ON xA.WorkActionId = xP.WorkActionId
						)
					</cfsavecontent>
				</cfoutput>
				
				<cfset vHourTable = "">
				<cfset vHourAlias = "A">
				
			</cfif>	
			
			<cfsavecontent variable="querystring">
			
					<cfoutput>
									 
						 SELECT TOP 100 PERCENT *
						 
						<cfif mode eq "Table">
							INTO UserQuery.dbo.#table#
						</cfif>	
									 
						 FROM  (SELECT DISTINCT 	
										C.CustomerId,
										C.CustomerName,
										WO.Reference as WorkOrderReference,
										SI.Code as ServiceItem,
										SI.Description as ServiceItemDescription,
										WOL.WorkOrderId,
										WOL.WorkOrderLine,
										WOL.Reference,
										WS.Description as ServiceDescription,
										WOL.ServiceDomainClass,
										SIDC.Description as ClassDescription,
										S.ActionClass,
										S.WorkSchedule,
										RA.Description AS ActionClassDescription,
										S.ScheduleId,
										S.ScheduleName,									
										S.Memo,
										S.ScheduleClass,
										(SELECT Description FROM Employee.dbo.Ref_ScheduleClass WHERE Code = S.ScheduleClass) as ScheduleClassDescription
										<cfif lcase(IncludePersonInfo) eq "true">
											,
											eP.PersonNo,
											eP.IndexNo,
											eP.FirstName,
											eP.LastName,
											eP.Gender, 
											eP.BirthDate,
											P.PositionNo,
											MAX(P.isActor) AS isActor
										</cfif>
										<cfif lcase(IncludeHourInfo) eq "true">
											,
											#vHourAlias#.DateTimePlanning,
											convert(varchar(5000),#vHourAlias#.ActionMemo) as ActionMemo
										</cfif>
										
								FROM	WorkOrderLineSchedule S         
										#vActionTable#
										INNER JOIN WorkOrderLine WOL	           ON S.WorkOrderId     = WOL.WorkOrderId     AND  S.WorkOrderLine = WOL.WorkOrderLine
										INNER JOIN WorkOrderService WS             ON WOL.ServiceDomain = WS.ServiceDomain    AND  WOL.Reference = WS.Reference 
										INNER JOIN Ref_ServiceItemDomainClass SIDC ON WOL.ServiceDomain = SIDC.ServiceDomain  AND  WOL.ServiceDomainClass = SIDC.Code
										INNER JOIN WorkOrder WO                    ON WOL.WorkOrderId   = WO.WorkOrderId
										INNER JOIN ServiceItem SI                  ON WO.ServiceItem    = SI.Code
										INNER JOIN Customer C                      ON WO.CustomerId     = C.CustomerId
										INNER JOIN Ref_Action RA 		           ON S.ActionClass     = RA.Code              AND WO.Mission = RA.Mission
										<cfif lcase(IncludePersonInfo) eq "true">
											INNER JOIN #vPersonTable# P			   ON S.ScheduleId = P.ScheduleId <cfif lcase(tense) eq "past">AND A.WorkActionId = P.WorkActionId</cfif> 
											INNER JOIN Employee.dbo.Person eP	   ON P.PersonNo = eP.PersonNo
										</cfif>
										<cfif lcase(IncludeHourInfo) eq "true">
											#vHourTable#
										</cfif>
																					
								WHERE	1=1 
								
								<cfif Mission neq "">
									AND		WO.Mission     = '#mission#'
								</cfif>
								
								<cfif WorkOrderid neq "">
									AND		WO.WorkOrderId IN (#preserveSingleQuotes(vWorkOrderId)#)
								</cfif>		
								
								<!--- Hanno 25/7 added open workorders and lines that fit within the requested frame- --->		
								AND     WO.ActionStatus = '1' 
													
								AND     WOL.Operational = 1									
								AND     WOL.DateEffective <= #endDate# AND (WOL.DateExpiration is NULL or WOL.DateExpiration >= #initialDate#)					
								
								<!--- schedule is operational --->
								AND     S.ActionStatus = '1'   
																					
								<!--- ------------------------------------------------------------------------------- --->															
								<!--- ------------and has several actions planned for the selection dates------------ --->
								<!--- ------------------------------------------------------------------------------- --->
								
								AND		EXISTS
										(
											SELECT 	'X'
											FROM	WorkOrderLineScheduleDate
											WHERE	ScheduleId  = S.ScheduleId
											AND     Operational = 1
											AND		ScheduleDate BETWEEN #initialDate# AND #endDate#
										)
								
								<cfif CustomerId neq "">
									AND		WO.CustomerId IN (#preserveSingleQuotes(vCustomerId)#)
								</cfif>
								
								<cfif WorkSchedule neq "">
									AND		S.WorkSchedule IN (#preserveSingleQuotes(vWorkSchedule)#)
								</cfif>
								
								<cfif PersonNo neq "">
									AND		P.PersonNo IN (#preserveSingleQuotes(vPersonNo)#)
								</cfif>
								
								<cfif ServiceItem neq "">
									AND		WO.ServiceItem IN (#preserveSingleQuotes(vServiceItem)#)
								</cfif>
								
								<cfif lcase(IncludePersonInfo) eq "true">
								
									<cfif ActorType neq "">
										AND		P.isActor IN (#preserveSingleQuotes(vActorType)#)
									</cfif>						
									
									<cfif Operational neq "">
									   AND      P.Operational = '#operational#'
									</cfif>	
								
								</cfif>
								
								GROUP BY	C.CustomerId,
										    C.CustomerName,
											WOL.WorkOrderId,
											WO.Reference,
											SI.Code,
											SI.Description,									   
										    WOL.WorkOrderLine,
										    WOL.Reference,
										    WS.Description,
										    WOL.ServiceDomainClass,
										    SIDC.Description,
										    S.ActionClass,
										    S.WorkSchedule,
										    RA.Description,
										    S.ScheduleId,
										    S.ScheduleName,
										    S.Memo,
											S.ScheduleClass
											<cfif lcase(IncludePersonInfo) eq "true">
												,
												eP.PersonNo,
												eP.IndexNo,
												eP.FirstName,
												eP.LastName,
												eP.Gender, 
												P.PositionNo,
												eP.BirthDate
											</cfif>
											<cfif lcase(IncludeHourInfo) eq "true">
												,
												#vHourAlias#.DateTimePlanning,
												convert(varchar(5000),#vHourAlias#.ActionMemo)
											</cfif>	
												
							) AS Data
							
							ORDER BY #OrderColumns# 							
								
				</cfoutput>
			
			</cfsavecontent>
			
			<cfif mode eq "view">
			
				<cfquery name="get"
					datasource="AppsWorkorder"
				   	username="#SESSION.login#"
				   	password="#SESSION.dbpw#">
						#preserveSingleQuotes(querystring)#
				</cfquery>	
				
				<cfreturn get>
				
			<cfelseif mode eq "subquery">
						
				<cfreturn querystring>
										
			<cfelseif mode eq "table">
			
				<cfquery name="get"
					datasource="AppsWorkorder"
				   	username="#SESSION.login#"
				   	password="#SESSION.dbpw#">
						#preserveSingleQuotes(querystring)#
				</cfquery>	
			
				<cfreturn "1">
			
						
			</cfif>
		
	</cffunction>	
	
</cfcomponent>	