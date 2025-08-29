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
<table width="100%">
	
	<tr class="labelit line">
		
			<td></td>
		    <td></td>				
			<td>TraNo</td>
			<td>Class</td>
			<td>Code</td>
			<td>InvoiceNo</td>
			<td>Doc.</td>
			<td>Posting Date</td>				
			<td>Officer</b></td>
			<td align="right">Amount</b></td>
			<td width="5"></td>
		
		</td>
	</tr>	
				
	<cfquery name="Ledger" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   InvoiceNo, 
		          VendorName, 
				  TransactionNo, 
				  TransactionSerialNo, 
				  Currency, 
				  AmountBase, 
				  DocumentCode,
				  DocumentId1,
				  DocumentId2,
				  PostingDate, 
				  ObjectClass, 
				  ObjectCode, 
				  Fund,
				  OrgCode,
				  ProgramCode,
				  ActivityCode,
				  ObjectName,
				  FiscalYear, 
                  DocumentCode, 
				  Description1,
				  Description2,
				  Description3,
				  UserId
		FROM      stLedgerIMIS I 
		WHERE     NOVADestination = 'Match'
		 AND      (TransactionSerialNo NOT IN
                      (SELECT   RI.TransactionSerialNo
					   FROM     stReconciliationIMIS RI INNER JOIN
    	                        stReconciliation R ON RI.ReconciliationNo = R.ReconciliationNo AND  (R.Status='complete' OR R.Status='Direct'))
					) 
		
			<cfif URL.VendorCode neq "-1">
					AND 
					VendorCode='#URL.VendorCode#'
			</cfif>
			
 	     AND   Mission = '#URL.Mission#'
		 AND   Fund != 'ZTA'
		 
		<!----
		cfif URL.Mission neq "CMP">
			AND    I.FiscalYear = '#Period.AccountPeriod#'
		cfif	
		---->

		ORDER BY TransactionSerialNo							
	     
	</cfquery>
		
	<cfoutput query="Ledger">
	
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  * 
				FROM    stReconciliationIMIS
				WHERE   reconciliationNo    = '0' 
				AND     TransactionSerialNo = '#TransactionSerialNo#'
			</cfquery>				
										
			<tr id="led#currentrow#" class="labelit navigation_row">
					
				<td width="1%" class="labelit">#currentrow#.</td>
					
				<td width="1%" style="padding-right:4px"><input type="checkbox" class="radiol" name="ledgerselect" id="l#TransactionSerialNo#" value="'#TransactionSerialNo#'" onClick="processinvoice()"></td>	
																						
				<td>#TransactionSerialNo#</td>
				<td width="40">#ObjectClass#</td>
				<td width="40">#ObjectCode#</td>
				<td width="90">#InvoiceNo#</td>
				<td width="120">#DocumentCode#-#DocumentId1#<cf_space spaces="25"></td>
				<td width="90">#Dateformat(PostingDate,"DD/MM/YY")#</td>
				<td width="30">#UserId#</td>
				<td width="100" align="right">#NumberFormat(AmountBase, "__,__.__")#</td>
				<td width="40" align="center" id="td#TransactionSerialNo#">
																	
				<cfif Check.recordcount eq "0">
					<button class="button3" type="button"
				        onClick="setstatus('#TransactionSerialNo#','1')">						
						<img align="absmiddle" src="#SESSION.root#/Images/config.gif" alt="Report this transaction as Direct Cost" border="0">
					</button>
				<cfelse> 
					<button class="button3" type="button"
				         onClick="setstatus('#TransactionSerialNo#','0')" >						
					    <img align="absmiddle" src="#SESSION.root#/Images/alert_good.gif" alt="Undo Direct Cost" border="0">							
					</button>
				</cfif>
					
				</td>
			</tr>
										
			<cfif Fund neq "">
					
					<tr class="navigation_row_child">
					<td></td>
					<td></td>
					<td colspan="9" class="labelit" bgcolor="FBF7DB">#Fund#-#OrgCode#-#ProgramCode#-#ActivityCode#-#ObjectName#</td>
					</tr>
					<tr><td colspan="2"></td><td colspan="9" class="line"></td></tr>
					
				</cfif>
					
				<cfif Description1 neq "">
					
					<tr class="navigation_row_child">
					<td></td>
					<td></td>
					<td class="labelit" bgcolor="ffffbf" colspan="9">#Description1#</td>
					</tr>
					<tr><td colspan="2"></td><td colspan="9" class="linedotted"></td></tr>
					
				</cfif>
					
				<cfif Description2 neq "" and description1 neq description2>
					
					<tr class="navigation_row_child">
					<td></td>
					<td></td>
					<td class="labelit" bgcolor="ffffdf" colspan="9">#Description2#</td>
					</tr>
					<tr><td colspan="2"></td><td colspan="9" class="linedotted"></td></tr>
					
				</cfif>
					
				<cfif Description2 neq "">
					
					<tr class="navigation_row_child">
					<td></td>
					<td></td>
					<td class="labelit" bgcolor="f4f4f4" colspan="9">#Description3#</td>
					</tr>
					<tr><td colspan="11" class="linedotted"></td></tr>
					
				</cfif>								
			
			
	</cfoutput>			
	
	</table>
	
	<cfset ajaxonload("doHighlight")>