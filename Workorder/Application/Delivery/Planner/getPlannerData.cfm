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

<cfparam name="form.activitymode" default="">
<cfparam name="url.occgroup"      default="14">

<cfquery name="getCountry"
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    *
		FROM      Ref_Mission
		WHERE     Mission = '#url.mission#'		
</cfquery>

<cfset nat = getCountry.CountryCode>

<cftransaction isolation="READ_UNCOMMITTED">
		
	<cfquery name="Deliveries"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   A.DateTimePlanning, 	
		         W.WorkOrderId,
				 WL.WorkOrderLine,
				 WL.WorkOrderLineId,				
				 W.OrgUnitOwner,
				 O.OrgUnitName,
				 C.Address,
				 C.AddressNo,
				 C.City,
				 C.PhoneNumber,
				 C.MobileNumber,
				 C.PostalCode,
					 P.latitude,
					 P.longitude,				 				 
		         C.CustomerName,	
				 A.WorkActionId,
				 A.DateTimePlanning,
				 A.DateTimeActual,		
				 PL.PersonNo,
				 PL.FirstName,
				 PL.LastName,				 				
				 PL.PlanOrderCode as Schedule,
				  (SELECT Description FROM Ref_PlanOrder
				 WHERE Code = PL.PlanOrderCode) as ScheduleName,
				 PL.DateTimePlanning as ScheduleTime, 
																		   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f009' 
														   AND   Operational = 1 ) as Instructions,	
														   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f007' 
														   AND   Operational = 1 ) as Item,		
														   
				 (SELECT TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f008' 
														   AND   Operational = 1 ) as Size,		
														   
				 (SELECT TOP 1 TopicValue FROM WorkOrderLineTopic  WHERE WL.WorkOrderId = WorkOrderId  
				                                           AND   WL.WorkOrderLine = WorkOrderLine 
				                                           AND   Topic = 'f010' 
														   AND   Operational = 1 ORDER BY DateEffective DESC) as Notification,		
														   				
				 1 as Planned,
				 (CASE WHEN DateTimeActual is NULL THEN 0 ELSE 1 END) as Actual
				 
	    FROM     WorkOrder AS W 
		
				 INNER JOIN Customer                           as C ON W.CustomerId   = C.CustomerId  
				 
				 LEFT OUTER JOIN System.dbo.PostalCode         as P ON C.PostalCode   = P.PostalCode AND C.Country = '#nat#'
				 
		         INNER JOIN WorkOrderLine                      as WL ON W.WorkOrderId = WL.WorkOrderId 
				 
				 INNER JOIN WorkOrderLineAction                as A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 	
				 
				 <cfif person eq "">	 
												 
				    LEFT OUTER JOIN 
				 
				 <cfelse>
				 
				    INNER JOIN
				 
				 </cfif>
				 
				 	(
				 
				    SELECT  W.WorkPlanId, D.PlanOrder, D.PlanOrderCode, W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning, D.WorkActionId
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts# 
					<cfif person neq "">
					AND     W.PersonNo IN (#preservesinglequotes(person)#)
					</cfif>
					AND     D.WorkActionId IS NOT NULL ) 
					
					PL ON A.WorkActionId = PL.WorkActionId
				 				 
				 LEFT OUTER JOIN 
				 
				 	Organization.dbo.Organization as O ON W.OrgUnitOwner = O.OrgUnit				 													 
											
	   WHERE     A.ActionClass = 'Delivery' 	   
	   AND       A.DateTimePlanning = #dts#
	   AND       W.Mission = '#url.mission#'	
	   
	    <cfif units neq "" or workactionids neq "">	  
	   AND       (
	   			 <cfif units neq "">
	             W.OrgUnitOwner IN (#units#) 
				 </cfif>
				 <cfif units neq "" and workactionids neq "">
				 OR
				 </cfif>
				 <cfif workactionids neq "">
				 WL.WorkOrderLineId IN (#preservesinglequotes(workactionids)#)
				 </cfif>
				 ) 	 	   
	   </cfif>	     
	   
	   <!---	   	
	   
	   <cfif units neq "">	  
	   AND        W.OrgUnitOwner IN (#units#)  	
	   </cfif>			   
	   
	   --->
	  	   
	    <cfif form.activitymode eq "0">	   
				
		 	AND   NOT EXISTS (
				SELECT   'X' 								
				FROM     WorkPlan AS W INNER JOIN
	                     WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
			    WHERE    W.Mission        = '#url.mission#'
			    AND      W.DateEffective  <= #dts# 
				AND      W.DateExpiration >= #dts#
				AND      D.WorkActionId = A.WorkActionId				
				)		
		
		 <cfelseif form.activitymode eq "1">
		
			 AND  EXISTS (
				SELECT   'X' 								
				FROM     WorkPlan AS W INNER JOIN
	                     WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId
			    WHERE    W.Mission        = '#url.mission#'
			    AND      W.DateEffective  <= #dts# 
				AND      W.DateExpiration >= #dts#
				AND      D.WorkActionId = A.WorkActionId				
				)		
		
		</cfif>
	  	   
	   AND        WL.Operational = '1'		
	   AND       W.ActionStatus != '9'		   
	   	   
	   ORDER BY   W.OrgUnitOwner
	   
	   
</cfquery>	

<!--- dropdown actor --->
	
<!--- drop down planorder --->	
	
<cfquery name="PlanOrder"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">									
		SELECT   *					   					   
		FROM     Ref_PlanOrder	
		ORDER BY ListingOrder															 			     	     
</cfquery>	

<cfquery name="GetList" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_TopicList  
	  WHERE    Code = 'f004'		
	  AND      Operational = 1		
	  ORDER BY ListOrder
</cfquery>	

</cftransaction>

<cfquery name="Actor"
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">						
				
		SELECT     PA.PositionNo, 
		           PA.FunctionNo, 
				   PA.FunctionDescription, 
				   P.PersonNo, 
				   P.LastName, 
				   P.FirstName
						   					   
		FROM       Person AS P INNER JOIN
	               PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
		           Position AS Pos ON PA.PositionNo = Pos.PositionNo
		WHERE      PA.DateEffective <= #dts#
		AND        PA.DateExpiration >= #dts#
		AND        PA.AssignmentStatus IN ('0', '1') 
		AND        Pos.Mission = '#url.mission#' 
		AND        PA.FunctionNo IN (SELECT FunctionNo 
		                             FROM   Applicant.dbo.FunctionTitle 
									 WHERE  OccupationalGroup = '#url.occgroup#')		
		ORDER BY P.LastName 
														 			     	     
</cfquery>	