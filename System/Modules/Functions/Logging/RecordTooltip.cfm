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
<cf_screentop height="100%" html="no">

<cfoutput>
<table align="center" cellspacing="0" class="formpadding">
	<tr><td colspan="3"><b>#url.time# - #url.action#</b></td></tr>
	<tr>
		<td width="5"></td>
		<td width="20%">Performed from host:</td>
		<td>#ucase(url.host)#</td>
	</tr>
	<tr>
		<td width="5"></td>
		<td>From IP Address:</td>
		<td>#url.ip#</td>
	</tr>
	<tr>
		<td width="5"></td>
		<td>By the Account:</td>
		<td>[#url.acc#] #url.name#</td>
	</tr>
</table>
</cfoutput>