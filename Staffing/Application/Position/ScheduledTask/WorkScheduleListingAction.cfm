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
<cfoutput>

<cfparam name="url.mode" default="current">

<!--- all action --->

<cfif url.mode eq "action">	
	
	<cfquery name="getPosition" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Position
			WHERE  PositionNo = '#url.positionno#'
	</cfquery>		
	
	<cfquery name="getWorkOrder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   WorkOrderImplementer
			WHERE  OrgUnit = '#getPosition.OrgUnitOperational#'
	</cfquery>		
	
	<cfquery name="getPositionSchedule" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT WorkSchedule
		FROM     WorkSchedulePosition
		WHERE    PositionNo = '#url.positionno#'
		AND      CalendarDate > getDate()
	</cfquery>	
	
	<!--- generate a list of schedules the position has technically access to --->	

	<cfinvoke component		= "Service.Process.WorkOrder.WorkOrderStaff"
	   	method	     		= "GetWorkOrderScheduledActions"
		mission             = "#getPosition.Mission#"
		workorder           = "#valueList(getWorkOrder.workorderid)#"
		workSchedule		= "#valueList(getPositionSchedule.workSchedule)#"
		tense				= "present"		
		initialDate		    = "#dateformat(getPosition.DateEffective,client.dateformatshow)#"
		endDate			    = "#dateformat(getPosition.DateExpiration,client.dateformatshow)#"					
		returnvariable	    = "activities">
		
		<!--- the table by design WorkOrderLineSchedulePosition only reflects the current situation onwards --->

	<cfsavecontent variable="myquery">
	
		SELECT    
		           C.CustomerName, 
				   S.Description  as Service, 
				   W.Reference    as WorkorderReference, 
				   left(WS.Description,50) as ServiceDescription, 
				   WL.Reference, 
				   D.Description  as DomainClass,				  
				   WLS.ScheduleId, 
				   WLS.ScheduleName, 
				   R.Description  as ActionName, 
				   WLS.WorkSchedule,
				   EWS.Description as WorkScheduleName,
				   left(WLS.Memo,50) as Memo,
				   
				   ( SELECT isActor 
				     FROM   WorkOrderLineSchedulePosition WLSP 
				     WHERE  WLS.ScheduleId = WLSP.ScheduleId 
					 AND    WLSP.PositionNo = '#url.positionno#' 
					 AND    WLSP.isActor IN ('1','2')) as isActor,
					 
				   <!--- determine access of the erspn to have workorder processor --->
				   
				   <cfif getAdministrator(getPosition.mission) eq "1">
				   
				    '2' as AccessLevel
				   
				   <cfelse>
				   				   
				   ( SELECT MAX(AccessLevel)
				     FROM   Organization.dbo.OrganizationAuthorization A
					 WHERE  Mission        = W.Mission 
					 AND    UserAccount    = '#session.acc#'
					 AND    Role           = 'WorkOrderProcessor'					 
					 AND    ClassParameter = W.ServiceItem ) as AccessLevel 
					 
				   </cfif>	 				 			  			                    
				   
		FROM       WorkOrderLineSchedule WLS 		                   
				   INNER JOIN WorkOrderLine WL ON WLS.WorkOrderId = WL.WorkOrderId AND WLS.WorkOrderLine = WL.WorkOrderLine 
				   INNER JOIN WorkOrder W   ON WL.WorkOrderId    = W.WorkOrderId 
				   INNER JOIN Customer C    ON W.CustomerId      = C.CustomerId 
				   INNER JOIN ServiceItem S ON W.ServiceItem     = S.Code 
				   
				   INNER JOIN WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
				   
				   INNER JOIN Employee.dbo.WorkSchedule EWS ON WLS.WorkSchedule = EWS.Code	  
				   INNER JOIN Ref_Action R  ON WLS.ActionClass   = R.Code  
				   LEFT OUTER JOIN Ref_ServiceItemDomainClass D ON WL.ServiceDomain = D.ServiceDomain AND WL.ServiceDomainClass = D.Code 
				  		
		<!--- show all schedules that are deemed valid --->		
		
		<cfif quotedValueList(activities.scheduleid) neq "">
		   
		WHERE      WLS.ScheduleId IN (#quotedValueList(activities.scheduleid)#)		
		
		<cfelse>
		
		WHERE      1=0
		
		</cfif>
									  
		<!--- schedule enabled --->
		AND        WLS.ActionStatus = 1 
		
		<!--- line is active --->
		AND        WL.Operational = 1  				
		AND        WL.DateEffective < GETDATE() AND (WL.DateExpiration IS NULL OR WL.DateExpiration >= GETDATE())		
		
		ORDER BY WLS.ActionClass, WL.Reference, WL.ServiceDomainClass					  		  
				
	</cfsavecontent>		

<cfelse>

	<!--- the table by design WorkOrderLineSchedulePosition only reflects the current situation onwards --->

	<cfsavecontent variable="myquery">
	
		SELECT     C.CustomerName,
			  	   S.Description  as Service, 
				   W.Reference    as WorkorderReference, 		           				  
				   WL.Reference, 
				   D.Description  as DomainClass,
				   left(WS.Description,40) as ServiceDescription, 
				   WLS.ScheduleId, 
				   WLSP.isActor,
				   CASE
					   WHEN WLSP.isActor = 0 THEN 'Not involved'
					   WHEN WLSP.isActor = 1 THEN 'Assistant'
					   WHEN WLSP.isActor = 2 THEN 'Responsible'
				   END AS isActorDescription, 
                   WLS.ScheduleName, 
				   EWS.Description as WorkScheduleName,
				   R.Description  as ActionName, 
				   WLS.WorkSchedule,
				   left(WLS.Memo,50) as Memo,
				   
				  <!--- determine if the schedule is indeed enabled for this position --->
				  
				  ( SELECT  count(DISTINCT WorkSchedule) 
				    FROM    Employee.dbo.WorkSchedulePosition
				    WHERE   CalendarDate >= getDate()
				    AND     WorkSchedule =  WLS.WorkSchedule
				    AND     PositionNo = '#URL.PositionNo#') as ValidSchedule,  
				   
				  <!--- determine access of the erspn to have workorder processor --->
				   
				  ( SELECT  MAX(AccessLevel)
				    FROM    Organization.dbo.OrganizationAuthorization A
					WHERE   Mission        = W.Mission 
					AND     UserAccount    = '#session.acc#'
					AND     Role           = 'WorkOrderProcessor'					 
					AND     ClassParameter = W.ServiceItem ) as AccessLevel 	
				   
		FROM       WorkOrderLineSchedulePosition WLSP 
		           INNER JOIN WorkOrderLineSchedule WLS ON WLSP.ScheduleId = WLS.ScheduleId 
				   INNER JOIN WorkOrderLine WL ON WLS.WorkOrderId = WL.WorkOrderId AND WLS.WorkOrderLine = WL.WorkOrderLine 
				   INNER JOIN WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
				   INNER JOIN WorkOrder W ON WL.WorkOrderId = W.WorkOrderId 
				   INNER JOIN ServiceItem S ON W.ServiceItem = S.Code 
				   INNER JOIN Customer C ON W.CustomerId = C.CustomerId 
				   INNER JOIN Ref_Action R ON WLS.ActionClass = R.Code  
				   INNER JOIN Employee.dbo.WorkSchedule EWS ON WLS.WorkSchedule = EWS.Code
				   LEFT OUTER JOIN Ref_ServiceItemDomainClass D ON WL.ServiceDomain = D.ServiceDomain AND WL.ServiceDomainClass = D.Code 
		WHERE      WLSP.isActor IN ('1','2')
		AND        WLSP.PositionNo = '#url.positionno#'  
		
		<!--- optionally add condition to set the hours for these --->		

		<!--- schedule enabled --->
		AND        WLS.ActionStatus = 1 
		
		<!--- line is active --->
		AND        WL.Operational = 1  				
		AND        WL.DateEffective < GETDATE() AND (WL.DateExpiration IS NULL OR WL.DateExpiration >= GETDATE())
		
		ORDER BY WLS.ActionClass, WL.Reference, WL.ServiceDomainClass
		
	</cfsavecontent>	
	
</cfif>	
	
</cfoutput>				
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 1>

<cfset fields[itm] = {label           = "Customer",                  
					field           = "CustomerName",
					filtermode      = "2",
					search          = "text"}>				

<cfset itm = itm+1>
	
<cfset fields[itm] = {label           = "WorkOrder",                  
					field           = "WorkOrderReference",
					filtermode      = "2",
					display         = "No",
					search          = "text"}>					

<cfset itm = itm+1>
					
<cfset fields[itm] = {label           = "Description",                  
					field           = "Memo",
					searchalias     = "WLS",		
					filtermode      = "2",
					search          = "text"}>						

<cfset itm = itm+1>
					
<cfset fields[itm] = {label           = "Schedule",  					
					field           = "WorkScheduleName",					
					filtermode      = "2",
					searchfield      = "Description",
					searchalias      = "EWS",			
					search          = "text"}>		
					
<cfif url.mode neq "action">

	<cfset itm = itm+1>
			
	<cfset fields[itm] =
		{label          = "S",      
		field           = "ValidSchedule",     
		align           = "center",
		formatted       = "Rating",	
		width           = "2%",
		ratinglist      = "0=Red,1=Green"}>
	
</cfif>																	
		
<cfset itm = itm+1>		
				
<cfset fields[itm] = {label           = "Class",  					
					field           = "DomainClass",		
					searchfield     = "Description",
					searchalias     = "D",						
					filtermode      = "2",
					search          = "text"}>					

<cfset itm = itm+1>						
<cfset fields[itm] = {label           = "Service Area",  					
					field           = "ServiceDescription",		
					searchfield     = "Description",
					width           = "50",
					searchalias     = "WS",			
					filtermode      = "2",
					search          = "text"}>						

<cfset itm = itm+1>											
<cfset fields[itm] = {label           = "Action",  					
					field           = "ActionName",	
					searchfield     = "Description",
					searchalias     = "R",						
					filtermode      = "2",
					search          = "text"}>						

<cfset itm = itm+1>								
<cfset fields[itm] = {label           = "Action Name", 					
					field           = "ScheduleName",					
					filtermode      = "0",    					
					search          = "text"}>	

<cfset itm = itm+1>							
<cfset fields[itm] = {label           = "Actor Type",  					
					 field           = "isActor",	
					 width           = "40",
					 processmode     = "radio",				
					 processlist     = "0=n/a,1=assist.,2=resp.",					
					 processtemplate = "Staffing/Application/Position/ScheduledTask/setWorkSchedule.cfm?scheduleid=",
					 processstring   = "positionno=#url.positionno#"}>							

<cfset itm = itm+1>		
<cfset fields[itm] = {label          = "access",  					
					 field           = "AccessLevel",
					 isAccess        = "Yes",
					 display         = "No"}>	

<cfset itm = itm+1>												
<cfset fields[itm] = {label          = "id",  					
					 field           = "ScheduleId",
					 alias           = "WLS",
					 isKey           = "Yes",
					 display         = "No"}>		

			
<cf_listing
    header            = "Actions"
    box               = "Actions"
	link              = "#SESSION.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleListingAction.cfm?mode=#url.mode#&positionno=#url.PositionNo#"
    html              = "No"
	show              = "40"
	datasource        = "AppsWorkOrder"
	listquery         = "#myquery#"	
	listgroup         = "CustomerName"
	listgroupfield    = "CustomerName"
	listgroupdir      = "ASC"	
	listorder         = "Service"	
	listorderdir      = "ASC"
	headercolor       = "ffffff"
	listlayout        = "#fields#"
	filterShow        = "Yes"
	excelShow         = "Yes"	
	drillmode         = "window"
	drillargument     = "950;1130;false;false"	
	drilltemplate     = "WorkOrder/Application/WorkOrder/ServiceDetails/Schedule/ScheduleEdit.cfm?mode=edit&scheduleid="	
	drillstring       = "">
						  					  