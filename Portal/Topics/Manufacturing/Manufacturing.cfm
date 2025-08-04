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

<cfparam name="url.period" default="#year(now())#">
<cfparam name="url.mode"   default="Materials">

<cfquery name="Period"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT * FROM Period
		WHERE AccountPeriod = '#url.period#'
</cfquery>

<cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
	    FROM     Ref_ModuleControl
		WHERE    SystemModule  = 'Accounting' 
		AND      FunctionClass = 'Application' 
		AND      FunctionName  = 'Receivables'
</cfquery>  
		
<!--- manufacturing --->

<cfif url.mode eq "Materials">

	<table width="94%" align="center">
	
	<tr><td align="center" class="labelmedium">To be defined</td></tr>
	<!---
	<tr><td class="labelmedium">XXXXXX</td></tr>
	<tr><td class="labelmedium">XXXXXX</td></tr>
	<tr><td class="labelmedium">XXXXXX</td></tr>
	<tr><td class="labelmedium">XXXXXX</td></tr>
	--->
	
	</table>
	
<cfelse>

	<table width="94%" align="center">
	
		<cfoutput>
		<tr class="line">
		<td style="height:35px" class="labellarge"><cf_tl id="Sales"> #Application.BaseCurrency#</td>
		<cfif Period.PeriodDateEnd gte now()>
		<td width="20%" align="right" class="labelit"><cf_tl id="This Week"></td>
		</cfif>
		<td width="20%" align="right" class="labelit">#monthasstring(month(now()))#</td>
		<td width="20%" align="right" class="labelit">#url.period#</td>		
		</tr>
		</cfoutput>
			
		<cfloop index="itm" list="1,0">
									
			<cfoutput>
			
			<tr><td style="height:40px" class="labellarge" colspan="4"><b><cfif itm eq "1"><cf_tl id="Finished product"><cfelse>Other</cfif></b></td></tr>
			
			<cfloop index="set" list="Shipped,Billed,Settled">
			
				<cfif set neq "Settled">
				
					<cftransaction isolation="READ_UNCOMMITTED">
				
					 <cfquery name="SaleBase"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						SELECT   T.Warehouse, 
								 <cfif set eq "Shipped">
							 	 Year(T.TransactionDate)  as TransactionYear,
								 Month(T.TransactionDate) as TransactionMonth,  						 
						         T.TransactionDate, 
								 <cfelse>
								 Year(H.TransactionDate)  as TransactionYear,
								 Month(H.TransactionDate) as TransactionMonth,  						 
						         H.TransactionDate, 
								 </cfif>
								 <!---
								 T.ItemDescription, 
								 T.TransactionLot, 
								 T.TransactionQuantity, 
								 T.TransactionUoM, 
								 T.TransactionCostPrice, 
								 T.TransactionValue, 
				                 S.SalesCurrency, 
								 S.SalesPrice, 
								 S.SalesBaseAmount, 
								 S.SalesBaseTax, 
								 --->
								 SUM(S.SalesBaseTotal) as SalesBaseTotal 
								 <!---
								 T.WorkOrderId, 
								 T.WorkOrderLine, 
								 T.RequirementId
								 --->
						FROM     ItemTransaction T INNER JOIN
				                 ItemTransactionShipping S ON T.TransactionId = S.TransactionId INNER JOIN
				                 Ref_Category R ON T.ItemCategory = R.Category
								 <cfif set neq "Shipped">
								 INNER JOIN (
								 
								 		SELECT   TransactionId, TransactionDate
			                            FROM     Accounting.dbo.TransactionHeader IH
										WHERE    IH.Mission = '#url.mission#'
			                            AND      IH.TransactionDate >= '#dateformat(Period.PeriodDateStart,dateSQL)#'
										AND      IH.TransactionDate <= '#dateformat(Period.PeriodDateEnd,dateSQL)#'
										AND      IH.ActionStatus IN ('0','1')
										AND      IH.Recordstatus = '1'
										
										) H ON H.TransactionId = S.InvoiceId						 
								 
								 </cfif>
								 
						WHERE    T.Mission = '#url.mission#' 						
						AND      T.TransactionType = '2' 
						AND      R.FinishedProduct = '#itm#' 
						
						<cfif set eq "Shipped">
						AND      T.TransactionDate >= '#dateformat(Period.PeriodDateStart,dateSQL)#'
						AND      T.TransactionDate <= '#dateformat(Period.PeriodDateEnd,dateSQL)#'	
						</cfif>					
						<!--- not returned --->
						AND      T.TransactionId NOT IN
				                          (SELECT  ParentTransactionId
				                           FROM    Materials.dbo.ItemTransaction
				                           WHERE   ParentTransactionId = T.TransactionId 
										   AND     TransactionType = '3')
						GROUP BY T.Warehouse<cfif set eq "Shipped">,T.TransactionDate<cfelse>,H.TransactionDate</cfif>				   
					</cfquery>	
					
					</cftransaction>
										
					<cfquery name="Week" dbtype="query">
						SELECT SUM(SalesBaseTotal) as Sale
						FROM   SaleBase
						WHERE  TransactionDate >= '#now()-7#'
					</cfquery>				   	
				
					<cfquery name="Month" dbtype="query">
						SELECT SUM(SalesBaseTotal) as Sale
						FROM   SaleBase
						WHERE  TransactionMonth = #month(now())#
					</cfquery>		
					
					<cfquery name="Year" dbtype="query">	
						SELECT SUM(SalesBaseTotal) as Sale 
						FROM   SaleBase
					</cfquery>		
					
				<cfelse>
				
					<!--- settlements received for invoice issued --->
					
					<cftransaction isolation="READ_UNCOMMITTED">
				
					<cfquery name="SettleBase"
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT    H.Journal, 
							          H.JournalSerialNo, 
									  L.AccountPeriod, 
									  Year(L.TransactionDate)  as TransactionYear,
									  Month(L.TransactionDate) as TransactionMonth,
									  L.TransactionDate, 									
									  L.AmountBaseCredit-L.AmountBaseDebit as SettleBase, 
									  L.GLAccount, 
									  L.TransactionSerialNo
							FROM      TransactionLine L INNER JOIN
		                    		  TransactionHeader H ON L.ParentJournal = H.Journal AND L.ParentJournalSerialNo = H.JournalSerialNo
							WHERE     H.Mission = '#url.mission#' 
							AND       H.TransactionCategory = 'Receivables' 
							AND       L.TransactionSerialNo <> '0' 
							AND       EXISTS
							
				                          (SELECT     'X'
				                            FROM      Materials.dbo.ItemTransaction T INNER JOIN
				                                      Materials.dbo.ItemTransactionShipping S ON T.TransactionId = S.TransactionId INNER JOIN
				                                      Materials.dbo.Ref_Category R ON T.ItemCategory = R.Category
				                            WHERE     S.Journal         = H.Journal 
											AND       S.JournalSerialNo = H.JournalSerialNo 
											AND       T.Mission         = H.Mission 
											AND       T.TransactionType = '2'
											AND       R.FinishedProduct = '#itm#')
							<!--- settment date --->				
							AND      L.TransactionDate >= '#dateformat(Period.PeriodDateStart,dateSQL)#'
							AND      L.TransactionDate <= '#dateformat(Period.PeriodDateEnd,dateSQL)#'	
														
					</cfquery>	
					
															
					</cftransaction>
										
					<cfquery name="Week" dbtype="query">
						SELECT SUM(SettleBase) as Sale
						FROM   SettleBase
						WHERE  TransactionDate >= '#now()-7#'
					</cfquery>		
					
					<cfquery name="Month" dbtype="query">
						SELECT SUM(SettleBase) as Sale
						FROM   SettleBase
						WHERE  TransactionMonth = #month(now())#
					</cfquery>		
					
					<cfquery name="Year" dbtype="query">	
						SELECT SUM(SettleBase) as Sale 
						FROM   SettleBase
					</cfquery>					
				
				</cfif>	
							
				<tr><td class="labelmedium" style="padding-left:10px"><cf_tl id="#set#"></td>
					<cfif Period.PeriodDateEnd gte now()>
				    <td  style="padding-right:4px;border:1px solid silver" align="right" class="labelmedium">					
					<cfif Week.Sale eq "">--<cfelse>#numberformat(Week.Sale,"__,__.__")#</cfif></td>
					</cfif>
					<td  style="padding-right:4px;border:1px solid silver" align="right" class="labelmedium">
					<cfif Month.Sale eq "">--<cfelse>#numberformat(Month.Sale,"__,__.__")#</cfif></td>
					<td  style="padding-right:4px;border:1px solid silver" align="right" class="labelmedium">
					<cfif Year.Sale eq "">--<cfelse>#numberformat(Year.Sale,"__,__.__")#</cfif></td>
				</tr>
			
			</cfloop>
			
			</cfoutput>
								
		</cfloop>
		
				
		<cftransaction isolation="READ_UNCOMMITTED">
				
			<cfquery name="ARBase"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT     R.GLAccount, 
				           R.Description,
						   H.TransactionPeriod, <!--- new period --->
						   SUM(AmountBaseDebit-AmountBaseCredit) as AmountBase
				FROM       TransactionLine L INNER JOIN
			               Ref_Account R ON L.GLAccount = R.GLAccount INNER JOIN
			               TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
				WHERE      H.Mission            = '#url.mission#'   
				AND        H.AccountPeriod      = '#url.period#' 
				AND        H.ActionStatus IN ('0','1')
				AND        H.RecordStatus != '9'	
				
				AND        R.BankReconciliation = 1  		
				
				AND        R.AccountClass       = 'Balance' <!--- balance --->
				AND        R.AccountType        = 'Debit'   <!--- asset   --->
				AND        R.AccountCategory    IN ('Vendor','Neutral')
				
				GROUP BY   R.GLAccount, 
				           R.Description,
						   H.TransactionPeriod				   
						   
			</cfquery>	
					
		</cftransaction>
	
		<tr><td colspan="4">
					
			<cfquery name="AccountList"
	         dbtype="query">
			 SELECT    DISTINCT GLAccount, Description
			 FROM      ARBase
			</cfquery>	
			
			<cfquery name="PeriodList"
	         dbtype="query">
			 SELECT    DISTINCT TransactionPeriod
			 FROM      ARBase
			</cfquery>	
			
			<cfquery name="PeriodList"
	         dbtype="query">
			 SELECT    DISTINCT TransactionPeriod
			 FROM      ARBase
			</cfquery>	
				
			<table width="100%">		
			<cfoutput>
			<tr><td colspan="3" style="font-weight:24px;height:35px" class="labellarge">
			<a href="javascript:ptoken.open('#session.root#/Gledger/Inquiry/AP_AR/InquiryView.cfm?mode=AR&mission=#url.mission#&SystemFunctionId=#System.SystemFunctionId#','ar_#url.mission#')">
			<cf_tl id="Accounts Receivable">[<cf_tl id="Running Balance">]</a>
			</td></tr>
			</cfoutput>
			
			<tr><td style="padding-left:10px">
			
				<table width="100%">
				<tr  class="labelmedium2">				
				<td style="border:1px solid silver;padding-left:5px">Running balance</td>
				<cfoutput query="PeriodList">
					<td style="border:1px solid silver;padding:2px" align="center" width="70">#TransactionPeriod#</td>		
				</cfoutput>		
				</tr>		
					
				<cfoutput query="AccountList">
				<tr class="labelmedium2">
					<td style="border:1px solid silver;padding-left:5px">#GLAccount# #Description#</td>		
					<cfset acc = glaccount>							
					<cfloop query="PeriodList">						
					<td style="border:1px solid silver;padding-right:4px" align="right">			
						<cfquery name="Amount"
				         dbtype="query">
							 SELECT    SUM(AmountBase) as AmountBase
							 FROM      ARBase
							 WHERE     GLAccount         = '#acc#'
							 AND       TransactionPeriod <= '#transactionperiod#'
						</cfquery>					
						#numberformat(Amount.AmountBase,",")#			
					</td>					
					</cfloop>			
				</tr>		
				</cfoutput>
				
				</table>
			</td></tr>
						
			</table>
		
		</td></tr>
		
	</table>
		

</cfif> 