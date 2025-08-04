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

<cfoutput>

	<cfsavecontent variable="myquery">	
	
	  SELECT     W.Reference as OrderNo,
	             WL.Reference, 
	             S.Description, 	
				 WL.ServiceDomain,			
				 WL.DateEffective, 
				 WL.DateExpiration, 								
				 WL.WorkOrderId, 
				 WL.WorkOrderLine,
				 WL.WorkorderLineId,
				(
					SELECT DateTimePlanning
					FROM WorkOrderLineAction A
					WHERE A.WorkOrderId = WL.WorkOrderId
					AND A.WorkOrderLine = WL.WorkOrderLine
					AND A.SerialNo = ( 
						SELECT MAX(A1.SerialNo)
						FROM WorkOrderLineAction A1
						WHERE A1.WorkOrderId = A.WorkOrderId
						AND A1.WorkOrderLine = A.WorkOrderLine
						AND A1.SerialNo > 0
						AND A1.ActionClass IN (
							SELECT UsageActionClose
							FROM ServiceItem S
							WHERE S.Code = W.ServiceItem)
					)
				) AS DateLastClosing,
				
				(
					SELECT MIN(D.TransactionDate)
					FROM WorkOrderLineDetail D
					WHERE D.WorkOrderId = WL.WorkOrderId
					AND	D.WorkOrderLine = WL.WorkOrderLine
					AND D.ServiceUsageSerialNo <=  
					(
						SELECT MAX(A.SerialNo)
						FROM WorkOrderLineAction A
						WHERE A.WorkOrderId = WL.WorkOrderId
						AND A.WorkOrderLine = WL.WorkOrderLine
						AND A.SerialNo > 0
						AND A.ActionClass IN 
						(
							SELECT UsageActionClose
							FROM ServiceItem S
							WHERE S.Code = W.ServiceItem
						)						
					)
					
					AND D.ServiceUsageSerialNo > ISNULL(
					(
						SELECT MAX(A1.SerialNo)
						FROM WorkOrderLineAction A1
						WHERE A1.WorkOrderId = WL.WorkOrderId
						AND A1.WorkOrderLine = WL.WorkOrderLine
						AND A1.ActionClass IN 
						(
							SELECT UsageActionClose
							FROM ServiceItem S
							WHERE S.Code = W.ServiceItem
						)										
						AND A1.SerialNo < 
							(
								SELECT MAX(A2.SerialNo)
								FROM WorkOrderLineAction A2
								WHERE A2.WorkOrderId = WL.WorkOrderId
								AND A2.WorkOrderLine = WL.WorkOrderLine
								AND A2.ActionClass IN 
								(
									SELECT UsageActionClose
									FROM ServiceItem S
									WHERE S.Code = W.ServiceItem
								)								
							)
					),0)
				) AS DatePeriodStart,
				
				(
					SELECT MAX(D.TransactionDate)
					FROM WorkOrderLineDetail D
					WHERE D.WorkOrderId = WL.WorkOrderId
					AND	D.WorkOrderLine = WL.WorkOrderLine
					AND D.ServiceUsageSerialNo <= 
					(
						SELECT MAX (A1.SerialNo)
						FROM WorkOrderLineAction A1
						WHERE A1.WorkOrderId = WL.WorkOrderId
						AND A1.WorkOrderLine = WL.WorkOrderLine
						AND A1.ActionClass IN 
						(
							SELECT UsageActionClose
							FROM ServiceItem S
							WHERE S.Code = W.ServiceItem
						)				
					)
				) AS DatePeriodEnd

				
	  FROM       ServiceItem S INNER JOIN
                 WorkOrder W ON S.Code = W.ServiceItem INNER JOIN
                 WorkOrderLine WL ON W.WorkOrderId = WL.WorkOrderId
      WHERE      WL.PersonNo = '#url.id1#' 
	  AND        WL.Operational = 1
 				 
	</cfsavecontent>	

</cfoutput>				  
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

				
<cfset fields[1] = {label   = "Service",                
					field   = "Description",
					alias   = "S",
					filtermode = "2",
					search  = "text"}>
					
<cfset fields[2] = {label   = "Reference",                    
					alias   = "WL",
					field   = "Reference",
					search  = "text"}>		
					
<cfset fields[3] = {label   = "Domain",                    
					alias   = "WL",
					field   = "ServiceDomain",
					search  = "text"}>								
						
<cfset fields[4] = {label      = "Effective",  				
					field      = "DateEffective",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DateEffective,'#CLIENT.DateFormatShow#')"}>	
					
<cfset fields[5] = {label      = "Expiration", 					
					field      = "DateExpiration",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DateExpiration,'#CLIENT.DateFormatShow#')"}>												
				
<cfset fields[6] = {label     = "WorkOrderLineId",   					
					display    = "No",
					alias      = "W",
					field      = "WorkorderLineId"}>		
					
<cfset fields[7] = {label      = "Last Approval",  				
					field      = "DateLastClosing",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DateLastClosing,'#CLIENT.DateFormatShow#')"}>	

<cfset fields[8] = {label      = "Aproval Start",  				
					field      = "DatePeriodStart",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DatePeriodStart,'#CLIENT.DateFormatShow#')"}>	

<cfset fields[9] = {label      = "Aproval End",  				
					field      = "DatePeriodEnd",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(DatePeriodEnd,'#CLIENT.DateFormatShow#')"}>	
					
								
<cf_listing
    header         = "WorkOrder"
    box            = "workorder"
	link           = "#SESSION.root#/Staffing/Application/Employee/WorkOrder/WorkOrderListingContent.cfm?id1=#url.id1#"
    html           = "No"
	show           = "40"
	height         = "100%"
	datasource     = "AppsWorkorder"
	listquery      = "#myquery#"
	listgroup      = "Description"
	listorder      = "Reference"
	listorderdir   = "ASC"	
	listorderalias = "WL"
	listlayout     = "#fields#"
	filterShow     = "Hide"
	excelShow      = "Yes"
	drillmode      = "securewindow"
	drillargument  = "900;990;false;true"	
	drilltemplate  = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineDetail.cfm?drillid="
	drillkey       = "WorkOrderLineId">
	
					  