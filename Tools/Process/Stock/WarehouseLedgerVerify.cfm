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
<!--- To improve performance dev changed IN statement to NOT EXIST --->

<cfparam name="attributes.itemNo" default="">

<!---

The custom method handles the following scenarios for General Ledger sync 

Warehouse Financials

1. Change of Ledger code for stock levels in the category maintenance

	Need to change the old GL code into the new stock account in financials
	(universal fix as below)

2. Change category of item which has a different stock account

	Need to change the old GL code into the new stock account in financials
	(universal fix as below)

3. Change standard cost price 100-110 and mode is manual

	Define any sourcing transactions that have have stock (loop)

	- Create a negative transaction so we source it all
	- Create a positive transaction so we have stock again but against a new value

	Define value in Warehouse transactionsLedger for that whole category of the item 
	(GL code)

	Make a price diffence correction

4. Move from method FIFO/LIFO to manual

	Same procedure as point 3

5. Move from Manual to FIFO/LIFO

	No action, it does not have to work retroactively

--->

<!--- reminder !!!!! also exclude depreciation --->




<cfquery name="AccountNew" 
		datasource="#attributes.Datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Category R INNER JOIN
		         Ref_CategoryGledger L ON R.Category = L.Category
		WHERE    L.Area = 'Stock' 
		AND      R.Category = '#attributes.categorynew#'
</cfquery>	

<cfparam name="attributes.categoryold" default="">

<cfquery name="AccountOld" 
		datasource="#attributes.Datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Category R INNER JOIN
		         Ref_CategoryGledger L ON R.Category = L.Category
		WHERE    L.Area = 'Stock' 
		AND      R.Category = '#attributes.categoryold#'
</cfquery>	

<cfset newaccount = AccountNew.GLAccount>
<cfset oldaccount = AccountOld.GLAccount>

<cfif AccountNew.GLAccount eq AccountOld.GLAccount>

	<!--- no action needed here --->

