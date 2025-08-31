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
<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity
  WHERE   EntityCode  = 'WrkRequest'
</cfquery>
  
<cfset currrow = 0>

<cfoutput>
	
		<cfsavecontent variable="myquery">			
						
			SELECT     R.Mission, 
			           S.Description AS ServiceDomain, 
					   C.Description AS ServiceClass, 
					   R.DomainReference, 
					   R.Reference, 
					   R.RequestType, 
                       K.Description AS RequestTypeName, 
					   R.DateEffective, 
					   R.RequestDate, 
					   R.RequestAction, 
					   (
					   SELECT   WL.Reference
					   FROM     WorkOrderLine AS WL INNER JOIN
                                RequestWorkOrder AS RW ON WL.WorkOrderId = RW.WorkOrderId AND WL.WorkOrderLine = RW.WorkOrderLine
					   WHERE    RW.RequestId = R.RequestId
					   ) as ReferenceNo,
					   
					   L.RequestActionName, 
					   R.ActionStatus,
					   R.RequestId
			FROM       Request R INNER JOIN
			           Ref_ServiceItemDomainClass C ON R.ServiceDomain = C.ServiceDomain AND R.ServiceDomainClass = C.Code INNER JOIN
			           Ref_ServiceItemDomain S ON R.ServiceDomain = S.Code INNER JOIN
			           Ref_Request K ON R.RequestType = K.Code INNER JOIN
			           Ref_RequestWorkflow L ON R.RequestType = L.RequestType AND R.RequestAction = L.RequestAction AND 
			           R.ServiceDomain = L.ServiceDomain
			WHERE      R.PersonNoUser = '#client.personno#'			
						
		</cfsavecontent>	
		
		
</cfoutput>
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
		
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Date",                  
					field       = "RequestDate",	
					formatted   = "dateformat(requestdate,CLIENT.DateFormatShow)",							
					search      = "date"}>		
					
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Provider",                  
					field       = "Mission",
					filtermode  = "2",
					search      = "text"}>		
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "RfsNo",    
                    labelfilter = "Request No",              
					field       = "Reference",					
					search      = "text"}>						
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Service",                  
					field       = "ServiceDomain",					
					searchalias = "S",
					searchfield = "Description",
					filtermode  = "2",
					search      = "text"}>		
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Class",                  
					field       = "ServiceClass",					
					searchalias = "C",
					searchfield = "Description",
					filtermode  = "2"}>							
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Reference",                  
					field       = "ReferenceNo"}>	
					
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Type of Request",                  
					field       = "RequestTypeName",	
					filtermode  = "2",				
					search      = "text"}>		
					
	
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "Effective",                  
					field       = "DateEffective",	
					formatted   = "dateformat(DateEffective,CLIENT.DateFormatShow)",							
					search      = "date"}>							
					
<!---	
<cfset itm = itm+1>						
<cfset fields[itm] = {label     = "--",                  
					field       = "ActionStatus",	
					filtermode  = "2",									
					search      = "text"}>							
					--->
														
<cfset itm = itm+1>												
<cfset fields[itm] = {label       = "St.", 					
                    LabelFilter = "Status",	
					field       = "ActionStatus",					
					filtermode  = "2",    					
					align       = "center",
					formatted   = "Rating",
					ratinglist  = "9=Red,0=white,1=Gray,2=yellow,3=Green"}>	
		   
	<cfset menu=ArrayNew(1)>	
	
	<!---
	
	<cfinvoke component = "Service.Access"  
	   method           = "createwfobject" 
	   entitycode       = "WrkRequest"
	   returnvariable   = "accesscreate">   
			   
	<cfif accesscreate eq "EDIT" or getAdministrator("*") eq "1">	    
					
		<cfset menu[1] = {label = "New Request", script = "addRequest('#url.mission#','MobileNumber','','','')"}>				 
		
	</cfif>		
	
	--->
			
	<cfset url.systemfunctionid = "">	
	
	<cf_listing
	    header        = "servicerequest"
		menu          = "#menu#"
	    box           = "servicerequest"
		link          = "#SESSION.root#/WorkOrder/Portal/User/Request/RequestListing.cfm?mission=#url.mission#"
	    html          = "No"
		show          = "40"
		datasource    = "AppsWorkOrder"
		listquery     = "#myquery#"		
		listorder     = "ServiceDomain"
		listorderdir  = "ASC"		
		headercolor   = "ffffff"
		listlayout    = "#fields#"
		filterShow    = "Hide"
		excelShow     = "Yes"
		drillmode     = "dialog"	
		drillargument = "900;1000;true;true"	
		drilltemplate = "WorkOrder/Application/Request/Request/Create/Document.cfm"
		drillkey      = "RequestId"
		annotation    = "WrkRequest">
	