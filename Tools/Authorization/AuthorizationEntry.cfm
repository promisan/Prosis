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
<table width="100%">
     <tr>
	    <td>
		<input type="password" id="authorizationcode" name="AuthorizationCode" class="regularxxl" style="width:200px;text-align:center" onKeyUp   = "search(event)">
		
		</td>
		<td><input type="button" class="button10g" id="autsubmit" name="Submit" value="Submit" onclick="setauthorization('#url.mission#','#url.systemfunctionid#','#url.object#','#url.objectclass#',document.getElementById('authorizationcode').value)"></td>
	 </tr>
</table>
</cfoutput>

<!--- dialog which has module and mission as reference --->