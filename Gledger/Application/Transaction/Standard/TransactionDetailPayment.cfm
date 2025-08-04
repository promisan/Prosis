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
<cfparam name="URL.ID1"     default="ReferenceName">
<cfparam name="URL.find"    default="">
<cfparam name="URL.journal" default="">
<cfparam name="URL.period"  default="">
<cfparam name="URL.page"    default="1">

<table width="99%">

<tr><td id="lineentry" style="width:100%">
		
	<table width="98%">
			
		<tr style="border-bottom:1px solid silver">
			<td colspan="2">
			
			<table><tr class="labelmedium">
			
			<td style="padding-left:4px"><cf_tl id="Find">:</td>
			<td style="padding-left:4px">		
			  <input name="search" id="search" style="background-color:f1f1f1;width:120px;border:0px" class="regularxxl enterastab" size="10">							
			</td>
			<td height="25" style="padding-left:10px">
			
				<select name="group" id="group" class="regularxxl" style="background-color:f1f1f1;width:200px;border:0px" size="1">
				     <OPTION value="ReferenceName" <cfif URL.ID1 eq "ReferenceName">selected</cfif>><cf_tl id="by Vendor">
				     <option value="Journal" <cfif URL.ID1 eq "Journal">selected</cfif>><cf_tl id="by Journal">			     
				     <OPTION value="TransactionDate" <cfif URL.ID1 eq "TransactionDate">selected</cfif>><cf_tl id="by Date">
					 <OPTION value="ActionBefore" <cfif URL.ID1 eq "ActionBefore">selected</cfif>><cf_tl id="by DueDate">
				</select> 
				
			</td>
			
			</tr>
			</table>
			</td>
		</tr>	
				
		<tr>
			<td colspan="2" align="center">
			  <cf_securediv id="paymentresult" 
			      name="paymentresult" 
				  bind="url:TransactionDetailPaymentResult.cfm?journal=#URL.journal#&period=#URL.Period#&find=#URL.find#&ID1={group}&search={search}" 
				  bindonload="true">			
			</td>
		</tr>
	
	</table>

</td></tr>

</table>

