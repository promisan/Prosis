<cfoutput>

<cfif URL.Mode eq "Shipped">

	<cfform method="POST" name="formfilter" onsubmit="return false">
	
	<table width="100%" cellspacing="0" cellpadding="3">
		
	<tr><td height="2"></td></tr>
				
		<TR>
		
		<TD>Reference:</TD>
		<TD>	
		<input type="text" name="Reference" class="regular" value="" size="20">
		</TD>
	
		<TD>Requested&nbsp;between:</TD>
		<TD width="120">	
		<cf_space spaces="35">
		 <cf_intelliCalendarDate8
			FieldName="datestart" 
			Default=""
			Class="regular"
			AllowBlank="True">	
			
		</TD>
		
		<TD>and:</TD>
		<TD width="110">
		<cf_space spaces="35">
		<cf_intelliCalendarDate8
			FieldName="dateend" 
			Default=""
			Class="regular"
			AllowBlank="True">				
		</TD>
		<td>
		<button
	       name="go"
	       value="Filter"
	       class="button3"
	       style="height:20;width:26"
	       onClick="reqstatusfilter('#url.mode#')">
		   <img src="<cfoutput>#SESSION.Root#</cfoutput>/images/go1.gif" alt="" border="0">
		</button>
		
				
		</td>
		<td width="40%"></td>
		</tr>
		<tr><td height="1" bgcolor="silver" colspan="8"></td></tr>
		
	</table>	
	
	</cfform>

</cfif>

</cfoutput>