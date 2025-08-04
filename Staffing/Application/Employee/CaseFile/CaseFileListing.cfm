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

<!--- 

1. define the selection date from the mandate
2. show people
--->

<cf_screentop height="100%" scroll="yes" jquery="Yes"  html="No" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
 
<cf_ListingScript>
					
<table width="100%" height="100%" cellspacing="0" cellpadding="0">						
					
<tr><td height="8"></td></tr>

<tr>
	<td height="30" style="padding-left:6px">	
		<cfinclude template="../PersonViewHeaderToggle.cfm">
	</td>
</tr>

<tr><td align="center" height="100%">									

	<table width="98%" align="center" height="100%">
	
	<tr><td class="line" height="1"></td></tr>
		
	<tr>
		<td height="100%"><cfinclude template="CaseFileListingContent.cfm"></td>
	</tr>
	
	</table>
	
	</td></tr>		
	
</table>	
					  