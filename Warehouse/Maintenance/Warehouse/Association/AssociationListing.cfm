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
<cf_screentop html="no" jquery="yes">

<table width="97%" height="100%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td>
			<table>	
				<tr>
					<td class="labelit"><cf_tl id="Type">:</td>
					<td style="padding-left:10px;">
						<select name="associationType" id="associationType" class="regularxxl">
							<option value="Transfer"> <cf_tl id="Transfer">
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="line"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td height="100%">
			<cf_securediv id="divAssociation" style="height:100%; min-height:100%;" 
			    bind="url:Association/AssociationListingDetail.cfm?warehouse=#url.warehouse#&type={associationType}">
		</td>
	</tr>
</table>


