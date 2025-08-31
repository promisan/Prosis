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
<cfparam name="url.mission"    default="">
<cfparam name="url.customerid" default="">

<cfoutput>
	
	<cfsavecontent variable="myquery">
	
	       SELECT *
		   FROM (
	
			SELECT     W.Mission,
			           W.ServiceItem, 
					   WL.PersonNo AS ActorPersoNo, 
					   S.Description, 
					   SC.Description AS ServiceItemClass, 
					   W.CustomerId, 
					   C.PersonNo, 
					   C.CustomerName, 
	                   WL.DateEffective, 
					   (
					   	SELECT TOP 1 WLA.DateTimePlanning
					   	FROM WorkOrderLineAction WLA 
					   	WHERE 
					   		WLA.WorkOrderId = WL.WorkOrderId  
					   		AND WLA.WorkOrderLine = WL.WorkOrderLine
					   		AND  WLA.ActionStatus <> '9' 
					   ) as DateTimePlanning, 
					   <!---
					   WLA.ActionClass, 
					   WLA.DateTimeActual, 
					   --->
					   WL.ActionStatus, 
					   WL.Operational, 
					   WL.OrgUnitImplementer, 
					   (SELECT LastName FROM Employee.dbo.Person WHERE PersonNo = WL.PersonNo) as ActorName,
	                   O.OrgUnitName AS NameImplementer, 
					   W.OrgUnitOwner, 
					   WL.Priority, 
					   WL.WorkOrderLineId
					   <!--- , WLA.WorkActionId --->
					   
			FROM       WorkOrder W INNER JOIN
	                   WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN					   
					   <!---
	                   WorkOrderLineAction WLA ON WL.WorkOrderId = WLA.WorkOrderId AND WL.WorkOrderLine = WLA.WorkOrderLine INNER JOIN
					   --->
	                   Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	                   ServiceItem S ON W.ServiceItem = S.Code INNER JOIN
	                   Ref_ServiceItemDomainClass SC ON WL.ServiceDomain = SC.ServiceDomain AND WL.ServiceDomainClass = SC.Code LEFT OUTER JOIN
	                   Organization.dbo.Organization O ON WL.OrgUnitImplementer = O.OrgUnit
					   
			WHERE      C.PersonNo = '#url.id#'
			
			<!--- ----------------------------------------- --->
			<!--- access limitation for workorder processor --->
			<!--- ----------------------------------------- --->
			
			<cfif url.mission neq "">
			AND       C.Mission = '#url.mission#'
			</cfif>
			
			<cfif getAdministrator("*") eq "0">
			
			AND        EXISTS (SELECT 'X'
			                   FROM    Organization.dbo.OrganizationAuthorization OA
							   WHERE   OA.Mission        =  W.Mission
							   AND     OA.UserAccount    = '#session.acc#'
							   AND     OA.Role           = 'WorkOrderProcessor'
							   AND     (OA.OrgUnit       = WL.OrgUnitImplementer OR OA.OrgUnit is NULL)							   
							   AND     OA.ClassParameter = W.ServiceItem
							   AND     OA.AccessLevel IN ('0','1','2'))
							   
			</cfif>				   
			
			<!--- ------------------------------------------ --->
			<!---			
			AND        WL.Operational = 1 
			--->
			AND        W.ActionStatus <> '9' 
			<!--- AND  WLA.ActionStatus <> '9' ---> ) as SUB			
		
	</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>					
<cf_tl id="Entity" var="vEntity">
<cfset fields[itm] = {label     = "#vEntity#",                    
					field       = "Mission", 							
					align       = "left",		
					filtermode  = "2", 
					search      = "text"}>	
					
<cfset itm = itm+1>					
<cf_tl id="Unit" var="vUnit">
<cfset fields[itm] = {label     = "#vUnit#",                    
					field       = "NameImplementer", 							
					align       = "left",		
					filtermode    = "2", 
					search      = "text"}>			
					
<cfset itm = itm+1>					
<cf_tl id="Actor" var="vActor">
<cfset fields[itm] = {label     = "#vActor#",                    
					field       = "ActorName", 							
					align       = "left",		
					filtermode    = "2", 
					search      = "text"}>											
					
