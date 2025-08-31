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
		
		SELECT  R.RequestId, 
				R.RequestDate, 
				C.CustomerName, 
				R.ServiceDomain, 
				R.DomainReference, 
				RL.ServiceItem, 
				S.Description, 
				R.ServiceDomainClass, 
                X.Description AS DomainClass,
                C.PersonNo
		FROM   Request AS R INNER JOIN
               Customer AS C ON R.CustomerId = C.CustomerId INNER JOIN
               RequestLine AS RL ON R.RequestId = RL.RequestId INNER JOIN
               ServiceItem AS S ON RL.ServiceItem = S.Code INNER JOIN
               Ref_ServiceItemDomainClass AS X ON R.ServiceDomain = X.ServiceDomain AND R.ServiceDomainClass = X.Code
		WHERE   R.Mission = '#url.Mission#' 
		AND 	R.RequestId NOT IN
                          (SELECT     RequestId
                            FROM          RequestWorkOrder
                            WHERE      RequestId = R.RequestId)
        AND 	R.ActionStatus <> '9'		
					
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
					
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "RequestDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "dateformat(RequestDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>	
					
					
	<cfset itm = itm+1>
	<cf_tl id="Patient" var = "1">			
	<cfset fields[itm] = {label       	= "#lt_text#",                    
	     				field         	= "CustomerName",					
						alias         	= "",							
						functionscript  = "ShowCandidate",
						functionfield 	= "PersonNo",
						width         	= "35",																	
						search        	= "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Type" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ServiceDomain",					
						alias       = "",		
						width       = "30",																	
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DomainReference",																	
						alias       = "",	
						width       = "30",																		
						search      = "text",
						filtermode  = "2"}>			
						
	<cfset itm = itm+1>	
	<cf_tl id="Service" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Description",																	
						alias       = "ServiceDescription",																			
						search      = "text",
						width       = "30",	
						filtermode  = "2"}>																				

	<cfset itm = itm+1>	
	<cf_tl id="Class" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DomainClass",																	
						alias       = "",																			
						search      = "text",
						width       = "30",	
						filtermode  = "2"}>																				
																																	
																											
		
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "billing"
	    box                 = "listing"
		link                = "#SESSION.root#/WorkOrder/Application/Medical/Complaint/Listing/RequestListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listorderfield      = "RequestDate"
		listorder           = "RequestDate"
		listorderdir        = "DESC"
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "workflow" 
		drilltemplate       = "workflow"
		drillargument       = "#client.height-90#;#client.width-90#;false;false"
		drillkey            = "requestid"
		drillbox            = "addaddress">	
		
