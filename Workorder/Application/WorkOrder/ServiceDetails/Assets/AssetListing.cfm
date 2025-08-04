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

<!--- show the matching lines --->

<cfparam name="url.workorderid"   default="">

<cfoutput>
	
	<cfsavecontent variable="myquery">
	
			SELECT WL.Reference AS MobileNumber,
			       C.CustomerName,
			       ServiceItem.Description AS Provider,
			       WL.ServiceDomainClass,
			       WL.DateEffective AS Effective,
			       WL.DateExpiration AS Expiration,
			       I.SerialNo,
			       I.AssetDecalNo,
			       I.Description,
			       A.DateEffective AS AssetEffective,
			       A.DateExpiration AS AssetExpiration,
			       Employee.dbo.Person.IndexNo,
			       Employee.dbo.Person.LastName,
			       Employee.dbo.Person.FirstName,
			       (Employee.dbo.Person.FirstName + ' ' + Employee.dbo.Person.LastName) as FullName,
			       I.AssetId,
			       I.Make,
			       I.MakeNo,
			       I.Model,
			       WL.PersonNo
			FROM ServiceItem
			     INNER JOIN WorkOrder AS W
			                          INNER JOIN WorkOrderLine AS WL
			                     ON W.WorkOrderId = WL.WorkOrderId
			                          INNER JOIN Customer AS C
			                     ON W.CustomerId = C.CustomerId
			          ON ServiceItem.Code = W.ServiceItem
			     LEFT OUTER JOIN Employee.dbo.Person
			          ON WL.PersonNo = Employee.dbo.Person.PersonNo
			     LEFT OUTER JOIN Materials.dbo.AssetItem AS I RIGHT OUTER JOIN WorkOrderLineAsset AS A
			                          ON I.AssetId = A.AssetId
			          ON WL.WorkOrderId = A.WorkOrderId
			             AND WL.WorkOrderLine = A.WorkOrderLine
			WHERE WL.DateEffective < GETDATE()
			     AND (WL.DateExpiration IS NULL
			          OR WL.DateExpiration > GETDATE())
			     AND (WL.ServiceDomain = 'MobileNumber')
			     AND (WL.Operational = '1')
			     AND (A.DateExpiration >= GETDATE()
			          OR A.DateExpiration IS NULL)
			     AND (A.Operational = 1)
			  	 AND      WL.WorkOrderId     = '#url.WorkorderId#' 
					
	</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cf_tl id="Mobile No." var="vMobileNo">
<cfset fields[itm] = {label     = "#vMobileNo#",
					field       = "MobileNumber",					
					alias       = "",														
					search      = "text"}>

<cfset itm = itm+1>
<cf_tl id="Decal No." var="vDecalNo">
<cfset fields[itm] = {label     = "#vDecalNo#",
					field       = "AssetDecalNo",					
					alias       = "",														
					search      = "text"}>

<cfset itm = itm+1>
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",
					field       = "Description",					
					alias       = "",														
					search      = "text"}>
					
<cfset itm = itm+1>					
<cf_tl id="Asset Effective" var="vAssetEffective">
<cfset fields[itm] = {label     = "#vAssetEffective#",                    
					field       = "AssetEffective", 		
					formatted   = "dateformat(AssetEffective,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	
					
<cfset itm = itm+1>
<cf_tl id="Serial No." var="vSerialNo">
<cfset fields[itm] = {label     = "#vSerialNo#",
					field       = "SerialNo",					
					alias       = "",														
					search      = "text"}>

<cfset itm = itm+1>
<cf_tl id="Index No." var="vIndexNo">
<cfset fields[itm] = {label     = "#vIndexNo#",
					field       = "IndexNo",					
					alias       = "",														
					search      = "text"}>

<cfset itm = itm+1>
<cf_tl id="Name" var="vName">
<cfset fields[itm] = {label     = "#vName#",
					field       = "FullName",					
					alias       = "",														
					search      = "text"}>

		
<cf_listing
		header			= "DecalListing"
	    box             = "myListing"
		link            = "#SESSION.root#/Workorder/Application/Workorder/ServiceDetails/Assets/AssetListing.cfm?WorkorderId=#url.WorkorderId#"
	    html            = "No"				
		datasource      = "AppsWorkorder"
		listquery       = "#myquery#"
		listorderfield  = "MobileNumber"
		listorderalias  = ""
		listorder       = "MobileNumber"
		listorderdir    = "ASC"
		headercolor     = "ffffff"
		show            = "40"			
		filtershow      = "show"
		excelshow       = "yes" 		
		listlayout      = "#fields#"
		drilltemplate  = "Warehouse/Application/Asset/AssetAction/AssetView.cfm?assetid="
		drillmode       = "window" 
		drillargument   = "900;1100;true;true"			
		drillkey        = "AssetId">
		
		
		
		