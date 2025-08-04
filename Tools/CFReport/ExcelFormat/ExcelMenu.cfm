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
<cfoutput>

<table cellspacing="0" cellpadding="0">
<tr>
	<td>
	<input type="button" name="mail" id="mail" value="eMail" class="button10s" style="font-size:15px;width:120px;height:53px" onclick="openexcel('mail','#url.id#','#url.table#')">
	</td>
	<td style="padding-left:3px">
	<input type="button" name="view" id="view" value="Open" class="button10s" style="font-size:15px;width:120px;height:53px" onclick="openexcel('open','#url.id#','#url.table#')">
	</td>
</tr>
</table>

</cfoutput>