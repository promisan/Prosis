

<cfoutput query="Leave">		
			
	<tr>
	
		<cfif currentrow eq "1">
			<td colspan="1" style="padding-top:2px" class="labelmedium"><cf_tl id="Leave"><cf_tl id="Entitlements">:</td>
		<cfelse>
			<td></td>
		</cfif>
			
		<td>
		<table ccellspacing="0" ccellpadding="0">
			<tr>
			<td class="labelmedium">#Description# accrual:</td>	   
			<td height="20" style="padding-left:4px">										  											   			   
				<INPUT type="input" name="#LeaveType#" value="0" style="padding-top:2px;width:30;text-align:center" maxlength="3" class="regularxl"> days									   
			</td>		
			</tr>					
		</table>
		</td>
					
	</TR>	
			
</cfoutput>	