<cfset itm = itm+1>					
<cf_tl id="Service" var="vService">
<cfset fields[itm] = {label     = "#vService#",                    
					field       = "Description", 							
					align       = "left",	
					filtermode  = "2", 	
					search      = "text"}>		
					
<cfset itm = itm+1>					
<cf_tl id="Class" var="vClass">
<cfset fields[itm] = {label     = "#vClass#",                    
					field       = "ServiceItemClass", 							
					align       = "left",		
					filtermode  = "2", 
					search      = "text"}>		
					
<cfset itm = itm+1>					
<cf_tl id="S" var="vStatus">
<cfset fields[itm] = {label     = "#vStatus#",                    
					field       = "ActionStatus", 		
					formatted     = "Rating",
					width         = "20",
					align       = "center",	
					ratinglist    = "0=white,1=yellow,3=Green,9=red"}>																					
					
<cfset itm = itm+1>					
<cf_tl id="Planning date" var="vPlanningDate">
<cfset fields[itm] = {label     = "#vPlanningDate#",                    
					field       = "DateTimePlanning", 		
					formatted   = "dateformat(DateTimePlanning,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	

<cfset itm = itm+1>					
<cf_tl id="Start date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",                    
					field       = "DateEffective", 		
					formatted   = "dateformat(DateEffective,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	

				
					
<cfset itm = itm+1>												
<cfset fields[itm] = {label         = "", 					                     
					  field         = "WorkOrderLineId",					
					  display       = "no"}>	

<!---						
<cfset itm = itm+1>					
<cf_tl id="Officer" var="vOfficer">
<cfset fields[itm] = {label     = "#vOfficer#",                    
					field       = "OfficerlastName", 	
					alias       = "T.",				
					search      = "text"}>		
			
--->					
	
<!--- define access 

<cfinvoke component = "Service.Access"  
	method          = "WorkorderProcessor" 
	mission         = "#workorder.mission#" 
	serviceitem     = "#workorder.serviceitem#"
	returnvariable  = "access">	    
					
<cfif access eq "EDIT" or access eq "ALL">		
	
	<cf_tl id="Add Record" var="vAdd">
	<cfset menu[1] = {label  = "#vAdd#", 
	                  icon   = "insert.gif", 
					  script = "addorder('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
					  
	<cfset dt = "ItemTransaction">
	<cfset dk = "TransactionId">   				  
						  
<cfelse>	

--->
	
	<cfset menu = "">			
	<cfset dt = "">
	<cfset dk = "">			  
	
<!---	
			
</cfif>				

--->

<cfset menu=ArrayNew(1)>	
	
<!--- access only for workorder processors and if the mission is selected --->	
	
<cfif url.mission neq "">
		   		   
	<cfinvoke component = "Service.Access"  
		   method           = "WorkOrderProcessor" 
		   mission          = "#url.mission#"  
		   returnvariable   = "access">
								   
	<cfif access eq "EDIT" or access eq "ALL">			
			
		<cf_tl id="Add Order" var="1">									
		<cfset menu[1] = {label = "#lt_text#", icon = "add.png",	script = "addorder('#url.mission#','#url.customerid#')"}>				 
					
	</cfif>		
	
</cfif>			
							
<cf_listing
	    header         = "supplieslist"
	    box            = "adhoc"
		link           = "#SESSION.root#/System/Organization/Customer/Activities/ActivityListing.cfm?mission=#url.mission#&id=#url.id#&systemfunctionid=#url.systemfunctionid#"
	    html           = "No"		
		tableheight    = "100%"
		tablewidth     = "100%"
		datasource     = "AppsWorkOrder"
		listquery      = "#myquery#"
		listorderfield = "DateEffective"
		listorderalias = ""
		listorder      = "DateEffective"
		listorderdir   = "DESC"		
		show           = "40"			
		menu           = "#menu#"			
		filtershow     = "Hide"
		excelshow      = "Yes" 		
		listlayout     = "#fields#"
		drillmode      = "tab" 
		drilltemplate  = "Workorder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid="
		drillargument  = "990;1000;true;true"			
		drillkey       = "workorderlineid"		
		drillbox       = "addworkorder">	
		