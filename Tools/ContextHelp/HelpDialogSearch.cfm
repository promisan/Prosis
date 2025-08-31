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
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="f8f8f8" style="border-bottom:1px solid silver">
<tr>
<td align="center" height="29">

	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td>
			<input type="text" name="searchme" id="searchme" style="background-color:transparent;border:0px;font-size:15px;width:100%" class="regularxl" onKeyUp="javascript:check()">
			</td>
			<td width="25" align="center" height="25" style="border-left:1px solid gray">
			<img src="#SESSION.root#/Images/locate3.gif" align="absmiddle" id="searchicon" alt="" border="0" onclick="find(searchme.value)">
			</td>
		</tr>	
		
		<tr><td>		
			<cfdiv id="findme"/>
		</td></tr>
		
	</table>
	
</td>
</tr>

</table>
</cfoutput>