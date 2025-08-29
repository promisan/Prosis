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

<table width="100%" align="center" cellspacing="0" cellpadding="0">
	<tr>
	<td height="20" width="8%" align="right"><b>WORKFLOW</b><td colspan="2"></td>
	</tr>
	<tr>
	<td height="10" align="right"><strong>ENTITY:</strong></td><td><strong>&nbsp;&nbsp;#Entity.EntityDescription# [#Entity.EntityCode#]</strong></td>
	</tr>
	<td height="10" align="right"><strong>CLASS:</strong></td><td><strong>&nbsp;&nbsp;#Class.EntityClassName# [#URL.EntityClass#]</strong></td>
	<td align="right">#DateFormat(NOW(),"dd/mm/yyyy")#</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="9" class="line"></td></tr>
	</tr>
</table>	

</cfoutput>