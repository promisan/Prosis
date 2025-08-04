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


<!--- retrieve the data to be shown --->

<cfif url.currency eq "">
	<cfset curr = Application.BaseCurrency>	
<cfelse>
	<cfset curr = url.currency>
</cfif>

<!--- no longer needed we work with temp tables
<cfif isDefined("SearchResult")>
	<cfset session["rowsSelected_#url.account#"] = quotedvalueList(SearchResult.TransactionLineId)>
</cfif>
--->

<cftry>

	<cfsilent>
	<cfoutput>#searchresult.recordcount#</cfoutput>
	</cfsilent>
				
<cfcatch>

	<!--- refresh the content --->	
							
	<cfquery name="Category" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_GLCategory
		WHERE  GLCategory = '#URL.GLCategory#'
	</cfquery>	
					
	<cfif url.mde eq "Transaction">	
		<cfinclude template="AccountResultListingCompress.cfm">		
	<cfelseif url.mde eq "JournalTransactionNo">			    	
		<cfinclude template="AccountResultListingAggregate.cfm">							
	<cfelse>		<!--- posting --->		
		<cfinclude template="AccountResultListingStandard.cfm">				
	</cfif>
			 	
		 
</cfcatch>

</cftry>


<cfquery name="Account"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Account G
		WHERE  G.GLAccount = '#URL.Account#'
</cfquery>

<cfif searchresult.recordcount eq "0">

	<cfoutput>
	<table width="100%">
	<tr><td align="center" class="labelit" bgcolor="ffffcf"><cf_tl id="No records to be shown in this view"></td></tr>
	</table>
	</cfoutput>

