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
<cfset balance = 0>
<cfset fill = 0>
<cfset strapfill = 0>
<cfset vSize = round(url.gSize * url.gScale * 100) / 100>					
<cfset capacity = url.gCapacity>

<cfif url.gQuantity neq 0>
	<cfset balance = url.gQuantity>
	<cfset fill = balance/capacity>
	<cfset strapfill = strapbalance/capacity>
</cfif>

<cfoutput>

<cfset vFillText1 = "#lsnumberFormat(balance,',._')# #url.UoMDescription#">
<cfset vFillText2 = "#lsnumberFormat(fill*100,'._')#%">
<cfset vStrapText1 = "#lsnumberFormat(strapbalance,',._')# #url.UoMDescription#">
<cfset vStrapText2 = "#lsnumberFormat((strapfill)*100,'._')#%">

<cfset vToolTipFillText = "System">
<cfset vToolTipStrapText = "Strap">

<cfif url.gGraphType eq "loss">
	<cfset vFillText1 = "#url.transactionType# Loss:">
	<cfset vFillText2 = "#lsnumberFormat(fill*100,'._')#% per #url.strapbalance# transactions">
	<cfset vStrapText1 = "#url.transactionType# Pointer:">
	<cfset vStrapText2 = "#lsnumberFormat(strapbalance,',._')# #url.UoMDescription# (#lsnumberFormat((strapfill)*100,'._')#%)">
	<cfset vToolTipFillText = "Loss">
	<cfset vToolTipStrapText = "Pointer">
</cfif>
<br>
<br>
<br>
<table width="80%" align="center">
	<tr>
		<td align="center">
			<table>
				<tr>
					<td align="right">
						<img name="up" src="#SESSION.root#/Images/Logos/Up.png" height="50" width="50">
					</td>
					<td align="left" valign="middle">
						<font size="+3"><b>#lsnumberFormat(fill*100,'._')#% Loss</b></font>
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td align="center" bgcolor="c0c0c0">
			&nbsp;&nbsp;<font size="+2"><b>#url.strapbalance# Transactions</b></font>&nbsp;&nbsp;			
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr>		
		<td align="center">
			<table>
				<tr>
					<td align="right">
						<img name="down" src="#SESSION.root#/Images/Logos/Down.png" height="50" width="50">
					</td>
					<td align="left" valign="middle">
						<font size="+3"><b>0% Loss</b></font>
					</td>	
				</tr>
			</table>
		</td>
	</tr>
</table>

</cfoutput>