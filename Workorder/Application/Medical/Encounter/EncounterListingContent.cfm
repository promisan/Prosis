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
<!--- listing --->


<cfoutput>

	<cfquery name="qCheck"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  * 
		FROM    Customer
		WHERE   PersonNo = '#URL.ID#'
	</cfquery>	

	<cfsavecontent variable="myquery">
	    SELECT *
		FROM (
			SELECT   WLA.WorkActionId,
					 WL.ServiceDomain, 
					 WL.ServiceDomainClass, 
					 WPD.DateTimePlanning, 
					 WLA.DateTimeActual, 
					 WP.PositionNo, 
					 WP.PersonNo, 
					 W.ServiceItem,
					 SI.Description,
					 P.LastName + ' ' + P.FirstName as Specialist, 				
					 WLA.ActionStatus,
					 WLA.ActionClass,
					 (
					 SELECT Reference 
					 FROM   Request R, RequestWorkOrder RW
					 WHERE  R.RequestId = RW.RequestId
					 AND    RW.WorkOrderLine = WL.WorkOrderLine
					 AND    RW.WorkorderId   = WL.WorkOrderId
					 ) as RequestReference 
					 
			FROM     WorkPlan WP INNER JOIN
			         WorkPlanDetail WPD ON WP.WorkPlanId = WPD.WorkPlanId RIGHT OUTER JOIN
			         WorkOrderLine WL INNER JOIN
			         WorkOrderLineAction WLA ON WL.WorkOrderId = WLA.WorkOrderId AND WL.WorkOrderLine = WLA.WorkOrderLine INNER JOIN
			         WorkOrder W ON WL.WorkOrderId = W.WorkOrderId ON WPD.WorkActionId = WLA.WorkActionId LEFT OUTER JOIN
					 ServiceItem SI ON SI.Code = W.Serviceitem LEFT OUTER JOIN                      
			         Employee.dbo.Person P ON WP.PersonNo = P.PersonNo
			WHERE    WLA.ActionClass   IN (SELECT Code FROM Ref_Action WHERE Mission = '#qCheck.mission#' AND ActionFulfillment = 'Schedule')		
			AND      W.CustomerId      = '#qCheck.CustomerId#' 
			AND      WL.Operational    = 1 
			AND      W.ActionStatus   <> '9' 
			AND      WL.ActionStatus <> '9'
			AND      WLA.ActionStatus <> '9'
			AND      WPD.DateTimePlanning is not NULL
			AND      WPD.Operational = 1
			
		) as Content	
		WHERE 1=1	
	</cfsavecontent>
	
	
	
	
</cfoutput>

<cf_tl id="DateTimePlanning"   	var="vDateTimePlanning">
<cf_tl id="Hour"        		var="vTimePlanning">
<cf_tl id="Request"		    	var="vRequest">
<cf_tl id="ServiceItem"			var="vServiceItem">
<cf_tl id="Class"				var="vClass">
<cf_tl id="ServiceDomain"   	var="vServiceDomain">
<cf_tl id="PositionNo" 			var="vPositionNo">
<cf_tl id="Specialist"   		var="vSpecialist">
<cf_tl id="Action"   			var="vAction">
<cf_tl id="Status"   			var="vStatus">

<cfset fields=ArrayNew(1)>
				
<cfset itm = 0>

<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vServiceItem#",    
					width      = "0", 
					field      = "Description",
					search     = "text",
					filtermode = "2"}>
					
<!---
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vPositionNo#",    
					width      = "0", 
					field      = "PositionNo",						
					alias      = "WP"}>
					--->
					
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vRequest#",    
					width      = "0", 
					field      = "RequestReference",
					search     = "text"}>		
					
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vAction#",    
					width      = "0", 
					filtermode = "2",	
					field      = "ActionClass",
					search     = "text"}>															

<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#vSpecialist#",    
					width      = "0", 
					filtermode = "2",	
					field      = "Specialist",
					search     = "text"}>
	
<cfset itm = itm+1>
<cfset fields[itm] = {label    = "#vDateTimePlanning#", 
					width      = "0", 
					field      = "DateTimePlanning",	
					formatted  = "Dateformat(DateTimePlanning,CLIENT.DateFormatShow)",	
					search     = "date"}>	
<cfset itm = itm+1>
<cfset fields[itm] = {label    = "#vTimePlanning#", 
					width      = "25", 
					field      = "DateTimePlanning",	
					formatted  = "TimeFormat(DateTimePlanning, 'HH:MM')"}>	

<cfset itm = itm+1>			
<cfset fields[itm] = {label       = "#vStatus#",      
					LabelFilter = "Status", 
					field       = "ActionStatus",     
					filtermode  = "2",    
					search      = "text",
					align       = "center",
					formatted   = "Rating",
					ratinglist  = "9=Red,0=white,1=Gray,2=yellow,3=Green"}>
										
<!--- embed|window|dialogajax|dialog|standard --->
					
<cf_listing header          = "listing1"
		    box             = "orderdetail"
			link            = "#SESSION.root#/Workorder/Application/Medical/Encounter/EncounterListingContent.cfm?id=#URL.id#&owner=#URL.owner#&mission=#URL.mission#"
		    html            = "No"		
			datasource      = "AppsWorkOrder"
			listquery       = "#myquery#"
			listorder       = "DateTimePlanning"		
			listorderalias  = ""
			listorderdir    = "ASC"
			headercolor     = "transparent"		
			height          = "100%"
			filtershow      = "Yese"
			excelshow       = "No"
			listlayout      = "#fields#"			
			show            = "30"
			drillmode       = "tab"	
		    drillargument   = "870;1020;true;true"				
			drilltemplate   = "WorkOrder/Application/Medical/Encounter/DocumentView.cfm?drillid="
			drillkey        = "WorkActionId"
			drillstring     = "owner=#URL.owner#&id=#URL.id#&context=portal"
			drillbox        = "appointmentbox">