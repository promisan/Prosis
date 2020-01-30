
<!--- retrieve the data to be shown --->

<cfif url.currency eq "">
	<cfset curr = Application.BaseCurrency>	
<cfelse>
	<cfset curr = url.currency>
</cfif>

<cfif isDefined("SearchResult")>
	<cfset session["rowsSelected_#url.account#"] = quotedvalueList(SearchResult.TransactionLineId)>
</cfif>

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
	<cfelse>		
		<cfinclude template="AccountResultListingStandard.cfm">				
	</cfif>
	
	 <!--- excel export feature reload field --->
	
	 <!--- capture the screen result to allow for identical excel export --->
	 <cfset lines = quotedValueList(SearchResult.TransactionLineId)>
	 
	 <cfoutput>
	 <script>	 
	    try {
		 document.getElementById('fieldselectedid').value = "#lines#"} catch(e) {}
	 </script>
	 </cfoutput>

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
	
<cfif url.mode eq "Print">

	 <script>
	    window.print()
	 </script>
	
	<cfquery name="Group"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_AccountGroup 
		WHERE  AccountGroup = '#Account.AccountGroup#'
	</cfquery>
	
	<table width="700">
	<tr>
		<td height="30" class="labelmedium" style="padding-left:15px">;
		<cfoutput query="Account">#AccountClass#:&nbsp;</b>#Group.Description#&nbsp;#GLAccount#: #Description#</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	</table>

</cfif>

