<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
			
	<tr>
	   <td colspan="2"><b><font color="0080FF">Claim Preparation</font></b></td>
	   <td align="right"><img src="#SESSION.root#/Images/step3.gif" alt="" border="0"></td>
	</tr>
	<tr>
	  <td height="1" colspan="3"></td>
	</tr>		
	<cfinclude template="../Inquiry/eMail/eMail.cfm">
	<tr><td height="5"></td></tr>	
	<tr>
		<td width="40" colspan="1" height="22">		
		&nbsp;<img src="#SESSION.root#/Images/mail2.gif" alt="EMail address" border="0" align="absmiddle">
		</td>
		<td colspan="2" width="80%" >
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
					Send correspondence to eMail address:</b>
					<cfinput type="Text" name="eMailAddress" value="#mail#" message="Please enter a valid Internet eMail address" validate="email" required="Yes" visible="Yes" enabled="Yes" size="30" maxlength="40" class="regular">
					</td>
					<td>
					  <cf_helpfile code       = "TravelClaim" 
						    id          = "eMail" 
							display     = "Icon"	
							displayText = "EMail Address"				
							color       = "006688">
					</td>
				</tr>
			</table>
		</td>

	</tr>
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="3" height="1" bgcolor="d0d0d0"></td></tr>
	<tr><td height="3"></td></tr>
	<tr><td colspan="3" align="center">
		
		<table cellspacing="2" cellpadding="2">
			<tr>
				<td>
				
					<input name="Back" 
					class   = "ButtonNav1"
					value   = "Previous" 
					type    = "button"
					style   = "width:150"
					onclick = "step('hide','hide','regular','hide')"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
				
				</td>
				
				<td>
				
					  <cf_Navigation
						 Alias         = "AppsTravelClaim"
						 Object        = "Claim"
						 Group         = "TravelClaim" 
						 Section       = "CL08"
						 Id            = "#URL.ClaimId#"
						 BackEnable    = "0"
						 HomeEnable    = "0"
						 ResetEnable   = "0"
						 ProcessEnable = "1"
						 ProcessName   = "Proceed"			 
						 NextSubmit    = "1"
						 NextEnable    = "0"
						 RefreshLeftMenu = "0"
						 NextMode      = "1">
				
				</td>
			</tr>
		</table>
							
	</td></tr>
</table>

</cfoutput>