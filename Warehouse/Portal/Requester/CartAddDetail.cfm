<cfoutput>
		
<table width="100%" cellspacing="0" cellpadding="0">

	<tr><td height="4"></td></tr>
	
	<cfif detail.ItemUoMSpecs neq "">
	
		<tr><td>    	
				
			<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				<tr><td height="6"><font face="Verdana" size="2">Specifications:</td></tr>
				<tr><td>&nbsp;
				#Detail.ItemUoMSpecs#
				</td></tr>
			</table>
				
			</td>
		</tr>	
	
	</cfif>	
	
	<cfif special.shippingMemo neq "">
		
		<tr><td>		
			
			<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
					<tr><td height="6"><font face="Verdana" size="2">Shipping Instructions</td></tr>
					<tr><td height="6"></td></tr>
					<tr><td bgcolor="f4f4f4" align="center" colspan="2"><img src="#SESSION.root#/images/finger.gif" alt="" border="0" align="absmiddle">#special.shippingMemo#.</td></tr>	
				
			</table>
		   		
		  </td>
		</tr>
	
	</cfif>
	
	<tr><td height="4"></td></tr>
	
</table>

</cfoutput>