<cfif searchresult.recordcount eq "0">

	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0">
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
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td style="padding:8px">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

	<cfoutput>
			
		<tr class="labelmedium line">
		    <td style="min-width:40px"></td>
			<TD style="min-width:100px"><cf_tl id="Journal"></TD>
		    <TD style="min-width:130px"><cf_tl id="TraNo"></TD>
			<TD width="100%"><cf_tl id="Reference"></TD>
			
			<cfif URL.ID neq "Transaction">
			
				<cfif url.id neq "Created">
				<TD style="min-width:100px"><cf_tl id="Date"></TD>
				<cfelse>
				<TD style="min-width:100px"><cf_tl id="Posted"></TD>
				</cfif>
				
			<cfelse>
			
				<TD style="min-width:100px"><cf_tl id="Date"></TD>
				<TD style="min-width:100px"><cf_tl id="Posted"></TD>		
					
			</cfif>	
		    <TD style="min-width:60px"><cf_tl id="Curr"></TD>
			<td style="min-width:100px" align="right"><cf_tl id="Debit"></td>
			<td style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Credit"></td>
			<td style="min-width:96px;border-top:1px solid silver;border-left:1px solid silver;padding-right:2px" bgcolor="yellow" align="right"><cf_tl id="Debit"> #curr#</td>
			<td style="min-width:96px;border-left:1px dotted silver;border-top:1px solid silver;border-right:1px solid silver;padding-right:4px" bgcolor="yellow" align="right"><cf_tl id="Credit"> #curr#</td>
			<cfif URL.ID neq "Transaction">
				<td style="min-width:100px;" align="right"><cf_tl id="EoD Balance"></td>			
			</cfif>
			<td style="min-width:36px;"></td>
		</TR>
				
	 </cfoutput>
	
	<tr><td width="100%" colspan="14" style="padding:6px">
	
	    <cf_divscroll overflowy="scroll">
	
		<table width="99%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
					
			<cfoutput>
			
				<tr style="height:1px">
				    <td style="min-width:30px"></td>
					<TD style="min-width:100px"></TD>
				    <TD style="min-width:130px"></TD>
					<TD width="100%"></TD>						
					<TD style="min-width:100px"></TD>					
				    <TD style="min-width:60px"></TD>
					<td style="min-width:100px"></td>
					<td style="min-width:100px"></td>
					<td style="min-width:100px"></td>
					<td style="min-width:100px"></td>
					<cfif URL.ID neq "Transaction">
					<td style="min-width:100px"></td>
					</cfif>				
				</TR>
										
			</cfoutput>
					
			<cfif Searchresult.recordcount eq "0">
				<tr>
				   <td style="padding-top:10px"
				       colspan="11" 
					   align="center" 
					   class="labelmedium"><font color="FF0000"><cf_tl id="No transactions found to show in this view"></td>
				 </tr>	
			</cfif>
			
			<cfset row = 0>
			<cfset grp = 1>
			
			<cfset rows = 1500>
			<cfset first   = ((URL.Page-1)*rows)+1>
			<cfset pages   = Ceiling(SearchResult.recordCount/rows)>
			
			<cfif pages lt '1'>
			   <cfset pages = '1'>
			</cfif>
				 
			 <cfif url.id eq "Transaction">
			   <cfset group = "JournalTransactionNo">
			 <cfelseif url.id eq "Created">
			   <cfset group = "CreatedInt">
			 <cfelseif url.id eq "DocumentDate">
			   <cfset group = "DocumentDate">  
			  <cfelseif url.id eq "TransactionPeriod">
			   <cfset group = "HeaderTransactionPeriod">    
			 <cfelseif url.id eq "JournalTransactionNo">			 
			   <cfset group = "TransactionDate">  
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
									 												
			<cfoutput query="SearchResult" group="#group#" startrow="#first#">
											
			  <cfset amtD   = 0>
			  <cfset amtC   = 0>
			  <cfset refi   = "referenceid">
							
			  <cfswitch expression = "#URL.ID#">
				 
				 <cfcase value = "TransactionType">
				 <tr>
				     <td colspan="11" class="labelmedium" style="height:35;padding-left:3px">#TransactionType#</td> 
				 </tr>			 
			     </cfcase>							 					
				 
			  </cfswitch>
			     
				  <cfoutput>	
				  
				  	  <!---
					
					  <cfif url.id eq "JournalTransactionNo">	
				
						  <cfif referenceid neq refi and amtD gt "0">
							  <tr><td height="4"></td></tr>
						  </cfif>							
						  
					  </cfif>
					  
					  --->
													
					  <cfif currentrow-first lt rows>
									
					    <tr id="r#currentrow#" class="navigation_row labelmedium line" style="height:15px">													
					    
						<td align="center">#currentrow#</td>
						
						<TD style="padding-left:4px">
						
							<table cellspacing="0" cellpadding="0">
							
								<tr class="labelmedium" style="height:15px">
								
									<td>#Journal#</td>
									
									<td></td>
									
									<td style="padding-left:4px;padding-right:4px">
									
									<cfif url.mde neq "JournalTransactionNo">
									
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
						
						<TD class="navigation_action" style="cursor: pointer;padding-left:4px">
						
							<cfif url.mde eq "JournalTransactionNo">
							
							#JournalTransactionNo#
							
							<cfelse>
							
							<a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')">
							 			  
							    <cfif TransactionReference neq "">
									#TransactionReference#
								<cfelse>
									#JournalTransactionNo#
								</cfif>
							  
							 </a> 
							 
							 </cfif>
							
						</TD>
							
						<td style="word-break: break-all; word-wrap: break-word;">
						
							<cfif url.mde eq "Transaction">
								
									#Description#
									
							<cfelseif url.mde eq "JournalTransactionNo">
								
									#DescriptionHeader#	
										
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
							
						</td>
							
						<cfif abs(AmountBaseDebit-AmountBaseCredit) gte 0.01 and url.id eq "Transaction">
							<cfset t = "<b><font color='FF0000'>">
						<cfelse>
							<cfset t = "">
						</cfif>
												
						<cfif URL.ID neq "Transaction">
						
							<cfif url.id neq "Created">
							<TD></TD>
							<cfelse>
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
						<td align="right" style="padding-right:4px">#t##NumberFormat(AmountCredit,',.__')#</td>							
						<td style="border-left:1px solid silver;padding-right:2px" bgcolor="ffffcf" align="right">#t##NumberFormat(AmountBaseDebit*DateExchangeRate,',.__')#</td>	
						<td style="border-left:1px solid silver;border-right:1px dotted silver;border-right:1px solid silver;padding-right:4px" align="right" bgcolor="ffffcf">#t##NumberFormat(AmountBaseCredit*DateExchangeRate,',.__')#</td>	

						<cfif URL.ID neq "Transaction">		    
							<td align="right"></td>
						</cfif>
													
						<cfif AmountBaseDebit is not "">
					    	<cfset AmtD = AmtD + AmountBaseDebit*DateExchangeRate>
							<cfset RunD = RunD + AmountBaseDebit>
						</cfif> 
					
						<cfif AmountBaseCredit is not "">
					        <cfset AmtC  = AmtC + AmountBaseCredit*DateExchangeRate>		
							<cfset RunC  = RunC + AmountBaseCredit>
						</cfif>	
						
					    </TR>
						
						<tr class="hide" id="row#currentrow#">
							<td colspan="2"></td>
							<td colspan="5">
								<cfdiv id="box#currentrow#">							
							</td>
						</tr>	
						
															
					  </cfif>	
					  
					  <cftry>				  
					  <cfset refi = ReferenceId>
					  <cfcatch></cfcatch>
					  </cftry>
					  
					  <cfset exch = DateExchangeRate>
					
				 </cfoutput>	 
				 
				 <!--- ------------------------------------ --->
				 <!--- show running balances for each date  --->
				 <!--- ------------------------------------ --->		 		
				 		 		 				 				 
				 <cfif URL.ID eq "TransactionPeriod" 				    
				    or URL.ID eq "TransactionDate" 
					or URL.ID eq "DocumentDate" 
					or URL.ID eq "Created">
				 
					    <cfif currentrow-first lte rows or grp eq "1"> 
										
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
															
								    <td colspan="1" bgcolor="ffffff" style="min-width:200px;border-left:1px solid gray;padding-left:10px;border-bottom:1px solid gray">													
																		
									<cfif findNoCase("transactionperiod", group)>		
									   #evaluate(group)#	
									   <cfset dte = "#dateformat(created,CLIENT.DateFormatShow)#">							  									  								    
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
															
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;border-bottom:solid gray 1px;padding-right:10px">#NumberFormat(RunD/exch,',.__')#</td>							
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;border-bottom:solid gray 1px;padding-right:10px">#NumberFormat(RunC/exch,',.__')#</td>	
										
									<td align="right" bgcolor="#cl#" style="border-left:solid silver 1px;padding-right:4px;border-top:solid gray 0px;border-bottom:solid gray 1px" class="labelit">
									
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
																	
							    </TR>
								
							</cfif>	
								
							</cfloop>	
																	
							<cfset grp = 0>
						
						</cfif>
									
					</cfif>
								
			</cfoutput>
					
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
			
			
			
		</TABLE>
		
	  </cf_divscroll>	
		
	</td>
	
	</tr>
	
	<!--- -------------- --->
	<!--- overall totals --->
	<!--- -------------- --->
	
    <cfset exch = exc>		
					
	<cfquery name="Total"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT sum(AmountDebit)      as Debit, 
		       sum(AmountCredit)     as Credit,		
			   sum(AmountBaseDebit)  as DebitBase, 
		       sum(AmountBaseCredit) as CreditBase,		
			   sum(AmountBaseDebit-AmountBaseCredit) as Balance 
		FROM   TransactionLine T, TransactionHeader J
		WHERE  T.GLAccount = '#URL.Account#'
		
		<cfif Category.recordcount eq "1">
		
			AND   J.Journal IN (SELECT Journal 
			                    FROM   Journal 
							    WHERE  GLCategory = '#URL.GLCategory#') 
		</cfif>
					
		<cfif url.find neq "">
			AND    (J.JournalTransactionNo LIKE '%#url.find#%' 
						OR J.JournalSerialNo LIKE '%#url.find#%'
						OR J.TransactionReference  LIKE '%#url.find#%'
						OR J.Description LIKE '%#url.find#%'
						OR J.ReferenceName LIKE '%#url.find#%' )
 
		</cfif>
		
		<cfif url.class eq "Debit">
			AND    T.AmountDebit > 0
		<cfelseif url.class eq "Credit">
			AND    T.AmountCredit > 0
		</cfif>
		
		<!---RFUENTES 21/5/2015 adding: CC for the accounts that are Result Class  ---->
			<cfif url.costcenter neq "All">
			AND	   T.OrgUnit IN ('#URL.costcenter#')			
			</cfif>
					
		<cfif url.pap neq "">
		
	    	<cfif GLaccount.accountclass eq "Result">
			    AND  J.TransactionPeriod = '#url.pap#'
			<cfelse>
			    AND  J.TransactionPeriod <= '#url.pap#'
			</cfif> 
			
        </cfif>
		
		<cfif URL.Period neq "All">
		AND    T.AccountPeriod = '#URL.Period#'
		<cfelse>
		AND    J.Journal IN (SELECT Journal FROM Journal WHERE SystemJournal != 'Opening' or SystemJournal is NULL) 
	    </cfif>
		AND    T.Journal = J.Journal and T.JournalSerialNo = J.JournalSerialNo
		AND    J.Mission = '#URL.Mission#'
		<!--- ARMIN 13/JAN/2016 only valid transactions ----->
		AND J.RecordStatus    = '1'
		AND J.ActionStatus IN ('0','1')
		
	</cfquery>				
						
	<cfoutput>   
	  
	  <TR bgcolor="fafafa" style="border-top:1px solid silver" class="line labelmedium">	  
	    <cfif URL.ID neq "Transaction"> 
	    <td colspan="6" style="padding-left:5px" height="22"><cf_tl id="Total">:</td>
	    <cfelse>
		<td colspan="7" style="padding-left:5px" height="22"><cf_tl id="Total">:</td>
	    </cfif>				
		<td></td>
		<td></td>			
		<td style="border-bottom:1px solid silver;border-left:1px solid silver;padding-right:2px" bgcolor="yellow" align="right" width="10%">
		#NumberFormat(total.DebitBase/exch,',__.__')#
		</td>	
		<td style="border-left:1px dotted silver;border-bottom:1px solid silver;border-right:1px solid silver;padding-right:4px" bgcolor="yellow" align="right" width="10%">
		#NumberFormat(total.CreditBase/exch,',__.__')#
		</td>	
		
		<cfif URL.ID neq "Transaction"> 
		<td align="right" bgcolor="80FF80" style="padding-right:4px">
			<cfif total.balance gte 0>
			<cfif Account.accounttype eq "Credit">			
				<font color="FF0000">
			</cfif>
			#NumberFormat(total.balance/exch,',.__')#
			<cfelse>
			<cfif Account.accounttype eq "Debit">			
				<font color="FF0000">
			</cfif>
			<cfif total.balance neq "">
			#NumberFormat(abs(total.balance/exch),',.__')#</b>
			</cfif>
			</font>
			</cfif>
		</td>	
		</cfif>
		<td></td>
	  </TR>
	  
	  </cfoutput>
		
	</table>
	</td></tr>
	</table>
		
</cfif>	
	
<cfif url.mode neq "Print">

	<cfoutput>
		<script>		    
			ColdFusion.navigate('AccountResultPage.cfm?page=#url.page#&records=#SearchResult.recordCount#','pagebox')
		</script>
	</cfoutput>
	
	<cfset AjaxOnLoad("doHighlight")>	
	
</cfif>