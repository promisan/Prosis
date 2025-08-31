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

<cfset wclass = "Contact">
<cf_tl id="Completed" var="lblCompleted">
<cf_tl id="Process"   var="lblProcess">
<cf_tl id="Revoked"   var="lblRevoked">

<cfoutput>
		
	<cfsavecontent variable="myquery">
	
	    SELECT TOP 100 PERCENT *,
					CASE 
		        		WHEN ISNULL(ParentWorkORderID,'00000000-0000-0000-0000-000000000000')='00000000-0000-0000-0000-000000000000' AND WorkActionID = FirstWorkActionID THEN
		        		CASE 
		        			WHEN wlaactionstatus = '8' THEN
		        				'1CAU'
		        			WHEN wlaactionstatus = '9' THEN
		        				'1CCA'
		        			ELSE
						    	'1C'
						END
					ELSE 
						CASE 
							WHEN LastServiceDomainClass = wlservicedomainclassnow THEN
								CASE
									WHEN wlaactionstatus = '8' THEN
		        						'REAU'
		        					WHEN wlaactionstatus = '9' THEN
		        						'RECA'
		        				ELSE
						    		'RE'
						    	END
						ELSE
							CASE
								WHEN wlaactionstatus = '8' THEN
		        					'NPAU'
		        				WHEN wlaactionstatus = '9' THEN
		        					'NPCA'
		        				ELSE
						    		'NP'
						    END
						END
					END as contact				 
		
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
							WHEN WL.ActionStatus = '9'  THEN '#lblRevoked#'	END as WorkOrderLineActionStatus,	
							
					   R.Description, 
					   WPD.DateTimePlanning, 
					   P.FirstName as ActorFirstName,
					   P.LastName  as ActorLastName,
					   O.OrgUnitName,
					   C.CustomerName,
					   A.LastName, 
					   A.FirstName, 
					   A.PersonNo, 
					   ISNULL(A.DocumentReference, A.PersonNo) as DocumentReference,				   
					   W.CustomerId,
		               WLA.WorkActionId
					   
			FROM       WorkPlanDetail WPD WITH (NOLOCK) 
			           INNER JOIN  WorkPlan WP WITH (NOLOCK)                ON WPD.WorkPlanId = WP.WorkPlanId 
					   INNER JOIN  WorkOrderLineAction WLA WITH (NOLOCK)    ON WPD.WorkActionId = WLA.WorkActionId 
					   INNER JOIN  Organization.dbo.Organization O WITH (NOLOCK) ON O.OrgUnit = WP.OrgUnit 
					   INNER JOIN  Employee.dbo.Person P WITH (NOLOCK)      ON P.PersonNo = WP.PersonNo 
					   INNER JOIN  WorkOrderLine WL WITH (NOLOCK)           ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine 
					   INNER JOIN  WorkOrderService WS WITH (NOLOCK)        ON WS.ServiceDomain = WL.ServiceDomain AND WS.Reference = WL.Reference 
					   INNER JOIN  Ref_ServiceItemDomainClass R WITH (NOLOCK) ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code 
					   INNER JOIN  WorkOrder W WITH (NOLOCK)                ON WL.WorkOrderId = W.WorkOrderId 
					   INNER JOIN  Customer C WITH (NOLOCK)                 ON W.CustomerId = C.CustomerId 
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
									
	</cfsavecontent>	

</cfoutput>	

<cfset itm = 0>

<cfif url.personno eq "">
    <cfset filter = "yes"> 
	<cfset force  = "1">
<cfelse>
    <cfset filter = "hide">
	<cfset force = "0">
</cfif>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Scheduled" var = "1">				
	<cfset fields[itm] = {label       	= "#lt_text#",                    
	     				field         	= "DateTimePlanning",					
						alias         	= "",	
						filterforce   	= "#force#",	
						functionscript  = "openschedule",
						functionfield 	= "workactionid",
						align         	= "left",		
						width         	= "12",
						formatted     	= "lsdateformat(DateTimePlanning,'dd/mm/YYYY')",																	
						search        	= "date"}>
	
	<cfset itm = itm+1>					
	<cf_tl id="Day" var = "1">				
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "DateTimePlanning",					
						alias           = "",	
						filterforce     = "#force#",							
						align           = "left",		
						width           = "6",
						formatted       = "lsdateformat(DateTimePlanning,'DDD')"}>					
						
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1">				
	<cfset fields[itm] = {label         = "#lt_text#",                    
	     				field           = "DateTimePlanning",					
						alias           = "",		
						align           = "center",		
						formatted       = "timeformat(DateTimePlanning,'HH:MM')"}>		
						
	<cfset itm = itm+1>	
	<cf_tl id="Status" var = "1">						
	<cfset fields[itm] = {label         = "Status", 	
                      LabelFilter       = "#lt_text#",				
					  field             = "WorkOrderlineActionStatus",					
					  filtermode        = "3",    
					  search            = "text",
					  align             = "center",
					  formatted         = "Rating",
					  ratinglist        = "Process=Yellow,Completed=Blue,Process=Green,Revoked=Red"}>						
			
	<cfif url.personno eq "">	
					
		<cfset itm = itm+1>
		<cf_tl id="Patient" var = "1">			
		<cfset fields[itm] = {label       	= "#lt_text#",                    
		     				field         	= "CustomerName",					
							alias         	= "",	
							functionscript  = "openaction",
							functionfield 	= "workorderlineid",																						
							search        	= "text"}>	
													
	</cfif>	
	
	<cfset itm = itm+1>
	<cf_tl id="Specialist" var = "1">			
	<cfset fields[itm] = {label       		= "#lt_text#",                    
	     				field         		= "ActorLastName",					
						alias         		= "",				
						functionscript      = "openaction",
						functionfield 		= "workorderlineid",																								
						search        		= "text",
						filtermode    		= "3"}>	
						
	<cfset itm = itm+1>	
	<cf_tl id="Type" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "Contact",																																								
						search              = "text",	
						width               = "8",						
						filtermode          = "3"}>												
						
	<cfset itm = itm+1>	
	<cf_tl id="Action" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "WorkOrderService",																																								
						search              = "text",						
						filtermode          = "3"}>		
						
				
	<cfset itm = itm+1>
	<cf_tl id="Unit" var = "1">				
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "OrgUnitName",					
						alias               = "",	
						display             = "0",
						displayfilter       = "Yes",						
						filtermode          = "2",																						
						search              = "text"}>					
	
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "Description",																	
						alias               = "",																							
						search              = "text",
						filtermode          = "2"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Plan" var = "1">		
	<cfset fields[itm] = {label             = "#lt_text#",                    
	     				field               = "PlanOrder",																	
						alias               = "",		
						width               = "8",																					
						search              = "text",
						filtermode          = "2"}>						
																										
<cfset menu=ArrayNew(1)>	

<!--- <cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "ActionStatus", value= "1"}>	 --->	

<cf_listing
	    header              = "billing"
	    box                 = "listing"
		link                = "#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&personno=#url.personno#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		queryfiltermode     = "query"  <!--- always take the lookup values from the query --->		
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listorderfield      = "DateTimePlanning"
		listorder           = "DateTimePlanning"	
		listgroupdir        = "DESC"	
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "#filter#"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.widthfull-90#;false;false"	
		drilltemplate       = "workflow"
		drillkey            = "WorkActionId"
		drillbox            = "addaddress">
		
		<!---
			listgroupfield      = "DateTimePlanning"
		listgroup           = "DateTimePlanning"
		listgroupdir        = "DESC"
		--->
		
	<cfset ajaxonload("doCalendar")>