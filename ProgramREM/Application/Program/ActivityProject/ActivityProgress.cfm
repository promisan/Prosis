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

<table width="99%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td height="3"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
    <tr>
		<td height="26" colspan="2" align="center">
		
		   <cf_tl id="Close" var="1">
		   <input type="button" name="Cancel" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" onClick="javascript:cl()">
		   
		</td>
	</tr>	
	<tr><td height="1" colspan="2"class="linedotted"></td></tr>  

	<cfoutput>
	<tr><td id="box#url.activityid#">
	
		<cfinclude template="../../Activity/Progress/ActivityProgressOutput.cfm">
	
	</td></tr>
	</cfoutput>	

</table>