
<cfparam name="URL.ID1"      default="Journal">
<cfparam name="URL.find"     default="">
<cfparam name="URL.init"     default="No">
<cfparam name="URL.tax"      default="">
<cfparam name="URL.ijournal" default="">
<cfparam name="URL.period"   default="">
<cfparam name="URL.mode"     default="">

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#GledgerHeader_#client.sessionNo#
</cfquery>

<!--- check if the contract account for the payment is associated to a certain bank, this we can
use to filter payment transactions to this bank only  --->

<cfquery name="ActionBank"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Account
	WHERE  GLAccount = '#HeaderSelect.ContraGLAccount#' 
</cfquery>

<!--- sub query for payment order --->

<cfif url.init eq "Yes">

	<cfif url.mode eq "PO">
	
		<cfoutput>
	
		<cfsavecontent variable="Outstanding">
			
				<!--- --------------------------------------------------------------------------------------------------- --->
			    <!--- --- Payment order from an incoming Payable that need reconciliation one by one -------------------- --->
				<!--- --------------------------------------------------------------------------------------------------- --->
							
				SELECT   	<!--- payment order --->
				            L.TransactionLineId, 
				         	L.AmountDebit, 
						 	L.AmountCredit, 
							<!--- processed already reconciled details, 14/7 correction of currency as these will be in the same currency --->
						 	ISNULL(SUM(R.AmountDebit *R.ExchangeRate),0) AS RecDebit, 
						 	ISNULL(SUM(R.AmountCredit*R.ExchangeRate),0) AS RecCredit
													
				FROM     	TransactionLine L WITH(NOLOCK)
								LEFT OUTER JOIN TransactionLine R WITH(NOLOCK)  <!--- processed actions for payment records --->
									INNER JOIN Accounting.dbo.TransactionHeader TH1 WITH(NOLOCK)
										ON TH1.Journal = R.Journal
										AND TH1.JournalSerialNo = R.JournalSerialNo
										AND TH1.RecordStatus != '9'
										AND TH1.ActionStatus IN ('0','1')
				                      ON  R.ParentJournal         = L.Journal 
						              AND R.ParentJournalSerialNo = L.JournalSerialNo 
									  AND R.GLAccount             = L.GLAccount
									  <!--- link to the line of the payment order, does not apply for sales contract --->
									  AND R.ParentLineId          = L.TransactionLineId 
									  AND R.ParentLineId is not NULL							  
									  
				WHERE    	L.ReconciliationPointer = 0  <!--- not manually overruled as reconciled ---> 
				
				 <!--- ---------------------------------------------------------- --->
				 <!--- -------------------Period is not closed-: TO BE CHECK----- --->
				 <!--- ---------------------------------------------------------- --->
				
				 AND        EXISTS (SELECT 'X'
				                    FROM   Period 
							        WHERE  AccountPeriod = L.AccountPeriod 
								    AND    ActionStatus = '0')			
						
				 <!--- ---------------------------------------------------------- --->
				 <!--- ------------------Payment order journal------------------- --->
				 <!--- ---------------------------------------------------------- --->
				
				 AND        L.Journal IN (SELECT Journal 
				                          FROM   Journal 
										  WHERE  Mission = '#HeaderSelect.Mission#'	
										  AND    TransactionCategory IN ('Payment','DirectPayment'))		
				
				 <!--- ---------------------------------------------------------- --->
				 <!--- the parent transaction GL account requires reconcilitation --->
				 <!--- ---------------------------------------------------------- --->
				 	 
				 AND        EXISTS  (SELECT   'X'
				                     FROM     Ref_Account
								     WHERE    GLAccount = L.GLAccount
				                     AND      BankReconciliation = 1)
				
				<!--- --------------------------------------------------------- --->
				<!--- payments can ONLY be reconciled against 
				      the same currency of the processing bank journal, ATTENTION for a receivable this is not necessarily the case -------- --->
				<!--- --------------------------------------------------------- --->
				
				AND         L.Currency       = '#HeaderSelect.Currency#'
								  
				GROUP BY 	L.Journal, 
				         	L.JournalSerialNo,
						 	L.TransactionLineId, 
						 	L.AmountDebit, 
						 	L.AmountCredit
							
			    <!--- the system allows you to settle from a different currency, in that we reconstruct the value in the issued currency 13/7/2013 --->
				 				
				HAVING      (  L.AmountDebit  <> 0 AND L.AmountDebit <> ISNULL(SUM(R.AmountCredit*R.ExchangeRate),0) ) OR 				
							<!--- if orginal amount is credit, check for the debit amounts --->				
							(  L.AmountCredit <> 0 AND L.AmountCredit <> ISNULL(SUM(R.AmountDebit*R.ExchangeRate),0) )	
							
					
		</cfsavecontent>
		
		</cfoutput>
		
	</cfif>		

	<cf_droptable dbname="AppsQuery" tblname="#HeaderSelect.Mission##SESSION.acc#Ledger">	
	
	<!--- Query returning search results --->
	<cfquery name="SearchResult"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	  <!--- select transactions which still have a balance on the orig amount 
	  and are not part of this transaction already --->
	   
	  SELECT   P.Journal,
	  		   J.Description as JournalDescription,
	           P.JournalSerialNo,
			   P.JournalTransactionNo,
			   H.TransactionReference,
			   H.ActionStatus,
			   P.GLAccount,
	           P.ReferenceName,
			   P.TransactionDate,
			   P.AccountPeriod,		
			   P.ReferenceNo,   
			   P.TransactionLineId,
			   
			   (SELECT TOP 1 ActionReference1
		        FROM   TransactionHeaderAction TA 
			    WHERE  Journal         = H.Journal
			    AND    JournalSerialNo = H.JournalSerialNo) as Tax,		
			   
			   P.Currency,		   		  
			   P.AmountDebit,
			   P.AmountCredit, 		
			   
			   <cfif url.mode neq "PO">
			   H.AmountOutstanding,
			   <cfelseif url.mode eq "PO">
			  (O.AmountCredit-O.RecDebit) as AmountOutstanding,		   
			   </cfif>
			   
	           R.Description   as GLDescription, 
			   H.Description   as HeaderDescription, 
			   H.TransactionId as TransactionIdHeader	
			   
	  INTO     userQuery.dbo.#HeaderSelect.Mission##SESSION.acc#Ledger		   	   
		
	  FROM     TransactionLine P 
	           INNER JOIN TransactionHeader H  ON P.Journal     = H.Journal AND P.JournalSerialNo = H.JournalSerialNo	 
			   INNER JOIN Ref_Account R        ON P.GLAccount   = R.GLAccount	
			   INNER JOIN Journal J            ON J.Journal     = P.Journal
			   
			   <cfif url.mode eq "PO">
			   INNER JOIN (#PreserveSingleQuotes(Outstanding)#) O ON P.TransactionLineId = O.TransactionLineId		   
			   </cfif>
	  
	  <!--- ------------------------------------------------------------------------------------------ --->	
	  <!--- -------------------------- Transaction needs to belong to same entity -------------------- --->
	  <!--- ------------------------------------------------------------------------------------------ --->
	  
	  WHERE    H.Mission        = '#HeaderSelect.Mission#'	
	    AND    H.RecordStatus   = '1'
		<!--- Parent transaction has been approved --->													 
		AND    H.ActionStatus IN ('0','1')	<!--- has been approved in the workflow --->	
	    AND    H.TransactionCategory NOT IN ('Inventory','Memorial','Receipt')
	    			
		<cfif HeaderSelect.OrgUnitOwner neq "0">	
		AND    H.OrgUnitOwner = '#HeaderSelect.OrgUnitOwner#'	 	
		</cfif>	
		
		<cfif url.mode eq "AP">
		
		 AND     J.Journal IN (SELECT Journal
			                   FROM   Journal 
							   WHERE  Mission = '#HeaderSelect.Mission#'	
							   AND    TransactionCategory  IN ('Payables','DirectPayment'))		
							   
		<cfelseif url.mode eq "PO">
				
		 AND     J.Journal IN (SELECT Journal 
			                   FROM   Journal 
							   WHERE  Mission = '#HeaderSelect.Mission#'	
							   AND    TransactionCategory IN ('Payment'))		<!--- direct payment ????? --->
							   
		
		<cfelse>
		
		 AND     J.Journal IN (SELECT Journal
			                   FROM   Journal 
							   WHERE  Mission = '#HeaderSelect.Mission#'	
							   AND    TransactionCategory  IN ('Receivables','Memorial','Banking'))		<!--- added receipt as this journal is used to present a settlement --->	 
			
		</cfif>
		
		<!--- ------------------------------------------------------------------------------------------ --->	
	           	
	    <!--- The account code of the parent transaction has been tagged as bank reconcilable, 
		    not each acocunt requires reconciliation --->
			
	    AND    EXISTS   (  SELECT   GLAccount
	                       FROM     Ref_Account
						   WHERE    GlAccount = P.GLAccount
	                       AND      BankReconciliation = 1
						)  
		
		<!--- ------------------------------------------------------------------------------------------ --->
		<!--- bank defined for contra-account of this journal is same as the defined bank for the parent --->
		<!--- ------------------------------------------------------------------------------------------ --->
		
		<cfif ActionBank.BankId neq "">					
		 AND     (H.ActionBankId is NULL or H.ActionBankId = '#ActionBank.BankId#') 
		</cfif>			
		
		AND     ABS(H.AmountOutstanding) >= 0.05
							
		<!--- ------------------------------------------------------------------------------------------ --->
		<!--- -------------------------------exclude opening balance transactions----------------------- --->
		<!--- ------------------------------------------------------------------------------------------ --->	
		AND    P.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
		<!--- ------------------------------------------------------------------------------------------ --->
				
		<!--- ------------------------------------------------------------------------------------------ --->
		<!--- -------already selected in the current active transaction in the process list ------------ --->
		<!--- ------------------------------------------------------------------------------------------ 	
		AND    P.TransactionLineId NOT IN (SELECT ParentLineId 
	                                       FROM   userQuery.dbo.#SESSION.acc#GledgerLine_#client.sessionNo#
								           WHERE  ParentLineId IS NOT NULL) 
										   	
		<cfif URL.find neq "">
	     AND (
			 	R.Description          like '%#URL.find#%' OR 
				H.JournalTransactionNo like '%#URL.find#%' OR 
				H.Description          like '%#URL.find#%' OR 
				P.ReferenceName        like '%#URL.find#%' OR
				P.ReferenceNo          like '%#URL.find#%' OR
				H.TransactionReference like '%#URL.find#%' )
	    </cfif>
		
		<cfif URL.tax neq "">			
										
				AND EXISTS (SELECT 'X'
				        FROM   TransactionHeaderAction TA 
						WHERE  Journal         = P.Journal
				        AND    JournalSerialNo = P.JournalSerialNo
						AND    ActionReference1 LIKE '%#URL.tax#%')													
				 
				
		</cfif>		
					
		<cfif URL.iJournal neq "">
	    AND     P.Journal  in (#PreserveSingleQuotes(URL.iJournal)#)            
		</cfif>					
		
		<cfif URL.Period neq "">
	    AND     P.AccountPeriod =  '#URL.Period#'
		</cfif>		
		
		--->
		
	</cfquery>
	
	<!---	
	<cfoutput>1. #cfquery.executiontime#</cfoutput>
	--->
	
</cfif>	


<!--- Query returning search results --->

<cfquery name="SearchResult"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM   #HeaderSelect.Mission##SESSION.acc#Ledger P
	
	<!--- ------------------------------------------------------------------------------------------ --->
	<!--- -------already selected in the current active transaction in the process list ------------ --->
	<!--- ------------------------------------------------------------------------------------------ --->	
	WHERE   P.TransactionLineId NOT IN (SELECT ParentLineId 
                                       FROM   userQuery.dbo.#SESSION.acc#GledgerLine_#client.sessionNo#
							           WHERE  ParentLineId IS NOT NULL) 
									   	
	<cfif URL.find neq "">
     AND (
		 	GLDescription          like '%#URL.find#%' OR 
			JournalTransactionNo   like '%#URL.find#%' OR 
			HeaderDescription      like '%#URL.find#%' OR 
			ReferenceName          like '%#URL.find#%' OR
			ReferenceNo            like '%#URL.find#%' OR
			TransactionReference   like '%#URL.find#%' )
    </cfif>
	
	<cfif URL.tax neq "">		
	AND     P.TAX LIKE '%#URL.tax#%'			
	</cfif>				
					
	<cfif URL.iJournal neq "">
    AND     P.Journal  in (#PreserveSingleQuotes(URL.iJournal)#)            
	</cfif>					
	
	<cfif URL.Period neq "">
    AND     P.AccountPeriod =  '#URL.Period#'
	</cfif>		
	
	ORDER BY P.#URL.ID1#,P.AccountPeriod <cfif url.id1 neq "TransactionDate">,P.TransactionDate</cfif>

</cfquery>

<!---
<cfoutput>2. #cfquery.executiontime#:#searchresult.recordcount#</cfoutput>
--->

<!--- lookup values --->

<cfquery name="JournalList" dbtype="query" >
	SELECT DISTINCT Journal, JournalDescription
	FROM SearchResult	
</cfquery>

<cfquery name="PeriodList" dbtype="query" >
	SELECT DISTINCT AccountPeriod
	FROM SearchResult
</cfquery>

<cfset client.pagerecords = 100>

<cfinclude template="../../../../Tools/PageCount.cfm">
 
<cfoutput>
	<input type="hidden" name="iPages" 			id="iPages" 		value="#pages#">
	<input type="hidden" name="iPageSelected" 	id="iPageSelected" 	value="#URL.Page#">	
	<input type="hidden" name="iMode"       	id="iMode"      	value="#URL.Mode#">	
	<input type="hidden" name="iSorting" 		id="iSorting"		value="#URL.ID1#">
	<input type="hidden" name="iJournal" 		id="iJournal" 		value="#ListQualify(ValueList(JournalList.Journal),"'")#">
	<input type="hidden" name="iPeriod"		 	id="iPeriod"   		value="#ValueList(PeriodList.AccountPeriod)#">									
</cfoutput>
						
<table width="99%" align="left" class="navigation_table">
					
<cfset prior = "">		

<cfif searchresult.recordcount eq "0">

<tr class="line labelmedium"><td style="height:40px;font-size:16px;color:gray;font-weight:200" align="center" colspan="13"><cf_tl id="There are no records to show in this view"></td></tr>

</cfif>
																
<cfoutput query="SearchResult" startrow="#first#" maxrows="#No#">
				
   <cfset deb  = 0>
   <cfset crd  = 0> 
   
   <cfset curr = Journal>	 
   
   <cfswitch expression="#URL.ID1#">
     <cfcase value = "Journal">			 
          <cfset curr = Journal>	 	 
     </cfcase>
     <cfcase value = "ReferenceName">
          <cfset curr = ReferenceName> 
     </cfcase>	 
     <cfcase value = "TransactionDate">
	      <cfset curr = Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")>
      </cfcase>			
   </cfswitch>
      		   
   <cfif prior neq curr>
   		  
   <tr class="labelmedium line fixrow" style="height:30px">
 		
	   <cfswitch expression="#URL.ID1#">
	     <cfcase value = "Journal">			 
	     <td align="left" colspan="13" style="padding-left:4px;;font-size:16px">#Journal# #JournalDescription#</td>			 	 
	     </cfcase>
	     <cfcase value = "ReferenceName">
	     <td align="left" colspan="13" style="padding-left:4px;font-size:16px;">#ReferenceName#</td> 
	     </cfcase>	 
	     <cfcase value = "TransactionDate">
	     <td align="left" colspan="13" style="padding-left:4px;font-size:16px;">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</td>
	     </cfcase>			
		 <td style="min-width:350px"></td>
	   </cfswitch>
   
   </tr>	
   
   <cfset prior = curr>	
   
   </cfif>   
   
   		<cfset val = AmountOutstanding>
		
		<!---
   					
		<cfif AmountDebit gt 0>
		  <cfif RecCredit eq "">
			  <cfset val = amountDebit>
		  <cfelse>
		      <cfset val = amountDebit-RecCredit>
		  </cfif>	  
		<cfelse>
		   <cfif RecCredit eq "">
		   	  <cfset val = amountCredit>   
		   <cfelse>
			  <cfset val = amountCredit-RecDebit>  
		   </cfif>	  
		</cfif>  		
		
		--->		
	
		<cfif abs(val) gte 0.10>
		
			<cfset fld = left(TransactionLineId,8)>
				
		    <TR class="navigation_row clsFinance labelmedium" style="height:20px;border-bottom:1px solid silver">
			
			    <td align="center" style="padding-left:4px;padding-right:4px;;<cfif actionstatus eq '0'>background-color:yellow</cfif>">
				
				<!---
				<cfif actionstatus eq "1">
				--->
										
					<input type = "checkbox" 
					name        = "selected" 
					id          = "selected"							
					value       = "#TransactionLineId#"
					onClick     = "hl(this,this.checked,'#fld#');settotal('#url.mode#')">
					
					<!---
					</cfif>
					--->
					
				</td>
				
				<TD style="padding-left:2px;padding-right:4px">#AccountPeriod#</td>
				<TD style="padding-left:5px;padding-right:5px;width:auto"><a class="navigation_action" href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#','1')">#JournalTransactionNo#</a></TD>
				<TD style="min-width:200px;padding-left:2px;">#GLAccount# <cfif len(GLDescription) gt "20">#left(GLDescription,20)#..<cfelse>#GLDescription#</cfif></TD>		
				<TD style="padding-left:5px;">#TransactionReference#</TD> 						
				<TD style="padding-left:5px;">#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>
			    <TD style="width:50%;padding-left:6px;"><cfif referencename eq "" or referencename eq "Contra-account">#HeaderDescription#<cfelse>#ReferenceName#</cfif></TD>
				
				<!--- 
				
				<td style="padding-left:2px;">
								
				<font color="gray">
										
				<cfif AmountDebit gt 0>
				      <cfset dc = "D">
					  <!---
					  <cfif RecCredit eq "">
						  <cfset val = amountDebit>
					  <cfelse>
					      <cfset val = amountDebit-RecCredit>
					  </cfif>	  
					  --->
				<cfelse>
				      <cfset dc = "C">
					  <!---
					  <cfif RecCredit eq "">
					  	  <cfset val = amountCredit>   
					   <cfelse>
						  <cfset val = amountCredit-RecDebit>  
					   </cfif>	  
					   --->
				</cfif>  	
				
				<cfif dc eq "D">
				AR
				<cfelse>
				AP
				</cfif>
												
				</td>
				
				--->
				
			    <TD style="padding-left:3px;">#Currency#
				
					<cfset fld = left(TransactionLineId,8)>
											
					<input type="text" 
					 	 name="cur_#fld#" 
						 id="cur_#fld#"
						 style="padding-top:2px"
						 value="#currency#" 							
						 class="hide">
					 
				</TD>							
				
			    <TD style="background-color:yellow;padding-left:2px;padding-right:4px;border-right:1px solid silver;min-width:50" align="right">											
												
					<cfif currency neq headerselect.currency>
					   
					   <cf_exchangeRate currencyFrom = "#currency#" currencyTo = "#headerselect.currency#">
					   <cfset erate = exc>
					   
					<cfelse>
					
						<cfset erate = 1>   
												
					</cfif> 
																				
					<input type="hidden" 
				 	 name="out_#fld#" 
				     id="out_#fld#"
					 onchange="settotal()"
					 style="padding-top:2px"
					 value="#NumberFormat(val,',.__')#" 
					 size="10" >
				     #NumberFormat(val,',.__')#   					
					
				</td>	
				
				<td align="right" id="box_#TransactionLineId#_3" style="min-width:80;border-left:1px solid silver;padding-right:2px;" class="xxhide">
																
					<input type="text" 
						 name="val_#fld#" 
						 id="val_#fld#"
						 value="#NumberFormat(val/erate,',.__')#" 
						 size="10" 
						 maxlength="12" 
						 onchange="recalcline('#TransactionLineId#','#fld#')"
						 class="hide" 
						 style="background-color:f1f1f1;height:100%;width:100%;text-align:right;padding-top:0px">
				 						 
				</td>	
										
				<td id="box_#TransactionLineId#_2" style="min-width:70;border-left:1px solid silver;padding-right:2px;" class="xxhide" align="right">
				
				<cfif currency eq headerselect.currency>
																		
					<input type="text" 
						 name="exc_#fld#" 
						 id="exc_#fld#"
						 value="#NumberFormat(1,',.__')#" 
						 size="10" 								 
						 maxlength="10" 
						 readonly
						 tabindex="9999"
						 class="hide" 
						 style="background-color:f1f1f1;text-align: right;padding-top:0px;height:100%;width:100%;">
					 
				<cfelse>
																						
					 <input type="text" 
						 name="exc_#fld#" 
						 id="exc_#fld#"
						 value="#NumberFormat(erate,',.__')#" 
						 size="10" 			
						 onchange="recalcline('#TransactionLineId#','#fld#')"				 
						 tabindex="9999"
						 maxlength="10" 							 
						 class="hide" 
						 style="background-color:f1f1f1;text-align: right;padding-top:0px;height:100%;width:100%;">
				 
				</cfif>
				</td>						
				
				<td id="box_#TransactionLineId#_1" style="min-width:80;border-left:1px solid silver;padding-right:2px;border-right:1px solid silver" class="xxhide" align="right">
				
					<input type="text" 
					 name="off_#fld#" 
					 id="off_#fld#"
					 value="#NumberFormat(val,',.__')#" 
					 size="10" 
					 readonly
					 tabindex="9999"
					 maxlength="12" 
					 class="hide" 							 
					 style="text-align: right;padding-top:0px;height:100%;width:100%;">
				
				</td>
										
				<cfset deb = deb + AmountDebit>
				<cfset crd = crd + AmountCredit>						
				
		    </TR>	
														
			</cfif>					
				   
   </cfoutput>   
   							
<tr style="height:0px">
    <TD width="20" align="center"></TD>
	<TD style="padding-left:5px;min-width:40px"><!--- <cf_tl id="Per"> ---></TD>
    <TD style="padding-left:2px;padding-right:2px;min-width:110"><!---<cf_tl id="Transaction">---></TD>
	<TD style="padding-left:5px;min-width:170"><!--- <cf_tl id="Account">---></TD>			
	<TD style="padding-left:5px;min-width:100"></td>
	<TD style="padding-left:5px;min-width:90"><!---<cf_tl id="Date">---></TD>
    <TD style="padding-left:5px;width:100%"><!---<cf_tl id="Reference">---></TD>
	<TD style="min-width:150" colspan="2" align="center"><!---<cf_tl id="Outstanding">---></TD>		  	
	<td style="min-width:250" colspan="3" align="center"></td>			
</tr>
   		   		   
</table>	
			
<cfset AjaxOnLoad("doHighlight")>

<cfif URL.ijournal eq "" AND URL.period eq "" AND URL.find eq "">
	<cfset AjaxOnLoad("setFilters")>
<cfelse>
	<cfset AjaxOnLoad("setPaging")>		
</cfif>	

<script>
	Prosis.busy('no')
</script>