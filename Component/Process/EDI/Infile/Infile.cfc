<cfcomponent>

    <cfproperty name="name" type="string">
	
    <cfset this.name = "Guatemala Infile EDI provider">	
		
		<cffunction name="CustomerValidate"
	             access="public"
	             returntype="any"
	             returnformat="plain"
	             displayname="CustomerValidate"> 
				
				<cfargument name="Datasource"  type="string"  required="true"   default="appsOrganization"> 
				<cfargument name="Reference"   type="string" required="true" default="">
				
				<cfset NIT = ARGUMENTS.Reference>				
				
				<cfset NIT = trim(replace(NIT,"-","","ALL"))>
				
				<cfif NIT eq "C/F">
					<cfset Customer.Status = "OK">
				<cfelse>
					
					<cfset pos = len(NIT)-1>
					
					<cfset vNitbody = left(NIT,LEN(NIT)-1)>
					<cfset vVerDigit = right(NIT,1)>
					<cfset vfactor = len(vNitBody) + 1>
					<cfset vN = "">
					<cfset vTot = "0">
					<cfset vValue = "0">
					
					<cfloop index="i" from="1" to="#pos#">
						<cfset vN = mid(vNitBody,i,1)>
						
						<cfif isnumeric(vN)>
							<cfset vValue = vN>					
						<cfelse>
							<cfset Customer.Status = "Invalid">
						</cfif>
						
						<cfset vTot = vTot + (vValue * vFactor)>
						<cfset vfactor = vfactor -1>
					
					</cfloop>
					
					<cfset vMod = "0">
					<cfset vMod = (11 - (vTot mod 11)) mod 11>
					<cfset vs = tostring(vMod)>
		
					<cfif ((vMod eq "10") and (UCASE(vVerDigit) eq "K")) OR (vs eq vVerDigit)>
						<cfset Customer.Status = "OK">
					<cfelse>
						<cfset Customer.Status = "Invalid">
					</cfif>
				</cfif>
								 
				 <cfreturn Customer>
				 
		</cffunction>			
		
		<cffunction name="WorkOrderSale"
			access="public"
             returntype="any"
             displayname="GetFACE_WK">
	         <cfargument name="Mission"         type="string"  required="true"   default="">
			 <cfargument name="Terminal"        type="string"  required="true"   default="1">			 
			 <cfargument name="TransHeaderID"   type="string"  required="true"   default="">
			 <cfargument name="RetryNo"         type="string"  required="false"  default="0">
			 <cfargument name="CatDesc"			type="string"  required="false"  default="DSC">
			 <cfargument name="CatProd"			type="string"  required="false"  default="PRD">
			 <cfargument name="AddrType"		type="string"  required="false"  default="Office">
			 <cfargument name="writeFile"		type="string"  required="false"  default="no">
			 <cfargument name="postInfile"		type="string"  required="false"  default="yes">
			 <cfargument name="includeWH"		type="string"  required="false"  default="no">
			 <cfargument name="includeUoMDesc"	type="string"  required="false"  default="no">
			 <cfargument name="includeWKRef"	type="string"  required="false"  default="no">
 			 <cfargument name="includeWKSeller"	type="string"  required="false"  default="no">
 			 <cfargument name="includeWKDate"	type="string"  required="false"  default="no">
 			 <cfargument name="includeSpecials"	type="string"  required="false"  default="no">
			 
			 <cfset thisMsg							= "WorkOrder Sale was generated OK">
			 <cfset vCincludeWH						= includeWH>
			 <cfset vCatDesc						= CatDesc>
 			 <cfset vCatProd						= CatProd>
 			 <cfset vAddrType						= AddrType>
			 
			 <cfquery name="getTrans" 
				datasource="AppsLedger"
			 	username="#SESSION.login#"
			 	password="#SESSION.dbpw#">
					SELECT 	* 
					FROM	Accounting.dbo.TransactionHeader
					WHERE	TransactionId = '#TransHeaderID#'
			</cfquery>	
			
			<cfif getTrans.recordCount lte 0>
			<!---this invoice was already issued---->
				<cfset thisMsg = "Coudln't get the Transaction for this invoice "&url.eventId>
				<cf_message message= "#thisMsg#">
				<cfabort>
			</cfif>
			
			
			<cfquery name="checkInvoice" 
				datasource="AppsLedger"
			 	username="#SESSION.login#"
			 	password="#SESSION.dbpw#">
					SELECT 	* 
					FROM	Accounting.dbo.TransactionHeaderAction
					WHERE	Journal 			= '#getTrans.Journal#'
					AND		JournalSerialNo 	= '#getTrans.JournalSerialNo#'
					AND		ActionCode			= 'Invoice'
					AND		ActionStatus		!=9
			</cfquery>	
			
			<cfif checkInvoice.recordCount gte 1>
				<cfif trim(checkInvoice.ActionReference1) neq "">
				<!---this invoice was already issued---->
					<cfset thisMsg = "This transaction already contains a valid Invoice: "&checkInvoice.ActionReference2&" - "&checkInvoice.ActionReference1>
					<cf_message message= "#thisMsg#">
					<cfabort>
				</cfif>
			</cfif>
			
			
			<!---getting the sale ------>
			<cfquery name="getInvoice" 
				datasource="AppsLedger"
			 	username="#SESSION.login#"
			 	password="#SESSION.dbpw#">
				
				SELECT '' FirstName,'' LastName, Org.OrgUnitName as CustomerName, Org.OrgUnitName as FullName,
				UPPER(Org.OrgUnitCode) as NIT, ISNULL(Cu.eMailAddress,'no_email') as eMailAddress,Cu.TaxExemption,
				It.TransactionDate, IT.TransactionBatchNo BatchNo, TH.Journal+'_'+cast(TH.JournalSerialNo as varchar(30)) as SaleNo
				<!-----attention this must be removed for the Production  ------------>
				--, TA.ActionReference1 BatchReference, TA.ActionReference2 BatchReference2
				, ' ' BatchReference,' ' BatchReference2
				<!------------not the line but the "null" value ------------------------->
				,I.ItemNo, I.ItemDescription, I.Category,IU.ItemBarCode, U.Description AS UoM, IU.UoM AS UoM, IU.ItemBarCode
				,W.Warehouse, W.WarehouseName,W.Address,W.Telephone,W.Mission
				,ABS(It.TransactionQuantity) as TransactionQuantity
				,ROUND((S.SalesAmount * S.TaxPercentage),2) + S.SalesAmount AS SalesAmountExemption,
				ROUND((S.SalesAmount * S.TaxPercentage),2) AS SalesTaxExemption
				,S.SalesCurrency,S.SalesPrice, S.SalesAmount, 
				S.SalesTax, S.SalesTotal, 
				REFA.Address +', '+REFA.AddressCity +', '+REFA.State CustomerAddress
				,WK.Reference as OrderNo, WK.OrderDate 
				,ISNULL(( SELECT FullName FROM Employee.dbo.Person 
						WHERE PersonNo = (SELECT TOP 1 PersonNo FROM WorkOrder.dbo.WorkOrderLine WKL WHERE WKL.WorkOrderId = WK.WorkOrderId)
					),'NO_SELLER')Seller
			,ISNULL(
					(
						SELECT SUM(S1.SalesTotal)
						FROM Materials.dbo.ItemTransaction T1
						INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
						INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
						WHERE S1.Journal = TH.Journal
						AND	  S1.JournalSerialNo  = TH.JournalSerialNo
						AND I1.Category = '#vCatDesc#'
					)
				,0) AS TotalDiscounts
			, ISNULL(
						(
							SELECT SUM(S1.SalesTax)
							FROM Materials.dbo.ItemTransaction T1
							INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
							INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
							WHERE S1.Journal = TH.Journal
							AND	  S1.JournalSerialNo  = TH.JournalSerialNo
								AND I1.Category = '#vCatDesc#'
						)
					,0) AS TotalTaxDiscounts
			,ISNULL(
						(
							SELECT TOP 1 T2.ItemDescription 
							FROM Materials.dbo.ItemTransaction T2
							INNER JOIN Materials.dbo.ItemTransactionShipping S2 ON S2.TransactionId = T2.TransactionId
							INNER JOIN Materials.dbo.Item I2 ON I2.ItemNo = T2.ItemNo
							WHERE  S2.Journal = TH.Journal
							AND	  S2.JournalSerialNo  = TH.JournalSerialNo
							AND I2.Category = '#vCatDesc#'
						)
					,'') DiscountDescription
			
			FROM Materials.dbo.ItemTransaction as IT
			INNER JOIN Materials.dbo.ItemTransactionShipping S 
				ON IT.TransactionId = S.TransactionId
			---MASTER KEY----
			INNER JOIN WorkOrder.dbo.WorkOrder as WK
				ON IT.WorkOrderId	= Wk.WorkOrderId
			----***--------
			----MATERIALS----
			INNER JOIN Materials.dbo.Item I 
				ON I.ItemNo		= IT.ItemNo
			INNER JOIN Materials.dbo.ItemUoM IU 
				ON IU.ItemNo	= I.ItemNo 
				AND IU.UoM		= IT.TransactionUoM
			INNER JOIN Materials.dbo.Ref_UoM U 
				ON U.Code		= IU.UoMCode
			INNER JOIN Materials.dbo.Warehouse W 
				ON W.Warehouse = IT.Warehouse
			----******-------
			INNER JOIN WorkOrder.dbo.Customer as Cu
				ON Cu.CustomerId= Wk.CustomerId
			INNER JOIN Organization.dbo.Organization as Org
				ON Cu.OrgUnit	= Org.OrgUnit
			--INNER JOIN Organization.dbo.OrganizationAddress as OA
			LEFT OUTER JOIN Organization.dbo.OrganizationAddress as OA
				ON Org.OrgUnit	= OA.OrgUnit
				AND OA.AddressType = '#AddrType#'
			--INNER JOIN System.dbo.Ref_Address as REFA
			LEFT OUTER JOIN System.dbo.Ref_Address as REFA
				ON REFA.AddressId	=	OA.AddressId
			--for the manual ones, must add the header and the invoice in headeraction
			INNER JOIN Accounting.dbo.TransactionHeader as TH
				ON  TH.Journal			= S.Journal
				AND TH.JournalSerialNo	= S.JournalSerialNo
			LEFT OUTER JOIN Accounting.dbo.TransactionHeaderAction as TA
				ON TH.Journal	=	TA.Journal
				AND TH.JournalserialNo = TA.JournalSerialNo
				ANd TA.ActionCode	= 'Invoice'
			----**-----
			WHERE 1=1
			AND TH.TransactionId		= '#getTrans.TransactionId#'
			AND	IT.TransactionType	= '2'
				
			</cfquery>
			
						<!--- Get Mission Information --->
			<cfquery name="GetMission" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM  Organization.dbo.Ref_Mission
				WHERE Mission = '#getTrans.Mission#'
			</cfquery>
			
			<cfif GetMission.recordCount lte 0>
			<!---this invoice was already issued---->
				<cfset thisMsg = "No mission found: "&getTrans.Mission>
				<cf_message message= "#thisMsg#">
				<cfabort>
			</cfif>			
			
			<!--- Get Warehouse device information --->				
			<cfquery name="GetWarehouseDevice" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Materials.dbo.WarehouseTerminal
				WHERE  Warehouse    = '#GetInvoice.Warehouse#'
				AND    TerminalName = '#terminal#'
				AND    Operational  = 1 
			</cfquery>	
			
			<cfif GetWarehouseDevice.recordCount lte 0>
			<!---this invoice was already issued---->
				<cfset thisMsg = "No Warehouse Terminal configured: "&getInvoice.Warehouse>
				<cf_message message= "#thisMsg#">
				<cfabort>
			</cfif>
			
			<!--- Get Warehouse and Series Information --->				
			<cfquery name="GetWarehouseSeries" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Organization.dbo.OrganizationTaxSeries 
				WHERE  OrgUnit    = '#GetWarehouseDevice.TaxOrgUnitEDI#'
				AND    SeriesType = 'Invoice'
				AND    Operational=1
			</cfquery>	
			
			<cfif GetWarehouseSeries.recordCount lte 0>
			<!---this invoice was already issued---->
				<cfset thisMsg = "No Warehouse Series configured: "&GetWarehouseDevice.TaxOrgUnitEDI>
				<cf_message message= "#thisMsg#">
				<cfabort>
			</cfif>
			
			<!--- Get Config --->
			<cfquery name="GetMissionConfig" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Organization.dbo.Ref_MissionExchange
				WHERE  Mission = '#getTrans.Mission#'
				AND    ClassExchange = 'FACE'
			</cfquery>	
			
			<cfif GetMissionConfig.recordCount lte 0>
			<!---this invoice was already issued---->
				<cfset thisMsg = "No mission configuration found: "&getTrans.Mission>
				<cf_message message= "#thisMsg#">
				<cfabort>
			</cfif>
			
			<!---- STORE THIS IN A CONFIG TABLE !! ---->
			<cfset vUser = GetMissionConfig.ExchangeUserId>
			<cfset vPwd = GetMissionConfig.ExchangePassword>
			<cfset vNitGFACE = GetWarehouseSeries.GFACEId>
			<cfset vNitEFACE = GetWarehouseSeries.EFACEId>
			<cfset DocumentType = GetWarehouseSeries.TaxDocumentType>  <!--- SAT Document Type: Regular Invoice --->
			
			<!----initializing.....------->
			<cfset vExchangeRate = "1">
			<cfset vCurrency = "GTQ">
			
			<cfif GetInvoice.SalesCurrency eq "QTZ">
				<cfset vExchangeRate = "1">
				<cfset vCurrency = "GTQ">
			<cfelse>
				<!---get the exchangeRate ------>
				<cfquery name="getExchange" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT *
					FROM   Accounting.dbo.Currency
					WHERE  Currency = '#GetInvoice.SalesCurrency#'
				</cfquery>				
				<cfset vExchangeRate = GetExchange.ExchangeRate>
				<cfset vCurrency	 = GetExchange.Currency>
			</cfif>
			
			<cfset vUoM = "UND">
						
			<cfset vNIT = GetInvoice.NIT>
			<cfif vNIT eq "CF" OR vNIT eq "C-F">
				<cfset vNIT = "C/F">
			</cfif>
			
				<cfset vInvoiceTotalAmount 	= "0">
				<cfset vInvoiceTotalExempt 	= "0">
				<cfset vInvoiceTotalDiscount = "0">
				<cfset vInvoiceTotalTax 	= "0">
				<cfset vInvoiceTotalDiscount = GetInvoice.TotalDiscounts+0>	
				<cfset vInvoiceTotalTaxDiscount = GetInvoice.TotalTaxDiscounts+0>		
				<cfset vDiscountDescription = GetInvoice.DiscountDescription>			
				<cfset vreccount 			= "1">
																		
				<cfsavecontent variable="soapBody">
			
				<cfoutput>
				<!---Infile utf 8 encoding testing  --->
				<!---
				
				<?xml version="1.0" encoding="utf-16"?>
				--->
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
				<soap:Body>
					<registrarDte xmlns="http://listener.ingface.com/">
						<dte xmlns="">
						<usuario>#vUser#</usuario>
						<clave>#vPwd#</clave>
						<dte>
						<fechaDocumento>#DateFormat(GetInvoice.TransactionDate,"YYYY-MM-DD")#</fechaDocumento>
						<tipoCambio>#vExchangeRate#</tipoCambio>
						<fechaResolucion>#DateFormat(GetWarehouseSeries.AuthorizationDate,"YYYY-MM-DD")#</fechaResolucion>		  
						<codigoEstablecimiento>#GetWarehouseDevice.Reference#</codigoEstablecimiento>
						<codigoMoneda>#vCurrency#</codigoMoneda>
						<correoComprador>#GetInvoice.eMailAddress#</correoComprador>
						<departamentoComprador>N/A</departamentoComprador>
						<departamentoVendedor>N/A</departamentoVendedor>
						<descripcionOtroImpuesto>N/A</descripcionOtroImpuesto>
						<cfif GetInvoice.CustomerAddress neq "">
							<direccionComercialComprador>#GetInvoice.Customeraddress#</direccionComercialComprador>
						<cfelse>
							<direccionComercialComprador>N/A</direccionComercialComprador>
						</cfif>
						<direccionComercialVendedor>#GetInvoice.Address#</direccionComercialVendedor>
						<estadoDocumento>ACTIVO</estadoDocumento>
						<idDispositivo>#GetWarehouseDevice.Terminal#</idDispositivo>
						<municipioComprador>N/A</municipioComprador>
						<municipioVendedor>N/A</municipioVendedor>
						<nitComprador>#Replace(vNIT,"-","","ALL")#</nitComprador>
						<nitGFACE>#vNitGFACE#</nitGFACE>
						<nitVendedor>#vNitEFACE#</nitVendedor>
						<nombreComercialComprador>#Replace(GetInvoice.CustomerName,"&","")#</nombreComercialComprador>
						<nombreComercialRazonSocialVendedor>#GetMission.MissionName#</nombreComercialRazonSocialVendedor>
						<nombreCompletoVendedor>#GetMission.MissionName#</nombreCompletoVendedor>
						<numeroDocumento>#GetInvoice.SaleNo#</numeroDocumento>
						<numeroResolucion>#Replace(GetWarehouseSeries.AuthorizationNo,"-","","ALL")#</numeroResolucion>
						<observaciones>N/A</observaciones>
						<regimen2989><cfif GetInvoice.TaxExemption eq "1">true<cfelse>false</cfif></regimen2989>						
						<regimenISR>N/A</regimenISR>
						<serieAutorizada>#GetWarehouseSeries.SeriesNo#</serieAutorizada>
						<serieDocumento>#DocumentType#</serieDocumento>
						<telefonoComprador>N/A</telefonoComprador>
						<tipoDocumento>FACE</tipoDocumento>
						
						<!------BEFORE DETAIL, ADDING Customized FIELDS ----->
						<cfif includeWKRef eq "yes">
							<personalizado_15>#getInvoice.OrderNo#</personalizado_15>
						</cfif>
						<cfif includeWKSeller eq "yes">
							<personalizado_16>#getInvoice.Seller#</personalizado_16>
						</cfif>
						<cfif includeWKDate eq "yes">
							<personalizado_17>#DateFormat(GetInvoice.OrderDate,"YYYY-MM-DD")#</personalizado_17>
						</cfif>
						
						<!------BEFORE DETAIL, ADDING Customized SPECIFICALLY FOR WALMART-Type Customers, must fill in----->
						<cfif includeSpecials eq "yes">
							<personalizado_01></personalizado_01>
							<personalizado_02></personalizado_02>
							<personalizado_03></personalizado_03>
							<personalizado_04></personalizado_04>
							<personalizado_05></personalizado_05>
							<personalizado_06></personalizado_06>
							<personalizado_07></personalizado_07>
							<personalizado_08></personalizado_08>
							<personalizado_09></personalizado_09>
							<personalizado_10></personalizado_10>
							<personalizado_11></personalizado_11>
							<personalizado_12></personalizado_12>
							<personalizado_13></personalizado_13>
							<personalizado_14></personalizado_14>
						</cfif>
						
							<cfloop query="GetInvoice">
								<cfif Category neq vCatDesc>
									<detalleDte>
									
									<!------BEFORE DETAIL, ADDING Customized SPECIFICALLY FOR WALMART-Type Customers, must fill in----->
									<cfif includeSpecials eq "yes">
										<personalizado_01></personalizado_01>
										<personalizado_05></personalizado_05>
										<personalizado_06></personalizado_06>
									</cfif>
									
									<cfif vCincludeWH eq "yes">
										<personalizado_02>#getInvoice.Warehouse#</personalizado_02>
									</cfif>
									
									<cantidad>#TransactionQuantity#</cantidad>
									<unidadMedida>#vUoM#</unidadMedida>
									<codigoProducto>#ItemBarCode#</codigoProducto>
									<cfif includeUoMDesc eq "yes">
										<cfset v_ItemDescription = ItemDescription&" - "&UoM>
									<cfelse>
										<cfset v_ItemDescription = ItemDescription>
									</cfif>
										<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
										<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
						            	<descripcionProducto>#v_ItemDescription#</descripcionProducto>
										
									<precioUnitario>#trim(numberformat(ABS(SalesPrice),"__.__"))#</precioUnitario>
									<montoBruto><cfif GetInvoice.TaxExemption eq "1">#numberformat(SalesAmountExemption,"__.__")#<cfelse>#trim(numberformat(ABS(SalesTotal),"__.__"))#</cfif></montoBruto>
									<importeNetoGravado>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeNetoGravado>
									<cfif vreccount eq "1" and ABS(TotalDiscounts) gt "0">
										<detalleImpuestosIva>#numberformat(SalesTax + TotalTaxDiscounts ,"__.__")#</detalleImpuestosIva>
										<montoDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</montoDescuento>
										<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
									<cfelse>
										<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
										<montoDescuento>0</montoDescuento>	
									</cfif>
										<importeExento>0</importeExento>
										<otrosImpuestos>0</otrosImpuestos>
										<importeOtrosImpuestos>0</importeOtrosImpuestos>
										<importeTotalOperacion>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeTotalOperacion>
										<tipoProducto><cfif Category eq vCatProd>B<cfelse>S</cfif></tipoProducto>
										</detalleDte>
									<cfset vreccount = vreccount + 1>
								</cfif>
								<cfif TaxExemption eq "1">
									<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesAmountExemption>	
									<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTaxExemption>
								<cfelse>
									<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesTotal>	
									<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTax>
								</cfif>
							</cfloop>
							<importeBruto>#vInvoiceTotalAmount#</importeBruto>
							<importeDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</importeDescuento>
							<importeTotalExento>#vInvoiceTotalExempt#</importeTotalExento>
							<importeOtrosImpuestos>0</importeOtrosImpuestos>
							<importeNetoGravado>#vInvoiceTotalAmount#</importeNetoGravado>
							<detalleImpuestosIva>#vInvoiceTotalTax#</detalleImpuestosIva>
							<montoTotalOperacion>#vInvoiceTotalAmount#</montoTotalOperacion>
							<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
						</dte>
						</dte>
						</registrarDte>
						</soap:Body>
						</soap:Envelope>
				</cfoutput>
				</cfsavecontent>
			
				<cfset soapBody = Replace(soapBody, Chr(09),"","all")> <!--- blank space ---->
				<cfset soapBody = Replace(soapBody, Chr(13),"","all")> <!--- newline space ---->
				<cfset soapBody = Replace(soapBody, Chr(10),"","all")> <!--- newline space ---->

				<cfquery name		="getEDIConfig"
						datasource	="AppsOrganization" 
						username  	="#SESSION.login#" 
						password  	="#SESSION.dbpw#">
						SELECT 		*
						FROM 		System.dbo.Parameter
				</cfquery>

				<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
				<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\WorkOrderSale">

				<cfif not directoryExists(vLogsDirectory)>
					<cfdirectory action="create" directory="#vLogsDirectory#">
				</cfif>
							
				<cfif writeFile eq "yes">
					<cffile action="WRITE" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_Req.txt" output="#soapbody#">	
				</cfif>
			
				<cfset EFACEResponse = structnew()>
				<cfset EFACEResponse.CustomMsg = "#thisMsg#">
				<cfset EFACEResponse.Status = "NOTOK">				
				
				<cfif postInfile eq "yes">
					<cfhttp url="https://ingface.net/listener/ingface" method="post" result="httpResponse" timeout="300" charset="UTF-8">
						<cfhttpparam type="header" name="SOAPAction" value=""/>
						<cfhttpparam type="header" name="accept-encoding" value="no-compression"/>	
						<cfhttpparam type="xml" value="#trim(soapBody)#" />
					</cfhttp>
					
					<cffile action="WRITE" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_Resp.txt" output="#httpResponse.fileContent#">
					
					<cfif httpResponse.statusCode eq "200 OK">
						<cfset xmlDoc = xmlParse(httpResponse.fileContent, false)>
						
						<cfset vvalid = xmlSearch(xmlDoc,"//*[local-name()='valido']")>
						<cfset cae = xmlSearch(xmlDoc,"//*[local-name()='cae']")>
						<cfset docNo = xmlSearch(xmlDoc,"//*[local-name()='numeroDocumento']")>
						<cfset dte = xmlSearch(xmlDoc,"//*[local-name()='numeroDte']")>
						
						<cfif vvalid[1].XmlText eq "true">
							
								<!---- Valid Invoice Number generated by the GFACE. update Invoice number information --->	
																		
								<cfset EFACEResponse.Status = "OK">
								<cfset EFACEResponse.Cae = cae[1].XmlText>
								<cfset EFACEResponse.DocumentNo = docNo[1].XmlText>
								<cfset EFACEResponse.Dte = dte[1].XmlText>
								<cfset EFACEResponse.ErrorDescription = "">
						<cfelse>
								<!---- Validation Error from the GFACE --->
					
							<cfset vErrorDesc = xmlSearch(xmlDoc,"//*[local-name()='descripcion']")>					
							
							<cfset EFACEResponse.Status = "false">
							<cfset EFACEResponse.Cae = "">
							<cfset EFACEResponse.DocumentNo = "">
							<cfset EFACEResponse.Dte = "">
							<cfset EFACEResponse.ErrorDescription = vErrorDesc[1].XmlText>
						</cfif>
						
					<cfelse>
						<cfset EFACEResponse.Status = httpResponse.statusCode>
						<cfset EFACEResponse.Cae = "">
						<cfset EFACEResponse.DocumentNo = "">
						<cfset EFACEResponse.Dte = "">
						<cfset EFACEResponse.ErrorDescription =  httpResponse.statusCode>
					</cfif>
				</cfif>
				<!-----
				----->
				
			 <cfreturn EFACEResponse>
				 
		</cffunction>	
		
						    
	
		<cffunction name="SaleIssue"
             access="public"
             returntype="any"
             displayname="GetFACE">
			 
			 <cfargument name="Datasource"      type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"         type="string"  required="true"   default="">
			 <cfargument name="Terminal"        type="string"  required="true"   default="1">			 
			 <cfargument name="BatchId"         type="string"  required="true"   default="">
			 <cfargument name="RetryNo"         type="string"  required="false"  default="0">
			 <cfargument name="catDesc"			type="string"  required="false"  default="DSC">
			 <cfargument name="catProd"			type="string"  required="false"  default="PRD">
			 <cfargument name="AddrType"		type="string"  required="false"  default="Home">
			 
			 <cfset vCatDesc						= CatDesc>
 			 <cfset vCatProd						= CatProd>
			 <cfset vAddrType						= AddrType>

			<cfquery name="GetBatch" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT *
				FROM WarehouseBatch
				WHERE BatchId = '#batchid#'
			</cfquery>					 
			 			 
			<cfquery name="GetInvoice" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
			
					SELECT	C.FirstName,
						C.LastName,
						<!---Infile utf 8 encoding testing  --->
						<!---C.CustomerName collate SQL_Latin1_General_Cp1251_CS_AS AS CustomerName,--->						 
						C.CustomerName,
						C.FullName, 
						UPPER(C.Reference) AS NIT, 
						C.eMailAddress,
						C.TaxExemption, 
						WB.TransactionDate,
						WB.BatchNo,
						WB.BatchReference,
						W.Warehouse, 
						W.WarehouseName,
						W.Address,
						W.Telephone,
						W.Mission,
						I.ItemNo, 
						<!---Infile utf 8 encoding testing  --->
						<!---I.ItemDescription collate SQL_Latin1_General_Cp1251_CS_AS AS ItemDescription,--->
						I.ItemDescription, 
						I.Category,
						IU.ItemBarCode, 
						--U.Description AS UoM,
						IU.UoM AS UoM,
						T.TransactionQuantity * -1 as TransactionQuantity,
						ROUND((S.SalesAmount * S.TaxPercentage),2) + S.SalesAmount AS SalesAmountExemption,
						ROUND((S.SalesAmount * S.TaxPercentage),2) AS SalesTaxExemption,
						S.SalesCurrency,
						S.SchedulePrice,
						S.SalesPrice, 
						S.SalesAmount, 
						S.SalesTax, 
						S.SalesTotal,
						<!---Infile utf 8 encoding testing  --->
						<!---
						(
							SELECT TOP 1 ltrim(rtrim(isnull(R.Address,'') + ' ' + isnull(R.Address2,'') + ' ' + isnull(R.AddressCity,'')))
							FROM Materials.dbo.CustomerAddress A 
							INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
							WHERE A.CustomerId = C.CustomerId
							AND A.AddressType = 'Home'
							ORDER BY DateEffective DESC
						) collate SQL_Latin1_General_Cp1251_CS_AS as Customeraddress,
						--->
												
						(
							SELECT TOP 1 ltrim(rtrim(isnull(R.Address,'') + ' ' + isnull(R.Address2,'') + ' ' + isnull(R.AddressCity,'')))
							FROM Materials.dbo.CustomerAddress A 
							INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
							WHERE A.CustomerId = C.CustomerId
							AND A.AddressType = '#vAddrType#'
							ORDER BY DateEffective DESC
						) Customeraddress,

						
						ISNULL((
							SELECT SUM(S1.SalesTotal)
							FROM Materials.dbo.ItemTransaction T1
							INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
							INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
							WHERE T1.TransactionBatchNo = WB.BatchNo
							/*AND I1.Category IN ('#vCatDesc#')*/
							AND S1.SchedulePrice <0 /*this should act as a discount*/
						),0) AS TotalDiscounts,
	
						ISNULL((
							SELECT SUM(S1.SalesTax)
							FROM Materials.dbo.ItemTransaction T1
							INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
							INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
							WHERE T1.TransactionBatchNo = WB.BatchNo
							/*AND I1.Category IN('#vCatDesc#')*/
							AND S1.SchedulePrice <0 /*this should act as a discount*/
						),0) AS TotalTaxDiscounts,
						
						<!---Infile utf 8 encoding testing  --->
						<!---					
						(
							SELECT TOP 1 T2.ItemDescription 
							FROM Materials.dbo.ItemTransaction T2
							INNER JOIN Materials.dbo.ItemTransactionShipping S2 ON S2.TransactionId = T2.TransactionId
							INNER JOIN Materials.dbo.Item I2 ON I2.ItemNo = T2.ItemNo
							WHERE T2.TransactionBatchNo = WB.BatchNo
							AND I2.Category = 'DSC'
						) collate SQL_Latin1_General_Cp1251_CS_AS AS DiscountDescription											
						--->						
						
						(
							SELECT TOP 1 T2.ItemDescription 
							FROM Materials.dbo.ItemTransaction T2
							INNER JOIN Materials.dbo.ItemTransactionShipping S2 ON S2.TransactionId = T2.TransactionId
							INNER JOIN Materials.dbo.Item I2 ON I2.ItemNo = T2.ItemNo
							WHERE T2.TransactionBatchNo = WB.BatchNo
							/*AND I2.Category IN ('#vCatDesc#')*/
							AND S2.SchedulePrice <0 /*this should act as a discount*/
						) DiscountDescription

						
				FROM Materials.dbo.WarehouseBatch WB
					INNER JOIN Materials.dbo.ItemTransaction T ON T.TransactionBatchNo = WB.BatchNo
					INNER JOIN Materials.dbo.ItemTransactionShipping S ON T.TransactionId = S.TransactionId
					INNER JOIN Materials.dbo.Customer C ON 
					<cfif getBatch.CustomerIdInvoice neq "">
						C.CustomerId = WB.CustomerIdInvoice
					<cfelse>
						C.CustomerId = WB.CustomerId
					</cfif>	
					INNER JOIN Materials.dbo.Item I ON I.ItemNo = T.ItemNo
					INNER JOIN Materials.dbo.ItemUoM IU ON IU.ItemNo = I.ItemNo AND IU.UoM = T.TransactionUoM
					--INNER JOIN Materials.dbo.Ref_UoM U ON U.Code = T.TransactionUoM 
					LEFT OUTER JOIN Materials.dbo.Ref_UoM U ON U.Code = IU.UoMCode 
					INNER JOIN Materials.dbo.Warehouse W ON W.Warehouse = WB.Warehouse
				WHERE WB.BatchId='#batchid#'	
				
				ORDER BY S.SalesTotal DESC
				
			</cfquery>	
						
			<!--- Get Mission Information --->
			<cfquery name="GetMission" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM  Organization.dbo.Ref_Mission
				WHERE Mission = '#mission#'	
			</cfquery>			
			
			<!--- Get Warehouse device information --->				
			<cfquery name="GetWarehouseDevice" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Materials.dbo.WarehouseTerminal
				WHERE  Warehouse = '#GetInvoice.Warehouse#'	
				AND    TerminalName = '#terminal#'
				AND    Operational=1
			</cfquery>	
						
			<!--- Get Warehouse and Series Information --->				
			<cfquery name="GetWarehouseSeries" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Organization.dbo.OrganizationTaxSeries 
				WHERE  OrgUnit = '#GetWarehouseDevice.TaxOrgUnitEDI#'
				AND    SeriesType = 'Invoice'
				AND    Operational=1
			</cfquery>	
							
			<!--- Get Config --->
			<cfquery name="GetMissionConfig" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Organization.dbo.Ref_MissionExchange
				WHERE  Mission = '#mission#'
				AND    ClassExchange = 'FACE'	
			</cfquery>	
						
			<!---- STORE THIS IN A CONFIG TABLE !! ---->
			<cfset vUser = GetMissionConfig.ExchangeUserId>
			<cfset vPwd = GetMissionConfig.ExchangePassword>
			<cfset vNitGFACE = GetWarehouseSeries.GFACEId>
			<cfset vNitEFACE = GetWarehouseSeries.EFACEId>
			<cfset DocumentType = GetWarehouseSeries.TaxDocumentType>  <!--- SAT Document Type: Regular Invoice --->
			
			<!----initializing.....------->
			<cfset vExchangeRate = "1">
			<cfset vCurrency = "GTQ">
			
			<cfif GetInvoice.SalesCurrency eq "QTZ">
				<cfset vExchangeRate = "1">
				<cfset vCurrency = "GTQ">			
			<cfelse>
				<!---get the exchangeRate ------>
				<cfquery name="getExchange" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT *
					FROM   Accounting.dbo.Currency
					WHERE  Currency = '#GetInvoice.SalesCurrency#'
				</cfquery>				
				<cfset vExchangeRate = GetExchange.ExchangeRate>
				<cfset vCurrency	 = GetExchange.Currency>
			</cfif>

			<!------
			<cfif GetInvoice.UoM eq "each">
				<cfset vUoM = "UND">
			<cfelse>
				<cfset vUoM = GetInvoice.UoM>
			</cfif>
			----->
			<cfset vUoM = "UND">
			
			<cfset vNIT = GetInvoice.NIT>
			<cfif vNIT eq "CF" OR vNIT eq "C-F">
				<cfset vNIT = "C/F">
			</cfif>
			
			<cfset vInvoiceTotalAmount = "0">
			<cfset vInvoiceTotalExempt = "0">
			<cfset vInvoiceTotalDiscount = "0">
			<cfset vInvoiceTotalTax = "0">
			<cfset vInvoiceTotalDiscount = GetInvoice.TotalDiscounts+0>	
			<cfset vInvoiceTotalTaxDiscount = GetInvoice.TotalTaxDiscounts+0>		
			<cfif GetInvoice.DiscountDescription neq "">
				<cfset vDiscountDescription = GetInvoice.DiscountDescription>
			<cfelse>
				<cfset vDiscountDescription = "Descuento">
			</cfif>				
			
			<cfset vreccount = "1">
																		
			<cfsavecontent variable="soapBody">
			<cfoutput>
			
			<!---Infile utf 8 encoding testing  --->
			<!---
			
			<?xml version="1.0" encoding="utf-16"?>
			--->
			<?xml version="1.0" encoding="utf-8"?>
			<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
			<soap:Body>
				<registrarDte xmlns="http://listener.ingface.com/">
					<dte xmlns="">
					<usuario>#vUser#</usuario>
					<clave>#vPwd#</clave>
					<dte>
					<fechaDocumento>#DateFormat(GetInvoice.TransactionDate,"YYYY-MM-DD")#</fechaDocumento>
					<tipoCambio>#vExchangeRate#</tipoCambio>
					<fechaResolucion>#DateFormat(GetWarehouseSeries.AuthorizationDate,"YYYY-MM-DD")#</fechaResolucion>		  
					<codigoEstablecimiento>#GetWarehouseDevice.Reference#</codigoEstablecimiento>
					<codigoMoneda>#vCurrency#</codigoMoneda>
					<correoComprador>#GetInvoice.eMailAddress#</correoComprador>
					<departamentoComprador>N/A</departamentoComprador>
					<departamentoVendedor>N/A</departamentoVendedor>
					<descripcionOtroImpuesto>N/A</descripcionOtroImpuesto>
					<cfif GetInvoice.CustomerAddress neq "">
						<direccionComercialComprador>#GetInvoice.Customeraddress#</direccionComercialComprador>
					<cfelse>
						<direccionComercialComprador>N/A</direccionComercialComprador>
					</cfif>
					<direccionComercialVendedor>#GetInvoice.Address#</direccionComercialVendedor>
					<estadoDocumento>Activo</estadoDocumento>
					<idDispositivo>#GetWarehouseDevice.Terminal#</idDispositivo>
					<municipioComprador>N/A</municipioComprador>
					<municipioVendedor>N/A</municipioVendedor>
					<nitComprador>#Replace(vNIT,"-","","ALL")#</nitComprador>
					<nitGFACE>#vNitGFACE#</nitGFACE>
					<nitVendedor>#vNitEFACE#</nitVendedor>
					<nombreComercialComprador>#Replace(GetInvoice.CustomerName,"&","")#</nombreComercialComprador>
					<nombreComercialRazonSocialVendedor>#GetMission.MissionName#</nombreComercialRazonSocialVendedor>
					<nombreCompletoVendedor>#GetMission.MissionName#</nombreCompletoVendedor>
					<numeroDocumento>#GetInvoice.BatchNo#</numeroDocumento>
					<numeroResolucion>#Replace(GetWarehouseSeries.AuthorizationNo,"-","","ALL")#</numeroResolucion>
					<observaciones>N/A</observaciones>
					<regimen2989><cfif GetInvoice.TaxExemption eq "1">true<cfelse>false</cfif></regimen2989>						
					<regimenISR>N/A</regimenISR>
					<serieAutorizada>#GetWarehouseSeries.SeriesNo#</serieAutorizada>
					<serieDocumento>#DocumentType#</serieDocumento>
					<telefonoComprador>N/A</telefonoComprador>
					<tipoDocumento>FACE</tipoDocumento>
						<cfloop query="GetInvoice">
							<cfif SalesPrice gt 0>
								<detalleDte>
								<cantidad>#TransactionQuantity#</cantidad>
								<unidadMedida>#vUoM#</unidadMedida>
								<codigoProducto>#ItemNo#</codigoProducto>
								<cfset v_ItemDescription = ItemDescription>
									<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
									<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
					            	<descripcionProducto>#v_ItemDescription#</descripcionProducto>
									
								<precioUnitario>#trim(numberformat(ABS(SalesPrice),"__.__"))#</precioUnitario>
								<montoBruto><cfif GetInvoice.TaxExemption eq "1">#numberformat(SalesAmountExemption,"__.__")#<cfelse>#trim(numberformat(ABS(SalesTotal),"__.__"))#</cfif></montoBruto>
								<importeNetoGravado>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeNetoGravado>
								
								<cfif TaxExemption eq "1">
									<cfset vSaleAmount = SalesAmountExemption>
								<cfelse>
									<cfset vSaleAmount = SalesTotal>					
								</cfif>
								
								<cfif (vreccount eq "1" and ABS(TotalDiscounts) gt "0")>
										<detalleImpuestosIva>#numberformat(SalesTax + TotalTaxDiscounts ,"__.__")#</detalleImpuestosIva>
										<montoDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</montoDescuento>
										<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
								<cfelseif (Abs(SchedulePrice*TransactionQuantity-vSaleAmount) gt 0.05)>
										<cfset vOriginal = SchedulePrice*TransactionQuantity>
										<cfset vTotalDiscounts = abs(vOriginal-vSaleAmount)>
										<cfset vInvoiceTotalDiscount = vTotalDiscounts + vInvoiceTotalDiscount> 
										<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
										<montoDescuento>#trim(numberformat(ABS(vTotalDiscounts),"__.__"))#</montoDescuento>
										<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
								<cfelse>
									<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
									<montoDescuento>0</montoDescuento>	
								</cfif>
									<importeExento>0</importeExento>
									<otrosImpuestos>0</otrosImpuestos>
									<importeOtrosImpuestos>0</importeOtrosImpuestos>
									<importeTotalOperacion>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeTotalOperacion>
									<tipoProducto><cfif SalesPrice gt 0>B<cfelse>S</cfif></tipoProducto>
									</detalleDte>
								<cfset vreccount = vreccount + 1>
							</cfif>
							<cfif TaxExemption eq "1">
								<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesAmountExemption>	
								<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTaxExemption>
							<cfelse>
								<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesTotal>	
								<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTax>
							</cfif>
						</cfloop>
						<importeBruto>#vInvoiceTotalAmount#</importeBruto>
						<importeDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</importeDescuento>
						<importeTotalExento>#vInvoiceTotalExempt#</importeTotalExento>
						<importeOtrosImpuestos>0</importeOtrosImpuestos>
						<importeNetoGravado>#vInvoiceTotalAmount#</importeNetoGravado>
						<detalleImpuestosIva>#vInvoiceTotalTax#</detalleImpuestosIva>
						<montoTotalOperacion>#vInvoiceTotalAmount#</montoTotalOperacion>
						<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
					</dte>
					</dte>
					</registrarDte>
					</soap:Body>
					</soap:Envelope>
			</cfoutput>
			</cfsavecontent>
			
			<cfset soapBody = Replace(soapBody, Chr(09),"","all")> <!--- blank space ---->
			<cfset soapBody = Replace(soapBody, Chr(13),"","all")> <!--- newline space ---->
			<cfset soapBody = Replace(soapBody, Chr(10),"","all")> <!--- newline space ---->

			<cfquery name		="getEDIConfig"
					datasource	="#datasource#" 
					username  	="#SESSION.login#" 
					password  	="#SESSION.dbpw#">
					SELECT 		*
					FROM 		System.dbo.Parameter
			</cfquery>

			<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
			<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\POSSale">

			<cfif not directoryExists(vLogsDirectory)>
				<cfdirectory action="create" directory="#vLogsDirectory#">
			</cfif>
			
  			<cffile action="WRITE" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_#RetryNo#.txt" output="#soapbody#">	
			<cffile action = "append" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_#RetryNo#.txt" output="#now()#">

		<!--- <cfhttp url="https://www.ingface.net/listener/ingface" method="post" result="httpResponse" timeout="300" charset="UTF-8">--->
			<cfhttp url="https://ingface.net/listener/ingface" method="post" result="httpResponse" timeout="300" charset="UTF-8">
				<cfhttpparam type="header" name="SOAPAction" value=""/>
				<cfhttpparam type="header" name="accept-encoding" value="no-compression"/>	
				<cfhttpparam type="xml" value="#trim(soapBody)#" />
			</cfhttp>
			
 			<cffile action="WRITE" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_Response_#RetryNo#.txt" output="#httpResponse.fileContent#">			
			<cffile action = "append" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_Response_#RetryNo#.txt" output="#now()#">
			<cffile action = "append" file="#vLogsDirectory#\FACE_#GetInvoice.BatchNo#_Response_#RetryNo#.txt" output="#httpResponse.statusCode#">
			
			<cfset EFACEResponse = structnew()>

			<cfif httpResponse.statusCode eq "200 OK" OR httpResponse.statusCode eq "200" OR httpResponse.statusCode eq "OK">
				<cfset xmlDoc = xmlParse(httpResponse.fileContent, false)>
				
				<cfset vvalid = xmlSearch(xmlDoc,"//*[local-name()='valido']")>
				<cfset cae = xmlSearch(xmlDoc,"//*[local-name()='cae']")>
				<cfset docNo = xmlSearch(xmlDoc,"//*[local-name()='numeroDocumento']")>
				<cfset dte = xmlSearch(xmlDoc,"//*[local-name()='numeroDte']")>
				
				<cfif vvalid[1].XmlText eq "true">
					
						<!---- Valid Invoice Number generated by the GFACE. update Invoice number information --->	
																
						<cfset EFACEResponse.Status = "OK">
						<cfset EFACEResponse.Cae = cae[1].XmlText>
						<cfset EFACEResponse.DocumentNo = docNo[1].XmlText>
						<cfset EFACEResponse.Dte = dte[1].XmlText>
						<cfset EFACEResponse.ErrorDescription = "">
				<cfelse>
						<!---- Validation Error from the GFACE --->
			
					<cfset vErrorDesc = xmlSearch(xmlDoc,"//*[local-name()='descripcion']")>					
					
					<cfset EFACEResponse.Status = "false">
					<cfset EFACEResponse.Cae = "">
					<cfset EFACEResponse.DocumentNo = "">
					<cfset EFACEResponse.Dte = "">
					<cfset EFACEResponse.ErrorDescription = vErrorDesc[1].XmlText>
				</cfif>
				
			<cfelse>
			
				<cfset EFACEResponse.Status = httpResponse.statusCode>
				<cfset EFACEResponse.Cae = "">
				<cfset EFACEResponse.DocumentNo = "">
				<cfset EFACEResponse.Dte = "">
				<cfset EFACEResponse.ErrorDescription =  httpResponse.statusCode>
			</cfif>		
			
			<cfreturn EFACEResponse>
			
	</cffunction>		
	

	<cffunction name="ManualSaleBatch"
            access="public"
            returntype="any"
			returnformat="plain"
            displayname="GetFACEManual">
			 
			 <!---  This function sends the Manual sales information to Infile.  It is required by law that the manual sales (paper invoices) are also reported to SAT through the GFACE
			        within the next 60 days after the month of the invoice 
					The function allows to send one or many invoices depending on the parameters specified
					--->
			 
			 <cfargument name="Datasource"      type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"         type="string"  required="true"   default="">
			 <cfargument name="DateStart"     	type="date"    required="true"   default="now()">				
			 <cfargument name="DateEnd"     	type="date"    required="true"   default="now()">			 			 
			 <cfargument name="BatchId"         type="string"  required="false"   default="">
			 <cfargument name="Warehouse"       type="string"  required="false"   default="">

			<cfset DateStart = dateadd("d",0,DateStart)>
			<cfset DateEnd = dateadd("d",1,DateEnd)>
						 
			<cfquery name="GetBatch" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
				SELECT *
				FROM WarehouseBatch B
				WHERE TransactionDate >= #DateStart# 
				AND TransactionDate < #DateEnd#			 
				AND ActionStatus <> '9'
				AND B.BatchReference IS NOT NULL
				AND B.BatchReference <> ''			
				AND B.BatchReference <> '0'						
				AND BatchId IN (
					SELECT H.TransactionSourceId
					FROM Accounting.dbo.TransactionHeader H
					INNER JOIN Accounting.dbo.TransactionHeaderAction A ON A.Journal = H.Journal and A.JournalSerialNo=H.JournalSerialNo
					WHERE TransactionSource='SalesSeries'
					AND H.Reference ='Receivables'
					AND H.RecordStatus <> '9'
					AND A.ActionCode = 'Invoice'
					AND A.ActionMode = '1'
					) 
				AND NOT EXISTS (
					SELECT 1
					FROM Accounting.dbo.TransactionHeader H1
					INNER JOIN Accounting.dbo.TransactionHeaderAction A1 ON A1.Journal = H1.Journal and A1.JournalSerialNo=H1.JournalSerialNo
					WHERE H1.TransactionSourceId = B.BatchId 
					AND H1.TransactionSource='SalesSeries'
					AND H1.Reference ='Receivables'
					AND H1.RecordStatus <> '9'
					AND A1.ActionMode = '2'
					AND A1.ActionCode = 'InvoiceCopy'
				 )
				AND  EXISTS (
					SELECT 1
					FROM ItemTransaction IT1
					WHERE IT1.TransactionBatchNo = B.BatchNo
				 )
				
				<cfif BatchId neq "">
					AND BatchId = '#batchid#'
				</cfif>
				
				<cfif Warehouse neq "">
					AND B.Warehouse = '#Warehouse#'
				</cfif>
				
				ORDER BY B.BatchNo
			</cfquery>		
		
			<cfloop query="GetBatch">			
			 			 
				<cfquery name="GetInvoice" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
				
					SELECT	C.FirstName,
							C.LastName,
							C.CustomerName,
							C.FullName, 
							UPPER(C.Reference) AS NIT, 
							C.eMailAddress,
							C.TaxExemption, 
							WB.TransactionDate,
							WB.BatchNo,
							LTRIM(RTRIM(WB.BatchReference)) BatchReference,
							W.Warehouse, 
							W.WarehouseName,
							W.Address,
							W.Telephone,
							W.Mission,
							I.ItemNo, 
							I.ItemDescription, 
							I.Category,
							IU.ItemBarCode, 
							U.Description AS UoM,
							T.TransactionQuantity * -1 as TransactionQuantity,
							ROUND((S.SalesAmount * S.TaxPercentage),2) + S.SalesAmount AS SalesAmountExemption,
							ROUND((S.SalesAmount * S.TaxPercentage),2) AS SalesTaxExemption,
							S.SalesCurrency,
							S.SalesPrice, 
							S.SalesAmount, 
							S.SalesTax, 
							S.SalesTotal,
							(
								SELECT TOP 1 ltrim(rtrim(isnull(R.Address,'') + ' ' + isnull(R.Address2,'') + ' ' + isnull(R.AddressCity,'')))
								FROM Materials.dbo.CustomerAddress A 
								INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
								WHERE A.CustomerId = C.CustomerId
								AND A.AddressType = 'Home'
								ORDER BY DateEffective DESC
							) as Customeraddress,
							
							ISNULL((
								SELECT SUM(S1.SalesTotal)
								FROM Materials.dbo.ItemTransaction T1
								INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
								INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
								WHERE T1.TransactionBatchNo = WB.BatchNo
								AND I1.Category = 'DSC'
								<!----- in case of any failure for the discounts
								AND T1.TransactionId not in 
								(
								'39148B6B-2219-29B1-2E17-17FBDE5735E3',
								'3913741E-2219-29B1-2E57-D1BC28A64580'
								)---->
							),0) AS TotalDiscounts,
		
							ISNULL((
								SELECT SUM(S1.SalesTax)
								FROM Materials.dbo.ItemTransaction T1
								INNER JOIN Materials.dbo.ItemTransactionShipping S1 ON S1.TransactionId = T1.TransactionId
								INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
								WHERE T1.TransactionBatchNo = WB.BatchNo
								AND I1.Category = 'DSC'
								<!----- in case of any failure for the discounts
								AND T1.TransactionId not in 
								(
								'39148B6B-2219-29B1-2E17-17FBDE5735E3',
								'3913741E-2219-29B1-2E57-D1BC28A64580'
								)---->
							),0) AS TotalTaxDiscounts,
													
							(
								SELECT TOP 1 T2.ItemDescription 
								FROM Materials.dbo.ItemTransaction T2
								INNER JOIN Materials.dbo.ItemTransactionShipping S2 ON S2.TransactionId = T2.TransactionId
								INNER JOIN Materials.dbo.Item I2 ON I2.ItemNo = T2.ItemNo
								WHERE T2.TransactionBatchNo = WB.BatchNo
								AND I2.Category = 'DSC'
							) AS DiscountDescription
							
							
					FROM Materials.dbo.WarehouseBatch WB
						INNER JOIN Materials.dbo.ItemTransaction T ON T.TransactionBatchNo = WB.BatchNo
						INNER JOIN Materials.dbo.ItemTransactionShipping S ON T.TransactionId = S.TransactionId
						INNER JOIN Materials.dbo.Customer C ON 
						<cfif getBatch.CustomerIdInvoice neq "">
							C.CustomerId = WB.CustomerIdInvoice
						<cfelse>
							C.CustomerId = WB.CustomerId
						</cfif>	
						INNER JOIN Materials.dbo.Item I ON I.ItemNo = T.ItemNo
						INNER JOIN Materials.dbo.ItemUoM IU ON IU.ItemNo = I.ItemNo AND IU.UoM = T.TransactionUoM

						LEFT OUTER JOIN Materials.dbo.Ref_UoM U ON U.Code = IU.UoMCode
						INNER JOIN Materials.dbo.Warehouse W ON W.Warehouse = WB.Warehouse
					WHERE WB.BatchId='#GetBatch.batchid#'
					<!----- in case of any failure for the discounts
					AND T.TransactionId not in (
						'39148B6B-2219-29B1-2E17-17FBDE5735E3',
						'3913EF0B-2219-29B1-2EB7-3816F7178118',
						'3913741E-2219-29B1-2E57-D1BC28A64580'
					)---->	
					
				</cfquery>	
							
				<!--- Get Mission Information --->
				<cfquery name="GetMission" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT *
					FROM  Organization.dbo.Ref_Mission
					WHERE Mission = '#mission#'	
				</cfquery>			
				
				<!--- Get TaxOrgunitManual information --->				
				<cfquery name="GetWarehouseDevice" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT TOP 1 *
					FROM   Materials.dbo.WarehouseTerminal
					WHERE  Warehouse = '#GetInvoice.Warehouse#'	
					AND    Operational=1
				</cfquery>	
							
				<!--- Get Warehouse and Series Information --->				
				<cfquery name="GetWarehouseSeries" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT *
					FROM   Organization.dbo.OrganizationTaxSeries 
					WHERE  OrgUnit = '#GetWarehouseDevice.TaxOrgUnitManual#'
					AND    SeriesType = 'Invoice'
					AND    Operational=1
				</cfquery>	
					
				
				<!--- Get Config --->
				<cfquery name="GetMissionConfig" 
					datasource="#datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
					SELECT *
					FROM   Organization.dbo.Ref_MissionExchange
					WHERE  Mission = '#mission#'
					AND    ClassExchange = 'FACE'	
				</cfquery>	
							
				<!---- STORE THIS IN A CONFIG TABLE !! ---->
				<cfset vUser = GetMissionConfig.ExchangeUserId>
				<cfset vPwd = GetMissionConfig.ExchangePassword>
				<cfset vNitGFACE = GetWarehouseSeries.GFACEId>
				<cfset vNitEFACE = GetWarehouseSeries.EFACEId>
				<cfset DocumentType = "1">  <!--- SAT Document Type: Regular Invoice --->
							
				<cfif GetInvoice.SalesCurrency eq "QTZ">
					<cfset vExchangeRate = "1">
					<cfset vCurrency = "GTQ">			
				</cfif>
				
				<cfset vUoM = "UND">
				
				<!-----
				<cfif GetInvoice.UoM eq "each">
					<cfset vUoM = "UND">
				<cfelse>
					<cfset vUoM = GetInvoice.UoM>
				</cfif>   ---->

				<cfset arr = listToArray (GetInvoice.BatchReference, " ",false,true)>
				<cfset invoiceNo = "">
				<cfif ArrayLen(arr) gt 1>
						<cfset invoiceNo = arr[2]>
					<cfelse>
						<cfset invoiceNo = arr[1]>
					</cfif>
				
				<cfset vNIT = GetInvoice.NIT>
				<cfif vNIT eq "CF" OR vNIT eq "C-F">
					<cfset vNIT = "C/F">
				</cfif>
				
				<cfset vInvoiceTotalAmount = "0">
				<cfset vInvoiceTotalExempt = "0">
				<cfset vInvoiceTotalDiscount = "0">
				<cfset vInvoiceTotalTax = "0">
				<cfset vInvoiceTotalDiscount = GetInvoice.TotalDiscounts+0>	
				<cfset vInvoiceTotalTaxDiscount = GetInvoice.TotalTaxDiscounts+0>		
				<cfset vDiscountDescription = GetInvoice.DiscountDescription>			
				<cfset vreccount = "1">
																			
				<cfsavecontent variable="soapBody">
				<cfoutput>
				
				<?xml version="1.0" encoding="utf-16"?>
				<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
				  <soap:Body>
				    <registrarDte xmlns="http://listener.ingface.com/">
				      <dte xmlns="">
					  
				        <usuario>#vUser#</usuario>
				        <clave>#vPwd#</clave>
				        <dte>
							<fechaDocumento>#DateFormat(GetInvoice.TransactionDate,"YYYY-MM-DD")#</fechaDocumento>
						  	<tipoCambio>#vExchangeRate#</tipoCambio>
						  	<fechaResolucion>#DateFormat(GetWarehouseSeries.AuthorizationDate,"YYYY-MM-DD")#</fechaResolucion>		  
						  
				          	<codigoEstablecimiento>#GetWarehouseDevice.Reference#</codigoEstablecimiento>
				          	<codigoMoneda>#vCurrency#</codigoMoneda>
				          	<correoComprador>#GetInvoice.eMailAddress#</correoComprador>
				          	<departamentoComprador>N/A</departamentoComprador>
				          	<departamentoVendedor>N/A</departamentoVendedor>
				          	<descripcionOtroImpuesto>N/A</descripcionOtroImpuesto>
							
							<cfif GetInvoice.CustomerAddress neq "">
								<direccionComercialComprador>#GetInvoice.Customeraddress#</direccionComercialComprador>
							<cfelse>
								<direccionComercialComprador>N/A</direccionComercialComprador>
							</cfif>
						  	
				          	<direccionComercialVendedor>#GetInvoice.Address#</direccionComercialVendedor>
				          	<estadoDocumento>Activo</estadoDocumento>
				          	<idDispositivo>#GetWarehouseDevice.Terminal#</idDispositivo>
							
				          	<municipioComprador>N/A</municipioComprador>
				          	<municipioVendedor>N/A</municipioVendedor>
				          	<nitComprador>#Replace(vNIT,"-","","ALL")#</nitComprador>
				          	<nitGFACE>#vNitGFACE#</nitGFACE>
				          	<nitVendedor>#vNitEFACE#</nitVendedor>
				          	<nombreComercialComprador>#Replace(GetInvoice.CustomerName,"&","")#</nombreComercialComprador>
				          	<nombreComercialRazonSocialVendedor>#GetMission.MissionName#</nombreComercialRazonSocialVendedor>
				          	<nombreCompletoVendedor>#GetMission.MissionName#</nombreCompletoVendedor>
				          	
							<numeroDocumento>#invoiceNo#</numeroDocumento>
				          
						  	<numeroResolucion>#Replace(GetWarehouseSeries.AuthorizationNo,"-","","ALL")#</numeroResolucion>
				         	<observaciones>N/A</observaciones>
				          	<regimen2989><cfif GetInvoice.TaxExemption eq "1">true<cfelse>false</cfif></regimen2989>						
				          	<regimenISR>N/A</regimenISR>
				          	<serieAutorizada>#GetWarehouseSeries.SeriesNo#</serieAutorizada>
				          	<serieDocumento>#DocumentType#</serieDocumento>
				          	<telefonoComprador>N/A</telefonoComprador>
				          	<tipoDocumento>CFACE</tipoDocumento>
							
							
							<cfloop query="GetInvoice">
							
								<cfif Category neq "DSC">
									
							    	<detalleDte>
									<cantidad>#TransactionQuantity#</cantidad>
					            	<unidadMedida>#vUoM#</unidadMedida>
									<codigoProducto>#ItemNo#</codigoProducto>
									<cfset v_ItemDescription = ItemDescription>
									<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
									<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
									
					            	<descripcionProducto>#v_ItemDescription#</descripcionProducto>
					            	<precioUnitario>#trim(numberformat(ABS(SalesPrice),"__.__"))#</precioUnitario>
					            	<montoBruto><cfif GetInvoice.TaxExemption eq "1">#numberformat(SalesAmountExemption,"__.__")#<cfelse>#trim(numberformat(ABS(SalesTotal),"__.__"))#</cfif></montoBruto>			            	
									
		<!--- 							<cfif Category eq "DSC">
										<montoDescuento>#numberformat(ABS(SalesTotal),"__.__")#</montoDescuento>
										<cfset vInvoiceTotalDiscount = vInvoiceTotalDiscount + ABS(SalesTotal)>
									<cfelse>
										<montoDescuento>0</montoDescuento>
									</cfif> --->
									
									
									
					            	<importeNetoGravado>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeNetoGravado>							            	
									
									<cfif vreccount eq "1" and ABS(TotalDiscounts) gt "0">
										<cfset TaxDiff = (SalesTax + TotalTaxDiscounts)>
										<cfif TaxDiff gte 1>
											<detalleImpuestosIva>#numberformat(SalesTax + TotalTaxDiscounts ,"__.__")#</detalleImpuestosIva>
											<cfelse>
											<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
										</cfif>
										<montoDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</montoDescuento>
										<personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
									<cfelse>
										<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
										<montoDescuento>0</montoDescuento>	
									</cfif>
									
									<importeExento>0</importeExento>							
									<otrosImpuestos>0</otrosImpuestos>
									<importeOtrosImpuestos>0</importeOtrosImpuestos>							
									<importeTotalOperacion>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeTotalOperacion>
									<tipoProducto><cfif Category eq "PRD">B<cfelse>S</cfif></tipoProducto>	
																								
				          			</detalleDte>							
								
									<cfset vreccount = vreccount + 1>
									
								</cfif>
	
								<cfif TaxExemption eq "1">
									<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesAmountExemption>	
									<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTaxExemption>
								<cfelse>
									<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesTotal>	
									<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTax>
								</cfif>
								
								
							</cfloop>												
				          
					          <importeBruto>#vInvoiceTotalAmount#</importeBruto>
					          <!--- <importeDescuento>#vInvoiceTotalDiscount#</importeDescuento> --->
							  <importeDescuento>#trim(numberformat(ABS(vInvoiceTotalDiscount),"__.__"))#</importeDescuento>
							  <importeTotalExento>#vInvoiceTotalExempt#</importeTotalExento>
							  <importeOtrosImpuestos>0</importeOtrosImpuestos>
							  <importeNetoGravado>#vInvoiceTotalAmount#</importeNetoGravado>
							  <detalleImpuestosIva>#vInvoiceTotalTax#</detalleImpuestosIva>
					          <montoTotalOperacion>#vInvoiceTotalAmount#</montoTotalOperacion>
							  <personalizado_01>#trim(vDiscountDescription)#</personalizado_01>
				        </dte>
				      </dte>
				    </registrarDte>
				  </soap:Body>
				</soap:Envelope>
				</cfoutput>
				</cfsavecontent>
				
				<cfquery name		="getEDIConfig"
					datasource	="#datasource#" 
					username  	="#SESSION.login#" 
					password  	="#SESSION.dbpw#">
					SELECT 		*
					FROM 		System.dbo.Parameter
			</cfquery>

				<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
				<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\Manual">

				<cfif not directoryExists(vLogsDirectory)>
					<cfdirectory action="create" directory="#vLogsDirectory#">
				</cfif>

  				<cffile action="WRITE" file="#vLogsDirectory#\CFACE_#GetInvoice.BatchNo#.txt" output="#soapbody#">	 
	 			
 				<cfhttp url="https://www.ingface.net/listener/ingface" method="post" result="httpResponse" timeout="300">
					<cfhttpparam type="header" name="SOAPAction" value=""/>
					<cfhttpparam type="header" name="accept-encoding" value="no-compression"/>	
					<cfhttpparam type="xml" value="#trim(soapBody)#" />
				</cfhttp>			
				
				<cffile action="WRITE" file="#vLogsDirectory#\CFACE_#GetInvoice.BatchNo#.err" output="#httpResponse.fileContent#">			
				
				<cfset EFACEResponse = structnew()>
	
				<cfif httpResponse.statusCode eq "200 OK" OR httpResponse.statusCode eq "200" OR httpResponse.statusCode eq "OK">
					<cfset xmlDoc = xmlParse(httpResponse.fileContent, false)>
					
					<cfset vvalid = xmlSearch(xmlDoc,"//*[local-name()='valido']")>
					<cfset cae = xmlSearch(xmlDoc,"//*[local-name()='cae']")>
					<cfset docNo = xmlSearch(xmlDoc,"//*[local-name()='numeroDocumento']")>
					<cfset dte = xmlSearch(xmlDoc,"//*[local-name()='numeroDte']")>
					
					<cfif vvalid[1].XmlText eq "true">
						
							<!---- Valid Invoice Number generated by the GFACE. update Invoice number information --->	
																	
							<cfset EFACEResponse.Status = "OK">
							<cfset EFACEResponse.Cae = cae[1].XmlText>
							<cfset EFACEResponse.DocumentNo = docNo[1].XmlText>
							<cfset EFACEResponse.Dte = dte[1].XmlText>
							<cfset EFACEResponse.ErrorDescription = "">
				
							
							<cfquery name="get"
							 datasource="#datasource#" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 	SELECT  *
								FROM    Accounting.dbo.TransactionHeader
								WHERE   TransactionSourceId = '#GetBatch.batchid#'
								AND     TransactionCategory = 'Receivables'				
							</cfquery> 							
				
					
				
							<cfquery name="AddAction"
				               datasource="#datasource#"
				               username="#SESSION.login#"
				               password="#SESSION.dbpw#">
				                  INSERT INTO Accounting.dbo.TransactionHeaderAction							  
	
				                         (ActionId,
									      Journal,
				                          JournalSerialNo,
				                          ActionCode,     
									      ActionMode,  
										  <!--- more information --->	
										  ActionReference1,
										  ActionReference2,
										  ActionReference3,						                       								
									      ActionReference4,
										  ActionMemo,  							   						  
				                          ActionDate,
						  			      ActionStatus,                                
				                          OfficerUserId,
				                          OfficerLastName,
				                          OfficerFirstName)
										  
				                  VALUES (NEWID(),
										  '#get.Journal#',
				            		      '#get.JournalSerialNo#',
				                          'InvoiceCopy',		
										  '2',						
										  <!--- more information --->	                       
										  '#EFACEResponse.Cae#',
										  '#EFACEResponse.DocumentNo#',
										  '#EFACEResponse.Dte#',
										  '#GetWarehouseSeries.SeriesNo#',
										  '#left(EFACEResponse.ErrorDescription,100)#', 
						                  getDate(),                                 
				        		          '1',     <!--- mode process completed --->
				                	      '#SESSION.acc#',
				                          '#SESSION.last#',
						                  '#SESSION.first#')  									                 
				            </cfquery>  	
																									
							
					<cfelse>
							<!---- Validation Error from the GFACE --->
				
						<cfset vErrorDesc = xmlSearch(xmlDoc,"//*[local-name()='descripcion']")>					
						
						<cfset EFACEResponse.Status = "false">
						<cfset EFACEResponse.Cae = "">
						<cfset EFACEResponse.DocumentNo = "">
						<cfset EFACEResponse.Dte = "">
						<cfset EFACEResponse.ErrorDescription = vErrorDesc[1].XmlText>
					</cfif>
					
				<cfelse>
				
					<cfset EFACEResponse.Status = httpResponse.statusCode>
					<cfset EFACEResponse.Cae = "">
					<cfset EFACEResponse.DocumentNo = "">
					<cfset EFACEResponse.Dte = "">
					<cfset EFACEResponse.ErrorDescription =  httpResponse.statusCode>
				</cfif>		
							
 		</cfloop>
			 		
		<cfreturn "">
			
	</cffunction>
					
	<cffunction name="SaleVoid"
             access="public"
             returntype="any"
             returnformat="plain"
             displayname="VoidSale">			 
			 
			 <cfargument name="Datasource"      type="string"  required="true"   default="appsOrganization">
			 <cfargument name="Mission"         type="string"  required="true"   default="">
			 <cfargument name="Terminal"        type="string"  required="true"   default="1">			 
			 <cfargument name="BatchId"         type="string"  required="true"   default="">
			 			 
			<cfquery name="GetInvoice" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
			
				SELECT	C.FirstName,
						C.LastName,
						C.CustomerName,
						C.FullName, 
						C.Reference AS NIT, 
						C.eMailAddress,
						C.TaxExemption, 
						WB.TransactionDate,
						WB.BatchNo,
						WB.BatchReference,
						W.Warehouse, 
						W.WarehouseName,
						W.Address,
						W.Telephone,
						W.Mission,
						I.ItemNo, 
						I.ItemDescription, 
						I.Category,
						IU.ItemBarCode, 
						--U.Description AS UoM,
						IU.UoM AS UoM,
						T.TransactionQuantity * -1 as TransactionQuantity,
						ROUND((S.SalesAmount * S.TaxPercentage),2) + S.SalesAmount AS SalesAmountExemption,
						ROUND((S.SalesAmount * S.TaxPercentage),2) AS SalesTaxExemption,
						S.SalesCurrency,
						S.SalesPrice, 
						S.SalesAmount, 
						S.SalesTax, 
						S.SalesTotal,
						(
							SELECT TOP 1 ltrim(rtrim(isnull(R.Address,'') + ' ' + isnull(R.Address2,'') + ' ' + isnull(R.AddressCity,'')))
							FROM Materials.dbo.CustomerAddress A 
							INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
							WHERE A.CustomerId = C.CustomerId
							AND A.AddressType = 'Home'
							ORDER BY DateEffective DESC
						) as Customeraddress,
						
						ISNULL((
							SELECT SUM(S1.SalesTotal)
							FROM Materials.dbo.ItemTransactionDeny T1
							INNER JOIN Materials.dbo.ItemTransactionShippingDeny S1 ON S1.TransactionId = T1.TransactionId
							INNER JOIN Materials.dbo.Item I1 ON I1.ItemNo = T1.ItemNo
							WHERE T1.TransactionBatchNo = WB.BatchNo
							AND I1.Category = 'DSC'
						),0) AS TotalDiscounts,
						
						(
							SELECT TOP 1 T2.ItemDescription 
							FROM Materials.dbo.ItemTransactionDeny T2
							INNER JOIN Materials.dbo.ItemTransactionShippingDeny S2 ON S2.TransactionId = T2.TransactionId
							INNER JOIN Materials.dbo.Item I2 ON I2.ItemNo = T2.ItemNo
							WHERE T2.TransactionBatchNo = WB.BatchNo
							AND I2.Category = 'DSC'
						) AS DiscountDescription
						
						
				FROM Materials.dbo.WarehouseBatch WB
					INNER JOIN Materials.dbo.ItemTransactionDeny T ON T.TransactionBatchNo = WB.BatchNo
					INNER JOIN Materials.dbo.ItemTransactionShippingDeny S ON T.TransactionId = S.TransactionId
					INNER JOIN Materials.dbo.Customer C ON C.CustomerId = WB.CustomerId
					INNER JOIN Materials.dbo.Item I ON I.ItemNo = T.ItemNo
					INNER JOIN Materials.dbo.ItemUoM IU ON IU.ItemNo = I.ItemNo AND IU.UoM = T.TransactionUoM
					--INNER JOIN Materials.dbo.Ref_UoM U ON U.Code = T.TransactionUoM 
					LEFT OUTER JOIN Materials.dbo.Ref_UoM U ON U.Code = IU.UoMCode 
					INNER JOIN Materials.dbo.Warehouse W ON W.Warehouse = WB.Warehouse
				WHERE WB.BatchId='#batchid#' 

			</cfquery>			

			<!--- Get Mission Information --->
			<cfquery name="GetMission" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM  Organization.dbo.Ref_Mission
				WHERE Mission = '#mission#'	
			</cfquery>			
			
			<!--- Get Warehouse device information --->				
			<cfquery name="GetWarehouseDevice" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Materials.dbo.WarehouseTerminal
				WHERE  Warehouse = '#GetInvoice.Warehouse#'	
				AND    TerminalName = '#terminal#'
				AND    Operational=1
			</cfquery>	
						
			<!--- Get Warehouse and Series Information --->				
			<cfquery name="GetWarehouseSeries" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM   Organization.dbo.OrganizationTaxSeries 
				WHERE  OrgUnit = '#GetWarehouseDevice.TaxOrgUnitEDI#'
				AND    SeriesType = 'CreditNote'
				AND    Operational=1
			</cfquery>	
							
			<!--- Get Config --->
			<cfquery name="GetMissionConfig" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM Organization.dbo.Ref_MissionExchange
				WHERE Mission = '#mission#'
				AND ClassExchange = 'FACE'	
			</cfquery>	
			
			
			<cfquery name="GetOriginalInvoice" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
		
				SELECT 	DISTINCT T.SeriesNo,
						T.AuthorizationNo,
						T.AuthorizationDate,
						T.InvoiceStart,
						T.InvoiceEnd,
						A.ActionReference1,
						A.ActionReference2,
						A.ActionReference3
						
				FROM   Accounting.dbo.TransactionHeaderAction A
				INNER JOIN Accounting.dbo.TransactionHeader H ON H.Journal = A.Journal AND H.JournalSerialNo = A.JournalSerialNo
				INNER JOIN Organization.dbo.OrganizationTaxSeries T ON T.OrgUnit = H.OrgUnitTax AND T.SeriesNo = A.ActionReference4
				WHERE  H.TransactionSourceId='#batchid#'			
				AND    H.TransactionCategory='Receivables'
				AND    T.SeriesType = 'Invoice'
		
			</cfquery>				
						
			<!---- STORE THIS IN A CONFIG TABLE !! ---->
			<cfset vUser = GetMissionConfig.ExchangeUserId>
			<cfset vPwd = GetMissionConfig.ExchangePassword>
			<cfset vNitGFACE = "12521337">
			<cfset vNitEFACE = "11912472">
			<cfset DocumentType = "64">  <!--- SAT Document Type: Regular Invoice --->
						
			<cfif GetInvoice.SalesCurrency eq "QTZ">
				<cfset vExchangeRate = "1">
				<cfset vCurrency = "GTQ">			
			</cfif>
			
			<cfset vUoM = "UND">
			<!-----
			<cfif GetInvoice.UoM eq "each">
				<cfset vUoM = "UND">
			<cfelse>
				<cfset vUoM = GetInvoice.UoM>
			</cfif>   ------>
		
			<cfset vNIT = GetInvoice.NIT>
			<cfif vNIT eq "CF" OR vNIT eq "C-F">
				<cfset vNIT = "C/F">
			</cfif>
						
			<cfset vInvoiceTotalAmount = "0">
			<cfset vInvoiceTotalExempt = "0">
			<cfset vInvoiceTotalDiscount = "0">
			<cfset vInvoiceTotalTax = "0">
												
			<cfsavecontent variable="soapBody">
			<cfoutput>
			
			<?xml version="1.0" encoding="utf-16"?>
			<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
			  <soap:Body>
			    <registrarDte xmlns="http://listener.ingface.com/">
			      <dte xmlns="">
				  
			        <usuario>#vUser#</usuario>
			        <clave>#vPwd#</clave>
			        <dte>
						<fechaDocumento>#DateFormat(GetInvoice.TransactionDate,"YYYY-MM-DD")#</fechaDocumento>
					  	<tipoCambio>#vExchangeRate#</tipoCambio>
					  	<fechaResolucion>#DateFormat(GetWarehouseSeries.AuthorizationDate,"YYYY-MM-DD")#</fechaResolucion>		  
					  
			          	<codigoEstablecimiento>#GetWarehouseDevice.Reference#</codigoEstablecimiento>
			          	<codigoMoneda>#vCurrency#</codigoMoneda>
			          	<correoComprador>#GetInvoice.eMailAddress#</correoComprador>
			          	<departamentoComprador>N/A</departamentoComprador>
			          	<departamentoVendedor>N/A</departamentoVendedor>
			          	<descripcionOtroImpuesto>N/A</descripcionOtroImpuesto>
						
						<cfif GetInvoice.CustomerAddress neq "">
							<direccionComercialComprador>#GetInvoice.Customeraddress#</direccionComercialComprador>
						<cfelse>
							<direccionComercialComprador>N/A</direccionComercialComprador>
						</cfif>
					  	
			          	<direccionComercialVendedor>#GetInvoice.Address#</direccionComercialVendedor>
			          	<estadoDocumento>Activo</estadoDocumento>
			          	<idDispositivo>#GetWarehouseDevice.Terminal#</idDispositivo>
						
			          	<municipioComprador>N/A</municipioComprador>
			          	<municipioVendedor>N/A</municipioVendedor>
			          	<nitComprador>#Replace(vNIT,"-","","ALL")#</nitComprador>
			          	<nitGFACE>#vNitGFACE#</nitGFACE>
			          	<nitVendedor>#vNitEFACE#</nitVendedor>
			          	<nombreComercialComprador>#Replace(GetInvoice.CustomerName,"&","")#</nombreComercialComprador>
			          	<nombreComercialRazonSocialVendedor>#GetMission.MissionName#</nombreComercialRazonSocialVendedor>
			          	<nombreCompletoVendedor>#GetMission.MissionName#</nombreCompletoVendedor>
			          	
						<numeroDocumento>#GetInvoice.BatchNo#</numeroDocumento>
			          
					  	<numeroResolucion>#Replace(GetWarehouseSeries.AuthorizationNo,"-","","ALL")#</numeroResolucion>
			         	<observaciones>Por anulaci�n de factura electr�nica No. #GetOriginalInvoice.ActionReference3#</observaciones>
			          	<regimen2989><cfif GetInvoice.TaxExemption eq "1">true<cfelse>false</cfif></regimen2989>						
			          	<regimenISR>N/A</regimenISR>
			          	<serieAutorizada>#GetWarehouseSeries.SeriesNo#</serieAutorizada>
			          	<serieDocumento>#DocumentType#</serieDocumento>
			          	<telefonoComprador>N/A</telefonoComprador>
			          	<tipoDocumento>NCE</tipoDocumento>
						
						
						<cfloop query="GetInvoice">
					    	<detalleDte>
							<cantidad>#TransactionQuantity#</cantidad>
			            	<unidadMedida>#vUoM#</unidadMedida>
							<codigoProducto>#ItemNo#</codigoProducto>
							<cfset v_ItemDescription = ItemDescription>
									<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
									<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
									
					        <descripcionProducto>#v_ItemDescription#</descripcionProducto>
			            	<precioUnitario>#trim(numberformat(ABS(SalesPrice),"__.__"))#</precioUnitario>
			            	<montoBruto><cfif GetInvoice.TaxExemption eq "1">#numberformat(SalesAmountExemption,"__.__")#<cfelse>#trim(numberformat(ABS(SalesTotal),"__.__"))#</cfif></montoBruto>			            	
							
