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

<cfif url.mode eq "save">

<cfquery name="update" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   ProgramAllotmentAllocationDetail
		SET      Remarks = '#url.memo#'
		WHERE    AllocationId = '#url.id#'														
</cfquery>		

</cfif>
<cfquery name="get" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ProgramAllotmentAllocationDetail
		WHERE    AllocationId = '#url.id#'														
</cfquery>		

<cfoutput>
	
	<cfif url.mode eq "edit">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td width="100%">
     			<input type="text" id="memo_#url.id#" name="memo_#url.id#" value="#get.Remarks#" class="regularxl"  style="width:100%" maxlength="80">
			</td>
			<td align="center" style="padding-left:2px">
						
			    <input type="button" name="Save" value="Save" class="button10s" style="height:25;width:40"
				       onclick="ColdFusion.navigate('AllocationEntryDetailLogMemo.cfm?mode=save&id=#url.id#&memo='+document.getElementById('memo_#url.id#').value,'edit_#url.id#')">
				
				</td>
			</tr>
		</table>
		
	<cfelse>
	
	#get.Remarks#
	
	</cfif>	

</cfoutput>