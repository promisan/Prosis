	
<cfset sh = "30">
<cfset sw = "100">

<table width="100%" bgcolor="d6d6d6">

<cfoutput query="support">
<tr>
	
		<td width="15" height="100%" valign="top">
		    <div id="#orgunit#">
		    <table height="100%" cellspacing="0" cellpadding="0">
				<tr>
				
				<td height="100%" style="border-right: 1px solid Black;"></td>
				<td valign="top">
				    <table cellspacing="0" cellpadding="0">
					<tr><td height="6"></td></tr>
					<tr><td width="30" style="border-top: 1px solid Black;"></td></td></tr>
					</table>
				</td>
					
				</tr>	
			</table>
				
		 </td>
			 
	     <td valign="top">
		 <table border="0" width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		     <tr>
			 	<td colspan="4" align="left" valign="top">
				 <table border="0" width="#sw#" cellspacing="0" cellpadding="0" class="formpadding">
				 	<tr>
					
					<cfset script = "javascript:editOrgUnit('#Orgunit#','#url.parent#')">  
					<cfset style  = "cursor: pointer;"> 
									
					<td colspan="1" width="120" align="left" valign="top">
						<table width="#sw-10#"
					       height="13"
					       cellspacing="0"
					       cellpadding="0"
						   class="formpadding"
						   bgcolor="#color#"
					       style="#style#; border: 1px inset gray;"
					       onClick="#script#">
							<tr><td height="2" bgcolor="a0a0a0"></td></tr>  
							<cfif script eq ""> 
							<tr><td height="30" align="center" style="border: 1px solid 000000;">#OrgUnitCode# #OrgUnitName#</td></tr>
							<cfelse>
							<tr><td height="30" 
								align="center"  
								style="border: 1px solid black;" 
								id="select" 
								onMouseOver="hl(this,'hl')" 
								onMouseOut="hl(this,'normal')">#OrgUnitCode# #OrgUnitName#</td></tr>
							</cfif>
							
						</table>
					</td>
					</tr>
									
				</table>
				</td>
			 </tr>
		 </table>
		 </div>
	</td>	 
</tr>
</cfoutput>	

</table>		