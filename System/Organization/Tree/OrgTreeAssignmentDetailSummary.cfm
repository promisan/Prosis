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
<cf_OrgTreeAssignmentData	   
	   presentation  = "summary"
	   mode          = "query"
	   tree          = "#url.tree#"
	   selectiondate = "#url.selectiondate#"
	   orgunit       = "#URL.Unit#"
	   postclass     = "#url.postclass#"
	   fund          = "#url.fund#">


<table width="100%" cellspacing="0" cellpadding="0" bgcolor="ffffef" class="formpadding">

    <tr><td colspan="7" height="1" bgcolor="d4d4d4"></td></tr>
	
	<cfif qDetails.recordcount eq "0">
	
	   <cfoutput>
		<tr><td class="labelit" colspan="6" align="center" style="cursor: pointer;" onClick="details('e#url.Unit#','#url.Unit#','show')">No assignments found.</td></tr>
	   </cfoutput>
	   
	</cfif>		
			
	<cfoutput query="qDetails">
												
		<tr>
			<td width="4">&nbsp;</td>
			
			<td width="45" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;">
				#left(replace(PostGrade,'-',''),3)#
			</td>
			<td width="40" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;">
			    #Fund#
			</td>				
			<td width="40" style="font: xx-small; color: 002350; border: 0px solid black;" style="cursor: pointer;" >
			    #Total#
			</td>				
		</tr>
			
		
	</cfoutput>

</table>	