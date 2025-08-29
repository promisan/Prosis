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
<cfparam name="url.currency" default="">
<cfparam name="url.transactionid" default="">

<cfif url.class eq "Deduction">
	
	<cfquery name="Advance" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT *
		FROM (
	
		SELECT        Journal, 
		              JournalSerialNo, 
					  TransactionId,
					  TransactionDate, 
					  Description, 
					  Currency, 
					  Amount, 
					  AmountOutstanding,
		              (SELECT   ISNULL(SUM(Amount), 0) AS Expr1
		               FROM     Payroll.dbo.PersonMiscellaneous
		               WHERE    Source = 'Ledger' 
					   AND      SourceId = H.TransactionId) AS AmountRecovery,
		              (SELECT   ISNULL(SUM(Amount), 0) AS Expr1
		               FROM     Payroll.dbo.PersonMiscellaneous
		               WHERE    Source = 'Ledger' 
					   AND      SourceId = H.TransactionId 
					   AND      H.ActionStatus = '5') AS AmountRecovered, 
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName
		FROM           TransactionHeader AS H
		WHERE          ReferencePersonNo = '#url.personno#' 
		AND            ReferenceNo       = 'Payroll'
		AND			   ActionStatus = '1'
		AND            RecordStatus = '1'
		<cfif url.currency neq "">
		AND            Currency = '#url.currency#'
		</cfif>
			
		) as D
		
		<!--- still pending recovery --->
		
		WHERE Amount > AmountRecovered
		           
	</cfquery>
	
	<table style="width:100%" class="navigation_table">
		
		<tr class="labelmedium2 line fixlengthlist">
		   <td style="width:35px"></td>
		   <td style="border:1px solid silver"><cf_tl id="Ledger"></td>
		   <td style="border:1px solid silver"><cf_tl id="Date"></td>
		   <td style="border:1px solid silver"><cf_tl id="Description"></td>	   
		   <td style="border:1px solid silver" align="right"><cf_tl id="Advance"></td>
		   <td style="border:1px solid silver" align="right"><cf_tl id="Payable"></td>
		   <td style="border:1px solid silver" align="right"><cf_tl id="Planned"></td>
		   <td style="border:1px solid silver" align="right" style="padding-right:4px"><cf_tl id="Recovered"></td>
		</tr> 
		<tr class="labelmedium2 line navigation_row">
		     <td align="center" style="padding-bottom:2px">
			 <cfif url.currency eq "">
			 <input class="radiol" type="radio" name="ledger" checked value="" 
			  onclick="ptoken.navigate('getCurrency.cfm?id=#url.personno#','currencybox')">
			  
			  <cfelse>
			  
			   <input class="radiol" type="radio" name="ledger" checked value="">
			  
			  </cfif>
			  </td>
		     <td colspan="8"><cf_tl id="No applicable"></td>		 
		</tr>  
		
		<cfoutput query="Advance">  
		  <tr class="labelmedium2 line navigation_row fixlengthlist">
		     <td align="center" style="padding-bottom:2px">
			 
			 <cfif url.currency eq "">
			 
			 <input class="radiol"  type="radio" name="ledger" value="#TransactionId#" <cfif url.transactionid eq transactionid>checked</cfif>
			    onclick="ptoken.navigate('getCurrency.cfm?currency=#currency#&id=#url.personno#','currencybox')">
				
			 <cfelse>
			 
			  <input class="radiol"  type="radio" name="ledger" value="#TransactionId#" <cfif url.transactionid eq transactionid>checked</cfif>>
			 
			 </cfif>	
				</td>
		     <td style="border:1px solid silver"><a href="javascript:ShowTransaction('#journal#','#journalserialNo#','','tab','')">#Journal#-#journalSerialNo#</a></td>
			 <td style="border:1px solid silver">#dateformat(TransactionDate,client.dateformatshow)#</td>
			 <td style="border:1px solid silver">#description# #Currency#</td>		 
			 <td style="border:1px solid silver" align="right">#numberformat(Amount,",.__")#</td>
			 <td style="border:1px solid silver" align="right"><cfif AmountOutstanding gt "0"><font color="FF0000"></cfif>#numberformat(AmountOutstanding,",.__")#</td>
			 <td style="border:1px solid silver" align="right">#numberformat(AmountRecovery,",.__")#</td>
			 <td style="border:1px solid silver" align="right" style="padding-right:4px">#numberformat(AmountRecovered,",.__")#</td>
		   </tr>
		</cfoutput> 
			
	</table>

<cfelse>

</cfif>

<cfif url.currency eq "">

<cfoutput>
<script>
    ptoken.navigate('getCurrency.cfm?id=#url.personno#','currencybox')
</script>
</cfoutput>

</cfif>

<cfset ajaxOnLoad("doHighlight")>