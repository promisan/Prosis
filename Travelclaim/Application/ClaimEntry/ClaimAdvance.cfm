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
<cfparam name="url.topic" default="">

<cfset travel = "1">

<cfquery name="Advance" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT A.*, R.Description as StatusDescription, R.PointerStatus
	FROM   IMP_ClaimAdvance A, Ref_Status R
	WHERE  Doc_No = '#ClaimTitle.DocumentNo#'
	AND db_mdst_source = '#ClaimTitle.Mission#'
	AND A.AdvanceStatus = R.Status
	AND R.StatusClass = 'Advance'
	ORDER BY f_rcvh_doc_id
</cfquery>

<cfif Advance.recordcount eq "0">

	<table width="100%" border="0" cellspacing="0" align="center" cellpadding="1" bordercolor="#C0C0C0" 
	  rules="rows">
				
		<cfquery name="Advances" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ClaimEventIndicatorCost CI INNER JOIN
                      Ref_Indicator I ON CI.IndicatorCode = I.Code INNER JOIN
                      ClaimEvent C ON CI.ClaimEventId = C.ClaimEventId
			WHERE     I.Category = 'Additional'
			AND       ClaimId = '#URL.ClaimId#' 
			</cfquery>
			
			<cfif advances.recordcount gt "0" and url.topic neq "Additional">
						
				<tr><td height="1" colspan="6"><font color="804040"><b>
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" align="absmiddle" alt="" border="0">
				Other Advances Received</td></tr>
				<tr><td colspan="6" height="1" bgcolor="silver"></td></tr>
				
				<cfoutput query="advances">
				<tr bgcolor="f9f9f9">
				   <td colspan="1"><cfif Description eq ""><b>Not submitted</b><cfelse>#Description#</cfif></td>
				   <td height="18">#DateFormat(InvoiceDate, CLIENT.DateFormatShow)#</td>
				   <td><cfif InvoiceNo eq ""><cfelse>#InvoiceNo#</cfif></td>
				   <td>#InvoiceCurrency#</td>
				   <td align="right">#numberFormat(InvoiceAmount,",__.__")#</td>	
				   <td align="right">#numberFormat(InvoiceAmount,",__.__")#</td>			  			   			   
			    </TR>					
				</cfoutput>
			
			<cfelse>
			
				<tr>
				  <td colspan="6" height="24" align="center"><font face="verdana" color="#0066CC">		  
				  <b>No Travel advance(s) recorded for this request</b></td>
				</tr>  
									
			</cfif>
				
	</table>	
	
	<cfset adv = 0>

<cfelse>

	<table width="100%" border="0" cellspacing="1" align="center" cellpadding="1" bgcolor="white" bordercolor="#C0C0C0" 
	  rules="rows">
		
		<tr bgcolor="white">
		  
		  <td>Travel Advance</td> 
		  <td>Status</td>
		  <td>Office</td>
		  <td>Curr</td>
		  <td align="right">Amount</td>
		  <td align="right">Balance</td>
		
		</tr>  
		<tr><td height="1" bgcolor="e4e4e4" colspan="8"></td></tr>
		
		<cfset adv = 0>
		<cfoutput query="Advance" group="f_rcvh_doc_id">
			<tr>
			
			  <td>#f_dorf_rcvh_id_code#-#f_rcvh_doc_id#</td>
			  <td>#StatusDescription#</td>
			  <td>#db_mdst_source#</td>
			  <td>#f_curr_code#</td>
			  <td align="right">#NumberFormat(curr_amt,"__,__.__")#</td>
			  <td align="right">#NumberFormat(curr_bal,"__,__.__")#</td>
			 
			</tr> 
						
			<cfif pointerStatus eq "1">
			
				<!--- scenario 1 and 4 --->
				<cfif Claim.PaymentCurrency eq f_curr_code>
				
					<cfset adv = adv+(curr_bal)> 
							
				<cfelse>
				
					<!--- scenario 2 --->
										
					<cfquery name="Exchange" 
					  datasource="AppsLedger">
					  SELECT   TOP 1 *
					  FROM     CurrencyExchange
					  WHERE    Currency         = '#Claim.PaymentCurrency#' 
					    AND    EffectiveDate   <= '#Claim.ClaimDate#'
					  ORDER BY EffectiveDate DESC
					 </cfquery>		
					
					<cfset adv = adv+(curr_bal*exchange.exchangeRate)> 
				
				</cfif>
			
			</cfif>
			
		</cfoutput>
		
		<cfquery name="Advances" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ClaimEventIndicatorCost CI INNER JOIN
                      Ref_Indicator I ON CI.IndicatorCode = I.Code INNER JOIN
                      ClaimEvent C ON CI.ClaimEventId = C.ClaimEventId
			WHERE     I.Category = 'Additional'
			AND       ClaimId = '#URL.ClaimId#' 
			</cfquery>
			
			<cfif advances.recordcount gt "0" and url.topic neq "Additional">
						
			<tr><td height="1" colspan="6"><font color="804040">&nbsp;<b>
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" align="absmiddle" alt="" border="0">
			Other Advances Received</td></tr>
			<tr><td colspan="6" height="1" bgcolor="silver"></td></tr>
			
			<cfoutput query="advances">
			<tr bgcolor="f9f9f9">
			   <td colspan="1"><cfif Description eq ""><b>Not submitted</b><cfelse>#Description#</cfif></td>
			   <td height="18">#DateFormat(InvoiceDate, CLIENT.DateFormatShow)#</td>
			   <td><cfif InvoiceNo eq ""><cfelse>#InvoiceNo#</cfif></td>
			   <td>#InvoiceCurrency#</td>
			   <td align="right">#numberFormat(InvoiceAmount,",__.__")#</td>	
			   <td align="right">#numberFormat(InvoiceAmount,",__.__")#</td>			  			   			   
		    </TR>					
			</cfoutput>
						
			</cfif>
			
	</table>	

</cfif>	