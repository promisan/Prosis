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

<cf_screentop height="100%" label="Release of funds edition NNNN" scroll="Yes" html="Yes" layout="webapp" banner="yellow" bannerheight="50">

<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="14"></td></tr>

<tr>
 <td>Fund</td>
 <td>OrgUnit</td>
  <cfloop index="resource" from="1" to="4">
  	<td>#resource#</td>
  </cfloop>
  <td>Total</td>
</tr>

<tr><td colspan="7" class="line"></td></tr>

<cfloop index="fund" from="1" to="4">
	<tr>
	<td><b>fund#Fund#</td>
	</tr>
<cfloop index="orgunit" from="1" to="6">
	<tr>
	<td></td>
	<td>service name</td>	
	<cfloop index="resource" from="1" to="4">
	<td><input type="text" name="amt_#fund#_#orgunit#_#resource#" style="width:100" class="amount"></td>
	</cfloop>
	<td>subtotal</td>
	</tr>
</cfloop>
<tr>
	<td></td>
	<td></td>	
	<cfloop index="resource" from="1" to="4">
	<td>total</td>
	</cfloop>
	<td>fund total</td>
	</tr>
</cfloop>

</table>

</cfoutput>