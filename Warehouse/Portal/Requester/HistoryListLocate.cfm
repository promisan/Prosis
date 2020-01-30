
<cfparam name="url.mode" default="regular">

<cfoutput>

	<cfif URL.mode eq "Shipped">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<cfform method="POST" name="formfilter" onsubmit="return false">		
					
			<TR height="30">
			
			<TD style="padding-left:10px"><cf_tl id="Reference">:</TD>
			<TD>	
			<input type="text" name="Reference" id="Reference" value="" size="20">
			</TD>
		
			<TD style="padding-left:10px"><cf_tl id="Requested during">:</TD>
			<TD width="120" style="z-index:10; position:relative;padding:0px">	
			
			<cf_space spaces="35">
			
			 <cf_intelliCalendarDate8
				FieldName="datestart" 
				Default=""
				Class="regularh"
				AllowBlank="True">	
				
			</TD>
			
			<TD><cf_tl id="and">:&nbsp;</TD>
			<TD width="110" style="z-index:10; position:relative;padding:0px">
			
			<cf_space spaces="35">
			
			<cf_intelliCalendarDate8
				FieldName="dateend" 
				Default=""
				Class="regularh"
				AllowBlank="True">				
				
			</TD>
			
			<td>
			
			
			<button name="go" id="go"
		       value="Filter"
		       class="button3"
		       style="height:20;width:26"
		       onClick="reqstatusfilter('#url.mode#')">
			   <img src="<cfoutput>#SESSION.root#</cfoutput>/images/go1.gif" alt="" border="0">
			</button>
							
			</td>
			<td width="40%"></td>
			</tr>
			<tr><td height="1" bgcolor="silver" colspan="8"></td></tr>
		</cfform>	
		</table>	
		
	<cfelse>
	
		<cf_compression>	
	
	</cfif>
	
</cfoutput>