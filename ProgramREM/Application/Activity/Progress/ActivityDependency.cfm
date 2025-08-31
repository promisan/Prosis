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
<table width="100%" height="100%"  bgcolor="white">
<tr><td valign="top" style="padding:20px">

	<table width="100%" bgcolor="white" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			 		
		<cfquery name="Parent" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    A.*
			FROM      ProgramActivity A,
			          ProgramActivityParent P
			WHERE     P.ActivityId = '#URL.ActivityId#'
			AND       A.ActivityId = P.ActivityParent
		</cfquery>
		
		<tr>
		
			<td width="160px" valign="top" style="padding-top:3px" class="labelmedium">Predecessors:</td>
			
			<td width="70%" colspan="2" align="left">
			<table cellspacing="0" cellpadding="0" class="formpadding">
				<cfoutput query="Parent">
				<cfif currentrow eq "4"><tr></cfif>
				<td width="160" bgcolor="yellow" style="border: 1px solid Gray;">	
				<table align="center">
				<tr><td class="labelit" align="center">#ActivityDescriptionShort#</td></tr>
				<tr><td  class="labelit">#Dateformat(ActivityDateStart,CLIENT.DateFormatShow)# - <b>#Dateformat(ActivityDate,CLIENT.DateFormatShow)#</b></td></tr>
				</table>	
				</td>	
				</cfoutput>
			</tr>
			</table>
			</td>
		
		</tr>
		
		<tr><td height="5"></td></tr>
				
		<cfquery name="Activity" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramActivity
		WHERE     ActivityId = '#URL.ActivityId#'
		</cfquery>
		
		<tr>
		<td valign="top" style="padding-top:3px" class="labelmedium">This task:</td>
		<td colspan="2" align="left">
		<table cellspacing="0" cellpadding="0" class="formpadding"><tr>
		<cfoutput query="Activity">
		<td width="160" bgcolor="f4f4f4" style="border: 1px solid Gray;">	
		<table align="center">
			<tr><td class="labelit" align="center">#ActivityDescriptionShort#</td></tr>
			<tr><td class="labelit">#Dateformat(ActivityDateStart,CLIENT.DateFormatShow)# - #Dateformat(ActivityDate,CLIENT.DateFormatShow)#</td></tr>
		</table>	
		</td>	
		</cfoutput>
		</tr></table>
		</td>
		</tr>
				
		<cfquery name="Child" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    A.*
		FROM      ProgramActivity A,
		          ProgramActivityParent P
		WHERE     P.ActivityParent = '#URL.ActivityId#'
		AND       A.ActivityId = P.ActivityId
		</cfquery>
		
		<tr><td height="5"></td></tr>
		
		<tr>
		<td valign="top" style="padding-top:3px" class="labelmedium">Dependent tasks:</td>
		<cfif Child.recordcount eq "0">
		<td class="labelit" colspan="2" align="left"><b>None</td>
		<cfelse>
		<td colspan="2" align="left">
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<cfoutput query="Child">
		<cfif currentrow eq "4"><tr></cfif>
		<td width="160" bgcolor="F4FBFD" style="border: 1px solid Gray;">	
		<table align="center">
			<tr><td align="center" class="labelit">#ActivityDescriptionShort#</td></tr>
			<tr><td class="labelit">#Dateformat(ActivityDateStart,CLIENT.DateFormatShow)# - #Dateformat(ActivityDate,CLIENT.DateFormatShow)#</td></tr>
		</table>	
		</td>	
		</cfoutput>
		</tr></table>
		</td>
		</cfif>
		</tr>
		
	</table>

</td></tr>
</table>	

