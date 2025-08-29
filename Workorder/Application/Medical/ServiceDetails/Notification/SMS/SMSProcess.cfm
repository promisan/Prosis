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

<table width="100%" height="100%" align="center"><tr><td align="center" style="padding-left:30px">

  <form style="height:100%;width:100%" action="javascript:send_sms_go()" name="sms_window">
  
  <table align="center" valign="top" width="100%" height="100%"  style="background: url('Notification/SMS/original.png') no-repeat;">
  	<tr height="85"><td></td><td colspan="3">&nbsp;</td></tr>
	<tr height="30">
		
		<td colspan="4" style="padding-left:23px;padding-right:28px">
		<cfoutput>		
		<textarea style="width:100%" rows="12" name="sms_text" id="sms_text">#Client.SMS#</textarea>
		</cfoutput>
		</td>
	</tr>
	
  	<tr height="10">
			<td width="20"></td>
			<td colspan ="3">&nbsp;</td>
	</tr>	
	<tr>
		<td width="1"></td>
		<td>
		<input type="Submit" value="Send">
		</td>
		<td width = "140">
		</td>
		<td>
			<input type="button" value="Close" onClick="ColdFusion.Window.hide('bb');">
		</td>
	</tr>
  	<tr height="100%">
			<td width="20"></td>
			<td colspan="3">&nbsp;</td>
	</tr>
	</table> 
  </form>
  
</td></tr></table>  
  
</cfoutput>


