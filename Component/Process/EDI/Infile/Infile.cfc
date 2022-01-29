<cfcomponent>

	<cfproperty name="name" type="string">

	<cfset this.name = "Guatemala QTZ Infile EDI provider">

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

			<cfquery name="GetUser"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization.dbo.OrganizationTaxSeries
				WHERE  SeriesType  = 'Invoice'
				AND    Operational = 1
			</cfquery>


			<cfset stToSign =
			{   "emisor_codigo": "#GetUser.UserName#",
				"emisor_clave": "#GetUser.UserKey#",
				"nit_consulta": "#NIT#"}>

			<cfhttp url="https://consultareceptores.feel.com.gt/rest/action" method="post" result="httpResponse" timeout="60">
				<cfhttpparam type="header" name="Content-Type" value="application/json"/>
				<cfhttpparam type="body" value="#Replace(serializeJSON(stToSign),"//","")#">
			</cfhttp>

			<cfset jSonNIT = deserializeJSON(httpResponse.fileContent)>

			<cfif jsonNIT.nombre neq "">
				<cfset Customer.Name = jsonNIT.nombre>
			</cfif>


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
				
	
	<cffunction name="SaleIssueV3"
			access="public"
			returntype="any"
			displayname="GetFACE">
			<!--- This method is used for issuing and also displaying an existing one --->

			<cfargument name="Datasource"         type="string"  required="true"   default="appsOrganization">
			
			<!---
			<cfargument name="Mission"            type="string"  required="true"   default="">
			--->
			
			<cfargument name="Journal"            type="string"  required="true"   default="">
			<cfargument name="JournalSerialNo"    type="string"  required="true"   default="">
			
			<cfargument name="TransactionSource"  type="string"  required="true"   default="SalesSeries"> <!--- salesseries | workorderseries | accountseries --->
									
			<cfargument name="Customer"           type="string"  required="true"   default="">
			
			<cfargument name="Warehouse"          type="string"  required="true"   default="">	
			<cfargument name="Terminal"           type="string"  required="true"   default="1">
					
			<cfargument name="RetryNo"            type="string"  required="false"  default="0">
			<cfargument name="catDesc"		      type="string"  required="false"  default="DSC">
			<cfargument name="catProd"		      type="string"  required="false"  default="PRD">
			<cfargument name="AddrType"		      type="string"  required="false"  default="Home">
			
			<!--- Infile = GT = 12% --->
			<cfset FEL.TaxPercentage = 0.12000>
		
			<cfquery name="GetTransaction"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.TransactionHeader
					WHERE  Journal         = '#journal#'
					AND    JournalSerialNo = '#JournalSerialNo#'
			</cfquery>
			
			<!--- we obtain added comments about this transaction --->
			
			<cfquery name="GetTransactionContent"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.TransactionHeaderTopic
					WHERE  Journal         = '#journal#'
					AND    JournalSerialNo = '#JournalSerialNo#'
					AND    Topic = 'Billing'
			</cfquery>
									
			<cfif GetTransaction.OrgUnitTax eq "0">
			
			    <!--- we look into the journal --->
			
				<cfquery name="getJournal"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Accounting.dbo.Journal
						WHERE  Journal = '#getTransaction.journal#'					
				</cfquery>
				
				<cfset FEL.OrgUnitTax = getJournal.OrgUnitTax>		
				
			<cfelse>
						
				<cfset FEL.OrgUnitTax = getTransaction.OrgUnitTax>	
			
			</cfif>
					
			<cfset FEL.JournalTransactionNo = "#getTransaction.JournalTransactionNo#">
			
			<!--- get entity Information --->
			<cfquery name="GetMission"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization.dbo.Ref_Mission
				WHERE  Mission = '#getTransaction.Mission#'
		    </cfquery>
			
			<cfquery name="GetTaxSeries"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT T.*, O.OrgUnitName
				FROM   Organization.dbo.OrganizationTaxSeries T
						INNER JOIN Organization.dbo.Organization O ON T.OrgUnit = O.OrgUnit
				WHERE  T.OrgUnit = '#FEL.OrgUnitTax#'
				AND    T.SeriesType  = 'Invoice'
				AND    T.Operational = 1			
		    </cfquery>
			
			<cfquery name="GetMissionConfig"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization.dbo.Ref_MissionExchange
				WHERE  Mission = '#mission#'
			    AND    ClassExchange = 'FACE'
			</cfquery>
			
			<cfset vUser     =   GetMissionConfig.ExchangeUserId>
			<cfset vPwd      =   GetMissionConfig.ExchangePassword>
			
			<!--- needed for what ? --->
			
			<cfset vUniqueId = GetTransaction.JournalTransactionNo>
			
			<cfquery name="GetPrevious"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT   A.*
					FROM     Accounting.dbo.TransactionHeaderAction A
					WHERE    Journal          = '#journal#'
					AND      JournalSerialNo  = '#JournalSerialNo#'				
					AND      ActionCode       IN ('Invoice','Creditnote')
					AND      ActionMode       = '2'		
					AND      ActionStatus IN ('1','5')									
					ORDER BY Created DESC								
			</cfquery>
			
			<cfset eMailTo = "">
					
			<cfif GetPrevious.ActionStatus eq 5>
				<!--- It is a re-attempt to post the SAME sales order which was cancelled
				      when the underline FEL has been already voided -  credit note so we need to pass a different id --->
				<cfset vUniqueId = "#GetTransaction.JournalTransactionNo#-#LEFT(GetPrevious.ActionId,5)#">
			
			<cfelseif actionId neq "">
			
				<cfquery name="GetAction"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Accounting.dbo.TransactionHeaderAction
						WHERE    ActionId         = '#actionid#'							
				</cfquery>
				
				<cfif getAction.ActionSource1 eq ""> 
				    <cfset vUniqueId = GetTransaction.JournalTransactionNo>			
				<cfelse>
				    <!--- we make sure we take the action which opened --->
					<cfset vUniqueId = getAction.ActionSource1>	
				</cfif>	
				
				<cfset eMailTo = GetAction.eMailAddress>
			
			<cfelse>
			
			    <cfset vUniqueId = GetTransaction.JournalTransactionNo>							
				
			</cfif>
			
			<!---
			<cfoutput>#vUniqueid#</cfoutput>
			--->
						
			<!--- ------------------------- --->
			<!--- 1 of 4 Vendor information --->
			<!--- ------------------------- --->
			
			<!--- to add header --->
			
			<cfset FEL.InvoiceType     =  GetTaxSeries.DocumentType>
			<cfset FEL.Phrase1 		   =  GetTaxSeries.Phrase1>
			<cfset FEL.Phrase2 		   =  GetTaxSeries.Phrase2>

			<cfif getTransaction.TransactionDate lte getTransaction.ActionBefore>
			    <cfset FEL.ActionBefore = "#DateFormat(DateAdd('d',30,GetTransaction.TransactionDate),'YYYY-MM-DD')#">
			<cfelse>
			    <cfset FEL.ActionBefore = "#DateFormat(GetTransaction.ActionBefore,'YYYY-MM-DD')#">
			</cfif>
			
			<!--- to be changed to make it taking from the transaction --->
			
			<cfset FEL.Currency        = "#GetTransaction.Currency#">	
			
			<!--- ccorrection for a wrong GT currency --->
			<cfif FEL.Currency eq "QTZ">
				<cfset FEL.Currency = "GTQ">
			</cfif>
			
			<cfset FEL.ExchangeRate    = "1">		
			<cfset FEL.vUoM            = "UND">
						
			<cfset FEL.VendorReference = "#GetTaxSeries.Reference#">  <!--- GetWarehouseDevice.Reference --->
			<cfset FEL.VendorMail      = "#GetTaxSeries.UserEMail#">  <!--- GetWarehouseDevice.UserMail --->
			<cfset FEL.VendorNIT       = "#GetTaxSeries.EFACEId#">	   <!--- #vNitEFACE# ---> 					
			<cfset FEL.VendorName      = "#GetTaxSeries.OrgUnitName#"> <!--- commercial name ---> 
			
			<cfquery name="param"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.Ref_ParameterMission
					WHERE  Mission = '#getTransaction.Mission#'
			</cfquery>			
						
			<cfif param.AdministrationLevel eq "Parent">
			
				<cfquery name="GetParent"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization.dbo.Organization
					WHERE  OrgUnit = '#getTransaction.OrgUnitOwner#'
			    </cfquery>			
			
			     <cfset FEL.VendorEntity    = "#getParent.OrgUnitName#">   <!--- formal name --->	
				 
			<cfelse>
			
			     <cfset FEL.VendorEntity    = "#getMission.MissionName#">   <!--- formal name --->												
				 
			</cfif>
			
			<cfquery name="GetVendorAddress"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT     OA.AddressType, OA.TelephoneNo, OA.MobileNo, R.Address,R.AddressCity, R.AddressPostalCode,
				           R.State, R.Country, R.eMailAddress, O.Source, O.SourceCode
				FROM       Organization.dbo.OrganizationAddress AS OA 
				           INNER JOIN System.dbo.Ref_Address AS R ON OA.AddressId = R.AddressId 
						   INNER JOIN Organization.dbo.Organization AS O ON OA.OrgUnit = O.OrgUnit
				WHERE      <cfif getTransaction.OrgUnitSource eq ""> 1=0 <cfelse> OA.OrgUnit     = '#getTransaction.OrgUnitSource#' </cfif>
				AND        OA.AddressType = 'Invoice' 
				AND        OA.Operational = 1
            </cfquery>
			
			<cfif getVendorAddress.recordcount gte "1">
			
				<cfset FEL.VendoreMail      = "#GetVendorAddress.eMailAddress#">  
				<cfset FEL.VendorAddress    = "#GetVendorAddress.Address#">
				<cfset FEL.VendorPostalCode = "#GetVendorAddress.AddressPostalCode#">	
				<cfset FEL.VendorCity       = "#GetVendorAddress.AddressCity#">
				<cfset FEL.VendorState      = "#GetVendorAddress.State#">
				
				<cfif GetVendorAddress.Country eq "GUA">
				      <cfset FEL.VendorCountry    = "GT">
				<cfelseif GetVendorAddress.Country neq "">
				      <cfset FEL.VendorCountry    = "#GetVendorAddress.Country#">
				<cfelse>
				      <cfset FEL.VendorCountry    = "GT">
				</cfif>  
											
			<cfelse>
			
				<!--- fall back --->
				<cfset FEL.VendoreMail      = "#GetVendorAddress.eMailAddress#"> 
				<cfset FEL.VendorAddress    = "CIUDAD">
				<cfset FEL.VendorPostalCode = "01001">	
				<cfset FEL.VendorCity       = "GUATEMALA">
				<cfset FEL.VendorState      = "GUATEMALA">
				<cfset FEL.VendorCountry    = "GT">
				
			</cfif>
						
			<!--- --------------------------- --->
			<!--- 2 of 4 Customer information --->		
			<!--- --------------------------- --->
			
			<!--- context specific correction information --->
															
			<cfswitch expression="#getTransaction.TransactionSource#">
			
				<cfcase value="SalesSeries">
				
					<!--- old mode of POS driven --->
				
					<cfquery name="GetBatch"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Materials.dbo.WarehouseBatch
							WHERE    BatchId = '#getTransaction.TransactionSourceId#'						
					</cfquery>
					
					<cfquery name="GetWarehouse"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Materials.dbo.Warehouse
							WHERE    Warehouse = '#GetBatch.Warehouse#'						
					</cfquery>
					
					<!--- fall back --->
					
					<cfif FEL.VendorAddress eq "CIUDAD">
					
						<cfset FEL.VendoreMail      = "#GetWarehouse.Contact#"> 
						<cfset FEL.VendorAddress    = "#GetWarehouse.Address#">
						<cfset FEL.VendorPostalCode = "01001">	
						<cfset FEL.VendorCity       = "GUATEMALA">
						<cfset FEL.VendorState      = "GUATEMALA">
						<cfset FEL.VendorCountry    = "#GetWarehouse.Country#">
					
					</cfif>
					
					<cfquery name="Customer"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Materials.dbo.Customer
							<cfif getBatch.CustomerIdInvoice neq "">
							WHERE   CustomerId        = '#getBatch.CustomerIdInvoice#'						
							<cfelse>
							WHERE   CustomerId        = '#getBatch.CustomerId#'	
							</cfif>
					</cfquery>
					
					<cfquery name="Address"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT     R.Address, R.AddressCity, R.AddressPostalCode, R.State, R.Country, R.eMailAddress
						FROM       Materials.dbo.CustomerAddress AS OA INNER JOIN
                                   System.dbo.Ref_Address AS R ON OA.AddressId = R.AddressId
						WHERE      OA.CustomerId = '#GetBatch.CustomerId#' 
						ORDER BY   OA.Created DESC
					</cfquery>	
										
					<!--- Get Warehouse information --->
					<cfquery name="GetWarehouse"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT  *
							FROM    Materials.dbo.Warehouse
							WHERE   Warehouse = '#GetBatch.Warehouse#'
					</cfquery>					
										
					<!--- Get Warehouse and Series Information --->
					<cfquery name="GetSeries"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT  T.*, O.OrgUnitName
							FROM    Organization.dbo.OrganizationTaxSeries T
								    INNER JOIN Organization.dbo.Organization O ON T.OrgUnit = O.OrgUnit
							WHERE   T.OrgUnit     = '#FEL.OrgUnitTax#'
							AND     T.SeriesType  = 'Invoice'
							AND     T.Operational = 1
					</cfquery>													

					<cfset FEL.CustomerName       = "#Replace(Customer.CustomerName,"&","")#">  <!--- #Replace(GetInvoice.CustomerName,"&","")# --->
					
					<cfset vNIT = Customer.Reference>
					<cfset vNit = Replace(vNIT," ","","ALL")>
					<cfif vNIT eq "C/F" OR vNIT eq "C-F" or vNIT eq "">
						<cfset vNIT = "CF">
					</cfif>		
					<cfset vNit = Replace(vNIT,"-","","ALL")>
					
					<cfset FEL.CustomerNIT        = "#vNit#">  <!--- #vNormalizedNIT# --->
					
					<cfset FEL.CustomereMail      = "#Customer.eMailAddress#">
					<cfset FEL.CustomerAddress    = "#Address.Address#">
					<cfset FEL.CustomerPostalCode = "#Address.AddressPostalCode#">
					<cfset FEL.CustomerCity       = "#Address.AddressCity#">
					<cfset FEL.CustomerState      = "#Address.State#">
					
					<cfif Address.Country eq "GUA">
				          <cfset FEL.CustomerCountry    = "GT">
     				<cfelseif Address.Country neq "">
				          <cfset FEL.CustomerCountry    = "#Address.Country#">
				    <cfelse>
				          <cfset FEL.CustomerCountry    = "GT">
				    </cfif>  
										
				</cfcase>
			
				<cfcase value="WorkOrderSeries">
				
					<!--- get customer --->
					
					<cfif getTransaction.TransactionSourceNo eq "Medical">
										    					
					    <!--- customer information is recorded differently --->
					
					    <cfset FEL.CustomerName       = "#getTransaction.ReferenceName#">
						
						<cfset vNIT = getTransaction.ReferenceNo>
						<cfset vNIT = ucase(vNit)>
						<cfset vNit = Replace(vNIT," ","","ALL")>
						<cfif vNIT eq "C/F" OR vNIT eq "C-F" or vNIT eq "">
							<cfset vNIT = "CF">
						</cfif>			
						<cfset vNit = Replace(vNIT,"-","","ALL")>
						<cfset FEL.CustomerNIT        = "#vNit#">	
						
						<cfset FEL.CustomereMail      = "#eMailTo#">		
						
						<!--- we obtain possible NIT information --->
						
						<cfquery name="GetAddress"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT      R.Address, R.Address2, 
							            R.AddressCity, R.AddressRoom, 
										R.AddressPostalCode, R.State, R.Country, 
										R.Source, R.Remarks
	                        FROM        System.dbo.CountryTaxCode AS T INNER JOIN
	                                    System.dbo.Ref_Address AS R ON T.AddressId = R.AddressId
	                        WHERE       T.TaxCode = '#getTransaction.ReferenceNo#'							
						</cfquery>
						
						<cfif getAddress.recordcount eq "1" 
						      and getTransaction.ReferenceNo neq "C/F" 
							  and getTransaction.ReferenceNo neq "CF">
																			
							<cfset FEL.CustomerAddress    = "#GetAddress.Address# #GetAddress.Address2#">
							<cfset FEL.CustomerPostalCode = "#GetAddress.AddressPostalCode#">
							<cfif FEL.CustomerPostalCode eq "">
								<cfset FEL.CustomerPostalCode = "01001">
							</cfif>
							<cfset FEL.CustomerCity       = "#GetAddress.AddressCity#">
							<cfset FEL.CustomerState      = "#GetAddress.State#">								
							<cfset FEL.CustomerCountry    = "#GetAddress.Country#">		
							
						<cfelse>
																			
							<cfset FEL.CustomerAddress    = "">
							<cfset FEL.CustomerPostalCode = "">
							<cfset FEL.CustomerPostalCode = "">	
							<cfset FEL.CustomerCity       = "">
							<cfset FEL.CustomerState      = "">								
							<cfset FEL.CustomerCountry    = "">					
						
						</cfif>
					
					<cfelse>
											
					    <cfquery name="Customer"
							datasource="#datasource#"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     WorkOrder.dbo.Customer							
								WHERE    CustomerId        = '#getTransaction.ReferenceId#'								
						</cfquery>
						
						<cfset FEL.CustomerName       = "#Replace(Customer.CustomerName,"&","")#">
						
						<cfset vNIT = Customer.Reference>
						<cfset vNIT = ucase(vNit)>
						<cfset vNit = Replace(vNIT," ","","ALL")>
						<cfif vNIT eq "C/F" OR vNIT eq "C-F" or vNIT eq "">
							<cfset vNIT = "CF">
						</cfif>			
						<cfset vNit = Replace(vNIT,"-","","ALL")>
						
						<cfset FEL.CustomerNIT        = "#vNit#">							
						
						<cfquery name="Address"
							datasource="#datasource#"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
							SELECT   R.Address, R.AddressCity, R.AddressPostalCode, R.State, R.Country, R.eMailAddress
							FROM     Organization.dbo.OrganizationAddress AS OA INNER JOIN
	                                 System.dbo.Ref_Address AS R ON OA.AddressId = R.AddressId
							WHERE    OA.OrgUnit = '#Customer.OrgUnit#' 
							AND      OA.AddressType = 'Invoice'
							ORDER BY OA.Created DESC
						</cfquery>		
						
						<cfif Address.Recordcount gte "1">
						
							<cfset FEL.CustomereMail      = "#Address.eMailAddress#">
							<cfset FEL.CustomerAddress    = "#Address.Address#">
							<cfset FEL.CustomerPostalCode = "#Address.AddressPostalCode#">
							<cfset FEL.CustomerCity       = "#Address.AddressCity#">
							<cfset FEL.CustomerState      = "#Address.State#"> 
							
							<cfif Address.Country eq "GUA">
						          <cfset FEL.CustomerCountry    = "GT">
		     				<cfelseif Address.Country neq "">
						          <cfset FEL.CustomerCountry    = "#Address.Country#">
						    <cfelse>
						          <cfset FEL.CustomerCountry    = "GT">
						    </cfif>  
					
					    <cfelse>
						
							<cfset FEL.CustomereMail      = "#Customer.eMailAddress#">
							<cfset FEL.CustomerAddress    = "#Customer.Address#">
							<cfset FEL.CustomerPostalCode = "#Customer.PostalCode#">
							<cfset FEL.CustomerCity       = "#Customer.City#">
							<cfset FEL.CustomerState      = ""> <!--- hardcoded --->
							
							<cfif Customer.Country eq "GUA">
						          <cfset FEL.CustomerCountry    = "GT">
		     				<cfelseif Customer.Country neq "">
						          <cfset FEL.CustomerCountry    = "#Customer.Country#">
						    <cfelse>
						          <cfset FEL.CustomerCountry    = "GT">
						    </cfif>  
							
						</cfif>	
						
					</cfif>	
												
				</cfcase>
				
				<cfcase value="AccountSeries">
				
					<!--- Get Warehouse and Series Information --->
					
					  <cfquery name="OrgUnit"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Organization.dbo.Organization							
							WHERE    OrgUnit  = '#getTransaction.ReferenceOrgUnit#'								
					</cfquery>
					
					<cfset FEL.CustomerName       = "#OrgUnit.OrgUnitName#">
					
					<cfset vNIT = OrgUnit.SourceCode>
					<cfset vNIT = ucase(vNit)>
					<cfset vNit = Replace(vNIT," ","","ALL")>
					<cfif vNIT eq "C/F" OR vNIT eq "C-F" or vNIT eq "">
						<cfset vNIT = "CF">
					</cfif>
					<cfset vNit = Replace(vNIT,"-","","ALL")>
					
					<cfset FEL.CustomerNIT        = "#vNit#">
					
					<cfquery name="Address"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT   R.Address, R.AddressCity, R.AddressPostalCode, R.State, R.Country, R.eMailAddress
						FROM     OrganizationAddress AS OA INNER JOIN
                                 System.dbo.Ref_Address AS R ON OA.AddressId = R.AddressId
						WHERE    OA.OrgUnit = '#getTransaction.ReferenceOrgUnit#' 
						AND      OA.AddressType = 'Invoice'
					</cfquery>						
					
					<cfquery name="GetSeries"
						datasource="#datasource#"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
							SELECT T.*, O.OrgUnitName
							FROM   Organization.dbo.OrganizationTaxSeries T
								   INNER JOIN Organization.dbo.Organization O ON T.OrgUnit = O.OrgUnit
							WHERE  T.OrgUnit     = '#FEL.OrgUnitTax#'
							AND    T.SeriesType  = 'Invoice'
							AND    T.Operational = 1
					</cfquery>			
					
					<cfset FEL.CustomereMail      = "#Address.eMailAddress#">				
					<cfset FEL.CustomerAddress    = "#Address.Address#">
					<cfset FEL.CustomerPostalCode = "#Address.AddressPostalCode#">
					<cfset FEL.CustomerCity       = "#Address.AddressCity#">					
					<cfset FEL.CustomerState      = "#Address.State#">
					
					<cfif Address.Country eq "GUA">
				          <cfset FEL.CustomerCountry    = "GT">
     				<cfelseif Address.Country neq "">
				          <cfset FEL.CustomerCountry    = "#Address.Country#">
				    <cfelse>
				          <cfset FEL.CustomerCountry    = "GT">
				    </cfif>  
				
				</cfcase>
							
			</cfswitch>	
			
			<cfif FEL.CustomerAddress eq "" or FEL.CustomerPostalCode eq "">
						
					<cfset FEL.CustomerAddress    = "Ciudad">
					<cfset FEL.CustomerPostalCode = "01001">
					<cfset FEL.CustomerCity       = "Ciudad">
					<cfset FEL.CustomerState      = "Guatemala"> 
					<cfset FEL.CustomerCountry    = "GT">
						
			</cfif>													
			
			<!--- ------------------------- --->
			<!--- --------3 of 4 Lines----- --->		
			<!--- ------------------------- --->
			
			<!--- for Infile : Guatemala we get the income and add 12% over it --->
			
			<cfquery name="GetLines"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">	
					
					SELECT   TH.Mission, 
					         TL.OrgUnit, 
							 TH.OrgUnitTax, 
							 TH.TransactionSource, 
							 TH.ReferenceId, 
							 TH.TransactionSourceId, 
							 TL.TransactionSerialNo, 							 
							 TH.TransactionDate, 
							 TH.DocumentAmount, 
							 TL.Reference, 
                             TL.ReferenceName       AS ItemName, 
							 TL.ReferenceNo         AS ItemNo, 
														 
							 TL.TransactionTaxCode  AS TaxCode,
							 TL.ReferenceQuantity   AS SaleQuantity, 
							 'C/U'                  AS SaleUoM,
							 TL.TransactionCurrency AS TransactionCurrency,
							 TL.TransactionAmount   AS TransactionAmount, 
							 TL.Currency            AS SaleCurrency, 
							 TL.AmountCredit        AS AmountSale, 
							 							 
							 TL.TransactionTaxCode, 
							 TH.OrgUnitSource
							 
					FROM     Accounting.dbo.TransactionLine AS TL INNER JOIN
	                         Accounting.dbo.TransactionHeader AS TH ON TL.Journal = TH.Journal AND TL.JournalSerialNo = TH.JournalSerialNo
					WHERE    TL.Journal         = '#Journal#' 
					AND      TL.JournalSerialNo = '#JournalSerialNo#' 
					AND      TL.TransactionSerialNo <> 0 
					AND      TL.GLAccount IN  (SELECT   GLAccount
				                               FROM     Accounting.dbo.Ref_Account
                 					           WHERE    TaxAccount = 0) <!--- we exclude lines that reflect tax as this is about Guate tax --->
					AND      TL.AmountCredit > 0    <!--- only positive amounts to be reflected     --->
					ORDER BY TL.TransactionSerialNo <!--- sorting of the lines in order of creation --->
															
			</cfquery>	
				
			<!--- ------------------------- --->	
			<!--- --------4 of 4 Totals---- --->		
			<!--- ------------------------- --->
			
			<!--- Hanno : 23/11/2021 sum the lines no longer needed : rethink the dicount application --->
			
			<cfquery name="GetTotal" dbtype="query">
					SELECT   SUM(AmountSale) as Amount
					FROM     getLines
					
			</cfquery>		
			
			<cfset FEL.Sale   = getTotal.Amount>	
			
			<!--- Hanno special correction if the amount like IO has already tax in it --->
			<cfif getLines.TaxCode eq "00" and getTransaction.TransactionSource eq "AccountSeries">								     
				 <cfset FEL.Sale = FEL.Sale * 100/112>			      
			</cfif>	
											
			<!--- remove the discount (negative) as found in the posting line --->	
				
			<cfquery name="GetDiscount"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT   ISNULL(SUM(AmountDebit),0) as Amount
						FROM     Accounting.dbo.TransactionLine AS TL INNER JOIN
		                         Accounting.dbo.TransactionHeader AS TH ON TL.Journal = TH.Journal AND TL.JournalSerialNo = TH.JournalSerialNo
						WHERE    TL.Journal         = '#Journal#' 
						AND      TL.JournalSerialNo = '#JournalSerialNo#' 
						AND      TL.TransactionSerialNo <> 0 <!--- contra-line --->
						AND      TL.GLAccount  IN  (SELECT   GLAccount
					                                FROM     Accounting.dbo.Ref_Account
	                 					            WHERE    TaxAccount = 1) <!--- we exclude lines that reflect tax --->
						AND      TL.AmountCredit < 0    <!--- negative amounts to be reflected to be equally divided --->					
				</cfquery>		
			
			<!--- Overall total --->
			
			<cfset FEL.Discount   = GetDiscount.Amount>					
						
			<!--- to be used for the lines --->
			<cfif FEL.Discount neq "">
			   <cfset FEL.Ratio      = FEL.Discount / FEL.Sale>	
			   <cfset FEL.Taxable    = FEL.Sale - FEL.Discount>	
			<cfelse>
			   <cfset FEL.Ratio      = "0">	
			   <cfset FEL.Taxable    = FEL.Sale>	
			</cfif>
																	
			<cfset FEL.Tax        = FEL.Taxable * FEL.TaxPercentage>						
			<cfset FEL.Amount     = FEL.Taxable + FEL.Tax>	
									
			<!---						
			v_TipoItem : default B, for now overruled only if ReferenceNo = item and has the itemclass = service
			like we can add some indicator on the transactionline : transactiontype						
			--->			
						
			<!--- ------- --->
			<!--- NEW XML --->
			<!--- ------- --->	
			
			<cfquery name="GetFirst"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT   TOP 1 A.*
					FROM     Accounting.dbo.TransactionHeaderAction A
					WHERE    Journal          = '#journal#'
					AND      JournalSerialNo  = '#JournalSerialNo#'				
					AND      ActionCode       = 'Invoice'
					AND      ActionMode       = '2'		
					AND      ActionStatus     = '9'									
					ORDER BY Created 								
			</cfquery>
			
			<cfif getFirst.recordcount eq "1">								   
							
				<cfif month(getFirst.created) neq month(now())>
				
					<!--- FEL allows up to 5 days correction --->	
					<cfif datediff("d",  getFirst.created,  now()) gte 6> 	
						<cfset dts = dateAdd("d",  -5,  now())>
					<cfelse>
					    <cfset dts = dateAdd("d",  0,  getFirst.created)>					    
					</cfif>
					
				 <cfelse>
				 
				 	<cfset dts = now()>	
					
				</cfif>	
				
			<cfelse>	
			
				<cfif month(getLines.TransactionDate) neq month(now())>
				
			    	<!--- FEL allows up to 5 days correction --->	
					<cfif datediff("d",  getLines.TransactionDate,  now()) gte 6> 	
						<cfset dts = dateAdd("d",  -5,  now())>
					<cfelse>
					    <cfset dts = dateAdd("d",  0,  getLines.TransactionDate)>					    
					</cfif>
				
				<cfelse>
				 
				 	<cfset dts = now()>	
					
				</cfif>	
							
			</cfif>
			
			<!---
			<cfoutput>
			CorreoReceptor="#FEL.CustomereMail#"
			</cfoutput>
			--->
			
			<cfxml variable="XmlDTE">
			<cfoutput>
				<?xml version="1.0" encoding="utf-8"?>
				
				<dte:GTDocumento xmlns:ds="http://www.w3.org/2000/09/xmldsig##"
					xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					Version="0.1" xsi:schemaLocation="http://www.sat.gob.gt/dte/fel/0.2.0">
					
						<dte:SAT ClaseDocumento="dte">
							<dte:DTE ID="DatosCertificados">
															
							<dte:DatosEmision ID="DatosEmision">
										<dte:DatosGenerales CodigoMoneda="#FEL.Currency#" FechaHoraEmision="#DateFormat(dts,"YYYY-MM-DD")#T#TimeFormat(dts,"hh:mm:ssXXX")#" Tipo="#FEL.InvoiceType#"></dte:DatosGenerales>
										<dte:Emisor AfiliacionIVA="GEN" CodigoEstablecimiento="#FEL.VendorReference#" CorreoEmisor="#FEL.VendorMail#" NITEmisor="#FEL.VendorNIT#" NombreComercial="#FEL.VendorName#" NombreEmisor="#FEL.VendorEntity#">										
								<dte:DireccionEmisor>
								<dte:Direccion>#FEL.VendorAddress#</dte:Direccion>
									<dte:CodigoPostal>#FEL.VendorPostalCode#</dte:CodigoPostal>
									<dte:Municipio>#FEL.VendorCity#</dte:Municipio>
									<dte:Departamento>#FEL.VendorState#</dte:Departamento>
									<dte:Pais>#FEL.VendorCountry#</dte:Pais>
								</dte:DireccionEmisor>
							</dte:Emisor>
														
							<dte:Receptor CorreoReceptor="" IDReceptor="#FEL.customerNIT#" NombreReceptor="#FEL.CustomerName#">
								
									<dte:DireccionReceptor>
										<dte:Direccion>#FEL.CustomerAddress#</dte:Direccion>
										<dte:CodigoPostal>#FEL.CustomerPostalCode#</dte:CodigoPostal>
										<dte:Municipio>#FEL.CustomerCity#</dte:Municipio>
										<dte:Departamento>#FEL.CustomerState#</dte:Departamento>
										<dte:Pais>#FEL.CustomerCountry#</dte:Pais>
									</dte:DireccionReceptor>											
								
							</dte:Receptor>
								
							<dte:Frases>
									<cfif FEL.Phrase1 eq "">
										<dte:Frase CodigoEscenario="1" TipoFrase="1"></dte:Frase>
									<cfelse>
										<dte:Frase CodigoEscenario="#FEL.Phrase1#" TipoFrase="#FEL.Phrase2#"></dte:Frase>
									</cfif>
							</dte:Frases>
								
							<dte:Items>
							
								<!--- 28/6/2021 : in principle we add to the line the standard tax for Guatemala 
								        as this is posted in another line --->
															 
								<cfset total = 0>		
								<cfset totax = 0>							 
							
								<cfloop query="GetLines">
												
										<cfif salequantity eq "">
										    <cfset quantity = 1>						
										<cfelseif salequantity lt 0>
											<cfset quantity = abs(salequantity)>
										<cfelse>
											<cfset quantity = salequantity>
										</cfif>		
										
										<!--- ItemClass --->
										
										<cfquery name="Item"
											datasource="#datasource#"
											username="#SESSION.login#"
											password="#SESSION.dbpw#">
												SELECT   *
												FROM     Materials.dbo.Item
												WHERE    ItemNo = '#itemNo#'																			
										</cfquery>
										
										<cfif item.recordcount eq "0">										
											<cfset itemtype = "S">											
										<cfelseif Item.ItemClass eq "Service">										
											<cfset itemtype = "S">												
										<cfelse>										
											<cfset itemtype = "B">											
										</cfif>											
																													
										<dte:Item BienOServicio="#ItemType#" NumeroLinea="#currentrow#">
											<dte:Cantidad>#Quantity#</dte:Cantidad>
											
											<dte:UnidadMedida><cfif SaleUoM neq "">#Left(SaleUoM,3)#<cfelse>#vUoM#</cfif></dte:UnidadMedida>
											
												<cfset v_ItemDescription = ItemName>
												<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
												<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
											
											<!--- 	
											<dte:Descripcion>#ItemNo#|#v_ItemDescription#</dte:Descripcion>		
											--->
											<dte:Descripcion>#v_ItemDescription#</dte:Descripcion>		
											
											<cfif TransactionAmount eq AmountSale>	
											
												<!--- prior mode in which 
												will disappear as we store differently : just precaution --->
												
												<cfset discount   = "0">
																																		
											    <!--- calculate price with tax --->
											    <cfset vSalesPrice = AmountSale*(1+FEL.TaxPercentage)/Quantity>											    
												<cfset vSalesPrice = round(vSalesPrice*100000)/100000>	
											
											<cfelseif TransactionAmount gt AmountSale>
											
											    <!--- we store now here the billable amount --->
											
											    <cfset discount   = FEL.Ratio * TransactionAmount>
												<cfset vSalesPrice = TransactionAmount/Quantity>
											
											<cfelse>
											
												<!--- special correction to lower the amount as tax will be added later, this
												was for IO posting --->
												
												<cfif getLines.TaxCode eq "00"  and getTransaction.TransactionSource eq "AccountSeries">
												    <cfset amt = AmountSale * 100/112>										   
												<cfelse>
												 	<cfset amt = AmountSale>	   
												</cfif>		
												
												<!--- calculate ratio --->											
												<cfset amt        = round(amt*10000)/10000>		
												<cfset discount   = FEL.Ratio * amt>
												<!--- Rethink for workorder with discount recorded : Hanno --->																							
												<!--- calculate price with default tax included  --->
												<cfset vSalesPrice = (amt - discount) * (1+FEL.TaxPercentage) /Quantity>
																																		
											</cfif>	
											
											<cfset vSalesPrice = round(vSalesPrice*10000)/10000>
											
											<!--- billable amount --->																						
											<cfset amount   = vSalesPrice * Quantity>
											<cfset amount   = round(amount*100)/100>		
											<cfset tax      = amount * (FEL.TaxPercentage / (1+FEL.TaxPercentage))>
											<cfset taxable  = amount - tax>		
																							
											<dte:PrecioUnitario><cfif SaleQuantity neq 0>#trim(numberformat(ABS(vSalesPrice),"__._______"))#<cfelse>0</cfif></dte:PrecioUnitario>
											<dte:Precio>#trim(numberformat(amount,"__._______"))#</dte:Precio>				
											
											<!--- Rethink for workorder with discount recorded : Hanno --->
																																
											<dte:Descuento>#trim(numberformat(discount,"__._______"))#</dte:Descuento>
																						
											<!--- we are not reading the tax line in the sale but we assume it by default
												to prevent issues  --->											
																																
											<dte:Impuestos>
												<dte:Impuesto>
													<dte:NombreCorto>IVA</dte:NombreCorto>
													<dte:CodigoUnidadGravable>1</dte:CodigoUnidadGravable>
												<dte:MontoGravable>#trim(numberformat(Taxable,"__.____"))#</dte:MontoGravable>
												<dte:MontoImpuesto>#trim(numberformat(Tax,"__.____"))#</dte:MontoImpuesto>
												</dte:Impuesto>
											</dte:Impuestos>
																																												
											<dte:Total>#trim(numberformat(Amount,"__.____"))#</dte:Total>
																						
										</dte:Item>	
																																				
										<cfset total = total + amount>		
										<cfset totax = totax + round(tax*10000)/10000>	
																																															
								</cfloop>		
																																
							</dte:Items>
							
							<cfset total = ceiling(total*100)/100>
							<cfset totax = ceiling(totax*100)/100>
																													
							<dte:Totales>
								<dte:TotalImpuestos>
										<dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="#trim(numberformat(totax,"__.____"))#"></dte:TotalImpuesto>
								</dte:TotalImpuestos>
								<dte:GranTotal>#trim(numberformat(total,"__.____"))#</dte:GranTotal>
							</dte:Totales>																		
								
							<cfif FEL.InvoiceType eq "FCAM">
								<dte:Complementos>
									<dte:Complemento IDComplemento="Cambiaria" NombreComplemento="Cambiaria" URIComplemento="http://www.sat.gob.gt/fel/cambiaria.xsd">
										<cfc:AbonosFacturaCambiaria xmlns:cfc="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0" Version="1" xsi:schemaLocation="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0 C:\Users\Desktop\SAT_FEL_FINAL_V1\Esquemas\GT_Complemento_Cambiaria-0.1.0.xsd">
											<cfc:Abono>
												<cfc:NumeroAbono>1</cfc:NumeroAbono>
												<cfc:FechaVencimiento>#FEL.ActionBefore#</cfc:FechaVencimiento>
												<cfc:MontoAbono>#trim(numberformat(FEL.Amount,"__._______"))#</cfc:MontoAbono>
											</cfc:Abono>
										</cfc:AbonosFacturaCambiaria>
									</dte:Complemento>
								</dte:Complementos>
							</cfif>
								
							</dte:DatosEmision>
						
						</dte:DTE>
						
						<cfif GetTransactionContent.recordcount eq "1">
							<dte:Adenda>
								<Codigo_cliente></Codigo_cliente>
								<Observaciones>#GetTransactionContent.TopicValue#</Observaciones>
							</dte:Adenda>
						</cfif>

					</dte:SAT>
				
				</dte:GTDocumento>
				
			</cfoutput>
		</cfxml>
							
		<cfset StringDTE = toString(XmlDTE)>
		
		<cfquery name	= "getEDIConfig"
			datasource	= "#datasource#"
			username  	= "#SESSION.login#"
			password  	= "#SESSION.dbpw#">
			SELECT 		*
			FROM 		System.dbo.Parameter
		</cfquery>

		<cfset vEDIDirectory  = getEDIConfig.EDIDirectory>
		<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\Infile">

		
		<cfif not directoryExists(vLogsDirectory)>
			<cfdirectory action="create" directory="#vLogsDirectory#">
		</cfif>
				
		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_#RetryNo#.txt" output="#StringDTE#">
					
		<cfset Base64DTE = ToBase64(StringDTE) />

		<cfset stToSign =
		{ "llave": "#GetTaxSeries.PrivateKey#",
			"archivo": "#Base64DTE#",
			"codigo": "#vUniqueId#",
			"alias": "#GetTaxSeries.Alias#",
			"es_anulacion": "N"
		}>
		
		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_To_Sign_#RetryNo#.txt" output="#serializeJSON(stToSign)#">
		
		<cfhttp url="https://signer-emisores.feel.com.gt/sign_solicitud_firmas/firma_xml" method="post" result="httpResponse" timeout="60">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body"   value="#Replace(serializeJSON(stToSign),"//","")#">
		</cfhttp>

		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_Response_Signature_#RetryNo#.txt" output="#httpResponse.fileContent#">
		
		<cftry>
			<cfset jSonDTE = deserializeJSON(httpResponse.fileContent)>
			<cfset vError = 0>
			<cfcatch>
				<cfset vError = 1>
			</cfcatch>
		</cftry>
		
		<cfset EFACEResponse.log = 1>
		
		<cfif vError eq 0>
		
			<cfif jsonDTE.resultado neq "NO">
										
				<cfset revBase64DTE =  ToString(ToBinary(jSONDTE.archivo)) />				
				
				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_Response_Signature_decoded_#RetryNo#.txt" output="#revBase64DTE#">
				<cfsavecontent variable="SignedXml"><?xml version="1.0" encoding="utf-8"?><cfoutput>#revBase64DTE#</cfoutput></cfsavecontent>

				<cfset Base64SignedXML = ToBase64(toString(SignedXml)) />

				<cfset stToCertify =
				{ "nit_emisor":"#FEL.VendorNIT#",
					"correo_copia":"#GetTaxSeries.UserEmail#",
					"xml_dte":"#Base64SignedXml#"
				}>

				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_To_Certify_#RetryNo#.txt" output="#serializeJSON(stToCertify)#">
				
				<cfhttp url="https://certificador.feel.com.gt/fel/certificacion/v2/dte/" method="post" result="httpResponse" timeout="60">
					<cfhttpparam type="header"  name="usuario"       value = "#GetTaxSeries.UserName#" />
					<cfhttpparam type="header"  name="llave"         value = "#GetTaxSeries.UserKey#" />
					<cfhttpparam type="header"  name="identificador" value = "#vUniqueId#" />
					<cfhttpparam type="header"  name="Content-Type"  value = "application/json" />
					<cfhttpparam type="body" value="#Replace(serializeJSON(stToCertify),"//","")#">
				</cfhttp>

				<cftry>
					<cfset jSonCertification = deserializeJSON(httpResponse.fileContent)>
					<cfset vError = 0>
					<cfcatch>
						<cfset vError = 1>
					</cfcatch>
				</cftry>

				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#vUniqueId#_Response_Certifier_#RetryNo#.txt" output="#httpResponse.fileContent#">
				
				<cfset EFACEResponse.ActionDate = dts>

				<cfif findNoCase("Connection Failure",httpResponse.fileContent)>
				
					<cfset vError                         = 1>
					<cfset EFACEResponse.Status           = "false">
					<cfset EFACEResponse.Cae              = "">
					<cfset EFACEResponse.DocumentNo       = "">
					<cfset EFACEResponse.Dte              = "">
					<cfset EFACEResponse.ErrorDescription = "Connection Failure">
					<cfset EFACEResponse.ErrorDetail      = "Connection Failure">

				</cfif>				

				<cfif vError eq 0>

					<Cfif jSonCertification.resultado neq "NO">
					
						<cfset EFACEResponse.Status          = "OK">
						<cfset EFACEResponse.Cae             = jSonCertification.uuid>
						<cfset EFACEResponse.Series          = jSonCertification.serie>
						<cfset EFACEResponse.DocumentNo      = jSonCertification.numero>
						<cfset EFACEResponse.Dte             = jSonCertification.fecha>
						<cfset EFACEResponse.ErrorDescription = "">
						<cfset EFACEResponse.ErrorDetail      = "">
						
					<cfelse>

						<cfset e = jSonCertification>
						<!---
						.categoria
						.fuente
						.mensaje_error
						.numeral
						--->
						<cfset vError = "">
						<cfset vCategory = "">
						<cfloop from="1" to="#ArrayLen(e.descripcion_errores)#" index="i">
							<cfif vError eq "">
								<cfset vError    = e.descripcion_errores[i].mensaje_error>
								<cfset vCategory = e.descripcion_errores[i].categoria>
							<cfelse>
								<cfset vError = "#vError#, #e.descripcion_errores[i].mensaje_error#">
							</cfif>
						</cfloop>

						<cfset EFACEResponse.Status            = "false">
						<cfset EFACEResponse.Cae               = "">
						<cfset EFACEResponse.DocumentNo        = "">
						<cfset EFACEResponse.Dte               = "">
						<cfset EFACEResponse.ErrorDescription  = "#vCategory#">
						<cfset EFACEResponse.ErrorDetail       = "#vError#">

					</cfif>
					
				<cfelse>
				
					<cfset EFACEResponse.Status                = "false">
					<cfset EFACEResponse.Cae                   = "">
					<cfset EFACEResponse.DocumentNo            = "">
					<cfset EFACEResponse.Dte                   = "">
					<cfset EFACEResponse.ErrorDescription      = "Error en conexion 101">
					<cfset EFACEResponse.ErrorDetail           = "">
					
				</cfif>

			<cfelse>
			
				<cfset EFACEResponse.Status                    = "false">
				<cfset EFACEResponse.Cae                       = "">
				<cfset EFACEResponse.DocumentNo                = "">
				<cfset EFACEResponse.Dte                       = "">
				<cfset EFACEResponse.ErrorDescription          = "Error en conexion 102">
				<cfset EFACEResponse.ErrorDetail               = "">
				
			</cfif>

		<cfelse>
		
			<cfset EFACEResponse.Status                        = "false">
			<cfset EFACEResponse.Cae                           = "">
			<cfset EFACEResponse.DocumentNo                    = "">
			<cfset EFACEResponse.Dte                           = "">
			<cfset EFACEResponse.ErrorDescription              = "Error en conexion 103">
			<cfset EFACEResponse.ErrorDetail                   = "">
			
		</cfif>
		
		<cfset EFACEResponse.ActionDate = dts>
		<cfset EFACEResponse.Source1    = "#vUniqueId#">
		<cfset EFACEResponse.Source2    = "#FEL.customerNIT#">
		
		<cfif EFACEResponse.Status eq "OK">
			 <cfset EFACEResponse.Status = "1">			
		<cfelse>
			 <cfset EFACEResponse.Status = "9">			 
		</cfif>
				
		<cfreturn EFACEResponse>							

	</cffunction>
		
	<!--- to be replaced --->
		
	<cffunction name="SaleIssueV2"
			access="public"
			returntype="any"
			displayname="GetFACE">

		<cfargument name="Datasource"    type="string"  required="true"   default="appsOrganization">
		<cfargument name="Mission"       type="string"  required="true"   default="">
		<cfargument name="Terminal"      type="string"  required="true"   default="1">
		<cfargument name="BatchId"       type="string"  required="true"   default="">
		<cfargument name="RetryNo"       type="string"  required="false"  default="0">
		<cfargument name="catDesc"		 type="string"  required="false"  default="DSC">
		<cfargument name="catProd"		 type="string"  required="false"  default="PRD">
		<cfargument name="AddrType"		 type="string"  required="false"  default="Home">

		<cfset vCatDesc						= CatDesc>
		<cfset vCatProd						= CatProd>
		<cfset vAddrType					= AddrType>
		
		<cfquery name="GetBatch"
			datasource="AppsMaterials"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   WarehouseBatch
				WHERE  BatchId = '#batchid#'
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
			C.PostalCode,
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
			IU.UoMDescription,
			IU.UoM AS UoM,
			T.TransactionQuantity * -1 as TransactionQuantity,
			ROUND((S.SalesAmount * S.TaxPercentage),7) + S.SalesAmount AS SalesAmountExemption,
			ROUND((S.SalesAmount * S.TaxPercentage),7) AS SalesTaxExemption,
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
			SELECT TOP 1 ltrim(rtrim(isnull(R.Address,'')))
			FROM Materials.dbo.CustomerAddress A
			INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
			WHERE A.CustomerId = C.CustomerId
			ORDER BY DateEffective DESC
			) Customeraddress,
			(
			SELECT TOP 1 isnull(R.AddressCity,'GT')
			FROM Materials.dbo.CustomerAddress A
			INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
			WHERE A.CustomerId = C.CustomerId
			ORDER BY DateEffective DESC
			) CustomeraddressCity,
			(
			SELECT TOP 1 isnull(R.State,'GT')
			FROM Materials.dbo.CustomerAddress A
			INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
			WHERE A.CustomerId = C.CustomerId
			ORDER BY DateEffective DESC
			) CustomerAddressState,
			(
			SELECT TOP 1 isnull(R.AddressPostalCode,'')
			FROM Materials.dbo.CustomerAddress A
			INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
			WHERE A.CustomerId = C.CustomerId
			ORDER BY DateEffective DESC
			) CustomerAddressPostalCode,
			(
			SELECT TOP 1 isnull(R.Country,'GT')
			FROM Materials.dbo.CustomerAddress A
			INNER JOIN System.dbo.Ref_Address R ON R.AddressId = A.AddressId
			WHERE A.CustomerId = C.CustomerId
			ORDER BY DateEffective DESC
			) CustomeraddressCountry,
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
		) DiscountDescription,
		IM.isServiceItem


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
			INNER JOIN Purchase.dbo.ItemMaster IM ON IM.Code = I.ItemMaster
			WHERE WB.BatchId='#batchid#'
		AND T.TransactionQuantity != 0
		ORDER BY S.SalesTotal DESC

		</cfquery>


        <!--- Get Mission Information --->
		<cfquery name="GetMission"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization.dbo.Ref_Mission
				WHERE  Mission = '#mission#'
		</cfquery>

		<cfquery name="GetPrevious"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT   A.*
				FROM     Accounting.dbo.TransactionHeader H
						 INNER JOIN Accounting.dbo.TransactionHeaderAction A ON H.Journal = A.Journal AND H.JournalSerialNo=A.JournalSerialNo
				WHERE  	 TransactionSourceId = '#batchId#'
				AND      A.ActionCode      = 'Invoice'
				AND      A.ActionReference1 IS NOT NULL
				AND      A.ActionReference2 IS NOT NULL
				AND      A.ActionReference3 IS NOT NULL
				ORDER BY A.Created DESC
		</cfquery>

		<cfset vUniqueId = GetBatch.BatchNo>
		<cfif GetPrevious.ActionStatus eq 9>
			<!--- It is a re-attempt --->
			<cfset vUniqueId = "#GetBatch.BatchNo#-#LEFT(GetPrevious.ActionId,5)#">
		</cfif>
		

		<!--- Get Warehouse information --->
		<cfquery name="GetWarehouse"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Materials.dbo.Warehouse
				WHERE  Warehouse = '#GetInvoice.Warehouse#'
		</cfquery>

		<!--- Get Warehouse device information --->
		<cfquery name="GetWarehouseDevice"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Materials.dbo.WarehouseTerminal
				WHERE  Warehouse    = '#GetInvoice.Warehouse#'
				AND    TerminalName = '#terminal#'
				AND    Operational=1
		</cfquery>

		<!--- Get Warehouse and Series Information --->
		<cfquery name="GetWarehouseSeries"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT T.*, O.OrgUnitName
				FROM   Organization.dbo.OrganizationTaxSeries T
					   INNER JOIN Organization.dbo.Organization O ON T.OrgUnit = O.OrgUnit
				WHERE  T.OrgUnit     = '#GetWarehouseDevice.TaxOrgUnitEDI#'
				AND    T.SeriesType  = 'Invoice'
				AND    T.Operational = 1
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

		<!--- STORE THIS IN A CONFIG TABLE !! --->
		<cfset vUser     =   GetMissionConfig.ExchangeUserId>
		<cfset vPwd      =   GetMissionConfig.ExchangePassword>
	
		<!--- NIT from Seller --->
		<cfset vNitEFACE    = GetWarehouseSeries.EFACEId>
		<cfset DocumentType = GetWarehouseSeries.TaxDocumentType>  <!--- SAT Document Type: Regular Invoice --->

		<!--- initializing..... --->

		<cfset vExchangeRate = "1">
		<cfset vCurrency = "GTQ">

		<cfif GetInvoice.SalesCurrency eq "QTZ">
			<cfset vExchangeRate = "1">
			<cfset vCurrency = "GTQ">
			
		<cfelse>
		
		<!--- get the exchangeRate --->
		
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

		<!---
		<cfif GetInvoice.UoM eq "each">
		    <cfset vUoM = "UND">
		<cfelse>
		    <cfset vUoM = GetInvoice.UoM>
		</cfif>
		--->

		<cfset vUoM = "UND">

		<cfset vNIT = GetInvoice.NIT>
		<cfif vNIT eq "CF" OR vNIT eq "C-F">
			<cfset vNIT = "C/F">
		</cfif>

		<cfset vInvoiceTotalAmount    = "0">
		<cfset vInvoiceTotalExempt    = "0">
		<cfset vInvoiceTotalDiscount  = "0">
		<cfset vInvoiceTotalTax       = "0">
		
		<cfif GetInvoice.TotalDiscounts neq "">
			<cfset vInvoiceTotalDiscount = GetInvoice.TotalDiscounts+0>
		<cfelse>
			<cfset vInvoiceTotalDiscount = 0>
		</cfif>
		
		<cfif GetInvoice.TotalTaxDiscounts neq "">
			<cfset vInvoiceTotalTaxDiscount = GetInvoice.TotalTaxDiscounts+0>
		<cfelse>
			<cfset vInvoiceTotalTaxDiscount = 0>
		</cfif>

		<cfif GetInvoice.DiscountDescription neq "">
			<cfset vDiscountDescription = GetInvoice.DiscountDescription>
		<cfelse>
			<cfset vDiscountDescription = "Descuento">
		</cfif>

		<cfset vreccount = "1">
		<cfset EFACEResponse = structnew()>

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

		<!--- ISO 8601 --->
		
		<cfset vInvoiceType   = GetWarehouseSeries.DocumentType>  <!--- this is AR or paid we know this on the level of the transaction --->
		<cfset vNormalizedNit = Replace(vNIT,"-","","ALL")>
		<cfset vNormalizedNit = Replace(vNormalizedNit,"C/F","CF","ALL")>
		
		<cfxml variable="XmlDTE">
			<cfoutput>
				<?xml version="1.0" encoding="utf-8"?>
				
				<dte:GTDocumento xmlns:ds="http://www.w3.org/2000/09/xmldsig##"
					xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					Version="0.1" xsi:schemaLocation="http://www.sat.gob.gt/dte/fel/0.2.0">
					
						<dte:SAT ClaseDocumento="dte">
							<dte:DTE ID="DatosCertificados">
							
							<dte:DatosEmision ID="DatosEmision">
										<dte:DatosGenerales CodigoMoneda="#vCurrency#" FechaHoraEmision="#DateFormat(now(),"YYYY-MM-DD")#T#TimeFormat(now(),"hh:mm:ssXXX")#" Tipo="#vInvoiceType#"></dte:DatosGenerales>
										<cfif GetWarehouseSeries.OrgUnitName eq "DR. JORGE MANUEL ALDANA SAENZ">
											<dte:Emisor AfiliacionIVA="GEN" CodigoEstablecimiento="#GetWarehouseDevice.Reference#" CorreoEmisor="#GetWarehouseSeries.UserEmail#" NITEmisor="#vNitEFACE#" NombreComercial="#GetWarehouseSeries.OrgUnitName#" NombreEmisor="#GetWarehouseSeries.OrgUnitName#">
										<cfelse>
											<dte:Emisor AfiliacionIVA="GEN" CodigoEstablecimiento="#GetWarehouseDevice.Reference#" CorreoEmisor="#GetWarehouseSeries.UserEmail#" NITEmisor="#vNitEFACE#" NombreComercial="#GetWarehouseSeries.OrgUnitName#" NombreEmisor="#GetMission.MissionName#">
										</cfif>
								<dte:DireccionEmisor>
								<dte:Direccion>#GetInvoice.Address#</dte:Direccion>
									<dte:CodigoPostal>01001</dte:CodigoPostal>
									<dte:Municipio>GUATEMALA</dte:Municipio>
									<dte:Departamento>GUATEMALA</dte:Departamento>
									<dte:Pais>GT</dte:Pais>
								</dte:DireccionEmisor>
								</dte:Emisor>
						
							<dte:Receptor CorreoReceptor="#GetInvoice.eMailAddress#" IDReceptor="#vNormalizedNIT#" NombreReceptor="#Replace(GetInvoice.CustomerName,"&","")#">
								
								<cfif GetInvoice.CustomeraddressPostalCode neq "" or GetInvoice.PostalCode neq "">
									<cfif GetInvoice.CustomerAddress neq "">
				
										<cfquery name		="qPostalCodeCheck"
												datasource	="#datasource#"
												username  	="#SESSION.login#"
												password  	="#SESSION.dbpw#">
												SELECT 		*
												FROM 		System.dbo.PostalCode
												WHERE 		PostalCode = '#GetInvoice.CustomeraddressPostalCode#' or PostalCode = '#GetInvoice.PostalCode#'
										</cfquery>
				
										<cfif qPostalCodeCheck.recordcount neq 0>
										
												<dte:DireccionReceptor>
												<dte:Direccion>#GetInvoice.Customeraddress#</dte:Direccion>
											<dte:CodigoPostal>#qPostalCodeCheck.PostalCode#</dte:CodigoPostal>
											<dte:Municipio>#GetInvoice.CustomeraddressCity#</dte:Municipio>
											<dte:Departamento>#GetInvoice.CustomeraddressState#</dte:Departamento>
											<dte:Pais><cfif GetInvoice.CustomeraddressCountry eq "GUA">GT<cfelseif GetInvoice.CustomeraddressCountry neq "">#GetInvoice.CustomeraddressCountry#<cfelse>GT</cfif></dte:Pais>
											</dte:DireccionReceptor>
										<cfelse>
												<dte:DireccionReceptor>
													<dte:Direccion>Ciudad</dte:Direccion>
													<dte:CodigoPostal>01001</dte:CodigoPostal>
													<dte:Municipio>GUATEMALA</dte:Municipio>
													<dte:Departamento>GUATEMALA</dte:Departamento>
													<dte:Pais>GT</dte:Pais>
												</dte:DireccionReceptor>
										</cfif>
									<cfelse>
											<dte:DireccionReceptor>
												<dte:Direccion>Ciudad</dte:Direccion>
												<dte:CodigoPostal>01001</dte:CodigoPostal>
												<dte:Municipio>GUATEMALA</dte:Municipio>
												<dte:Departamento>GUATEMALA</dte:Departamento>
												<dte:Pais>GT</dte:Pais>
											</dte:DireccionReceptor>
									</cfif>
								<cfelse>
										<dte:DireccionReceptor>
											<dte:Direccion>Ciudad</dte:Direccion>
											<dte:CodigoPostal>01001</dte:CodigoPostal>
											<dte:Municipio>GUATEMALA</dte:Municipio>
											<dte:Departamento>GUATEMALA</dte:Departamento>
											<dte:Pais>GT</dte:Pais>
										</dte:DireccionReceptor>
								</cfif>
								</dte:Receptor>
								
								<dte:Frases>
									<dte:Frase CodigoEscenario="1" TipoFrase="1"></dte:Frase>
								</dte:Frases>
								
								<dte:Items>
								<cfloop query="GetInvoice">
									<cfif SalesPrice gt 0 and TransactionQuantity gte 0 and SalesTotal gte 0>
										<cfset v_TipoItem = "B">
										<cfif GetInvoice.isServiceItem eq "1">
											<cfset v_TipoItem = "S">
										</cfif>
											<dte:Item BienOServicio="#v_TipoItem#" NumeroLinea="#vreccount#">
										<dte:Cantidad>#TransactionQuantity#</dte:Cantidad>
										<dte:UnidadMedida><cfif UoMDescription neq "">#Left(UoMDescription,3)#<cfelse>#vUoM#</cfif></dte:UnidadMedida>
											<cfset v_ItemDescription = ItemDescription>
											<cfset v_ItemDescription = replace(v_ItemDescription,"&","&amp;","all")>
											<cfset v_ItemDescription = replace(v_ItemDescription,"'","&apos;","all")>
												<dte:Descripcion>#ItemNo#|#v_ItemDescription#</dte:Descripcion>
				
											<cfif TaxExemption eq "1">
												<cfset vSaleAmount = SalesAmountExemption>
											<cfelse>
												<cfset vSaleAmount = SalesTotal>
											</cfif>
											<cfif (vreccount eq "1" and TotalDiscounts gt "0")>
												<cfset vTaxLine = numberformat(SalesTax + TotalTaxDiscounts ,"__.__")>
												<cfset vOriginal = SchedulePrice*TransactionQuantity>
												<cfset vTotalDiscounts = vSaleAmount-vOriginal>
												<cfset vDiscountLine = trim(numberformat(vInvoiceTotalDiscount,"__.__"))>
												<cfelseif (Abs(SchedulePrice*TransactionQuantity-vSaleAmount) gt 0.05)>
												<cfset vOriginal = SchedulePrice*TransactionQuantity>
												<cfset vTotalDiscounts = vSaleAmount-vOriginal>
												<cfset vInvoiceTotalDiscount = vTotalDiscounts + vInvoiceTotalDiscount>
												<cfset vTaxLine = numberformat(SalesTax,"__.__")>
												<cfset vDiscountLine = trim(numberformat(vTotalDiscounts,"__.__"))>
											<cfelse>
												<cfset vTaxLine = numberformat(SalesTax,"__.__")>
												<cfset vDiscountLine = 0>
											</cfif>
											<cfset vSaleAmountWithoutDiscount = SchedulePrice*TransactionQuantity>
											<dte:PrecioUnitario><cfif TransactionQuantity neq 0>#trim(numberformat(ABS(SalesPrice),"__._______"))#<cfelse>0</cfif></dte:PrecioUnitario>
										<dte:Precio>#trim(numberformat((ABS(SalesPrice)*TransactionQuantity),"__._______"))#</dte:Precio>
				
											<dte:Descuento>0</dte:Descuento>
										<dte:Impuestos>
										<dte:Impuesto>
											<dte:NombreCorto>IVA</dte:NombreCorto>
											<dte:CodigoUnidadGravable>1</dte:CodigoUnidadGravable>
										<dte:MontoGravable>#trim(numberformat(ABS(vSaleAmount-SalesTax),"__._______"))#</dte:MontoGravable>
										<dte:MontoImpuesto>#trim(numberformat(SalesTax,"__._______"))#</dte:MontoImpuesto>
										</dte:Impuesto>
										</dte:Impuestos>
										<dte:Total>#trim(numberformat(ABS(SalesTotal),"__._______"))#</dte:Total>
										</dte:Item>
										<cfset vreccount = vreccount + 1>
				
										<cfif TaxExemption eq "1">
											<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesAmountExemption>
											<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTaxExemption>
										<cfelse>
											<cfset vInvoiceTotalAmount = vInvoiceTotalAmount + SalesTotal>
											<cfset vInvoiceTotalTax = vInvoiceTotalTax + SalesTax>
										</cfif>
									</cfif>
								</cfloop>
								</dte:Items>
								
								<dte:Totales>
								<dte:TotalImpuestos>
										<dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="#trim(numberformat(vInvoiceTotalTax,"__.__"))#"></dte:TotalImpuesto>
								</dte:TotalImpuestos>
								<dte:GranTotal>#trim(numberformat(vInvoiceTotalAmount,"__._______"))#</dte:GranTotal>
								</dte:Totales>
								
								<cfif vInvoiceType eq "FCAM">
										<dte:Complementos>
										<dte:Complemento IDComplemento="Cambiaria" NombreComplemento="Cambiaria" URIComplemento="http://www.sat.gob.gt/fel/cambiaria.xsd">
										<cfc:AbonosFacturaCambiaria xmlns:cfc="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0" Version="1" xsi:schemaLocation="http://www.sat.gob.gt/dte/fel/CompCambiaria/0.1.0 C:\Users\Desktop\SAT_FEL_FINAL_V1\Esquemas\GT_Complemento_Cambiaria-0.1.0.xsd">
											<cfc:Abono>
												<cfc:NumeroAbono>1</cfc:NumeroAbono>
												<cfc:FechaVencimiento>#DateFormat(DateAdd("d",30,GetInvoice.TransactionDate),"YYYY-MM-DD")#</cfc:FechaVencimiento>
												<cfc:MontoAbono>#vInvoiceTotalAmount#</cfc:MontoAbono>
											</cfc:Abono>
										</cfc:AbonosFacturaCambiaria>
										</dte:Complemento>
										</dte:Complementos>
								</cfif>
								
							</dte:DatosEmision>
						
						</dte:DTE>
					
					</dte:SAT>
				
				</dte:GTDocumento>
				
			</cfoutput>
		</cfxml>

		<cfset StringDTE = toString(XmlDTE)>

		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_#RetryNo#.txt" output="#StringDTE#">

		<cfset Base64DTE = ToBase64(StringDTE) />

		<cfset stToSign =
		{ "llave": "#GetWarehouseSeries.PrivateKey#",
			"archivo": "#Base64DTE#",
			"codigo": "#vUniqueId#",
			"alias": "#GetWarehouseSeries.Alias#",
			"es_anulacion": "N"
		}>

		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_To_Sign_#RetryNo#.txt" output="#serializeJSON(stToSign)#">

		<cfhttp url="https://signer-emisores.feel.com.gt/sign_solicitud_firmas/firma_xml" method="post" result="httpResponse" timeout="60">
			<cfhttpparam type="header" name="Content-Type" value="application/json" />
			<cfhttpparam type="body" value="#serializeJSON(stToSign)#">
		</cfhttp>

		<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_Response_Signature_#RetryNo#.txt" output="#httpResponse.fileContent#">

		<cftry>
			<cfset jSonDTE = deserializeJSON(httpResponse.fileContent)>
			<cfset vError = 0>
			<cfcatch>
				<cfset vError = 1>
			</cfcatch>
		</cftry>

		<cfset EFACEResponse.log = 1>
		<cfset EFACEResponse.ErrorDetail      = "">
				
		<cfif vError eq 0>			

			<cfif jsonDTE.resultado neq "NO">
				<cfset revBase64DTE =  ToString(ToBinary(jSONDTE.archivo)) />

				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_Response_Signature_decoded_#RetryNo#.txt" output="#revBase64DTE#">
				<cfsavecontent variable="SignedXml"><?xml version="1.0" encoding="utf-8"?>
					<cfoutput>#revBase64DTE#</cfoutput></cfsavecontent>

				<cfset Base64SignedXML = ToBase64(toString(SignedXml)) />

				<cfset stToCertify =
				{ "nit_emisor":"#vNitEFACE#",
					"correo_copia":"#GetWarehouseSeries.UserEmail#",
					"xml_dte":"#Base64SignedXml#"
				}>

				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_To_Certify_#RetryNo#.txt" output="#serializeJSON(stToCertify)#">

				<cfhttp url="https://certificador.feel.com.gt/fel/certificacion/v2/dte/" method="post" result="httpResponse" timeout="60">
					<cfhttpparam type="header" name="usuario" value="#GetWarehouseSeries.UserName#" />
					<cfhttpparam type="header" name="llave" value="#GetWarehouseSeries.UserKey#" />
					<cfhttpparam type="header" name="identificador" value="#vUniqueId#" />
					<cfhttpparam type="header" name="Content-Type" value="application/json" />
					<cfhttpparam type="body" value="#serializeJSON(stToCertify)#">
				</cfhttp>

				<cftry>
					<cfset jSonCertification = deserializeJSON(httpResponse.fileContent)>
					<cfset vError = 0>
					<cfcatch>
						<cfset vError = 1>
					</cfcatch>
				</cftry>

				<cffile action="WRITE" file="#vLogsDirectory#\FEL_#GetInvoice.BatchNo#_Response_Certifier_#RetryNo#.txt" output="#httpResponse.fileContent#">

				<cfif findNoCase("Connection Failure",httpResponse.fileContent)>
				
					<cfset vError = 1>
					<cfset EFACEResponse.Status           = "0">
					<cfset EFACEResponse.Cae              = "">
					<cfset EFACEResponse.DocumentNo       = "">
					<cfset EFACEResponse.Dte              = "">
					<cfset EFACEResponse.ErrorDescription = "Connection Failure">
					<cfset EFACEResponse.ErrorDetail      = "Connection Failure">

				</cfif>

				<cfif vError eq 0>

					<Cfif jSonCertification.resultado neq "NO">
					
						<cfset EFACEResponse.Status = "1">
						<cfset EFACEResponse.Cae        = jSonCertification.uuid>
						<cfset EFACEResponse.Series     = jSonCertification.serie>
						<cfset EFACEResponse.DocumentNo = jSonCertification.numero>
						<cfset EFACEResponse.Dte        = jSonCertification.fecha>
						<cfset EFACEResponse.ErrorDescription = "">
						
					<cfelse>

						<cfset e = jSonCertification>
						<!---
						.categoria
						.fuente
						.mensaje_error
						.numeral
						--->
						<cfset vError = "">
						<cfset vCategory = "">
						<cfloop from="1" to="#ArrayLen(e.descripcion_errores)#" index="i">
							<cfif vError eq "">
								<cfset vError = e.descripcion_errores[i].mensaje_error>
								<cfset vCategory = e.descripcion_errores[i].categoria>
							<cfelse>
								<cfset vError = "#vError#, #e.descripcion_errores[i].mensaje_error#">
							</cfif>
						</cfloop>

						<cfset EFACEResponse.Status     = "0">
						<cfset EFACEResponse.Cae        = "">
						<cfset EFACEResponse.DocumentNo = "">
						<cfset EFACEResponse.Dte        = "">
						<cfset EFACEResponse.ErrorDescription = "#vCategory#">
						<cfset EFACEResponse.ErrorDetail = "#vError#">

					</cfif>
					
				<cfelse>
				
					<cfset EFACEResponse.Status = "0">
					<cfset EFACEResponse.Cae = "">
					<cfset EFACEResponse.DocumentNo = "">
					<cfset EFACEResponse.Dte = "">
					<cfset EFACEResponse.ErrorDescription = "Error en conexion 101">
					
				</cfif>

			<cfelse>
			
				<cfset EFACEResponse.Status = "0">
				<cfset EFACEResponse.Cae = "">
				<cfset EFACEResponse.DocumentNo = "">
				<cfset EFACEResponse.Dte = "">
				<cfset EFACEResponse.ErrorDescription = "Error en conexion 102">
				
			</cfif>

		<cfelse>
		
			<cfset EFACEResponse.Status = "0">
			<cfset EFACEResponse.Cae = "">
			<cfset EFACEResponse.DocumentNo = "">
			<cfset EFACEResponse.Dte = "">
			<cfset EFACEResponse.ErrorDescription = "Error en conexion 103">
			
		</cfif>
		
		<cfset EFACEResponse.ActionDate = now()>
		<cfset EFACEResponse.Source1    = "#GetInvoice.BatchNo#">
		<cfset EFACEResponse.Source2    = "#vNormalizedNIT#">
		
		<cfreturn EFACEResponse>

	</cffunction>
	

	<cffunction name="SaleVoid"
			access="public"
			returntype="any"
			returnformat="plain"
			displayname="VoidSale">

		<cfargument name="Datasource"      type="string"  required="true"   default="appsOrganization">
		<cfargument name="Mission"         type="string"  required="true"   default="">
		<cfargument name="Terminal"        type="string"  required="true"   default="1">
		<cfargument name="Journal"         type="string"  required="true"   default="">
		<cfargument name="JournalSerialNo" type="string"  required="true"   default="">
		
		<cfquery name="GetTransaction"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Accounting.dbo.TransactionHeader
					WHERE  Journal         = '#journal#'
					AND    JournalSerialNo = '#JournalSerialNo#'
		</cfquery>
			
		<cfif GetTransaction.OrgUnitTax eq "" or GetTransaction.OrgUnitTax eq "0">
			
			    <!--- we look into the journal --->
			
				<cfquery name="getJournal"
					datasource="#datasource#"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Accounting.dbo.Journal
						WHERE  Journal         = '#getTransaction.journal#'											
				</cfquery>
				
				<cfset FEL.OrgUnitTax = getJournal.OrgUnitTax>		
				
		<cfelse>
			
				<cfset FEL.OrgUnitTax = getTransaction.OrgUnitTax>	
			
		</cfif>				
		
		<!--- Get Mission Information --->
		<cfquery name="GetMission"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Organization.dbo.Ref_Mission
				WHERE Mission = '#getTransaction.mission#'
		</cfquery>

        <!--- Get Warehouse and Series Information --->
		<cfquery name="GetWarehouseSeries"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Organization.dbo.OrganizationTaxSeries
				WHERE  OrgUnit     = '#FEL.OrgUnitTax#'
				AND    SeriesType  = 'CreditNote'
				AND    Operational = 1
		</cfquery>

		<cfquery name="GetInvoiceToCancel"
			datasource="#datasource#"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">

			SELECT 	TOP 1 *
			FROM    Accounting.dbo.TransactionHeaderAction A
					INNER JOIN Accounting.dbo.TransactionHeader H       ON H.Journal = A.Journal AND H.JournalSerialNo = A.JournalSerialNo
					INNER JOIN Organization.dbo.OrganizationTaxSeries T ON T.OrgUnit = '#FEL.OrgUnitTax#' AND T.SeriesNo = A.ActionReference4
			WHERE   H.Journal         = '#journal#'
			AND     H.JournalSerialNo = '#journalserialNo#'
			AND     A.ActionStatus    = '1'
			AND     A.ActionMode      = '2'
			ORDER BY A.Created DESC
												
		</cfquery>
		
		

		<cfif GetInvoiceToCancel.recordcount neq 0>
		
				<cfquery name	= "getEDIConfig"
					datasource	= "#datasource#"
					username  	= "#SESSION.login#"
					password  	= "#SESSION.dbpw#">
					SELECT 		*
					FROM 		System.dbo.Parameter
				</cfquery>
	
				<cfset vEDIDirectory = getEDIConfig.EDIDirectory>
				<cfset vLogsDirectory = vEDIDirectory & "Logs\#GetMission.Mission#\NC">
	
				<cfif not directoryExists(vLogsDirectory)>
					<cfdirectory action="create" directory="#vLogsDirectory#">
				</cfif>
				
				<!--- NEEDED --->
				
				<cfquery name="GetMissionConfig"
				datasource="#datasource#"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization.dbo.Ref_MissionExchange
					WHERE  Mission = '#mission#'
				    AND    ClassExchange = 'FACE'
				</cfquery>
					
				<cfset vUser     = GetMissionConfig.ExchangeUserId>
				<cfset vPwd      = GetMissionConfig.ExchangePassword>
				
				<cfset vNitEFACE = GetWarehouseSeries.EFACEId>
	
				<cfset DocumentType = "64">  <!--- SAT Document Type: Regular Invoice --->	
	
				<cfset vNIT = GetInvoiceToCancel.ActionSource2>
				<cfif vNIT eq "CF" OR vNIT eq "C-F" OR vNIT eq "">
					<cfset vNIT = "C/F">
				</cfif>
	
				<cfset vNormalizedNit = Replace(vNIT,"-","","ALL")>
				<cfset vNormalizedNit = Replace(vNormalizedNit,"C/F","CF","ALL")>			
									
				<cfxml variable="XmlDTE">
					<cfoutput>
						<?xml version="1.0" encoding="UTF-8"?>
								<dte:GTAnulacionDocumento xmlns:ds="http://www.w3.org/2000/09/xmldsig##" xmlns:dte="http://www.sat.gob.gt/dte/fel/0.1.0" xmlns:n1="http://www.altova.com/samplexml/other-namespace" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="0.1" xsi:schemaLocation="http://www.sat.gob.gt/dte/fel/0.1.0 C:\Users\User\Desktop\FEL\Esquemas\GT_AnulacionDocumento-0.1.0.xsd">
					<dte:SAT>
					<dte:AnulacionDTE ID="DatosCertificados">
						<dte:DatosGenerales FechaEmisionDocumentoAnular="#GetInvoiceToCancel.ActionReference3#" 
						    FechaHoraAnulacion="#DateFormat(now(),'YYYY-MM-DD')#T#TimeFormat(now(),'HH:MM:SS')#-06:00" ID="DatosAnulacion" 
							IDReceptor="#vNormalizedNit#" 
							MotivoAnulacion="ANULACION" 
							NITEmisor="#vNitEFACE#" 
							NumeroDocumentoAAnular="#GetInvoiceToCancel.ActionReference1#"></dte:DatosGenerales>
					</dte:AnulacionDTE>
					</dte:SAT>
					</dte:GTAnulacionDocumento>
					</cfoutput>
				</cfxml>
						
		
				<cfset StringDTE = toString(XmlDTE)>
	
				<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#.txt" output="#StringDTE#">
				<cfset Base64DTE = ToBase64(StringDTE) />
	
				<cfset stToSign =
				{   "llave": "#GetWarehouseSeries.PrivateKey#",
					"archivo": "#Base64DTE#",
					"codigo": "#GetInvoiceToCancel.ActionSource1#",
					"alias": "#GetWarehouseSeries.Alias#",
					"es_anulacion": "S" }>
	
				<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#_To_Sign.txt" output="#serializeJSON(stToSign)#">
	
				<cfhttp url="https://signer-emisores.feel.com.gt/sign_solicitud_firmas/firma_xml" method="post" result="httpResponse" timeout="60">
					<cfhttpparam type="header" name="Content-Type" value="application/json"/>
					<cfhttpparam type="body" value="#Replace(serializeJSON(stToSign),"//","")#">
				</cfhttp>
	
				<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#_Response_Signature.txt" output="#httpResponse.fileContent#">
	
				<cfset jSonDTE = deserializeJSON(httpResponse.fileContent)>
				
				<cfif jsonDTE.resultado neq "NO">
				
					<cfset revBase64DTE =  ToString(ToBinary(jSONDTE.archivo)) />
	
					<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#_Response_Signature_decoded.txt" output="#revBase64DTE#">
					<cfsavecontent variable="SignedXml"><?xml version="1.0" encoding="utf-8"?>
						<cfoutput>#revBase64DTE#</cfoutput>
					</cfsavecontent>
	
					<cfset Base64SignedXML = ToBase64(toString(SignedXml)) />
	
					<cfset stToCertify =
					{ "nit_emisor":"#vNitEFACE#",
						"correo_copia":"#GetWarehouseSeries.UserEmail#",
						"xml_dte":"#Base64SignedXml#"
					}>
	
					<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#_To_Certify.txt" output="#serializeJSON(stToCertify)#">
					
					<cfset vSerialNo = GetInvoiceToCancel.ActionSource1>
	
					<cfhttp url="https://certificador.feel.com.gt/fel/anulacion/v2/dte/" method="post" result="httpResponse" timeout="60">
						<cfhttpparam type="header" name="usuario"       value="#GetWarehouseSeries.UserName#" />
						<cfhttpparam type="header" name="llave"         value="#GetWarehouseSeries.UserKey#" />
						<cfhttpparam type="header" name="identificador" value="#vSerialNo#" />
						<cfhttpparam type="header" name="Content-Type"  value="application/json" />
						<cfhttpparam type="body"                        value="#Replace(serializeJSON(stToCertify),"//","")#">
					</cfhttp>
	
					<cfset jSonCertification = deserializeJSON(httpResponse.fileContent)>
	
					<cffile action="WRITE" file="#vLogsDirectory#\NC_FEL_#GetTransaction.JournalTransactionNo#_Response_Certifier.txt" output="#httpResponse.fileContent#">
					<cfset vStatus = "200 OK">
					<cfset jDoc=deserializeJSON(httpResponse.fileContent)>
					<cfif jDoc['resultado'] eq "NO">
						<cfset vStatus = "ERROR">
						<cfset stError = jDoc['descripcion']>
					<cfelse>
						<cfset vStatus = "200 OK">
						<cfset stError = "">
					</cfif>
	
				<cfelse>
					<cfset vStatus = "ERROR">
					<cfset stError = "">
				</cfif>
	
	
			<cfset EFACEResponse = structnew()>
			
			<cfset EFACEResponse.ActionDate    = now()>			
			<!--- transaction --->
			<cfset EFACEResponse.source1       = GetInvoiceToCancel.ActionSource1>			
			<!--- customer NIT --->
			<cfset EFACEResponse.source2       = GetInvoiceToCancel.ActionSource2>			
			<cfset EFACEResponse.log           = 0>
						
			<cfif vStatus eq "200 OK" or vStatus eq "200">
	
				<cfif GetInvoiceToCancel.ActionReference5 eq "">
				
					<cfset xmlDoc 	= xmlParse(httpResponse.fileContent, false)>
					<cfset vvalid 	= xmlSearch(xmlDoc,"//*[local-name()='valido']")>
					<cfset cae 		= xmlSearch(xmlDoc,"//*[local-name()='cae']")>
					<cfset docNo 	= xmlSearch(xmlDoc,"//*[local-name()='numeroDocumento']")>
					<cfset dte 		= xmlSearch(xmlDoc,"//*[local-name()='numeroDte']")>
	
					<cfif vvalid[1].XmlText eq "true">
					
						<!--- Valid Invoice Number generated by the GFACE. update Invoice number information --->
						
						<cfset EFACEResponse.Status           = "OK">
						<cfset EFACEResponse.Cae              = cae[1].XmlText>
						<cfset EFACEResponse.DocumentNo       = docNo[1].XmlText>
						<cfset EFACEResponse.Dte              = dte[1].XmlText>
						<cfset EFACEResponse.ErrorDescription = "">
						<cfset EFACEResponse.log              = 1>
												
					<cfelse>
					
						<cfset vErrorDesc = xmlSearch(xmlDoc,"//*[local-name()='descripcion']")>
						<cfset stError = vErrorDesc[1].XmlText>
						
					</cfif>
					
				<cfelse>
				
					<cfset  EFACEResponse.Status           = "OK">
					<cfset  EFACEResponse.Cae              = jDoc['uuid']>
					<cfset  EFACEResponse.Series           = jDoc['serie']>
					<cfset  EFACEResponse.DocumentNo       = jDoc['numero']>
					<cfset  EFACEResponse.Dte              = jDoc['numero']>
					<cfset  EFACEResponse.ErrorDescription = "">
					<cfset  EFACEResponse.log              = 1>
					
				</cfif>
	
				<cfif EFACEResponse.log eq 1>
	
					<!--- Create new action for the original invoice describing the credit note : MOVED TO MANAGER.CFC --->
						
				<cfelse>
				
					<cfset EFACEResponse.Status     = "false">
					<cfset EFACEResponse.Cae        = "">
					<cfset EFACEResponse.DocumentNo = "">
					<cfset EFACEResponse.Dte        = "">
					<cfset EFACEResponse.ErrorDescription = stError>
	
				</cfif>
	
			<cfelse>
						
				<cfset EFACEResponse.Status      = vStatus>
				<cfset EFACEResponse.Cae         = "">
				<cfset EFACEResponse.DocumentNo  = "">
				<cfset EFACEResponse.Dte         = "">
				<cfset EFACEResponse.ErrorDescription =  stError>
				
			</cfif>
			
	    <cfelse>
				
			<!--- FEL was never posted, no record in transaction header, hence we allow to continue --->
			
			<cfset EFACEResponse.Status     = "OK">
			<cfset EFACEResponse.Cae        = "">
			<cfset EFACEResponse.DocumentNo = "">
			<cfset EFACEResponse.Dte        = "">
			<cfset EFACEResponse.ErrorDescription = "Nothing to revert in FEL">
			
	    </cfif>				
	
	<cfreturn EFACEResponse>
	
	</cffunction>

</cfcomponent>