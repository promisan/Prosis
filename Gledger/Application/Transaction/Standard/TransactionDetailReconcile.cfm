<cfparam name="URL.ID1"     default="Journal">
<cfparam name="URL.find"    default="">
<cfparam name="URL.journal" default="">
<cfparam name="URL.period"  default="">

<table width="100%" style="height:100%;min-height:385;padding-top:5px">
	
	<tr><td id="lineentry" style="height:100%">
									
		<table width="100%" height="100%">
		
			
			<tr>			
				<td width="100%" id="tSearch" name="tSearch" colspan="2" style="height:40px;padding-left:20px;padding-right:28px"></td>			
			</tr>	
		
			<cfquery name="HeaderSelect"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM #SESSION.acc#GledgerHeader_#client.sessionNo#
			</cfquery>
						
			<tr style="height:20px">
				<td colspan="2" align="center" style="padding-left:20px;padding-right:28px">
				<table width="100%">										
					<tr class="line labelmedium">
					    <td id="total" align="right" style="width:100%;padding-right:10px"></td>
						
						<!---
					    <TD width="20"  align="center">S</TD>
						<TD width="70"><cf_tl id="Per"></TD>
					    <TD width="70"><cf_space spaces="25"><cf_tl id="Transaction"></TD>
						<TD style="padding-left:5px" colspan="2"><cf_tl id="Account"></TD>			
						<TD style="padding-left:5px" width="90"><cf_tl id="Date"></TD>
					    <TD style="padding-left:5px" width="27%"><cf_tl id="Reference"></TD>
						--->
						
						<TD bgcolor="yellow" style="border:1px solid silver;min-width:120" align="center" colspan="2"><cf_tl id="Outstanding"></TD>		  
						
						<td style="border:1px solid silver;min-width:260" align="center" bgcolor="D7EFF7">
						<table width="100%">
						  <tr class="line labelmedium"><td align="center" colspan="3"><cf_tl id="Reconciliation"></td></tr>
						  <tr class="labelmedium" bgcolor="D3E9F8">		
									   		<td align="center"  style="padding-left:4px"><cf_tl id="Amount"> <cfoutput>#headerselect.currency#</cfoutput></td>
											<TD align="center"  style="padding-left:4px"><cf_tl id="Exchange"></TD>
											<td align="center"  style="padding-left:4px"><cf_tl id="Offset"></td>			
						  </tr>
						</table>
						</td>			
					</tr>
				 </table>	
				 </td>
			</tr>			 
											
			<tr>
				<td colspan="2" align="center" style="height:420px;padding-left:20px;padding-right:30px;padding-bottom:10px">											  
				  <cf_divscroll style="padding-right:4px;padding-bottom:5px">				  			  				  
				      <cfdiv id="reconcileresult" name="reconcileresult" style="height:100px;" bind="url:TransactionDetailReconcileResult.cfm?mode=#url.mode#&journal=#URL.journal#&period=#URL.Period#&find=#URL.find#&ID1=#URL.ID1#" bindonload="true">			
				  </cf_divscroll>				  
				</td>
			</tr>				
		
		</table>
	
	</td></tr>

</table>

<script>
	Prosis.busy('yes');		
</script>	