<cfelse>

	<cf_verifyOperational 
         datasource= "#Attributes.DataSource#"
         module    = "Accounting" 
		 Warning   = "No">
		 
	<cfif Operational eq "1"> 
		
		<!--- ----------------------------------------------- --->
		<!--- define the correct GL values of stock and asset --->
		<!--- ----------------------------------------------- --->
		
		<cfloop index="itemclass" list="Asset,Supply">
		
			<cfif itemclass eq "Supply">
			
			    <!--- -------- --->
			    <!--- supplies --->
				<!--- -------- --->
			
				<cfquery name="ItemTransaction" 
					datasource="#attributes.Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					<!--- retrieve all transactions involved for this category and the prior category and define the
					value for the current GL account of the involved categories --->
					
					SELECT     IT.Mission,	
							   R.GLAccount, 						       
					           SUM(IT.TransactionValue) AS Amount <!--- calculated value --->
							
					FROM       Materials.dbo.ItemTransaction IT INNER JOIN
				               Materials.dbo.Item I ON IT.ItemNo = I.ItemNo INNER JOIN
				               Materials.dbo.Ref_CategoryGledger R ON I.Category = R.Category and R.Area = 'Stock'	
					
					<!--- take all items that belong to either of the two categories at stake --->
							   
					WHERE      I.Category IN ('#attributes.categorynew#','#attributes.categoryold#') 
					
					AND        NOT EXISTS 
													(
													 SELECT TransactionId 
					                                 FROM   Materials.dbo.AssetItem 
													 WHERE  TransactionId = IT.TransactionId
													 )		
														
					AND        I.ItemClass = 'Supply'									
										
					GROUP BY   IT.Mission,
					           R.GLAccount			
					
					ORDER BY   IT.Mission 
							
				</cfquery>		
				

				
				<!--- complement the query with 0 value if the old GL no longer has presence --->
				
				<cfloop query="ItemTransaction">
				
					<cfquery name="Check" dbtype="query">
						SELECT * 
						FROM   ItemTransaction
						WHERE  Mission = '#mission#'
						AND    GLAccount = '#AccountOld.GLAccount#'								
					</cfquery>
								
					<cfif check.recordcount eq "0">
															
					    <cfset queryaddrow(ItemTransaction, 1)>
											
						<!--- set values in cells --->
						<cfset querysetcell(ItemTransaction, "Mission", "#Mission#")>
						<cfset querysetcell(ItemTransaction, "GLAccount", "#AccountOld.GLAccount#")>
						<cfset querysetcell(ItemTransaction, "Amount", "0")>																				
				
					</cfif>
				
				</cfloop>
				
				<cfquery name="LedgerBase" dbtype="query">
						SELECT * 
						FROM   ItemTransaction										
					</cfquery>
								
			<cfelse>
			
				<!--- select all asset items under this master item for the value as per asset show, each asset item
				has one GLAccount so the query is different  --->
				
				<!--- ------------------- --->
			    <!--- Assets source value --->
				<!--- ------------------- --->
							
				<cfquery name="LedgerBase" 
					datasource="#attributes.Datasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
												
					SELECT     A.AssetId,
					           IT.Mission,
					           '#newaccount#' as GLAccount, 	
						       I.Category,	
							   I.ItemNo,     					   			   
					           SUM(A.DepreciationBase-A.DepreciationCumulative) AS Amount <!--- calculated value --->
							   <!--- actual --->
					FROM       Materials.dbo.ItemTransaction IT INNER JOIN
							   Materials.dbo.Item I ON IT.ItemNo = I.ItemNo INNER JOIN
					           Materials.dbo.Ref_CategoryGledger R ON I.Category = R.Category AND R.Area = 'Stock' INNER JOIN
					           Materials.dbo.AssetItem A ON A.TransactionId = IT.TransactionId		
					
					<!--- now all asset items that belong to the same category so we correct them all if needed --->
							   
					WHERE      I.Category = '#attributes.categorynew#'
										
					AND        IT.TransactionType = '1'
					
					GROUP BY   IT.Mission,
					           A.AssetId,			          							  
							   I.Category,	
							   I.ItemNo   
							   				
					ORDER BY   IT.Mission, 
					           A.AssetId 
							
				</cfquery>		
			
			</cfif>			

					
		    <!--- process the defined CORRECT stock values for each glaccount into the ledger --->
				  
			<cfoutput query="LedgerBase" group="mission">	
			
			    <cfset row = 0>	
				<cfset sel = "">
				<cfset header = "0">
								
				<!--- retrieve journal --->
							
				<cfquery name="Journal" 
				   datasource="#attributes.Datasource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						SELECT    *
						FROM      Accounting.dbo.Journal
						WHERE     Mission       = '#Mission#' 
						AND       SystemJournal = 'Warehouse'
						AND       Currency      = '#APPLICATION.BaseCurrency#'
				 </cfquery>
				 	 
				<cfquery name="GLCorrection" 
				   datasource="#attributes.Datasource#" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT * 
					   FROM   Accounting.dbo.Ref_AccountMission 
					   WHERE  Mission       = '#Mission#'
					   AND    SystemAccount = 'Correction'		   
				</cfquery>
			
				<cfif GLCorrection.recordcount eq "0">
					    
			  		 <cf_message message = "GL ACCOUNT MAINTENANCE: A System GL Account for type: Correction has not been declared for #Mission#.">
					 <cfabort>
					
				</cfif>		
			
				<cfoutput>
														
					<!--- define value in the general ledger for each determined account to be review OR 
					   for each individual asset, by EXCLUDING the opening balance transaction I can check the full database --->	
					   
					<cfif ItemClass eq "Supply">   		
								
						<cfquery name="Ledger" 
							datasource="#attributes.Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
											
							SELECT    L.GLAccount, 
									  SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
							FROM      Accounting.dbo.TransactionHeader H 
									  INNER JOIN Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
									  INNER JOIN Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
									  INNER JOIN Accounting.dbo.Journal J ON L.Journal = J.Journal
							WHERE     H.Mission      = '#Mission#'
							AND       R.AccountClass = 'Balance' 
							AND       R.AccountType  = 'Debit'     
							
							AND       J.SystemJournal IN ('Warehouse','Asset') 									
							
							AND       L.GLAccount  = '#GLAccount#' 
							AND       NOT EXISTS (SELECT AssetId 
							                      FROM   Materials.dbo.AssetItem
												  WHERE  AssetId = L.ReferenceId
												)
							GROUP BY  L.GLAccount 	
															
						</cfquery>	
						
					<cfelse>
					
						   <cfquery name="Ledger" 
							datasource="#attributes.Datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
											
							SELECT    SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
							FROM      Accounting.dbo.TransactionHeader H 
									  INNER JOIN Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
									  INNER JOIN Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
									  INNER JOIN Accounting.dbo.Journal J ON L.Journal = J.Journal
							WHERE     H.Mission      = '#Mission#'
							AND       R.AccountClass = 'Balance' 
							AND       R.AccountType  = 'Debit'     							
							AND       J.SystemJournal IN ('Warehouse','Asset') 																													
							AND       L.ReferenceId  = '#assetid#'							
					        </cfquery>
					
					</cfif>												
						
					<!--- ---------------------------------------- --->	
					<!--- tracking of accounts to be cleared below --->
					<!--- ---------------------------------------- --->
								
					<cfif sel eq "">
					    <cfset sel = "'#GLAccount#'">		
					<cfelse>
					    <cfset sel = "#sel#,'#GLAccount#'">		
					</cfif> 
					
					<!--- ---------------------------------------- --->
									
					<cfif amount eq "">
					   <cfset amount = "0">
					</cfif>
					
					<cfset whsval = amount>
									
					<cfif Ledger.LedgerValue eq "">
						 <cfset glval = 0>
					<cfelse>
						 <cfset glval = Ledger.LedgerValue> 
					</cfif>
											
					<!--- supplies --->
					
					<cfif ItemClass eq "Supply">
																					
						<cfif abs(whsval-glval) gte "0.5">
									
								<cfset diff = round((whsval-glval)*100)/100>
									
								<!--- transaction for difference --->
								
								<cfset row = row+1>
								
								<cfif header eq "0">
							
									<cf_GledgerEntryHeader
									    DataSource            = "#attributes.Datasource#"
										Mission               = "#Mission#"			
										Journal               = "#Journal.Journal#" 
										Description           = "Stock Correction"
										TransactionSource     = "WarehouseSeries"
										TransactionCategory   = "Inventory"			
										MatchingRequired      = "0"
										Reference             = "Warehouse"       
										ReferenceName         = "Change of Stock GL Account"
										ReferenceId           = ""
										ReferenceNo           = ""
										DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
										DocumentAmount        = "0"
										AmountOutstanding     = "0">
										
										<cfif diff lt 0>
											<cfset cl = "Credit">
											<cfset ct = "Debit">
											<cfset diff = -diff>
										<cfelse>
										    <cfset cl = "Debit">
											<cfset ct = "Credit">
										</cfif>	
																																																		
										<cf_GledgerEntryLine
										    DataSource            = "#attributes.Datasource#"
											Lines                 = "2"
											Journal               = "#Journal.Journal#"
											JournalNo             = "#JournalTransactionNo#"					
											Currency              = "#APPLICATION.BaseCurrency#"
																
											TransactionSerialNo1  = "#row#"
											Class1                = "#cl#"									
											Reference1            = "Account Correction"       
											ReferenceName1        = "Account Correction from Source"					
											GLAccount1            = "#glaccount#"										
											TransactionType1      = "Standard"
											Amount1               = "#diff#"
																																
											TransactionSerialNo2  = "0"
											Class2                = "#ct#"									
											Reference2            = "ContraAccount"       
											ReferenceName2        = "Account Correction from Source"					
											GLAccount2            = "#GLCorrection.GLAccount#"					
											TransactionType2      = "Contra-Account"
											Amount2               = "#diff#">
											
											<cfset header = "1">		
																																										
								<cfelse>		
								
										<cfif diff lt 0>
											<cfset cl = "Credit">
											<cfset ct = "Debit">
											<cfset diff = -diff>
										<cfelse>
										    <cfset cl = "Debit">
											<cfset ct = "Credit">
										</cfif>	
								
										<cf_GledgerEntryLine
										    DataSource            = "#attributes.Datasource#"
											Lines                 = "2"
											Journal               = "#Journal.Journal#"
											JournalNo             = "#JournalTransactionNo#"					
											Currency              = "#APPLICATION.BaseCurrency#"
																
											TransactionSerialNo1  = "#row#"
											Class1                = "#cl#"									
											Reference1            = "Account Correction"       
											ReferenceName1        = "Account Correction from Source"					
											GLAccount1            = "#glaccount#"										
											TransactionType1      = "Standard"
											Amount1               = "#diff#"
											
											TransactionSerialNo2  = "0"
											Class2                = "#ct#"									
											Reference2            = "ContraAccount"       
											ReferenceName2        = "Account Correction from Source"					
											GLAccount2            = "#GLCorrection.GLAccount#"					
											TransactionType2      = "Contra-Account"
											Amount2               = "#diff#">																
									
								</cfif>	
								
								
												
						</cfif>	
					
					<cfelse>
					
						<!--- check if each asset is booked on the same account and value --->
						
						<cfset row = "0">
						
						<cfif whsval eq "">
							<cfset whsval = 0>
						</cfif>
										
						<cfset diff = whsval - glval>															
									
						 		<!--- we only rebook if we find any existing transaction for this asset item --->
								
								<cfquery name="Exist" 
								datasource="#attributes.Datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">												
								SELECT    *
								FROM      Accounting.dbo.TransactionLine
								WHERE     ReferenceId  = '#assetid#'											
							   </cfquery>									
							   
							   <cfif Exist.recordcount eq "0">
							   
							   		<!--- create an initial value for this asset --->
								
									<cf_GledgerEntryHeader
										    DataSource            = "#attributes.Datasource#"
											Mission               = "#LedgerBase.Mission#"			
											Journal               = "#Journal.Journal#" 
											Description           = "Stock Correction"
											TransactionSource     = "AssetSeries"
											TransactionCategory   = "Inventory"			
											MatchingRequired      = "0"
											Reference             = "Warehouse"       
											ReferenceName         = "Correction of Stock GL Account"
											ReferenceId           = "#LedgerBase.AssetId#"
											ReferenceNo           = ""
											DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
											DocumentAmount        = "#whsval#"
											AmountOutstanding     = "0">
									
										<!--- Lines --->
																				 
										<cf_GledgerEntryLine
										    DataSource            = "#attributes.Datasource#"
											Lines                 = "2"
											Journal               = "#Journal.Journal#"
											JournalNo             = "#JournalTransactionNo#"					
											Currency              = "#APPLICATION.BaseCurrency#"
																
											TransactionSerialNo1  = "1"
											Class1                = "Debit"
											ReferenceId1          = "#LedgerBase.AssetId#"
											Description1          = "Asset correction booking"		
											Reference1            = "Overbooking"       
											ReferenceName1        = "Overbooking"					
											GLAccount1            = "#newaccount#"										
											TransactionType1      = "Standard"
											Amount1               = "#whsval#"
												
											TransactionSerialNo2  = "2"
											Class2                = "Credit"
											ReferenceId2          = "#LedgerBase.AssetId#"
											Description2          = "Asset overbooking for master item"											
											Reference2            = "ContraAccount"       
											ReferenceName2        = "Account Correction from Source"					
											GLAccount2            = "#GLCorrection.GLAccount#"					
											TransactionType2      = "Contra-Account"
											Amount2               = "#whsval#">	
											
									<cfelse>	
									
										<cfquery name="Lines" 
										datasource="#attributes.Datasource#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">												
										SELECT    L.GLAccount, 
												  SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS LedgerValue
										FROM      Accounting.dbo.TransactionHeader H 
												  INNER JOIN
								                  Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
												  INNER JOIN
										          Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
												  INNER JOIN
										          Accounting.dbo.Journal J ON L.Journal = J.Journal
										WHERE     R.AccountClass = 'Balance' 
										AND       J.SystemJournal IN ('Warehouse','Asset') 
										AND       R.AccountType = 'Debit'				
										AND       H.Mission      = '#Mission#'
										AND       L.GLAccount    != '#GLAccount#'
										AND       L.ReferenceId  = '#assetid#'
										GROUP BY  L.GLAccount 			
									   </cfquery>		
							   											   					   
									   <cfloop query="Lines">
																	   					   
									   	<!--- step 1 rebook any balance transactions for this asset first --->
									
										<cf_GledgerEntryHeader
											    DataSource            = "#attributes.Datasource#"
												Mission               = "#LedgerBase.Mission#"			
												Journal               = "#Journal.Journal#" 
												Description           = "Stock Correction"
												TransactionSource     = "AssetSeries"
												TransactionCategory   = "Inventory"			
												MatchingRequired      = "0"
												Reference             = "Warehouse"       
												ReferenceName         = "Overbooking GL Account"
												ReferenceId           = "#LedgerBase.AssetId#"
												ReferenceNo           = ""
												DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
												DocumentAmount        = "#LedgerValue#"
												AmountOutstanding     = "0">
										
											<!--- Lines --->
																					 
											<cf_GledgerEntryLine
											    DataSource            = "#attributes.Datasource#"
												Lines                 = "2"
												Journal               = "#Journal.Journal#"
												JournalNo             = "#JournalTransactionNo#"					
												Currency              = "#APPLICATION.BaseCurrency#"
																	
												TransactionSerialNo1  = "1"
												Class1                = "Debit"
												ReferenceId1          = "#LedgerBase.AssetId#"
												Description1          = "Asset overbooking for master item change"		
												Reference1            = "Overbooking"       
												ReferenceName1        = "Overbooking"					
												GLAccount1            = "#newaccount#"										
												TransactionType1      = "Standard"
												Amount1               = "#LedgerValue#"
													
												TransactionSerialNo2  = "2"
												Class2                = "Credit"
												ReferenceId2          = "#LedgerBase.AssetId#"
												Description2          = "Asset overbooking for master item change"											
												Reference2            = "ContraAccount"       
												ReferenceName2        = "Account Correction"					
												GLAccount2            = "#GLAccount#"					
												TransactionType2      = "Contra-Account"
												Amount2               = "#LedgerValue#">	
												
										</cfloop>	
										
										<!--- 2. Then book for the overall difference --->
																												
										<cf_GledgerEntryHeader
											    DataSource            = "#attributes.Datasource#"
												Mission               = "#LedgerBase.Mission#"			
												Journal               = "#Journal.Journal#" 
												Description           = "Stock Correction"
												TransactionSource     = "AssetSeries"
												TransactionCategory   = "Inventory"			
												MatchingRequired      = "0"
												Reference             = "Warehouse"       
												ReferenceName         = "Correction of Stock GL Account"
												ReferenceId           = "#LedgerBase.AssetId#"
												ReferenceNo           = ""
												DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
												DocumentAmount        = "#diff#"
												AmountOutstanding     = "0">
										
											<!--- Lines --->
																					 
											<cf_GledgerEntryLine
											    DataSource            = "#attributes.Datasource#"
												Lines                 = "2"
												Journal               = "#Journal.Journal#"
												JournalNo             = "#JournalTransactionNo#"					
												Currency              = "#APPLICATION.BaseCurrency#"
																	
												TransactionSerialNo1  = "1"
												Class1                = "Debit"
												ReferenceId1          = "#LedgerBase.AssetId#"
												Description1          = "Asset Value Correction"		
												Reference1            = "Overbooking"       
												ReferenceName1        = "Overbooking"					
												GLAccount1            = "#newaccount#"										
												TransactionType1      = "Standard"
												Amount1               = "#diff#"
													
												TransactionSerialNo2  = "2"
												Class2                = "Credit"
												ReferenceId2          = "#LedgerBase.AssetId#"
												Description2          = "Asset Value correction"											
												Reference2            = "ContraAccount"       
												ReferenceName2        = "Account Correction from Source"					
												GLAccount2            = "#GLCorrection.GLAccount#"					
												TransactionType2      = "Contra-Account"
												Amount2               = "#diff#">	
											
									</cfif>	
									
							
								
								   
												
						</cfif>
					
											
				</cfoutput>		
											
				<!--- -------------------- This applies to a general cleanup----- ---------------------------------- --->
				<!--- Any ledger bookings for supplies that do not have a tracable value in ItemTransaction anymore  --->
				<!--- ---------------------------------------------------------------------------------------------- --->	
				<!--- -------define any value of the GL account for the balance account in journal : Warehouse------ --->
				
						
					<cfquery name="Missing" 
						datasource="#attributes.Datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    L.GLAccount, 
							          SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit) AS Value
							FROM      Accounting.dbo.TransactionHeader H 
									  INNER JOIN
					                  Accounting.dbo.TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
									  INNER JOIN
							          Accounting.dbo.Ref_Account R ON L.GLAccount = R.GLAccount 
									  INNER JOIN
							          Accounting.dbo.Journal J ON L.Journal = J.Journal
							WHERE     R.StockAccount = '1' 
							AND       J.SystemJournal IN ('Warehouse','Asset')					
							AND       H.Mission = '#mission#'
												
							AND       NOT EXISTS (
																<!--- account no longer has a value exists in the materials reality but does have a value in GL --->
																SELECT    R.GLAccount
																FROM      ItemTransaction IT INNER JOIN
																          Item I ON IT.ItemNo = I.ItemNo INNER JOIN
																          Ref_CategoryGledger R ON I.Category = R.Category AND R.Area = 'Stock'
																WHERE 
																		R.GlAccount = L.GLAccount 
																GROUP BY R.GLAccount
																HAVING      (SUM(IT.TransactionValue) > 0)
														)
												
							AND   NOT EXISTS (SELECT AssetId FROM Materials.dbo.AssetItem WHERE AssetId = L.ReferenceId)				
							<!--- important, do not change source !!!! --->
							AND       L.TransactionType <> 'Contra-Account'				
							GROUP BY  L.GLAccount  
							HAVING abs(SUM(L.AmountBaseDebit) - SUM(L.AmountBaseCredit)) > 0 
					</cfquery>
								
					<cfset mis = mission>
					
					<cfloop query="Missing">
					
						<!--- transaction for difference --->
						
						<cfif abs(Value) gte 1>
						
						<cf_GledgerEntryHeader
						    DataSource            = "#attributes.Datasource#"
							Mission               = "#Mis#"			
							Journal               = "#Journal.Journal#" 
							Description           = "Stock Correction"
							TransactionSource     = "WarehouseSeries"
							TransactionCategory   = "Inventory"			
							MatchingRequired      = "0"
							Reference             = "Warehouse"       
							ReferenceName         = "Account not in source"
							ReferenceId           = ""
							ReferenceNo           = ""
							DocumentCurrency      = "#APPLICATION.BaseCurrency#"			
							DocumentAmount        = "#value#"
							AmountOutstanding     = "0">
						
							<!--- Lines --->
																	 
							<cf_GledgerEntryLine
							    DataSource            = "appsMaterials"
								Lines                 = "2"
								Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"					
								Currency              = "#APPLICATION.BaseCurrency#"
													
								TransactionSerialNo1  = "1"
								Class1                = "Credit"
								Reference1            = "Stock Correction"       
								ReferenceName1        = "Empty account"	
								Description1          = "Account no longer used"				
								GLAccount1            = "#GLAccount#"										
								TransactionType1      = "Standard"
								Amount1               = "#value#"
									
								TransactionSerialNo2  = "2"
								Class2                = "Debit"
								Reference2            = "ContraAccount"       
								ReferenceName2        = "Account Correction from Source"					
								GLAccount2            = "#GLCorrection.GLAccount#"					
								TransactionType2      = "Contra-Account"
								Amount2               = "#value#">
								
						</cfif>			
						
					</cfloop>
									
							
			</cfoutput>	
			
		</cfloop>	
			
	</cfif>

</cfif>	
