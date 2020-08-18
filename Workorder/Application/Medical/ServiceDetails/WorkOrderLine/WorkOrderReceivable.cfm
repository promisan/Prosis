
<cfif ARsearchresult.recordcount gte "1">
			
	<table width="98%" align="center">
			
		<tr class="labelmedium line">	   	   
		    <td><cf_tl id="Issued to"></td>
			<td><cf_tl id="Currency"></td>
			<td><cf_tl id="Invoice"></td>
			<td><cf_tl id="Source"></td>
			<td><cf_tl id="Effective"></td>
			<td><cf_tl id="Expiration"></td>
			<td  align="right"><cf_tl id="Outstanding"></td>
		</TR>
		
		<cfif ARsearchresult.recordcount eq "0">
		
		<tr><td class="labelmedium" align="center" colspan="6"><font color="gray"><cf_tl id="There are no records found to be shown"></td></tr>
		
		</cfif>
	
		<cfoutput query="ARSearchResult" group="currency">
		  
		    <cfset totalOutStanding = 0>
			
		    <cfoutput>
			
		    <tr class="navigation_row line labelmedium">			
				<td>#ReferenceName#</td>
				<td>#Currency#</td>
				<td>
				<a style="color:black;" href="#SESSION.root#/Gledger/Application/Transaction/View/TransactionView.cfm?id=#TransactionId#" target="_blank" >#TransactionReference#</a>
				</td>
				<td>#TransactionSource#</td>
				<td>
				<a style="color:black;" href="WorkOrderLineView.cfm?drillid=#ReferenceId#" target="_blank" >#DateFormat(DocumentDate,CLIENT.DateFormatShow)# </a>
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