<cfelse>
	
	<cfquery name="Category" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_GLCategory
		WHERE  GLCategory = '#URL.GLCategory#'
	</cfquery>
	
	<table width="100%" height="100%">
	
	<tr><td>
	
	<table width="100%" height="100%">
		 
	<!--- get opening journal ---> 
	
	<cfquery name="OpeningJournal"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  Journal 
		FROM    Journal 
		WHERE   Mission = '#URL.Mission#'
		AND     SystemJournal = 'Opening'
	 </cfquery>	
	 
	 <!--- optain query the overall totals for opening and closing to be shown 
	 technicallyt the same query condition as for the details but aggregated by journal and period --->
	 		 						
	<cfquery name="Totals"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
	    SELECT T.Journal,
			   <cfif GLaccount.accountclass eq "Result">
		       T.TransactionPeriod,
			   <cfelse>
			   J.TransactionPeriod,
			   </cfif>
		       SUM(AmountDebit)                as Debit, 
		       SUM(AmountCredit)               as Credit,		
			   ISNULL(sum(AmountBaseDebit),0)  as DebitBase, 
		       ISNULL(sum(AmountBaseCredit),0) as CreditBase,		
			   sum(AmountBaseDebit-AmountBaseCredit) as Balance 
			   
		FROM   TransactionLine T INNER JOIN TransactionHeader J ON T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
		WHERE  T.GLAccount = '#URL.Account#'
		
		AND    J.Mission = '#URL.Mission#'
		<!--- ARMIN 13/JAN/2016 only valid transactions ----->
		AND    J.RecordStatus  = '1'
		AND    J.ActionStatus IN ('0','1')
		
		<cfif Category.recordcount eq "1">
		
			AND   J.Journal IN (SELECT Journal 
			                    FROM   Journal 
								WHERE  Journal = J.Journal
								AND    JournalType = 'General' 
							    AND    GLCategory = '#URL.GLCategory#') 
		</cfif>
		
		<!--- show totals, not the filtering here
									
		<cfif url.find neq "">
			AND    (J.JournalTransactionNo         LIKE '%#url.find#%' 
						OR J.JournalSerialNo       LIKE '%#url.find#%'
						OR J.TransactionReference  LIKE '%#url.find#%'
						OR J.Description           LIKE '%#url.find#%'
						OR J.Journal               LIKE '%#url.find#%'
						OR J.ReferenceName         LIKE '%#url.find#%' )
 
		</cfif>
		
		--->
						
		<cfif url.class eq "Debit">
			AND    T.AmountDebit > 0
		<cfelseif url.class eq "Credit">
			AND    T.AmountCredit > 0
		</cfif>
				
		<cfif url.owner neq "All" and url.owner neq "" and url.owner neq "undefined" and curPeriod.AdministrationLevel neq "Tree">
		AND	   J.OrgUnitOwner IN ('#URL.owner#')			
		</cfif>
				
		<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
		<cfif url.costcenter neq "All" and url.costcenter neq "" and url.costcenter neq "undefined">
			AND	   T.OrgUnit IN ('#URL.costcenter#')			
		</cfif>
		
		<cfif URL.Period neq "All">
			AND    J.AccountPeriod = '#URL.Period#'
		<cfelse>
			AND    J.Journal IN (SELECT Journal FROM Journal WHERE Journal = J.Journal AND SystemJournal != 'Opening' or SystemJournal is NULL) 
	    </cfif>
					
		<cfif url.pap neq "">
		
	    	<cfif GLaccount.accountclass eq "Result">
			AND  T.TransactionPeriod = '#url.pap#'
			<cfelse>
			<!--- economical period --->
			AND  J.TransactionPeriod <= '#url.pap#'
			</cfif> 			
			
        </cfif>		
		
		GROUP BY T.Journal,
			  <cfif GLaccount.accountclass eq "Result">
		       T.TransactionPeriod
			   <cfelse>
			   J.TransactionPeriod
			   </cfif>			
		
	</cfquery>	
	
						
	<cfquery name="Opening" dbtype="query">
		SELECT SUM(Debit)                as Debit, 
		       SUM(Credit)               as Credit,		
			   SUM(DebitBase)            as DebitBase, 
		       SUM(CreditBase)           as CreditBase,		
			   SUM(DebitBase-CreditBase) as Balance 
		FROM   Totals
		<cfif url.pap neq "">
		WHERE  TransactionPeriod < '#url.pap#'
		<cfelseif OpeningJournal.recordcount gte "1">
		WHERE  Journal IN (#quotedvalueList(OpeningJournal.Journal)#)
		</cfif>
	</cfquery>		
	
	<cfif Opening.recordcount eq "0">
	
		<cfquery name="Opening" dbtype="query" >
			SELECT SUM(Debit)                as Debit, 
			       SUM(Credit)               as Credit,		
				   SUM(DebitBase)            as DebitBase, 
			       SUM(CreditBase)           as CreditBase,		
				   SUM(DebitBase-CreditBase) as Balance 
			FROM   Totals
			<cfif OpeningJournal.recordcount gte "1">
			WHERE  Journal IN (#quotedvalueList(OpeningJournal.Journal)#)	
			<cfelse>
			WHERE 1=0
			</cfif>	
		</cfquery>	
		
	</cfif>
		
	<!--- we take the current exchange rate --->
			
		    <!---
			
			<cfif url.date neq "">
					
				<cfset dateValue = "">
				<CF_DateConvert Value="#url.date#">			
				<cfset DTE = dateValue>
				<cf_ExchangeRate EffectiveDate="#url.date#" CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#curr#">
			
			<cfelse>
			
			--->
			
			<cfset dateValue = "">
				<CF_DateConvert Value="#dateformat(now(),CLIENT.DateFormatShow)#">
				<cfset DTE = dateValue>		
				
			<cf_ExchangeRate EffectiveDate="#dateformat(now(),CLIENT.DateFormatShow)#"
			     CurrencyFrom="#Application.BaseCurrency#" 
				 CurrencyTo="#curr#">
					
			<!---
			</cfif>
			--->	 
			
            <cfset exch = exc>	
			
	<tr><td width="100%" colspan="14">
	
	    <cf_divscroll overflowy="scroll">
	
		<table width="99%" class="navigation_table">
		
			<cfoutput>
			
			<!--- 1 - 3 main detail content --->
			
			<cfif opening.recordcount gte "1">
	
			    <TR class="line labelmedium2 fixrow" style="background-color:e4e4e4;height:25px">	
			    
			  	<td colspan="7" style="width:100%;padding-left:5px">
								
				  <table>
				  <tr>
										 					
					  <cfinvoke component="Service.Analysis.CrossTab"  
							  method      = "ShowInquiry"
							  buttonClass = "td"									   						 
							  buttonText  = "Export Excel"						 
							  reportPath  = "GLedger\Application\Lookup\"
							  SQLtemplate = "AccountResultExcel.cfm"
							  querystring = "id=#url.mde#&account=#URL.Account#"
							  filter      = ""						  
							  dataSource  = "appsQuery" 
							  module      = "Accounting"						  
							  reportName  = "Execution Report"
							  table1Name  = "Ledger Transactions"						 		
							  data        = "1"
							  ajax        = "0"				 
							  olap        = "0" 
							  excel       = "1"> 	
										
				</tr>
				</table>			
				</td>		 
				<td align="right" style="padding-right:5px"><cf_tl id="Opening">#url.pap#</td>		   													
				<td style="min-width:100px;border-bottom:1px solid silver;border-left:1px solid silver;padding-right:2px" bgcolor="yellow" align="right">
				#NumberFormat(Opening.DebitBase/exch,',.__')#
				</td>	
				<td style="min-width:100px;border-left:1px dotted silver;border-bottom:1px solid silver;border-right:1px solid silver;padding-right:4px" bgcolor="yellow" align="right" width="10%">
				#NumberFormat(Opening.CreditBase/exch,',.__')#
				</td>	
				
				<cfif URL.mde neq "Transaction"> 
													
				<td align="right" bgcolor="80FF80" style="min-width:100px;padding-right:4px">
									
					<cfif opening.balance neq 0>
						<cfif Account.accounttype eq "Credit">			
							<font color="FF0000">
						</cfif>
					#NumberFormat(Opening.balance/exch,',.__')#
					<cfelse>
					<cfif Account.accounttype eq "Debit">			
						<font color="FF0000">
					</cfif>
					<cfif opening.balance neq "">
					#NumberFormat(abs(Opening.balance/exch),',.__')#</b>
					</cfif>
					</font>
					</cfif>
				</td>	
				<cfelse>
				<td></td>
				</cfif>
				<td></td>
								
			    </TR>	
			
			</cfif>
			
			<!--- 2 - 3 main detail content --->
																
			<tr class="labelmedium2 fixlengthlist line <cfif opening.recordcount gte "1">fixrow2<cfelse>fixrow</cfif>">
			
			<cfquery name="Opening" dbtype="query" >
				SELECT SUM(Debit)                as Debit, 
				       SUM(Credit)               as Credit,		
					   SUM(DebitBase)            as DebitBase, 
				       SUM(CreditBase)           as CreditBase,		
					   SUM(DebitBase-CreditBase) as Balance 
				FROM   Totals
				<cfif url.pap neq "">
				WHERE  TransactionPeriod < '#url.pap#'
				<cfelseif OpeningJournal.recordcount gte "1">
				WHERE  Journal NOT IN (#quotedvalueList(OpeningJournal.Journal)#)
				</cfif>
			</cfquery>
			
			    <td></td>
				<TD><cf_tl id="Journal"></TD>
			    <TD><cf_tl id="TraNo"></TD>
				<TD><cf_tl id="Reference"></TD>
				
				<cfif URL.mde neq "Transaction">
				
					<cfif url.id neq "Created">
						<TD style="min-width:100px"><cf_tl id="Date"></TD>
					<cfelse>
						<TD style="min-width:100px"><cf_tl id="Posted"></TD>
					</cfif>
					
				<cfelse>
				
					<TD><cf_tl id="Date"></TD>
					<TD><cf_tl id="Posted"></TD>		
						
				</cfif>	
				
			    <TD><cf_tl id="Curr"></TD>
				<td style="width:100px" align="right"><cf_tl id="Debit"></td>
				<td style="width:100px;padding-right:4px" align="right"><cf_tl id="Credit"></td>
				<td style="width:96px;border-left:1px solid silver;padding-right:2px" bgcolor="yellow" align="right"><cf_tl id="Debit"> #curr#</td>
				<td style="width:96px;border-left:1px dotted silver;border-right:1px solid silver;padding-right:4px" bgcolor="yellow" align="right"><cf_tl id="Credit"> #curr#</td>
				
				<cfif URL.mde neq "Transaction">
					<td style="width:100px;;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Running"></td>	
				<cfelse>
					<td style="min-width:0px;" align="right"></td>		
				</cfif>
				
				<cfif URL.mde eq "Posting"  and Account.BankId neq "" and url.aggregate eq "0">
				<td align="right"><cf_tl id="Note"></td>	
				<cfelse>
				   <td style="min-width:0px;" align="right"></td>		
				</cfif>
				
			</TR>
			
			 					
		 </cfoutput>	  
												
		 <cfif Searchresult.recordcount eq "0">
			<tr>
			   <td style="padding-top:10px" colspan="13" align="center" class="labelmedium2"><font color="FF0000"><cf_tl id="No transactions found to show in this view"></td>
			 </tr>	
		 </cfif>
						
		 <cfset grp = 1>
			
			<cfset rows = url.row>
			<cfset first   = ((URL.Page-1)*url.row)+1>
			<cfset pages   = Ceiling(SearchResult.recordCount/url.row)>
			
			<cfif pages lt '1'>
			   <cfset pages = '1'>
			</cfif>				 
			
			 <cfif url.id eq "Created">
			   <cfset group = "CreatedInt">
			 <cfelseif url.id eq "DocumentDate">
			   <cfset group = "DocumentDate">  
			  <cfelseif url.id eq "TransactionPeriod">
			   <cfset group = "TransactionPeriod">    			
			 <cfelse>
			   <cfset group = URL.ID>
			 </cfif>	
			 
			<cfset runD   = 0>
			<cfset runC   = 0>		
			
			<cfset ar   = ArrayNew(2)>		
					
			<!--- populate array --->
			
			<cfquery name="CurrList" dbtype="query">
					SELECT DISTINCT Currency
					FROM   SearchResult
			</cfquery>
		
			<cfloop query = "currlist">
			
				<cfparam name="ar[currentrow][1]" default="#currency#">				
				<cfparam name="ar[currentrow][2]" default="0">		
				<cfparam name="ar[currentrow][3]" default="0">	
					
			</cfloop>		
			
			<cfset srow = "0">			
			
			 <!--- runtime balance totals --->
			
			<!---					  
			<cfset AmtD = Opening.DebitBase>
			<cfset AmtC = Opening.CreditBase>
			--->
			<cfif Opening.DebitBase eq "" or url.pap eq "">
				<cfset RunD = "0">
			<cfelse>
				<cfset RunD = Opening.DebitBase>			
			</cfif>	
			
			<cfif Opening.CreditBase eq "" or url.pap eq "">
			    <cfset RunC = "0">
			<cfelse>
				<cfset RunC = Opening.CreditBase>
			</cfif>
																						
			<cfoutput query="SearchResult" group="#group#" startrow="#first#">
							 
			  <cfset refi   = "referenceid">
			 
										
			  <cfswitch expression = "#URL.ID#">
				 
				 <cfcase value = "TransactionType">
				 <tr>
				     <td colspan="13" class="labelmedium2" style="height:35;padding-left:3px">#TransactionType#</td> 
				 </tr>			 
			     </cfcase>							 					
				 
			  </cfswitch>
			     
				  <cfoutput>	
				   	  				  
				  	  <cfset srow = srow+1>
					  					  
					  <!--- runtime balance totals --->
					  					  					  
					  <cfif AmountBaseDebit is not "">
					    	<!--- <cfset AmtD = AmtD + AmountBaseDebit*DateExchangeRate> --->
							<cfset RunD = RunD + AmountBaseDebit>
					  </cfif> 
					
					  <cfif AmountBaseCredit is not "">
					        <!--- <cfset AmtC  = AmtC + AmountBaseCredit*DateExchangeRate>	--->
							<cfset RunC  = RunC + AmountBaseCredit>
					  </cfif>		
					  				  														
					  <cfif srow-first lt rows>									
					  
					    <tr id="r#currentrow#" class="navigation_row labelmedium2 line fixlengthlist" style="height:25px">																		    
						<td align="center">#currentrow#</td>						
						<TD style="padding-left:4px">
						
							<table>							
								<tr class="labelmedium" style="height:15px">								
									<td>#Journal#</td>									
									<td></td>									
									<td style="padding-left:4px;padding-right:4px">	
																																			
									<cfif url.mde neq "JournalTransactionNo" and url.aggregate eq "0">		
																
										<img src="#SESSION.root#/Images/arrow.gif" alt="" 
										id="box#currentrow#Exp" border="0" class="regular" 
										style="cursor: pointer;" 
										onClick="moreinfo('#journal#','#journalserialNo#','#glaccount#','box#currentrow#','row#currentrow#')" 
										align="absmiddle">		
																		
										<img src="#SESSION.root#/Images/ArrowDown.gif" 
										id="box#currentrow#Min" alt="" border="0" class="hide" 
										style="cursor: pointer;"
										onClick="moreinfo('#journal#','#journalserialNo#','#glaccount#','box#currentrow#','row#currentrow#')" 
										align="absmiddle">	
																			
									</cfif>		
																	
									</td>									
								</tr>								
							</table>						
						</TD>
						
						<TD class="navigation_action" style="cursor: pointer">
						
						    <cfif url.aggregate eq "0">
																					
								<cfif url.mde eq "JournalTransactionNo" or url.mde eq "Transaction">							
								#JournalTransactionNo#							
								<cfelse>	
								    					
								    <a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')">							 			  
								    <cfif TransactionReference neq "">#TransactionReference#<cfelse>#JournalTransactionNo#</cfif>
									</a> 
																 
								</cfif>
							
							<cfelse>
							
							#TransactionCategory#
							
							</cfif>
							
						</TD>
							
						<td colspan="2">	
						
						    <cfif url.aggregate eq "0">
												
								<cfif url.mde eq "Transaction">#Description#<cfelseif url.mde eq "JournalTransactionNo">#DescriptionHeader#										
								<cfelse>														
									    <cfif (memo eq ""  or memo eq "credit" or memo eq "debit" or memo eq "Contra-account") 
										   and (ReferenceName eq "" or ReferenceName eq "credit" or ReferenceName eq "debit" or referencename eq "Contra-account")>
												#DescriptionHeader#
										<cfelseif memo neq "" and memo neq "Contra-account">#Memo#
										<cfelseif referencename neq "" and referencename neq "Contra-account">#ReferenceName#
										<cfelse>
										
										<cfif ParentLineId neq "">	
														
												<cfquery name="Parent" 
												datasource="AppsLedger" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												    SELECT *
												    FROM TransactionLine
													WHERE TransactionLineId = '#ParentLineId#'
												</cfquery>
												#parent.memo#
												
										</cfif>			
										
									</cfif>
										
								</cfif>	
								
							<cfelse>
																
								#Reference#
							
							</cfif>	
							
						</td>
							
						<cfif abs(AmountBaseDebit-AmountBaseCredit) gte 0.01 and url.id eq "Transaction">
							<cfset t = "<b><font color='FF0000'>">
						<cfelse>
							<cfset t = "">
						</cfif>
												
						<cfif URL.mde neq "Transaction">
						
							<cfif url.id eq "Created">							
							<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
							</cfif>
							
						<cfelse>
							<TD>#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>
							<TD>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>	
						</cfif>	
						
						<cfloop query="currlist">
						
							<cfif ArrayFind(ar[currentrow], SearchResult.currency)>
							
								<cfset ar[currentrow][2] = ar[currentrow][2]+SearchResult.AmountDebit>
								<cfset ar[currentrow][3] = ar[currentrow][3]+SearchResult.AmountCredit>	
						       
							</cfif>   		
						
						</cfloop>									
											
					    <TD align="left">#SearchResult.Currency#</TD>
					    <td align="right">#t##NumberFormat(AmountDebit,',.__')#</td>	
						<td align="right">#t##NumberFormat(AmountCredit,',.__')#</td>							
						<td style="width:100px;border-left:1px solid silver;padding-right:3px;background-color:##ffffaf80" align="right">#t##NumberFormat(AmountBaseDebit*DateExchangeRate,',.__')#</td>	
						<td style="width:100px;border-left:1px solid silver;border-right:1px dotted silver;border-right:1px solid silver;padding-right:3px;background-color:##ffffaf80" align="right">#t##NumberFormat(AmountBaseCredit*DateExchangeRate,',.__')#</td>							
						<td align="right" style="width:100px;border-left:solid silver 1px;padding-right:4px;border-top:solid gray 0px"></td>

						<cfif URL.mde eq "Posting" and Account.BankId neq "" and url.aggregate eq "0">		    
							<td align="right" id="note_#Journal#_#JournalSerialNo#" style="padding-bottom:5px">
								<cf_annotationshow entity="GLTransaction" 
							         keyvalue4="#TransactionId#"
								     docbox="note_#Journal#_#JournalSerialNo#">		
							</td>
						<cfelse>
							<td></td>						
						</cfif>
						
					    </TR>
						
						<tr class="hide" id="row#currentrow#">
							<td colspan="2"></td>
							<td colspan="8"><cfdiv id="box#currentrow#"></td>
						</tr>						
															
					  </cfif>	
					  					  
					  <cftry>				  
					  <cfset refi = ReferenceId>
					  <cfcatch></cfcatch>
					  </cftry>
					  
					  <cfset exch = DateExchangeRate>
					
				 </cfoutput>	 
				 
				 <!--- ------------------------------------ --->
				 <!--- show running balances per date ----  --->
				 <!--- ------------------------------------ --->		 		
				 		 		 				 				 
				 <cfif URL.ID eq "TransactionPeriod" 				    
				    or URL.ID eq "TransactionDate" 
					or URL.ID eq "DocumentDate" 
					or URL.ID eq "Created">
														 
					    <cfif (srow-first lte rows or grp eq "1")> 
										
						    <cfloop index="row" from="1" to="#currlist.recordcount#">
							
							<cfif row gte "2">
												
								<TR class="labelmedium">								
									<td colspan="4" bgcolor="ffffff"></td>														
								    <td colspan="1" bgcolor="ffffff" style="height:17px;padding-left:10px;border-bottom:solid silver 1px"></td>									
									<td align="right" bgcolor="#cl#" colspan="1" style="font-size:12px;padding-right:3px;border-bottom:1px solid gray">#ar[row][1]#</td>
									<td align="right" bgcolor="#cl#" style="padding-right:3px;border-bottom:1px solid gray" colspan="1"><font color="808080">#NumberFormat(ar[row][2],',.__')#</td>
									<td align="right" bgcolor="#cl#" style="padding-right:3px;border-bottom:1px solid gray" colspan="1"><font color="808080">#NumberFormat(ar[row][3],',.__')#</td>																														
							    </TR>							
							
							<cfelse>
																		   				
							    <TR class="labelmedium">
								
									<td colspan="4" bgcolor="white"></td>														
									<cfset cl = "DAF9FC">																			
								    <td colspan="1" style="min-width:200px;border-left:1px solid gray;padding-left:10px;border-bottom:1px solid gray">																															
									<cfif findNoCase("transactionperiod", group)>		
									   #evaluate(group)#	
									   
									   <!--- --------------------- --->
									   <!--- RETHINK exchange rate --->
									   
									   <cfset mydte = createDate(left(transactionperiod,4),mid(transactionperiod,5,2),"01")>									   
									   <cfset dte = "#dateformat(mydte,CLIENT.DateFormatShow)#">		
										   					  									  								    
									<cfelseif findNoCase("date", group)>
									   #dateformat(evaluate(group),"#client.dateformatshow#")#
									   <cfset dte = "#dateformat(evaluate(group),CLIENT.DateFormatShow)#">						   
									<cfelse>											
									   #dateformat(created,"#client.dateformatshow#")#
									   <cfset dte = "#dateformat(created,CLIENT.DateFormatShow)#">				
									</cfif> 						
															
									<cfif curr eq Application.BaseCurrency>
					 
									 	<cfset exch = "1">
									 
									<cfelse>
									 
									 	<cf_ExchangeRate EffectiveDate="#dte#" CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#curr#">
										<cfset exch = exc>
										
										:#numberformat(1/exch,",.___")#
																 
									 </cfif>							 
															
									</td>
									
									<td align="right" bgcolor="#cl#" style="font-size:12px;padding-right:3px;border-bottom:1px solid gray" colspan="1">#ar[row][1]#</td>
									<td align="right" bgcolor="#cl#" style="padding-right:3px;border-bottom:1px solid gray" colspan="1"><font color="808080">#NumberFormat(ar[row][2],',.__')#</td>
									<td align="right" bgcolor="#cl#" style="padding-right:3px;border-bottom:1px solid gray" colspan="1"><font color="808080">#NumberFormat(ar[row][3],',.__')#</td>															
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;border-bottom:solid gray 1px;padding-right:3px">#NumberFormat(RunD/exch,',.__')#</td>							
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;border-bottom:solid gray 1px;padding-right:3px">#NumberFormat(RunC/exch,',.__')#</td>											
									
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;padding-right:4px;border-top:solid gray 0px;border-bottom:solid gray 1px">
																											
										<cfset run = (RunD-RunC) / exch>
									
									    <cfif run gte 0>
										
											<cfif Account.accounttype eq "Credit">			
											<font color="FF0000">
											</cfif>									
											#NumberFormat(run,',.__')#
											
										<cfelse>
										
											<cfif Account.accounttype eq "Debit">			
											<font color="FF0000">
											</cfif>
											#NumberFormat(abs(run),',.__')#</font>
											
										</cfif>			
											
									</td>		
									
									<td style="border-left:solid silver 1px;padding-right:4px;border-top:solid gray 0px;border-bottom:solid silver 1px"></td>				
																	
							    </TR>
								
							</cfif>	
								
							</cfloop>	
							
							<tr><td style="height:8px"></td></tr>
																	
							<cfset grp = 0>
						
						</cfif>
									
					</cfif>
								
			</cfoutput>			
		</TABLE>	
			
	  </cf_divscroll>	
		
	</td>
	
	</tr>
	
	<!--- closing balances --->
	
	<cfquery name="YTD" dbtype="query" >
			SELECT sum(Debit)                as Debit, 
			       sum(Credit)               as Credit,		
				   sum(DebitBase)            as DebitBase, 
			       sum(CreditBase)           as CreditBase,		
				   sum(DebitBase-CreditBase) as Balance 
			FROM   Totals
	</cfquery>		
	
	<cfoutput>
	
	<cfif ytd.recordcount gte "1">		
			 						
				  
		  <TR class="labelmedium2 fixlengthlist" style="height:29px;border:1px solid silver">	
		    
		  	<td style="width:100%;padding-left:5px">
			
			<table>
			<tr>
			
			  <!---
			  <cfset lines = quotedValueList(SearchResult.TransactionLineId)>
			  selectedid  = "#lines#"
			  --->			  
					 					
					  <cfinvoke component="Service.Analysis.CrossTab"  
							  method      = "ShowInquiry"
							  buttonClass = "td"									   						 
							  buttonText  = "Export Excel"						 
							  reportPath  = "GLedger\Application\Lookup\"
							  SQLtemplate = "AccountResultExcel.cfm"
							  querystring = "id=#url.mde#&account=#URL.Account#"
							  filter      = ""						  
							  dataSource  = "appsQuery" 
							  module      = "Accounting"						  
							  reportName  = "Execution Report"
							  table1Name  = "Ledger Transactions"						 		
							  data        = "1"
							  ajax        = "1"				 
							  olap        = "0" 
							  excel       = "1"> 	
									
			</tr>
			</table>			
			</td>		 
			<td align="right" style="min-width:160px;padding-right:5px"><cf_tl id="Closing">#url.pap#</td>		   													
			<td style="min-width:98px;border-bottom:1px solid silver;border-left:1px solid silver" bgcolor="yellow" align="right">
			#NumberFormat(ytd.DebitBase/exch,',.__')#
			</td>	
			<td style="min-width:98px;border-left:1px dotted silver;border-bottom:1px solid silver;border-right:1px solid silver" bgcolor="yellow" align="right" width="10%">
			#NumberFormat(ytd.CreditBase/exch,',.__')#
			</td>	
			
			<!---			
			<cfif URL.mde neq "Transaction"> 
			--->
												
			<td align="right" bgcolor="80FF80" style="min-width:100px">
								
				<cfif ytd.balance neq 0>
					<cfif Account.accounttype eq "Credit">			
						<font color="FF0000">
					</cfif>
				#NumberFormat(ytd.balance/exch,',.__')#
				<cfelse>
				<cfif Account.accounttype eq "Debit">			
					<font color="FF0000">
				</cfif>
				<cfif ytd.balance neq "">
				#NumberFormat(abs(ytd.balance/exch),',.__')#</b>
				</cfif>
				</font>
				</cfif>
			</td>	
			
			<!---
			<cfelse>
			<td></td>
			</cfif>
			--->
			
			<cfif URL.mde eq "Posting"  and Account.BankId neq "">
			<td style="min-width:24px"></td>
			<cfelse>
			<td style="min-width:10px"></td>
			</cfif>
			
		  </TR>	  
		  		  
	 </cfif>	
	
	</cfoutput>		
	
		
</cfif>	
	
<cfoutput>
	<script>		    
		_cf_loadingtexthtml='';
		Prosis.busy('no')
		ptoken.navigate('AccountResultPage.cfm?row=#url.row#&page=#url.page#&records=#SearchResult.recordCount#','pagebox')
	</script>
</cfoutput>
	
<cfset AjaxOnLoad("doHighlight")>	
	