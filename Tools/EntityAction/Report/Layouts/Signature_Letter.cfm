<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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