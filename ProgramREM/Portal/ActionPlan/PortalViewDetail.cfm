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

<cfparam name="client.widthfull" default="#client.width#">

<cf_wait1 flush="yes">

<cf_LoginTop FunctionName = "#URL.ID#" Graphic="No">
	
	<table width="100%" align="center" height="94%" border="0" cellspacing="0" cellpadding="0">
	<tr><td><cfinclude template="PortalViewBanner.cfm"></td></tr>
	<tr><td height="8"></td></tr>
	<tr>
	<td valign="top">    
		<cfinclude template="../../Application/Program/ProgramView/ProgramViewGeneral.cfm">
	</td>
	</tr>
	</table>

<cf_LoginBottom FunctionName = "#URL.ID#">

<cf_waitEnd>

