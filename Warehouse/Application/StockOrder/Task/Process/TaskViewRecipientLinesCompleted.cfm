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
<cfparam name="url.script"        default="0">
<cfparam name="url.warehouse"     default="">
<cfparam name="url.status"        default="">
<cfparam name="url.requesttype"   default="">


<cfquery name="Parameter" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission  = '#url.mission#'	
</cfquery>

<!--- limit access if the role of ServiceRequester and limit access if role is WorkOrderProcessor --->

<cfoutput>

<cfsavecontent variable="myquery">	

		<!--- single lines --->

		SELECT  H.Created, 
		        H.Reference, 
				O.OrgUnitCode, 
				LEFT(O.OrgUnitName,40) as OrgUnitName, 
				H.Contact, 
				H.City,
				H.RequestType,
				H.DateDue,
				
				(
				SELECT   MAX(TransactionDate)
				FROM     ItemTransaction I
				WHERE    RequestId IN (SELECT RequestId 
				                       FROM   Request 
									   WHERE  Requestid = I.RequestId and Reference = H.Reference)
				) as Completed,
				
				S.Description,
				H.RequestHeaderId,
				
				CASE    (SELECT     COUNT(*)
                	     FROM   Request
                         WHERE  Reference  = H.Reference 
						) WHEN 1 THEN  	
							   
						(  SELECT  TOP 1 I.ItemDescription
		                   FROM    Request D, Item I
						   WHERE   D.ItemNo  = I.ItemNo
                		   AND     Reference = H.Reference) 	
				   
				ELSE
				
						'[ MULTIPLE LINES ]' 
				
				END as ItemDescription,   
				
				CASE   (SELECT    COUNT(*)
                	    FROM       Request
                        WHERE      Reference  = H.Reference 
					    ) WHEN 1 THEN  	
							   
				    ( SELECT  TOP 1 RequestedQuantity
                      FROM    Request
				      WHERE   Reference = H.Reference) 	
				   
				ELSE
				
				    ( SELECT  COUNT(*)
                      FROM    Request
                      WHERE   Reference = H.Reference)
				
				END  as Quantity,	  
				   
				H.Remarks
				
		FROM    RequestHeader H INNER JOIN
                Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
				Status S ON S.Class= 'Header' AND S.Status = H.ActionStatus
				
		WHERE   H.Mission = '#url.mission#'		
				
		AND     H.ActionStatus  = '5'
	
	   <cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
			
	   <cfelse>	
	   
		   <!--- Hanno 15/6 alert what happens if the request was tasked to another warehouse 
		       and also received to which this person does not have access --->
	
	    AND     H.Reference IN (
	                       SELECT     Reference
               	           FROM       Request
                   	       WHERE      Reference  = H.Reference 						  
						   AND  (
							
									 ShipToWarehouse IN (
									 <!--- only if the user may indeed submit for the warehouse --->
									 #preservesinglequotes(requestaccess)#	
								     ) OR
									 ShipToWarehouse IN (
									 <!--- only if the user may indeed submit for the warehouse --->
									 #preservesinglequotes(facilityaccess)#	
								     )
								 )	
			 
		        )	 
			
	   </cfif>													   
					
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Request", 					
					  field      = "Reference",																
					  search     = "text"}>		

<!---
					  
<cfif url.status eq "">
							  
	<cfset itm = itm + 1>						
	<cfset fields[itm] = {label      = "Status", 					
						  field      = "Description",	
						  filtermode = "2",												
						  search     = "text"}>						  
</cfif>					  

--->

<cfset itm = itm + 1>						
<cfset fields[itm] = {label      = "Type", 					
					  field      = "RequestType",	
					  filtermode = "3",												
					  search     = "text"}>		
			  				
<cfset itm = itm + 1>
<cfset fields[itm] = {label       = "Date",                    
     				  field       = "Created",
					  alias       = "R",	
					  searchalias = "R",	
					  formatted   = "dateformat(Created,CLIENT.DateFormatShow)",												
					  search      = "date"}>	

					  
<cfset itm = itm + 1>
<cfset fields[itm] = {label       = "Region",                    
     				  field       = "City",		
					  filtermode  = "2",					
					  search      = "text"}>							  					  	
					
<cfset itm = itm + 1>
<cfset fields[itm] = {label       = "Unit",                    
     				  field       = "OrgUnitName",		
					  filtermode  = "2",	
					  width       = "60",				
					  search      = "text"}>	
					  				  
<!---				  
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Lines",                   		
					field       = "Lines",		
					align       = "center",																			
					search      = ""}>							  		
--->

				  				  
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Due",                   		
					field       = "DateDue",									
					alias       = "H",	
					formatted   = "dateformat(DateDue,CLIENT.DateFormatShow)",												
					search      = "date"}>		
					
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Completed",                   		
					field       = "Completed",													
					formatted   = "dateformat(Completed,CLIENT.DateFormatShow)"}>												  					  
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Product",                    
					  field       = "ItemDescription", 													
					  search      = ""}>	
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Quantity",                    
					  field       = "Quantity", 
					  align       = "right"}>										  					  				

<!---					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Requester",                    
					  field       = "Contact", 													
					  search      = "text"}>						  
--->				  								  					  
  				  				  				
<cfset itm = itm+1>	
<cfset fields[itm] = {label     = "Remarks",                    
	     			field       = "Remarks",	
					alias       = "H",					
					rowlevel    = "2",
					colspan     = "9",																						
					search      = "text"}>							
 				  				  				
<cfset itm = itm+1>	
<cfset fields[itm] = {label     = "id",                    
	     			field       = "RequestHeaderId",	
					display     = "No", 																												
					search      = "text"}>			
										
<cfset menu=ArrayNew(1)>	
							
<cf_listing
	    header           = "requestlinelist"
	    box              = "requestlinelistdetail"
		link             = "#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewRecipientLines.cfm?filter=completed&mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"
	    html             = "No"		
		tableheight      = "100%"
		tablewidth       = "98%"
		datasource       = "AppsMaterials"
		listquery        = "#myquery#"
		listorderfield   = "Created"
		listorder        = "Created"
		listorderalias   = "H"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		show             = "40"		
		menu             = "#menu#"
		filtershow       = "show"
		excelshow        = "Yes" 		
		listlayout       = "#fields#"
		drillmode        = "securewindow" 
		systemfunctionid = "#url.systemfunctionid#"
		annotation       = "whsRequest"
		drillargument    = "#client.height-160#;#client.width-100#;true;false"	
		drilltemplate    = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?presentation=pdf&drillid="
		drillkey         = "RequestHeaderId"
		drillbox         = "addworkorder"
		classheader      = "labelit">	
	