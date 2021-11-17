<cfparam name="URL.ID1"     default="Journal">
<cfparam name="URL.find"    default="">
<cfparam name="URL.journal" default="">
<cfparam name="URL.period"  default="">

<table width="100%" style="height:100%;min-height:385;padding-right:20px">
	
	<tr><td id="lineentry" style="height:100%;padding-right:25px">
									
		<table width="100%" height="100%" border="0" style="border-top:1px solid silver">		
			
			<cfquery name="HeaderSelect"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
			</cfquery>
						
			<tr style="height:20px">
				<td colspan="2" valign="top" align="center" style="height:60px">
				<table width="100%" style="height:100%">										
					<tr class="line labelmedium">
					    <td id="tSearch" name="tSearch" align="right" bgcolor="f4f4f4" style="border-right:1px solid silver;width:100%;padding-right:4px;padding-left:3px"></td>
						<td id="total" valign="bottom" align="right" bgcolor="ffffcf" style="border-right:1px solid silver;padding-bottom:2px;padding-right:1px"></td>
						<!---
					    <TD width="20"  align="center">S</TD>
						<TD width="70"><cf_tl id="Per"></TD>
					    <TD width="70"><cf_space spaces="25"><cf_tl id="Transaction"></TD>
						<TD style="padding-left:5px" colspan="2"><cf_tl id="Account"></TD>			
						<TD style="padding-left:5px" width="90"><cf_tl id="Date"></TD>
					    <TD style="padding-left:5px" width="27%"><cf_tl id="Reference"></TD>
						--->
						
						<TD bgcolor="yellow" style="border-right:1px solid silver;min-width:120" align="center" colspan="2"><cf_tl id="Outstanding"></TD>		  
						
						<td style="min-width:255px;width:255px;max-width:255px" align="center" bgcolor="D7EFF7">
						<table width="100%">
						  <tr class="line labelmedium"><td align="center" colspan="4"><cf_tl id="Reconciliation"></td></tr>
						  <tr class="labelmedium" bgcolor="D3E9F8">		
									   		<td align="right"  style="padding-right:24px"><cf_tl id="Amount"> <cfoutput>#headerselect.currency#</cfoutput></td>
											<TD align="right"  style="padding-right:24px"><cf_tl id="Exchange"></TD>
											<td align="right"  style="padding-right:4px"><cf_tl id="Offset"></td>		
											<td align="center"  style="padding-left:20px"></td>		
						  </tr>
						</table>
						</td>			
					</tr>
				 </table>	
				 </td>
			</tr>			 
											
			<tr>
				<td colspan="2" align="center" style="height:690px">														  
				  <cf_divscroll>				  			  				  
				      <cf_securediv id="reconcileresult" 
					  name="reconcileresult" 
					  bind="url:TransactionDetailReconcileResult.cfm?init=Yes&mode=#url.mode#&journal=#URL.journal#&period=#URL.Period#&find=#URL.find#&ID1=#URL.ID1#" bindonload="true">			
				  </cf_divscroll>				  
				</td>
			</tr>				
		
		</table>
	
	</td></tr>

</table>

<script>
	Prosis.busy('yes');		
</script>	
