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
<cfoutput query="Leave">		
			
	<tr>
	
		<cfif currentrow eq "1">
			<td colspan="1" style="padding-top:2px" class="labelmedium"><cf_tl id="Leave"><cf_tl id="Entitlements">:</td>
		<cfelse>
			<td></td>
		</cfif>
			
		<td>
		<table ccellspacing="0" ccellpadding="0">
			<tr>
			<td class="labelmedium">#Description# accrual:</td>	   
			<td height="20" style="padding-left:4px">										  											   			   
				<INPUT type="input" name="#LeaveType#" value="0" style="padding-top:2px;width:30;text-align:center" maxlength="3" class="regularxl"> days									   
			</td>		
			</tr>					
		</table>
		</td>
					
	</TR>	
			
</cfoutput>	