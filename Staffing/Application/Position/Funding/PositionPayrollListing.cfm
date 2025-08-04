<!--
    Copyright © 2025 Promisan

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
<cfset vSelectedColor = 'E0E0E0'>

<cfoutput>
	<table width="100%" height="100%" align="center">
		<tr><td height="5"></td></tr>
		<tr>
			<td valign="top" width="1%" style="padding:8px; border-right:1px dotted ###vSelectedColor#;">
				<table>
					<tr 
						style="cursor:pointer; background-color:#vSelectedColor#;" 
						class="clsVMenu"
						onclick="$('.clsVMenu').css('background-color',''); this.style.backgroundColor='#vSelectedColor#'; ptoken.navigate('#session.root#/Staffing/Application/Position/Funding/PositionPayrollSettlement.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#','divPositionPayrollListing');">
						<td style="padding:5px;">
							<table width="100%">
								<tr>
									<td align="center">
										<img src="#session.root#/images/logos/staffing/Entitlement.png" style="height:40px;">
									</td>
								</tr>
								<tr>
									<td class="labelmedium" align="center">
										<cf_tl id="Settlement">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr 
						style="cursor:pointer;"
						class="clsVMenu" 
						onclick="$('.clsVMenu').css('background-color',''); this.style.backgroundColor='#vSelectedColor#'; ptoken.navigate('#session.root#/Staffing/Application/Position/Funding/PositionPayrollEntitlement.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#','divPositionPayrollListing');">
						<td style="padding:5px;">
							<table width="100%">
								<tr>
									<td align="center">
										<img src="#session.root#/images/logos/staffing/Settlement.png" style="height:40px;">
									</td>
								</tr>
								<tr>
									<td class="labelmedium" align="center">
										<cf_tl id="Entitlement">
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
			<td valign="top" height="100%">
				<cf_securediv 
					id="divPositionPayrollListing"
					style="height:100%;" 
					bind="url:#session.root#/Staffing/Application/Position/Funding/PositionPayrollSettlement.cfm?systemfunctionid=#url.systemfunctionid#&positionno=#url.positionno#">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	</table>
</cfoutput>