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

	<table width="97%" border="0" cellspacing="2" cellpadding="2" align="center" rules="rows" bordercolor="silver" >
	
		<tr><td class="labelit"><b>Claim Submission Fund Account Period Mapping Table</td>
		    <td align="right"><input type="button" class="button10g" name="Add" value="Add" onClick="recordadd()"></td>
		</tr>
		
		<tr><td colspan="2" id="fundbox">
	
		<cfset url.addHeader = 0>
		<cfinclude template="../FundValidation/RecordListing.cfm">
		
		</td></tr>
		
	</table>
	
</cfoutput>	
	
	
	