<!--- 							<cfif Category eq "DSC">
								<montoDescuento>#numberformat(ABS(SalesTotal),"__.__")#</montoDescuento>
								<cfset vInvoiceTotalDiscount = vInvoiceTotalDiscount + ABS(SalesTotal)>
							<cfelse>
								<montoDescuento>0</montoDescuento>
							</cfif> --->
							
							<montoDescuento>0</montoDescuento>
							
			            	<importeNetoGravado>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeNetoGravado>			
			            	<detalleImpuestosIva>#numberformat(SalesTax,"__.__")#</detalleImpuestosIva>
							
							<importeExento>0</importeExento>							
							<otrosImpuestos>0</otrosImpuestos>
							<importeOtrosImpuestos>0</importeOtrosImpuestos>							
							<importeTotalOperacion>#trim(numberformat(ABS(SalesTotal),"__.__"))#</importeTotalOperacion>
							<tipoProducto><cfif Category eq "PRD">B<cfelse>S</cfif></tipoProducto>	
							
							<cfif TaxExemption eq "1">
								<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesAmountExemption>	
								<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTaxExemption>
							<cfelse>
								<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesTotal>	
								<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTax>
							</cfif>							
			          		</detalleDte>							
						</cfloop>
												
			          
				          <importeBruto>#vInvoiceTotalAmount#</importeBruto>
				          <importeDescuento>#vInvoiceTotalDiscount#</importeDescuento>
						  <importeTotalExento>#vInvoiceTotalExempt#</importeTotalExento>
						  <importeOtrosImpuestos>0</importeOtrosImpuestos>
						  <importeNetoGravado>#vInvoiceTotalAmount#</importeNetoGravado>
						  <detalleImpuestosIva>#vInvoiceTotalTax#</detalleImpuestosIva>
				          <montoTotalOperacion>#vInvoiceTotalAmount#</montoTotalOperacion>
			        </dte>
			      </dte>
			    </registrarDte>
			  </soap:Body>
			</soap:Envelope>
			</cfoutput>
			</cfsavecontent>

			<cfquery name		="getEDIConfig"
					datasource	="#datasource#" 
					username  	="#SESSION.login#" 
					password  	="#SESSION.dbpw#">
					SELECT 		*
					FROM 		System.dbo.Parameter
			</cfquery>

			<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
			<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\NC">

			<cfif not directoryExists(vLogsDirectory)>
				<cfdirectory action="create" directory="#vLogsDirectory#">
			</cfif>
			
  			<cffile action="WRITE" file="#vLogsDirectory#\NC_#GetInvoice.BatchNo#.txt" output="#soapbody#">						

			<cfhttp url="https://www.ingface.net/listener/ingface" method="post" result="httpResponse" timeout="300">
				<cfhttpparam type="header" name="SOAPAction" value=""/>
				<cfhttpparam type="header" name="accept-encoding" value="no-compression"/>	
				<cfhttpparam type="xml" value="#trim(soapBody)#" />
			</cfhttp>			
			
 			<cffile action="WRITE" file="#vLogsDirectory#\NC_#GetInvoice.BatchNo#_Response.txt" output="#httpResponse.fileContent#">
			
			<cfset EFACEResponse = structnew()>

			<cfif httpResponse.statusCode eq "200 OK">				
				<cfset xmlDoc = xmlParse(httpResponse.fileContent, false)>
				
				<cfset vvalid = xmlSearch(xmlDoc,"//*[local-name()='valido']")>
				<cfset cae = xmlSearch(xmlDoc,"//*[local-name()='cae']")>
				<cfset docNo = xmlSearch(xmlDoc,"//*[local-name()='numeroDocumento']")>
				<cfset dte = xmlSearch(xmlDoc,"//*[local-name()='numeroDte']")>				
				
				<cfif vvalid[1].XmlText eq "true">
					
						<!---- Valid Invoice Number generated by the GFACE. update Invoice number information --->										
						<cfset EFACEResponse.Status = "OK">
						<cfset EFACEResponse.Cae = cae[1].XmlText>
						<cfset EFACEResponse.DocumentNo = docNo[1].XmlText>
						<cfset EFACEResponse.Dte = dte[1].XmlText>
						<cfset EFACEResponse.ErrorDescription = "">
						
						<!--- Create new action for the original invoice describing the credit note --->
						
						<cf_assignId>		
						
						<cfquery name="get"
						 datasource="#datasource#" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT  *
							FROM    Accounting.dbo.TransactionHeader
							WHERE   TransactionSourceId = '#batchid#'
							AND     TransactionCategory = 'Receivables'				
						</cfquery> 							
			
						<cfquery name="AddAction"
			               datasource="#datasource#"
			               username="#SESSION.login#"
			               password="#SESSION.dbpw#">
			                  INSERT INTO Accounting.dbo.TransactionHeaderAction							  

			                         (ActionId,
								      Journal,
			                          JournalSerialNo,
			                          ActionCode,     
								      ActionMode,  
									  <!--- more information --->	
									  ActionReference1,
									  ActionReference2,
									  ActionReference3,						                       								
								      ActionReference4,
									  ActionMemo,  							   						  
			                          ActionDate,
					  			      ActionStatus,                                
			                          OfficerUserId,
			                          OfficerLastName,
			                          OfficerFirstName)
									  
			                  VALUES ('#rowguid#',
									  '#get.Journal#',
			            		      '#get.JournalSerialNo#',
			                          'CreditNote',		
									  '2',						
									  <!--- more information --->	                       
									  '#EFACEResponse.Cae#',
									  '#EFACEResponse.DocumentNo#',
									  '#EFACEResponse.Dte#',
									  '#GetWarehouseSeries.SeriesNo#',
									  '#left(EFACEResponse.ErrorDescription,100)#', 
					                  getDate(),                                 
			        		          '1',     <!--- mode process completed --->
			                	      '#SESSION.acc#',
			                          '#SESSION.last#',
					                  '#SESSION.first#')  									                 
			            </cfquery>  											
						
				<cfelse>
				
					<!---- Validation Error from the GFACE --->
			
					<cfset vErrorDesc = xmlSearch(xmlDoc,"//*[local-name()='descripcion']")>					
					
					<cfset EFACEResponse.Status = "false">
					<cfset EFACEResponse.Cae = "">
					<cfset EFACEResponse.DocumentNo = "">
					<cfset EFACEResponse.Dte = "">
					<cfset EFACEResponse.ErrorDescription = vErrorDesc[1].XmlText>					
				
				</cfif>
				
			<cfelse>
			
				<cfset EFACEResponse.Status = httpResponse.statusCode>
				<cfset EFACEResponse.Cae = "">
				<cfset EFACEResponse.DocumentNo = "">
				<cfset EFACEResponse.Dte = "">
				<cfset EFACEResponse.ErrorDescription =  httpResponse.statusCode>
			</cfif>		
			
			<cfreturn EFACEResponse>
			 
	</cffunction>		    

	
</cfcomponent>	