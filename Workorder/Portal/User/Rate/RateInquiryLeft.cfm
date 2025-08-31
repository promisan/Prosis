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
  <table cellpadding="0" cellspacing="0" border="0" width="100%" style="padding-left:3px;">
  
  	<tr>
  		<td style="padding-left:8px; padding-top:8px">
			<table cellpadding="2" cellspacing="2" border="0" width="100%">
			<tr><td colspan="2" height="5px"></td></tr>
			<tr>
				<td height="18px" class="labelit" colspan="2" style="padding:1px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/clearances_line_bg.png')">
					<b>&nbsp;International Calls</b>
				</td>
			</tr>
						
			<tr><td colspan="2" height="5px"></td></tr>
			<tr height="25px">
				<td class="labelit" height="10px">&nbsp;&nbsp;Calling Rates:</td>
				<td width="30px" class="labelit" align="left">Map:</td>
			</tr>
			
						
			<tr>
				<td style="padding-left:13px" valign="middle">
				<cfoutput>
				
				<cfquery name="Country"
						datasource="appsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						SELECT  *
						FROM    Ref_Nation	
				</cfquery>	
				
					<select id="ctry" class="regularxl" name="ctry" onchange="countrytoggle(this.value)">
						<option value="">Select a Country</option>
						<cfloop query="Country">
							<cfif country.code neq "">
								<option value="#Country.code#">#Country.name#</option>
							</cfif>
						</cfloop>
					</select>
				</cfoutput>
				</td>
				<td>
					<input title="View the map" type="Checkbox" checked name="map" id="map" onClick="doIt()">
				</td>
			</tr>
			<tr><td colspan="2" height="12px"></td></tr>
			
			<tr>
				<td height="18px" class="labelit" colspan="2" style="padding:1px; background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/clearances_line_bg.png')">
					<b>&nbsp;Domestic Long Distance Calls</font></b>
				</td>
			</tr>
			<tr><td colspan="2" height="5px"></td></tr>
			<tr><td class="labelit" height="25px">&nbsp;&nbsp; Calling Rates:</td></tr>
			<tr>
				<td colspan="2" class="labelit" style="padding-left:13px" valign="middle">	
					<b>Landline</b> Long Distance rate for Canada, Puerto Rico and domestic USA including Hawaii and Alaska is <b>$ 0.07 per minute</b>.
				</td>
			</tr>
			
			<tr><td colspan="2" height="5px"></td></tr>
			<tr><td class="labelit" height="25px">&nbsp;&nbsp; Wireless Coverage Maps:</td></tr>
			<tr>
				<td colspan="2" style="padding-left:13px" valign="middle">	
					<select id="carrier" name="carrier" class="regularxl" onchange="carrier()">
						<option value="">Select a Carrier</option>
						<option value="http://www.wireless.att.com/coverageviewer/#?type=voice">ATT</option>
						<option value="http://www.t-mobile.com/coverage/pcc.aspx">T-Mobile</option>
						<option value="http://www.verizonwireless.com/b2c/CoverageLocatorController?requesttype=NEWREQUEST?p_url=coverage_map_demo&=CDinaBox&cm_ite=Roaming">Verizon</option>
					</select>
				</td>
			</tr>
										
			<!---
			<tr>
				<td height="18px" colspan="2" style="padding:1px; background-image:url('#SESSION.root#/Images/clearances_line_bg.png')">
					<b><font face="Verdana">&nbsp;Roaming lookup</font></b>
				</td>
			</tr>
			<tr><td colspan="2" height="5px"></td></tr>
			<tr height="25px">
				<td height="10px" colspan="2">&nbsp;&nbsp;From:</td>
			<tr>
			<tr>
				<td colspan="2" style="padding-left:13px" valign="middle">	
					<select id="carrier" name="carrier">
						<option>Select Carrier</option>
						<option>ATT</option>
						<option>T-Mobile</option>
						<option>Verizon</option>
					</select>
				</td>
			</tr>
			<tr><td colspan="2" height="1px"></td></tr>
				<td colspan="2" style="padding-left:13px" valign="middle">
					<select id="fctry" name="fctry">
						<cfloop query="Country">
						<option value="#Country.code#">#Country.name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr><td colspan="2" height="5px"></td></tr>
			<tr height="25px">
				<td height="10px" colspan="2">&nbsp;&nbsp;To:</td>
			<tr>
			<tr>
				<td colspan="2" style="padding-left:13px" valign="middle">	
					<select id="tctry" name="tctry">
						<cfloop query="Country">
						<option value="#Country.code#">#Country.name#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			
			--->
			
			</table>
		 </td>
      </tr>
		  	 	  
  </table>
  
  
