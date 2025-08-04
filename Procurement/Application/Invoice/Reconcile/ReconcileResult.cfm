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

<cfparam name="form.InvoiceSelect" default="">
<cfparam name="form.LedgerSelect"  default="">
<cfparam name="URL.mode" default="listing">

<cfif URL.mode eq "save">

		<cftransaction>

		<cfquery name="s1" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT max(reconciliationno) AS mr
			FROM   stReconciliation	
		</cfquery>
		
		<cfif s1.mr eq "">
			<cfset r=0>
		<cfelse>
			<cfset r=#s1.mr#+1>
		</cfif>	
		
		<cfquery name="u1" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO stReconciliation
			       (ReconciliationNo,Status,OfficerUserid,OfficerLastName,OfficerFirstName)
			VALUES (#r#,'complete','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>
				
		<cfquery name="u2" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO stReconciliationIMIS (
					        ReconciliationNo,
							TransactionSerialNo,
							Mission)
				SELECT  	'#r#',
					        TransactionSerialNo,
						    '#url.mission#'
				FROM    	stLedgerIMIS
				WHERE   	TransactionSerialNo IN (#preserveSingleQuotes(form.LedgerSelect)#)	 
				AND     	Mission = '#url.mission#'					
		</cfquery>
				
		<cfquery name="u2" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE   Invoice
				SET      ReconciliationNo = #r#
				
				<cfif form.InvoiceSelect neq "">
				WHERE    InvoiceId IN (#preserveSingleQuotes(form.InvoiceSelect)#)	 
				<cfelse>
				WHERE   1= 0
				</cfif>
				AND      Mission = '#url.mission#'					
		</cfquery>	
		
		</cftransaction>
						
		<cfoutput>
		
			<script language="JavaScript">
				ColdFusion.navigate('ReconcileViewInvoice.cfm?mission=#url.mission#&vendorcode2=#form.vendor2#&vendorcode3=#form.vendor3#&period=#url.period#','invoicebox')
				ColdFusion.navigate('ReconcileViewLedger.cfm?mission=#url.mission#&vendorcode=#form.vendor#&vendorcode3=#form.vendor3#&period=#url.period#','ledgerbox')
			</script>
		
		</cfoutput>
				
</cfif>

<cfif URL.mode eq "save">
	<cfset URL.mode = "listing">
</cfif>
<table width="100%"><tr><td width="100%"></td></tr></table>
<cf_divScroll height="400px">
<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<tr><td height="1" class="linedotted"></td></tr>
		
		<tr><td valign="top">
					
			<table width="100%" cellspacing="0" cellpadding="0">
				
				<cfquery name="InvoiceRec" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT I.*, O.OrgUnitCode, OrgUnitName
					FROM   Invoice I LEFT OUTER JOIN Organization.dbo.Organization O
							ON I.OrgUnitVendor = O.OrgUnit 
				    WHERE  I.Mission = '#URL.Mission#'
					
					AND    InvoiceId NOT IN
		                          (SELECT  InvoiceId
		                            FROM   Invoice I INNER JOIN stReconciliation R ON I.ReconciliationNo = R.reconciliationNo
		                            WHERE  I.mission = '#URL.Mission#' 
									AND    I.ActionStatus <> '9' 
									AND    R.status = 'complete')
					
					AND  InvoiceId IN (
						SELECT   IP.InvoiceId
						FROM     PurchaseLine PL INNER JOIN
				                 RequisitionLine RL ON PL.RequisitionNo = RL.RequisitionNo INNER JOIN
		                         InvoicePurchase IP ON PL.RequisitionNo = IP.RequisitionNo 
						WHERE    (RL.Mission = '#URL.Mission#') 
						AND      (RL.ActionStatus <> '9')
					)		
					
					<cfif Form.InvoiceSelect neq "">	
					AND    I.InvoiceId IN (#preserveSingleQuotes(form.InvoiceSelect)#)
					<cfelse>
					AND   1=0
					</cfif>
					
					AND    I.ActionStatus != '9' 
					
					AND    I.InvoiceId NOT IN (
											SELECT   InvoiceId
											FROM     Invoice I
											WHERE    I.ActionStatus = '0' 
											AND      I.InvoiceId NOT IN
							                            (SELECT  ObjectKeyValue4
							                             FROM    Organization.dbo.OrganizationObject
							                             WHERE   EntityCode = 'ProcInvoice'
														 AND     ObjectKeyValue4 = I.InvoiceId)
											AND     I.Mission = '#URL.Mission#'
										   )	
						
					ORDER BY TransactionNo
				</cfquery>
				
				<cfoutput query="InvoiceRec">
						
				    <tr>
					
					<td width="100" class="labelit">#TransactionNo#</td>
					<td width="80" class="labelit">#InvoiceNo#</td>
					<td width="100" class="labelit">#Dateformat(DocumentDate,CLIENT.DateFormatShow)#</td>
					<td width="120" class="labelit">#OrgUnitName#</td>
					<td width="120" class="labelit">#OfficerFirstName# #OfficerLastName#</td>
					<td width="100" class="labelit" align="right">#NumberFormat(DocumentAmount, "__,__.__")#</td>
					<td width="10"></td>
					<td width="80">
					
					<img src="#SESSION.root#/Images/delete5.gif" style="cursor:pointer" height="11" width="11" alt="Remove" border="0" align="absmiddle"
				     onClick="javascript:deleteline('i#InvoiceId#')">
					
				    </td>
					</tr>
					<tr><td colspan="8" bgcolor="e4e4e4" height="1"></td></tr>
						
				</cfoutput>
				
				<cfquery name="Total" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT SUM(DocumentAmount) as TOTAL
					FROM   Invoice I
					WHERE  (ReconciliationNo is NULL or ReconciliationNo IN (SELECT ReconciliationNo 
					                                                         FROM   stReconciliation
																			 WHERE  Status IN ('Pending','Partial')))
					<cfif Form.InvoiceSelect neq "">	
					AND    I.InvoiceId IN (#preserveSingleQuotes(form.InvoiceSelect)#)
					<cfelse>
					AND   1=0
					</cfif>
					<!---
					AND    ActionStatus = '1'
					--->
				</cfquery>
			
			    <cfoutput>
				
				<cfset totalNOVA = Total.Total>
			   
				      <tr bgcolor="e4e4e4">
						<td width="100"></td>
						<td width="80"></td>
						<td width="100"></td>
						<td width="120"></td>
						<td width="120" class="Labelmedium">Total #SESSION.welcome#:</td>
						<td width="100" class="Labelmedium" align="right"><b>#NumberFormat(totalNOVA, "__,__.__")#</td>
						<td width="10"></td>						
						<td width="80"></td>	
					  </tr>		
					  <tr><td colspan="8" class="line"></td></tr>				
				
				</cfoutput>		
				
				<cfquery name="InvoiceIMIS" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    InvoiceNo, 
				              VendorName, 
						      TransactionNo, 
						      TransactionSerialNo, 
						      Currency, 
							  Description1,
						      AmountBase, 
						      PostingDate, 
						      ObjectClass, 
						      ObjectCode, 
						      FiscalYear, 
		                      DocumentCode, 
						      UserId
					FROM      stLedgerIMIS I 
					WHERE     NOVADestination = 'Match'
					AND       TransactionSerialNo not IN (
											   SELECT RI.TransactionSerialNo
											   FROM   stReconciliationIMIS RI INNER JOIN
						    	                      stReconciliation R ON RI.ReconciliationNo = R.ReconciliationNo 
													  AND R.Status = 'Complete')	
													  
					<cfif Form.LedgerSelect neq "">	
					AND       TransactionSerialNo IN (#preserveSingleQuotes(form.LedgerSelect)#)	
					<cfelse>
					AND   1=0
					</cfif>								  			       						   
						 
			 	    AND       Mission = '#URL.Mission#'
					ORDER BY  TransactionSerialNo
				</cfquery>			
						
				<cfoutput query="InvoiceIMIS">
							
					    <tr bgcolor="ffffef">				
						<td width="100" class="labelit">#TransactionSerialNo#</td>
						<td width="80" class="labelit">#InvoiceNo#</td>
						<td width="100" class="labelit">#Dateformat(PostingDate,CLIENT.DateFormatShow)#</td>
						<td width="120" class="labelit">#Description1#</td>
						<td width="120" class="labelit">#UserId#</td>
						<td width="100" class="labelit" align="right">#NumberFormat(AmountBase, "__,__.__")#</td>
						<td width="10"></td>
						<td width="80">
							<img src="#SESSION.root#/Images/delete5.gif" style="cursor:pointer" height="11" width="11" alt="" border="0" onclick="deleteline('l#TransactionSerialNo#')">
						</td>
						</tr>
						<tr><td colspan="8" bgcolor="e4e4e4" height="1"></td></tr>
							
				</cfoutput>
				
				<cfquery name="TotalIMIS" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   Sum(AmountBase) as total
						FROM     stLedgerIMIS I 
						WHERE    NOVADestination = 'Match'
						AND      TransactionSerialNo not IN
							                   (SELECT  RI.TransactionSerialNo
												FROM    stReconciliationIMIS RI INNER JOIN stReconciliation R ON RI.ReconciliationNo = R.ReconciliationNo 
												AND     R.Status = 'Complete')						 
						<cfif Form.LedgerSelect neq "">	
						AND       TransactionSerialNo IN (#preserveSingleQuotes(form.LedgerSelect)#)	
						<cfelse>
						AND   1=0
						</cfif>			
				 	    AND  Mission = '#URL.Mission#'
				 </cfquery>
		
				 <cfoutput>
				 
						<cfset totalIMIS = TotalIMIS.Total>
					 
					    <tr bgcolor="ffffaf">
		  				    <td width="100"></td>
						    <td width="80"></td>
							<td width="100"></td>
							<td width="120"></td>
							<td width="120" class="Labelmedium">Total IMIS:</td>
							<td width="100" class="Labelmedium" align="right"><b>#NumberFormat(totalIMIS, "__,__.__")#</td>							
							<td width="10"></td>
							<td width="80"></td>
						</tr>	
						<tr><td colspan="8" class="line"></td></tr>						
								
						<cftry>
							<cfset t = totalimis-totalNOVA>
						      <tr bgcolor="ffffef">
			 				    <td></td> 
							    <td></td> 
								<td></td>
								<td></td>
								<td class="labelmedium"><b>Difference</b></td>
								<td class="labelmedium" align="right"><b><font color="FF0000">#NumberFormat(t, "__,__.__")#</font></td>
								<td></td>
								<td></td>
							  </tr>							
						<cfcatch>
							<cfset t="-0.05">
						</cfcatch>
						</cftry>
				   		
					</cfoutput>					
					
			</table>
			
			</td></tr>
			<tr>
			<td width="100%" style="padding-top:6px">
			<table align="center">
			<tr>
			
			<cfoutput>
			
			 <cfif getAdministrator(url.mission) eq "1">		 						
			
				<cfif t gt -100 and t lt 100 and 
				    InvoiceRec.recordcount gte "1" and 
					InvoiceIMIS.recordcount gte "1">
					<td>
					<button class="button10g" style="height:21px;width:120"  name="match" id="match" type="button" onclick="matchinvoice()">Save</button>
					</td>				
				</cfif>
			
			<cfelse>
						
				<cfif t gt -2 and t lt 2 and 
				    InvoiceRec.recordcount gte "1" and 
					InvoiceIMIS.recordcount gte "1">
					<td>
					<button class="button10g" style="height:21px;width:120"  name="match" id="match" type="button" onclick="matchinvoice()">Save</button>
					</td>				
				</cfif>
			
			</cfif>
						
			</cfoutput>
			
			<cfif  InvoiceRec.recordcount gte "1" or InvoiceIMIS.recordcount gte "1">
				<td>
				<button class   = "button10g" 
				        style   = "height:21px;width:120" 
						name    = "restart"
                        id      = "restart" 
						onclick = "history.go()">Reset</button>
				</td>		
			</cfif>
			
			</tr>
				
			</table>
			</td>
			</tr>
		
</table>
</cf_divScroll>