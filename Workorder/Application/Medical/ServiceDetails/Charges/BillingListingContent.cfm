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
	
		SELECT ServiceItemUnit,WorkOrdeRLineId,OrderDate,
Specialist,SpecialistName,
DateTimePlanning Hora,
FileNo,
CustomerName as PatientName,
ServiceItem as Codigo,
UnitDescription,
AmountBilled as Monto,
ActionStatus as Estado,
''TipoCita,
Invoice
,CASE 
WHEN ServiceItemUnit = 'Prov' THEN AmountBilled
ELSE 0 END as Provisioned
,CASE 
WHEN SettleDesc = 'Efectivo' THEN AmountPosted
ELSE 0 END as Efectivo
,CASE 
WHEN SettleDesc = 'Cheque' THEN AmountPosted
ELSE 0 END as Cheque
,CASE 
WHEN SettleDesc = 'Credit Card' THEN AmountPosted
ELSE 0 END as CreditCard
,CASE 
WHEN SettleDesc = 'Credito' THEN AmountPosted
ELSE 0 END as Credito
,CASE 
WHEN SettleDesc = 'CREDOMATIC' THEN AmountPosted
ELSE 0 END as CREDOMATIC
,CASE 
WHEN SettleDesc = 'VISANET' THEN AmountPosted
ELSE 0 END as VISANET
,CASE 
WHEN SettleDesc = 'AR' THEN AmountBilled
ELSE 0 END as CxC,SettleDesc


		FROM (
		
		SELECT	W.ServiceItem,ISNULL(WLBD.ServiceItemUnit,'Prov')ServiceItemUnit,
				W.OrderDate,
				W.Currency,
				S.Description,
				DM.Description as ClassDescription,
				O.OrgUnitName,
				(SELECT OrgUnitName
				 FROM   Organization.dbo.Organization
				 WHERE  OrgUnit = L.OrgUnitImplementer) AS OrgUnitImplementerName,		
				L.Reference,
				L.DateEffective,
				L.DateExpiration,
				L.WorkOrderLineId,				
				C.CustomerName,
				(SELECT FullName
				 FROM   Employee.dbo.Person
				 WHERE  PersonNo = L.PersonNo) AS SpecialistName,	
				(SELECT PersonNo
				 FROM   Applicant.dbo.Applicant 
				 WHERE  PersonNo = C.PersonNo) AS PersonNo,		
				 (SELECT DocumentReference
				 FROM   Applicant.dbo.Applicant 
				 WHERE  PersonNo = C.PersonNo) AS FileNo,				
				DM.Description AS ServiceDomainClass,
				
				
				
					ISNULL((
					SELECT     SUM(ISNULL(B.CostAmount,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
				),0) AS AmountCost,				
				
				ISNULL((
					SELECT     SUM(ISNULL(B.SaleAmountIncome,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
				),0) AS AmountIncome,
				
				ISNULL((
					SELECT     SUM(ISNULL(B.SaleAmountIncome-B.CostAmount,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
				),0) AS AmountMargin,
				
				ISNULL((
					SELECT     SUM(ISNULL(B.SaleAmountTax,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
				),0) AS AmountTax,
				
				ISNULL((
					SELECT     SUM(ISNULL(B.SalePayable,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
				),0) AS AmountBilled,
				
				ISNULL((
					SELECT     SUM(ISNULL(B.SalePayable,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
					AND        B.Journal is not NULL
				),0) AS AmountPosted,	
				
				CASE WHEN 
				ISNULL((
					SELECT     SUM(ISNULL(B.SalePayable,0)) 
					FROM       WorkOrderLineCharge B 
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine
					AND        B.Journal is not NULL
				),0) > 0 THEN 'Posted' ELSE 'Pending' END AS BillingStatus,
				
							
			ISNULL((
									
					SELECT     SUM(ISNULL(H.AmountOutstanding, 0)) AS Expr1
					FROM       WorkOrderLineCharge B INNER JOIN
                    			Accounting.dbo.TransactionHeader H ON B.Journal = H.Journal AND B.JournalSerialNo = H.JournalSerialNo						
					WHERE      B.WorkOrderId   = L.WorkOrderId
					AND        B.WorkOrderLine = L.WorkOrderLine		
					AND        H.RecordStatus != '9' 
					AND        H.ActionStatus IN ('0','1')			
				),0) AS AmountOutstanding
				,(
					SELECT 
					CASE 
						WHEN ActionStatus = '1' THEN 'Pendiente/Abierta'
						WHEN ActionStatus = '0' THEN 'Pendiente/Abierta'
						WHEN ActionStatus = '3' THEN 'Atendida'
						WHEN ActionStatus = '8' THEN 'Ausente'
						WHEN ActionStatus = '9' THEN 'Cancelada'
						WHEN ActionStatus = '4' THEN 'Atendida'
						ELSE 'Revisar'
					END as ActionsTatus
					FROM (SELECT TOP 1 * FROM WorkOrder.dbo.WorkOrderLineAction WHERE WorkOrderId = L.WorkOrderId AND WorkOrderLine = L.WorkOrderLine ORDER BY DateTimeActual DESC) as WOLA
				) as ActionStatus
				,(
				SELECT (tl.AmountDebit-tl.AmountCredit)
				FROM Accounting.dbo.TransactionLine as tl
				LEFT outer Join Materials.dbo.Ref_SettlementMission as rf
					on rf.GLAccount = tl.GLAccount
					inner join Materials.dbo.Ref_Settlement as st
					on rf.Code = st.Code
				WHERE tl.ParentJournal = TH.Journal 
				and tl.ParentJournalSerialNo = TH.JournalSerialNo
				and tl.Reference = 'Settlement'
				)as Settled
				,ISNULL((
				SELECT st.Description
				FROM Accounting.dbo.TransactionLine as tl
				LEFT outer Join Materials.dbo.Ref_SettlementMission as rf
					on rf.GLAccount = tl.GLAccount
					inner join Materials.dbo.Ref_Settlement as st
					on rf.Code = st.Code
				WHERE tl.ParentJournal = TH.Journal 
				and tl.ParentJournalSerialNo = TH.JournalSerialNo
				and tl.Reference = 'Settlement'
				),'AR')as SettleDesc
				,ISNULL(TH.TransactionReference,'SF') as Invoice
				,SIU.UnitDescription
				,(
					SELECT DateTimePlanning FROM WorkPlanDetail WHERE WorkActionId IN (
						SELECT TOP 1 WorkActionId FROM WorkOrderLineAction WHERE WorkOrderId = W.WorkOrderId Order by DateTimePlanning desc
					) and Operational = '1'
				) as DateTimePlanning
				,L.PersonNo Specialist
													
					
		FROM WorkOrderLine L
				INNER JOIN WorkOrder W ON W.WorkOrderId = L.WorkOrderId
				INNER JOIN ServiceItem S ON S.Code = W.ServiceItem
				INNER JOIN Customer C ON C.CustomerId = W.CustomerId
				INNER JOIN Ref_ServiceItemDomainClass DM ON DM.Code = L.ServiceDomainClass AND DM.ServiceDomain = L.ServiceDomain
				INNER JOIN Organization.dbo.Organization O ON O.Orgunit = W.OrgUnitOwner
				LEFT OUTER JOIN Accounting.dbo.TransactionHeader as TH
				ON 	TH.TransactionSourceId = L.WorkOrderLineId
				AND TH.TransactionCategory = 'Receivables'
				LEFT OUTER JOIN WorkORder.dbo.WorkOrderLineBillingDetail as WLBD
				ON WLBD.WorkOrderId = L.WorkOrderId
				AND WLBD.WorkOrderLine = L.WorkOrderLine
				LEFT OUTER JOIN ServiceItemUnit SIU ON SIU.ServiceItem = S.Code
				AND	WLBD.ServiceItem = SIU.ServiceItem AND WLBD.ServiceItemUnit = SIU.Unit
		WHERE 1=1
		AND		L.Operational = 1
		AND   W.Mission       = 'ALDANA'
		AND   L.ActionStatus  != '9'
		AND   W.OrderDate >= (SELECT DatePostingStart
		                      FROM   ServiceItemMission
							  WHERE  Mission = 'ALDANA'
							  AND    ServiceItem = W.ServiceItem)  
		) as Sub
		WHERE 1=1
		AND AmountBilled > 0
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OrderDate",					
						alias       = "",								
						width       = "15",			
						formatted   = "dateformat(OrderDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>	

	<cfset itm = itm+1>
	<cf_tl id="Hora" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Hora",					
						alias       = "",		
						width       = "30",	
						filtermode  = "2",
						formatted   = "dateformat(OrderDate,CLIENT.DateFormatShow)",																																	
						search      = "date"}>		
										
	<cfset itm = itm+1>
	<cf_tl id="FileNo" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "FileNo",					
						alias         = "",							
						width         = "35",																	
						search        = "text"}>	
						
	<!--- 
	functionscript      = "ShowCandidate",
						functionfield = "PersonNo"	,
						--->					
						
	<cfset itm = itm+1>	
	<cf_tl id="Patient" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "PatientName",																	
						alias       = "",																			
						display     = "0",
						search      = "text",	
						filtermode  = "2"}>													
							
	<cfset itm = itm+1>	
	<cf_tl id="Code" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Codigo",																	
						alias       = "",																			
						display     = "0",
						search      = "text",	
						filtermode  = "3"}>		
												
	<cfset itm = itm+1>	
	<cf_tl id="Service" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UnitDescription",																	
						alias       = "",		
						width       = "20",																				
						search      = "text",	
						filtermode  = "2"}>		
												
	<cfset itm = itm+1>
	<cf_tl id="Amount" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Monto",					
						alias       = "",								
						width       = "15",		
						formatted   = "numberformat(AmountCost,',.__')",															
						search      = "date"}>	

	<cfset itm = itm+1>
	<cf_tl id="Status" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Estado",					
						alias       = "",		
						width       = "10",																			
						search      = "text",
						filtermode  = "3"}>						
								
												
	<cfset itm = itm+1>
	<cf_tl id="Invoice" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Invoice",	
						align       = "right",				
						alias       = "",	
						style       = "border-left:1px solid silver;background-color:DDFBE2",	
						width       = "15",				
						search      = ""}>							
						

	<cfset itm = itm+1>
	<cf_tl id="Provisioned" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Provisioned",	
						align       = "right",				
						alias       = "",		
						width       = "15",			
						style       = "border-left:1px solid silver;background-color:D3E9F8",		
						formatted   = "numberformat(AmountIncome,',.__')",														
						search      = ""}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Cash" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Efectivo",	
						align       = "right",				
						alias       = "",		
						width       = "15",			
						style       = "border-left:1px solid silver;background-color:ffffcf",		
						formatted   = "numberformat(AmountMargin,',.__')",														
						search      = ""}>										
	
						
	<cfset itm = itm+1>
	<cf_tl id="Check" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Cheque",	
						align       = "right",				
						alias       = "",		
						width       = "15",		
						style       = "border-left:1px solid silver;background-color:D3E9F8",			
						formatted   = "numberformat(AmountTax,',.__')",														
						search      = ""}>		
														
	
	<cfset itm = itm+1>
	<cf_tl id="CreditCard" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CreditCard",	
						align       = "right",										
						width       = "18",		
						style       = "border-left:1px solid silver;background-color:D3E9F8",			
						formatted   = "numberformat(AmountBilled,',.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Credit" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Credito",	
						align       = "right",										
						width       = "18",			
						style       = "border-left:1px solid silver;background-color:E6E6E6",			
						formatted   = "numberformat(AmountPosted,',.__')",														
						search      = ""}>			
						
	<cfset itm = itm+1>
	<cf_tl id="CREDOMATIC" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CREDOMATIC",	
						align       = "right",										
						width       = "18",			
						style       = "border-left:1px solid silver;background-color:FED7CF",			
						formatted   = "numberformat(AmountOutstanding,',.__')",														
						search      = ""}>																																														
	<cfset itm = itm+1>
	<cf_tl id="VISANET" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "VISANET",	
						align       = "right",										
						width       = "18",			
						style       = "border-left:1px solid silver;background-color:FED7CF",			
						formatted   = "numberformat(AmountOutstanding,',.__')",														
						search      = ""}>	
	<cfset itm = itm+1>
	<cf_tl id="AR" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CxC",	
						align       = "right",										
						width       = "18",			
						style       = "border-left:1px solid silver;background-color:FED7CF",			
						formatted   = "numberformat(AmountOutstanding,',.__')",														
						search      = ""}>	
		
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "billing"
	    box                 = "listing"
		link                = "#SESSION.root#/WorkOrder/Application/Medical/ServiceDetails/Charges/BillingListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsWorkOrder"
		listquery           = "#myquery#"		
		listorderfield      = "OrderDate"
		listorder           = "OrderDate"
		listgroupfield      = "SpecialistName"
		listgrouporder      = "SpecialistName"
		listorderdir        = "DESC"
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "WorkOrder/Application/Medical/ServiceDetails/WorkOrderline/WorkOrderLineView.cfm?drillid="
		drillkey            = "WorkOrderLineId"
		drillbox            = "addaddress">	