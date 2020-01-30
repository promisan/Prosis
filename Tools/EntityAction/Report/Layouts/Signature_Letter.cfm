<cfoutput>
	<table width="99%" cellspacing="0" cellpadding="0" id="tdata_letter">

			<cfif Attributes.Closing neq "">
				<tr valign="right">
					<td width="100%" colspan="2">
						<table width="100%">
							<tr>
								<td></td>
								<td width ="40%">
								#Attributes.Closing#
								</td>
								<td width="5%"></td>
							</tr>

							<tr>
								<td></td>
								<td width ="40%">
								#Attributes.From#
								</td>
								<td width="5%"></td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>	
			<cfif Attributes.SectionLine eq "Yes">
			<tr>
				<td colspan="2" class="continous" width="100%">&nbsp;</td>
			</tr>
			<tr height="10">
				<td colspan="2">&nbsp;</td>
			</tr>			
			</cfif>
			
			<cfif Attributes.SignatureTitle neq "">
				<tr valign="center">
					<td width="100%" colspan="2">
						#Attributes.SignatureTitle#
					</td>
				</tr>
			</cfif>
				
			<cfif Attributes.SignatureLine1 neq "">
				<tr>
					<td colspan="2">
					<div class="content" align="justify">
						#Attributes.SignatureLine1#
					</div>	
					</td>
				</tr>

			</cfif>
			
			<cfif Attributes.SignatureLine2 neq "">
				<tr>
					<td colspan="2">
					<div class="content" align="justify">
						#Attributes.SignatureLine2#
					</div>
					</td>
				</tr>

			</cfif>
				
				
			<cfif Attributes.SignatureLine3 neq "">	
				<tr>
				<td colspan="2">			
				<div class="content" align="justify">
						#Attributes.SignatureLine3#
				</div>		
				</td>	
				</tr>

			</cfif>	
				
			<cfif Attributes.SignatureTitle neq "">	
				<tr>
					<td align="right" width="70%" valign="top">
						<table width="100%" >
							<tr height="5">
								<td width="40%" align="right" valign="bottom">
									#Attributes.SignatureLabel#:
								</td>
								<td class="continous" width="60%">
									&nbsp;
								</td>
							</tr>
							
							<tr height="5">
								<td width="40%" align="right" valign="bottom">
								</td>
								<td width="60%" align="center">
									#Attributes.SignedBy#
								</td>
							</tr>
						</table>
				</td>
				<td align="left" width="30%" valign="top">
						<table width="100%" >
							<tr height="5">
								<td width="10%" align="right" valign="bottom">
									Date:
								</td>
								<td class="continous" width="40%">
									&nbsp;
								</td>
								<td></td>
							</tr>
							
						</table>				
					
				</td>
				</tr>
		</cfif>		
	</table>
</cfoutput>