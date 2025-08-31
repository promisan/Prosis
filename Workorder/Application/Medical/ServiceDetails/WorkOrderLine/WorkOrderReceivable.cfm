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
<cfif ARsearchresult.recordcount gte "1">
			
	<table width="98%" align="center">
			
		<tr class="labelmedium2 line fixlengthlist">	   	   
		    <td><cf_tl id="Issued to"></td>
			<td><cf_tl id="Currency"></td>
			<td><cf_tl id="Invoice"></td>
			<td><cf_tl id="Source"></td>
			<td><cf_tl id="Effective"></td>
			<td><cf_tl id="Expiration"></td>
			<td  align="right"><cf_tl id="Outstanding"></td>
		</TR>
		
		<cfif ARsearchresult.recordcount eq "0">
		
		<tr><td class="labelmedium2" align="center" colspan="6"><font color="gray"><cf_tl id="There are no records found to be shown"></td></tr>
		
		</cfif>
	
		<cfoutput query="ARSearchResult" group="currency">
		  
		    <cfset totalOutStanding = 0>
			
		    <cfoutput>
			
		    <tr class="navigation_row line labelmedium2 fixlengthlist">			
				<td>#ReferenceName# #ReferenceNo#</td>
				<td>#Currency#</td>
				<td>
				<cfif TransactionReference eq "">
				<a href="#SESSION.root#/Gledger/Application/Transaction/View/TransactionView.cfm?id=#TransactionId#" target="_blank">#JournalTransactionNo#</a>
				<cfelse>
				<a href="#SESSION.root#/Gledger/Application/Transaction/View/TransactionView.cfm?id=#TransactionId#" target="_blank">#TransactionReference#</a>
				</cfif>
				</td>
				<td>#TransactionSource#</td>
				<td>
				<cfif transactionsourceid neq url.drillid>
				<a href="javascript:ptoken.open('WorkOrderLineView.cfm?drillid=#TransactionSourceId#','_blank')">#DateFormat(DocumentDate,CLIENT.DateFormatShow)# </a>
				<cfelse>
				<cf_tl id="this encounter">
				</cfif>
				</td>
				<td>#DateFormat(ActionBefore,CLIENT.DateFormatShow)#</td>			
				<td align="right">#numberFormat(AmountOutstanding,',.__')#</td>			
				<cfset totalOutStanding = totalOutStanding+ARSearchResult.AmountOutStanding>
		    </tr>
			
		    </cfoutput>
			
			<!---
			<tr>
				<td colspan="5"></td>
					<td align="right">
						<font color="red">#numberFormat(totalOutStanding,',.__')#</font>
					</td>
			</tr>
			--->
		</cfoutput>
	</table>

</cfif>

