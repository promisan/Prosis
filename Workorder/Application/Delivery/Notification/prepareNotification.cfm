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
<cfinclude template="../getTreeData.cfm">

<!--- --------------------------------- --->

<cfquery name="ResultList" datasource="AppsWorkOrder">

		SELECT   WL.WorkOrderLine,   
				C.CustomerName, 
				C.PostalCode, 
				C.Address,
				C.emailAddress, 
				C.PhoneNumber,
				C.MobileNumber, 
				C.City, 
				PL.DateTimePlanning, 
				PL.LastName, 
				PL.PlanOrderCode,
				PL.PlanOrderDescription,
				W.WorkOrderId, 
				O.OrgUnitName, 				
				W.Reference,
				(
				SELECT count(1) 
				FROM   WorkOrderLineTopic
				WHERE   WorkOrderId   = WL.WorkOrderId
				AND     WorkOrderLine = WL.WorkOrderLine
				AND    Topic  = 'f010' 
				AND    Operational = 1
				) as NotificationEnabled,				
				
				(
				SELECT  COUNT(1)
				FROM    WorkOrderLineAction
				WHERE   WorkOrderId   = WL.WorkOrderId
				AND     WorkOrderLine = WL.WorkOrderLine
				AND     ActionClass   = 'Notification'
				) as Notifications		
		
		FROM   WorkOrder AS W 
		       INNER JOIN WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId
			   INNER JOIN Customer AS C ON W.CustomerId = C.CustomerId 
			   INNER JOIN WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine 			    		   
			   LEFT OUTER JOIN  Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit
			  
			   <!--- actions that were put into a workplan; then we show them for the SMS --->
			    			   				 
			   INNER JOIN
								 
				 	(
				 
				    SELECT  W.WorkPlanId, D.WorkActionId, D.PlanOrder, D.PlanOrderCode, PO.Description as PlanOrderDescription,W.PersonNo, P.LastName, P.FirstName, D.DateTimePlanning
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN Ref_PlanOrder PO ON PO.Code= D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 
					AND     W.DateEffective  <= #dts# 
					AND     W.DateExpiration >= #dts# 
					<cfif person neq "">
					AND     W.PersonNo IN (#preservesinglequotes(person)#)
					</cfif>
					AND     D.WorkActionId IS NOT NULL ) PL ON A.WorkActionId = PL.WorkActionId
			   			   			  
		WHERE   W.Mission = '#url.mission#'	
		AND     A.ActionClass = 'Delivery'
		AND     A.DateTimePlanning = #dts#	
					
		<cfif units neq "">	  		
		AND     W.OrgUnitOwner IN (#units#)  	
		</cfif>		
			
		AND     WL.Operational = '1'			  	   
	    AND     W.ActionStatus != 9		
		
		<!--- only valid mobiles --->
		
		<cfif notification eq "SMS">		
		AND   (MobileNumber != '' and MobileNumber is not NULL)		
		<cfelseif notification eq "TTS">
		AND   (MobileNumber = '' or MobileNumber is NULL)
		<cfelseif notification eq "SMTP">
		AND   (emailAddress != '' AND emailAddress is NOT NULL) 
		</cfif>
		
</cfquery>