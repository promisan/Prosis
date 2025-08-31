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
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>	  	

		SELECT  C.CustomerId, 
				C.CustomerName, 
				C.eMailAddress, 
				O.OrgUnitName, 
				WLA.DateTimePlanning, 
				WLA.OfficerUserId, 
				WLA.OfficerLastName, 
				WLA.OfficerFirstName, 
	            WLA.Created, 
	            WL.WorkOrderLineId,
				WLA.WorkActionId,
	            D.Description AS DomainClass,
	            S.Description AS ServiceDescription
	            
		FROM   WorkOrder AS W INNER JOIN
	           WorkOrderLine AS WL ON W.WorkOrderId = WL.WorkOrderId INNER JOIN
	           WorkOrderLineAction AS WLA ON WL.WorkOrderId = WLA.WorkOrderId AND WL.WorkOrderLine = WLA.WorkOrderLine INNER JOIN
	           Ref_Action AS R ON WLA.ActionClass = R.Code INNER JOIN
	           Customer AS C ON W.CustomerId = C.CustomerId INNER JOIN
	           Organization.dbo.Organization AS O ON WL.OrgUnitImplementer = O.OrgUnit INNER JOIN
	           Ref_ServiceItemDomainClass AS D ON WL.ServiceDomain = D.ServiceDomain AND WL.ServiceDomainClass = D.Code INNER JOIN 
	           ServiceItem S ON S.Code = W.ServiceItem
		
		WHERE  R.ActionFulfillment = 'Schedule' 
		AND    W.Mission = '#url.mission#'
		AND    WL.Operational = 1
		AND    WL.ActionStatus < '3' 
		AND    WLA.WorkActionId NOT IN (SELECT WorkActionId
	                                    FROM   WorkPlanDetail
	                                    WHERE  WorkActionId = WLA.WorkActionId) 
		AND    DateTimePlanning > getDate()-180				
										
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>		

	<cfset itm = itm+1>
	<cf_tl id="Requested" var = "1">				
	<cfset fields[itm] = {label     		= "#lt_text#",                    
	     				field       		= "DateTimePlanning",					
						alias       		= "",		
						align       		= "center",		
						functionscript      = "openschedule",
						functionfield 		= "workactionid",
						formatted   		= "dateformat(DateTimePlanning,CLIENT.DateFormatShow)",																	
						search      		= "date"}>			
					
	<cfset itm = itm+1>
	<cf_tl id="Patient" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "CustomerName",					
						alias         = "",	
						functionscript= "openaction",
						functionfield = "workorderlineid",
						width         = "35",																	
						search        = "text"}>		
				
	<cfset itm = itm+1>
	<cf_tl id="eMail" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "eMailAddress",																	
						alias       = "",	
						width       = "30",																		
						search      = "text"}>		
																		
	<cfset itm = itm+1>
	<cf_tl id="Unit" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrgUnitName",					
						alias       = "",		
						width       = "30",		
						filtermode  = "2",															
						search      = "text"}>		

	<cfset itm = itm+1>	
	<cf_tl id="Service" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ServiceDescription",																	
						alias       = "ServiceDescription",																			
						search      = "text",
						width       = "30",	
						filtermode  = "2"}>	
												
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DomainClass",																	
						alias       = "",	
						width       = "30",																		
						search      = "text",
						filtermode  = "2"}>								
																			
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "schedule"
	    box                 = "listing"
		link                = "#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/WorkPlan/ScheduleAction/ActionListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listorderfield      = "DateTimePlanning"
		listorder           = "DateTimePlanning"
		listorderdir        = "ASC"
		listgroupfield      = "OrgUnitName"
		listgroup           = "OrgUnitName"
		listgroupdir        = "DESC"
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drillargument       = "#client.height-90#;#client.widthfull-90#;false;false"	
		drilltemplate       = "workflow"
		drillkey            = "WorkActionId"
		drillbox            = "addschedule">
		