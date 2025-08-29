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
<cfif url.class eq "Deduction" and url.transactionId neq "">

	
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
					   					   
					  (SELECT    SUM(L.AmountCredit - L.AmountDebit) AS Expr1
						FROM     TransactionLine AS L
						         INNER JOIN   TransactionHeader AS PH ON L.ParentJournal = PH.Journal AND L.ParentJournalSerialNo = PH.JournalSerialNo AND L.TransactionSerialNo = 1 
								 INNER JOIN   TransactionHeader AS LH ON L.Journal = LH.Journal AND L.JournalSerialNo = LH.JournalSerialNo
						WHERE    PH.TransactionId = H.TransactionId 
						AND      LH.ActionStatus <> '9' 
						AND      LH.RecordStatus <> '9') AS AmountRecovered, 
					   
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName
		FROM           TransactionHeader AS H
		WHERE          ReferenceNo       = 'Payroll'
		AND			   ActionStatus = '1'
		AND            RecordStatus = '1'
		AND            TransactionId = '#url.transactionid#'
			
			
		) as D
		
		<!--- still pending recovery --->
		
		-- WHERE Amount >= AmountRecovered
		           
	</cfquery>
	
	<table style="width:100%;background-color:f5f5f5" class="navigation_table">
		
		<tr class="labelmedium2 line">
		   <!---
		   <td style="width:35px"></td>
		   --->
		   <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><cf_tl id="Date"></td>
		   <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><cf_tl id="Description"></td>	   
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Advance"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Payable"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right"><cf_tl id="Planned"></td>
		   <td style="min-width:100px;border:1px solid silver;padding-right:4px" align="right" style="padding-right:4px"><cf_tl id="Recovered"></td>
		</tr> 
				
		<cfoutput query="Advance">  
		  <tr class="labelmedium2 line navigation_row">
		     <!---
		     <td style="padding-left:4px;border:1px solid silver;padding-right:4px"><a href="javascript:ShowTransaction('#journal#','#journalserialNo#','','tab','')">#Journal#-#journalSerialNo#</a></td>
			 --->
			 <td style="padding-left:4px;border:1px solid silver;padding-right:4px">#dateformat(TransactionDate,client.dateformatshow)#</td>
			 <td style="padding-left:4px;border:1px solid silver;padding-right:4px">#description# #Currency#</td>		 
			 <td style="border:1px solid silver;padding-right:4px" align="right">#numberformat(Amount,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right"><cfif AmountOutstanding gt "0"><font color="FF0000"></cfif>#numberformat(AmountOutstanding,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right">#numberformat(AmountRecovery,",.__")#</td>
			 <td style="border:1px solid silver;padding-right:4px" align="right" style="padding-right:4px">#numberformat(AmountRecovered,",.__")#</td>
		   </tr>		   
		</cfoutput> 
			
	</table>

</cfif>

<cfset ajaxOnLoad("doHighlight")>