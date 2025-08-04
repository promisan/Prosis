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

<cfquery name="Detail" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		SELECT * 
		FROM   UserMail
		WHERE  MailId = '#url.drillid#'		
</cfquery>		

<cfoutput query="detail">

<table width="100%">
<tr><td style="padding:5px">
	<table width="96%" style="border: 1px dotted Silver;" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td width="80" class="labelit">From:</td><td class="labelmedium">#Detail.MailAddressFrom#</td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr>
		<td colspan="2" class="labelit">#Detail.Mailbody#</td>
	</tr>
	</table>
</td></tr>
</table>

</cfoutput>

