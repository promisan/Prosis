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
<cf_listingscript>

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<table width="100%" height="100%">
	<tr><td valign="top" height="100%" style="padding-top:4px">
		<cf_securediv style="height:100%" 
		     bind="url:FolderListDetail.cfm?dir=#url.dir#&key=#url.key#&systemfunctionid=#url.systemfunctionid#" 
			 id="mylisting">
	</td></tr>
	
	<tr><td height="1" class="linedotted"></td></tr>
	<tr><td height="100" bgcolor="f4f4f4">
		<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr><td width="150">CM case No</td><td>
			<select></select>
			</td>
			<td>Open CM request</td>
			</tr>
			<tr><td>Reason:</td>
			     <td colspan="2"><input type="text" style="width:90%" name="Reason" id="Reason" value=""></td>
				 
			</tr>
			<tr><td>Comments</td>
			    <td colspan="2"><input type="text" style="width:90%" name="Comments" id="Comments" value=""></td>
			</tr>
			<tr><td colspan="3"><input type="button" class="button10g" name="Upload selected files" id="Upload selected files" value="Upload"></td></tr>
			
		</table>
	</td></tr>
</table>
