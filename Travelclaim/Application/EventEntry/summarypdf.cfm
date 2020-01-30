
<cfset src ="Line">

<cfset amt =ClaimpdfSummary.SumAmount>
	<cfoutput>
	
	<cfif src eq "Line" and amt gt "0">
	
		<tr bgcolor="f5f5f5">
		         <td></td>
				<td colspan="5"><b>Claim Total:</b></td>
				<td >#claim.PaymentCurrency# </td> 
				<td align="right" colspan="3" font="gray"> #numberFormat(amt,"__,__.__")#</td>
				
		</tr>
		
		<!--- hide claim advance off-set once uploaded into IMIS --->
		
		<cfif Claim.ReferenceNo eq "">
		
			<cfif adv neq "">
			
				<tr bgcolor="ffffdf">
				         <td></td>
						 <td  colspan="5"><b>Less:Travel Advance(s):</b></td>
						<td colspan="1" >#claim.PaymentCurrency# </td> 
						 <td align="right" colspan="3"><font color="red"> <b>(#numberFormat(adv,"__,__.__")#)</b></td>
					
				</tr>	
			
			</cfif>
		
			<cfif advances.recordcount gt "0">
			
					<tr bgcolor="ffffef">	
					            
				        <td colspan="6">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/images/warning.gif" align="absmiddle" alt="" border="0">
						The claim will be reviewed to take into account the Other Advances noted</td>
									
				</tr>	
			
			</cfif>
		
			<tr bgcolor="f9f9f9">
			         <td></td>
			        <td colspan="5"><b>
					<cfif (amt-adv) gt "0">
					Estimated Payable:
					<cfelse>
					<font color="FF0000">Estimated Recovery</font>
					</cfif>
					
					</b></td>
					<td colspan="1" align="left">#claim.PaymentCurrency# </td> 
					
					<td align="right" bgcolor="f2f2f2" colspan="3">
					<cfif amt-adv gte "0">
					  <cfset color = "black"> 
					<cfelse>
					  <cfset color = "804040"> 
					</cfif>
					<font size="2" color="#color#" align="right" >#numberFormat(amt-adv,"__,__.__")#</td>					
			 </tr>		
			 
			 
		</cfif>	
		
		
		
	</cfif>
	
	<cfif src eq "LineExternal" and Claim.Reference neq "">		
		
			<cfquery name="Offset" 
		 	datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     IMP_CLAIMOFFSET
			WHERE    f_dorf_id_code_pybh = '#Claim.Reference#' 
			AND      f_pybh_doc_id = '#Claim.ReferenceNo#'
			</cfquery>
			
			
			<tr bgcolor="white">
		         <td></td>
				<td colspan="6"><b><font color="gray">Claim Total:</b></td>
				<td>#Claim.PaymentCurrency#</td>
				<td align="right"><font color="gray"><b>#numberFormat(amt,"__,__.__")#</b></td>
				
			</tr>
			
			<cfloop query="Offset">

			<tr bgcolor="ffffdf">
		         <td></td>
		        <td colspan="6"><b>Less:</b> Offset #f_dorf_id_code_rcvh# #f_rcvh_doc_id#</td>
				<td >#Claim.PaymentCurrency# </td>			
				<td align="right"><font color="red"><b>(#numberFormat(offset_amt,"__,__.__")#)</b></td>					
			</tr>	
							
			</cfloop>
			
			<cfif offset.recordcount gte "1">
			
				<cfquery name="Offset" 
			 	datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   sum(offset_amt) as Offset
				FROM     IMP_CLAIMOFFSET
				WHERE    f_dorf_id_code_pybh = '#Claim.Reference#' 
				AND      f_pybh_doc_id = '#Claim.ReferenceNo#'
				</cfquery>
				
				<tr bgcolor="f5f5f5">
			       <td></td>
					<td colspan="6"><b>Amount Paid:</b></td>
					<td>#Claim.PaymentCurrency#</td>
					
					<cfif amt gte Offset.Offset>
					<td align="right"><font color="gray"><b>#numberFormat(amt-Offset.Offset,"__,__.__")#</b></td>
					<cfelse>
					<td align="right"><font color="red"><b>#numberFormat(amt-Offset.Offset,"__,__.__")#</b></td>
					</cfif>
									
				</tr>
			
			</cfif>
		
		</cfif>
	
	</cfoutput>
	