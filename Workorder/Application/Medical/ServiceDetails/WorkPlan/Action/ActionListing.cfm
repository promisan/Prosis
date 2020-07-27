
<cfparam name="url.personno" default="">

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.systemfunctionid#"				
		Label           = "Yes">		
		
<CF_DropTable dbName="AppsQuery"  tblName="actionListing_#Session.acc#">				

<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission WITH (NOLOCK)
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfset wclass = "Contact">
<cf_tl id="Completed" var="lblCompleted">
<cf_tl id="Process" var="lblProcess">
<cf_tl id="Revoked" var="lblRevoked">
		
<cfquery name="prepare" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT * 
	INTO  userQuery.dbo.actionListing_#Session.acc#
	FROM (	
	
		SELECT     WL.WorkOrderId, 
		           WL.WorkOrderLine, 
				   WL.WorkOrderLineId, 
				   WL.ActionStatus,
				   WL.Reference,
				   WLA.ActionClass, 
				   wla.ActionStatus      as wlaactionstatus,
				   WL.DateEffective,
				   WS.DescriptionShort   as WorkOrderService,
				   wl.ServiceDomainClass as wlservicedomainclass,
				   R.DescriptionShort    as wlservicedomainclassnow,
				   wl.ParentWorkorderId, 
				   
				   ISNULL(( SELECT TOP 1 wpd1.WorkActionId
				      	    FROM     WorkOrderLineAction CWL WITH (NOLOCK) 
				                     INNER JOIN WorkOrder CW WITH (NOLOCK) ON CW.WorkOrderId = CWL.WorkOrderId
					                 INNER JOIN WorkPlanDetail wpd1 WITH (NOLOCK) ON wpd1.WorkActionId = cwl.WorkactionId AND wpd1.Operational = '1'
	   				        WHERE    CW.CustomerId     =  W.CustomerId
              			    AND      CWL.ActionClass   = 'Contact'
              			    AND      CWL.ActionStatus NOT IN ('9','8')
							ORDER BY ISNULL(wpd1.DateTimePlanning, CWL.DateTimePlanning) ASC),WLA.WorkActionid) 
							
              			    /*AND      ISNULL(wpd1.DateTimePlanning,CWL.DateTimePlanning) <= ISNULL(wpd.DateTimePlanning,wla.DateTimePlanning)*/
        				    /*ORDER BY CASE WHEN CWL.DateTimeActual is NULL THEN CWL.DateTimePlanning ELSE CWL.DateTimeActual END ASC*/
														
							as firstWorkActionId /*to get the current one*/,
					
					( SELECT TOP 1 R1.DescriptionShort
					  FROM        WorkOrderLine wl1 WITH (NOLOCK)
					              INNER JOIN WorkORder AS wo WITH (NOLOCK) ON wo.WorkOrderId = wl1.WorkOrderId
					              INNER JOIN WorkOrderLineAction AS wla1  WITH (NOLOCK) ON wla1.WorkOrderId = wo.WorkOrderId
					                                                      AND wla1.WorkOrderLine = wl1.WorkOrderLine
					              INNER JOIN Ref_ServiceItemDomainClass R1 WITH (NOLOCK)  ON WL1.ServiceDomain = R1.ServiceDomain
                                                						 AND WL1.ServiceDomainClass = R1.Code
                                  INNER JOIN WorkOrder.dbo.WorkPlanDetail wpd1 WITH (NOLOCK) ON wpd1.WorkActionId = wla1.WorkActionId
					  WHERE       wo.customerId = W.CustomerId
		              AND         ActionClass = '#wclass#'
		              AND         wla1.ActionStatus NOT IN ( '9','8')
		              AND         wo.ActionStatus != '9'
		              AND         wpd1.Operational = '1'
		              AND         R1.DescriptionShort = R.DescriptionShort
		              AND         wla1.WorkActionId != wla.WorkActionId
				      AND         ISNULL(wpd1.DateTimePlanning,wla1.DateTimePlanning) <= ISNULL(wpd.DateTimePlanning,wla.DateTimePlanning)
					  ORDER BY    ISNULL(wpd1.DateTimePlanning, wla1.DateTimePlanning) DESC
				    ) as lastServiceDomainClass, 
											   	
				   (  SELECT  LEFT(Description,1) 
				      FROM    Ref_PlanOrder  WITH (NOLOCK)
					  WHERE   Code = WPD.PlanOrderCode) as PlanOrder,
					 
				   CASE WHEN WL.ActionStatus = '3'  THEN '#lblCompleted#' 				       
						WHEN WLA.ActionStatus < '3' THEN '#lblProcess#'		
						WHEN WLA.ActionStatus = '9' THEN '#lblRevoked#'	
						WHEN WL.ActionStatus = '9'  THEN '#lblRevoked#'				
						END as WorkOrderLineActionStatus,	
						
				   R.Description, 
				   WPD.DateTimePlanning, 
				   P.FirstName as ActorFirstName,
				   P.LastName  as ActorLastName,
				   O.OrgUnitName,
				   C.CustomerName,
				   A.LastName, 
				   A.FirstName, 
				   A.PersonNo, 
				   ISNULL(A.DocumentReference, A.PersonNo) AS DocumentReference,				   
				   W.CustomerId,
	               WLA.WorkActionId
				   
		FROM       WorkPlanDetail WPD WITH (NOLOCK) 
		           INNER JOIN  WorkPlan WP WITH (NOLOCK) ON WPD.WorkPlanId = WP.WorkPlanId 
				   INNER JOIN  WorkOrderLineAction WLA WITH (NOLOCK) ON WPD.WorkActionId = WLA.WorkActionId 
				   INNER JOIN  Organization.dbo.Organization O WITH (NOLOCK) ON O.OrgUnit = WP.OrgUnit 
				   INNER JOIN  Employee.dbo.Person P WITH (NOLOCK) ON P.PersonNo = WP.PersonNo 
				   INNER JOIN  WorkOrderLine WL WITH (NOLOCK) ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine 
				   INNER JOIN  WorkOrderService WS WITH (NOLOCK) ON WS.ServiceDomain = WL.ServiceDomain AND WS.Reference = WL.Reference 
				   INNER JOIN  Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code 
				   INNER JOIN  WorkOrder W WITH (NOLOCK) ON WL.WorkOrderId = W.WorkOrderId 
				   INNER JOIN  Customer C WITH (NOLOCK) ON W.CustomerId = C.CustomerId 
				   INNER JOIN  Applicant.dbo.Applicant A  WITH (NOLOCK) ON C.PersonNo = A.PersonNo	
				   
		WHERE      <cfif url.mission neq "">
				   WP.Mission = '#url.mission#' 
				   <cfelse>
				   1=1
				   </cfif>
				   
		<cfif url.personno neq "">
		AND       A.PersonNo = '#url.personno#'
		</cfif>		  
		
		AND       WLA.ActionClass   = '#wclass#' 
			   
		<!---		   
		<cfif url.orgunit neq "" and url.orgunit neq "0">
		AND        WP.OrgUnit = '#url.orgunit#' 
		</cfif>
		<cfif url.positionno neq "">
		AND        WP.PositionNo = '#url.positionno#' 
		</cfif>	
		--->
		<!---
		AND        WP.DateEffective = '#dateformat(url.selecteddate,client.dateSQL)#'
		--->
		
		AND        WL.Operational   = 1
		<!---
		AND        WLA.ActionStatus != '9'
		--->
		AND        WPD.Operational = 1
		
		
		) as CC
		
		WHERE 1=1 
		
		--condition
								
</cfquery>			

<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>
	
	<cfoutput>
		<tr><td style="padding:5px" class="labellarge">#url.mission# <cf_tl id="Agenda"></td></tr>
	</cfoutput>

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:5px">
		<cf_securediv id="divListingContainer" style="height:100%"
		  bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#&personno=#url.personno#">        	
	</td>	
	
   </tr>

</table>		
		