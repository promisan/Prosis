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

<cfsavecontent variable="myquery">
	
	SELECT    A.DateEffective, 
	          A.DateExpiration,
			  WL.ServiceDomain, 
			  WL.ServiceDomainClass, 
			  WL.Reference, 
			  WL.PersonNo, 
			  P.IndexNo, 
			  P.LastName, 
			  P.FirstName, 
	          P.Gender, 
			  P.Nationality,
			  WL.WorkOrderLineId
	FROM      WorkOrderLineAsset AS A INNER JOIN
	          WorkOrderLine AS WL ON A.WorkOrderId = WL.WorkOrderId AND A.WorkOrderLine = WL.WorkOrderLine LEFT OUTER JOIN
	          Employee.dbo.Person AS P ON WL.PersonNo = P.PersonNo
	WHERE     A.AssetId = '#url.assetid#'
	AND       A.Operational = 1
	
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cf_tl id="Tag" var = "1">		
<cfset fields[1] = {label      = "#lt_text#",                   			
					field      = "Reference",					
					search     = "text"}>

<cf_tl id="Person Id" var = "1">							
<cfset fields[2] = {label      		 = "#lt_text#",                 
					field      		 = "PersonNo", 					
					functionscript   = "EditPerson",
					search     		 = "text"}>					

<cf_tl id="Last Name" var = "1">										
<cfset fields[3] = {label      = "#lt_text#", 					
					field      = "LastName",
					search     = "text"}>	

<cf_tl id="First Name" var = "1">														
<cfset fields[4] = {label      = "#lt_text#", 					
					field      = "FirstName",
					search     = "text"}>		

<cf_tl id="Start" var = "1">									
<cfset fields[5] = {label      = "#lt_text#",   					
					field      = "DateEffective",
					alias      = "A",
					formatted  = "dateformat(DateEffective,CLIENT.DateFormatShow)",
					search     = "date"}>	
					
<cf_tl id="End" var = "1">		
<cfset fields[6] = {label      = "#lt_text#",   					
					field      = "DateExpiration",
					alias      = "A",
					formatted  = "dateformat(DateExpiration,CLIENT.DateFormatShow)",
					search     = "date"}>										
	

<cf_tl id="No" var = "1">		
<cfset fields[7] = {label      = "#lt_text#",                   
					Display    = "0",				
					field      = "workorderlineid"}>			

<!--- embed|window|dialogajax|dialog|standard --->

<table width="100%" height="99%" border="0" bordercolor="silver" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td width="100%" height="100%">						

	<cf_listing header  = "Service"
	    box            = "workorder"
		link           = "#SESSION.root#/Warehouse/Application/Asset/Service/ServiceListContent.cfm?assetid=#url.assetid#"
	    html           = "No"		
		datasource     = "AppsWorkorder"
		listquery      = "#myquery#"
		listorder      = "DateEffective"
		listorderdir   = "ASC"
		listorderalias = "A"
		headercolor    = "ffffff"				
		tablewidth     = "99%"
		listlayout     = "#fields#"
		FilterShow     = "Yes"
		ExcelShow      = "Yes"
		drillmode      = "tab" 
		drillargument  = "800;800"	
		drilltemplate  = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?drillid="
		drillkey       = "WorkOrderLineId">	
		
	</td></tr>

</table>		