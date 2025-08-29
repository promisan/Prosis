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
<cfset actionclass = "Delivery">

<!--- listing --->

<cfoutput>

	<!--- we determine the correct local date based on the timezome --->
	<cf_getLocalTime Datasource="AppsWorkOrder" Mission="#url.mission#">
	
	<cfset dte = dateformat(localtime,client.dateSQL)>
	
	<cfsavecontent variable="myquery">
	
		SELECT     S.Description,
		           C.CustomerName, 
		           C.PostalCode, 
				   C.City, 
				   A.DateTimePlanning, 			   
				   WL.WorkOrderLineId, 
				   O.OrgUnitName, 
				   W.ActionStatus,
				   PL.Driver, 
				   PL.Schedule
				  			  
		FROM       WorkOrder AS W INNER JOIN
	               WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
				   ServiceItem AS S ON W.ServiceItem = S.Code INNER JOIN
	               Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
	               WorkOrderLineAction AS A ON WL.WorkOrderId = A.WorkOrderId AND WL.WorkOrderLine = A.WorkOrderLine LEFT OUTER JOIN
				   
				   <!--- planned for today --->
			 				 
				 	(
				 
				    SELECT  W.WorkPlanId, 
					        D.PlanOrder, 
							D.PlanOrderCode, 
							R.Description as Schedule,							
							P.LastName as Driver, 
							D.DateTimePlanning as PlanDate,														
							D.WorkActionId
							
				    FROM    WorkPlan AS W INNER JOIN
                            WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId INNER JOIN
                            Employee.dbo.Person AS P ON W.PersonNo = P.PersonNo INNER JOIN
							Ref_PlanOrder AS R ON R.Code = D.PlanOrderCode
					WHERE   W.Mission = '#url.mission#' 													
					AND     D.WorkActionId IS NOT NULL 
					
					) PL ON A.WorkActionId = PL.WorkActionId AND A.DateTimePlanning	= PL.PlanDate				   
				   	 
				   INNER JOIN  Organization.dbo.Organization AS O ON W.OrgUnitOwner = O.OrgUnit 				  
	
		WHERE      W.Mission         = '#url.mission#'		
		AND        A.ActionClass     = '#actionclass#' 	
		AND        S.Selfservice     = '1'
		AND        WL.Operational = 1
		AND        W.ActionStatus != '9'
		AND        A.DateTimePlanning >= '#dte#'  <!--- all transactions of yesterday and future --->	
						
		<cfif getAdministrator("*") eq "0">
		AND        O.OrgUnit IN (SELECT OrgUnit FROM System.dbo.UserMission WHERE Account = '#SESSION.acc#')
		</cfif>
		
				
	</cfsavecontent>

</cfoutput>

<cf_tl id="Service"  var="service">
<cf_tl id="Delivery" var="delivery">
<cf_tl id="Branch"   var="branch">
<cf_tl id="Name"     var="Name">
<cf_tl id="City"     var="City">
<cf_tl id="ZIP"      var="ZIP">
<cf_tl id="Date"     var="Date">
<cf_tl id="Schedule" var="Schedule">
<cf_tl id="Driver"   var="Driver">
<cf_tl id="Status"   var="status">

<cfset fields=ArrayNew(1)>
				
<cfset itm = 0>
			
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "#delivery#", 
					width      = "0", 
					field      = "DateTimePlanning",	
					formatted  = "dateformat(DateTimePlanning,CLIENT.DateFormatShow)",	
					search     = "date",	
					filtermode = "2",			
					alias      = ""}>				
			
<cfset itm = itm+1>				
<cfset fields[itm] = {label      = "#branch#",    
					width      = "0", 
					field      = "OrgUnitName",
					search     = "text",
					filtermode = "2",					
					alias      = "O"}>		
					
<cfset itm = itm+1>				
<cfset fields[itm] = {label      = "#service#",    
					width      = "0", 
					field      = "Description",
					search     = "text",
					filtermode = "2",
					searchfield = "Description",
					alias      = "S"}>				
							
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "#name#", 
                    width      = "0", 					
					field      = "CustomerName",
					alias      = "",
					search     = "text"}>
								
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "#city#",    
					width      = "0", 
					field      = "City",
					alias      = ""}>									

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "#zip#", 
                    width      = "0", 
					field      = "PostalCode", 	
					search     = "text",				
					alias      = ""}>		
							
<cfset itm = itm+1>				
<cfset fields[itm] = {label      = "#Schedule#",    
					width      = "0", 
					field      = "Schedule",
					alias      = ""}>		
					
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "#status#",    
					width      = "0", 
					field      = "ActionStatus",
					formatted  = "rating",
					align      = "center",
					size       = "10",
					ratinglist = "0=White,1=Green,9=red",
					alias      = ""}>							
					
<!--- second line fields --->
					
<!--- hidden fields --->					
						
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Address", 
                    width      = "1%", 					
					display    = "No",
					alias      = "",
					field      = "Address"}>									
	
<cfset itm = itm+1>
<cfset fields[itm] = {label      = "Id", 
                    width      = "1%", 					
					display    = "No",
					alias      = "",
					field      = "WorkOrderLineId"}>	
			
<!--- embed|window|dialogajax|dialog|standard --->

<cfsavecontent variable="myaddscript">

	<cfoutput>
		h = #client.height-170#;
		w = #client.width-100#;
		window.open('#SESSION.root#/WorkOrder/Application/WorkOrder/Create/WorkOrderAdd.cfm?systemfunctionid=#url.systemfunctionid#&context=portal&mission=#url.mission#','_blank','left=30, top=30, width=' + w + ', height= ' + h + ', toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes');		
	</cfoutput>

</cfsavecontent>

<cfset menu=ArrayNew(1)>

<cf_tl id="Add Record" var="add">
														
<cfset menu[1] = {label = "#add#", icon = "add.png", script = "#myaddscript#"}>				 		
					
<cf_listing header          = "listing1"
		    box             = "orderdetail"
			link            = "#SESSION.root#/Workorder/Portal/Organization/Service/ServiceListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
		    html            = "No"		
			datasource      = "AppsWorkOrder"
			listquery       = "#myquery#"
			listgroup       = "DateTimePlanning"
			listorder       = "OrgUnitName"		
			listorderdir    = "ASC"
			headercolor     = "transparent"		
			height          = "100%"
			menu            = "#menu#"
			filtershow      = "Hide"
			excelshow       = "No"
			listlayout      = "#fields#"			
			show            = "30"
			drillmode       = "window"	
		    drillargument   = "870;1020;true;true"				
			drilltemplate   = "WorkOrder/Application/WorkOrder/Create/WorkOrderEdit.cfm?drillid="
			drillkey        = "WorkOrderLineId"
			drillstring     = "systemfunctionid=#url.systemfunctionid#&context=portal"
			drillbox        = "addworkorder">