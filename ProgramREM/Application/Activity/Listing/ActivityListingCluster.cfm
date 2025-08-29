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

	 <!--- ------------ --->
	 <!--- Project Line --->
	 <!--- ------------ --->
	
	<cfset clrow = clrow+1>	
			
    <tr bgcolor="eaeaea" class="line navigation_row labelit" style="cursor: pointer;">
	<cfif url.outputshow eq "0">
	
	<td align="left" colspan="2" valign="top" style="min-width:25px;padding-left:4px;padding-top:2px;height:23px;border-right: 0px solid Gray;">
				
	<img src="#SESSION.root#/Images/Expand4.gif"
	     alt="Progress"
	     id="pmax#clrow#"
	     border="0"
		 align="absmiddle"
	     class="hide"
	     style="cursor: pointer;border:1px solid gray"
	     onClick="showproject('#clrow#')">
	 
	<img src="#SESSION.root#/Images/Collapse4.gif"
	     alt="Collapse"
	     id="pmin#clrow#"
	     border="0"
		 align="absmiddle"
	     class="regular"
	     style="cursor: pointer;;border:1px solid gray"
	     onClick="showproject('#clrow#')">
	
	</td>
	
	<cfelse>
	
	<td colspan="2"></td>
	
	</cfif>
	
	<td style="border-right: 1px solid Gray;">				
	<cfif subproject eq "">
		<cf_space spaces="72" label="Main" script="javascript:showproject('#clrow#')">
	<cfelse>
	    <cf_space spaces="72" label="#SubProject#" script="javascript:showproject('#clrow#')">	
	</cfif>
	</td>			
	<td style="border-right: 1px solid Gray;"></td>
	<td style="border-right: 1px solid Gray;">
	<cf_space align="center" spaces="23" label="#DateFormat(Project.ProjectStart, CLIENT.DateFormatShow)#"></td>
	<td style="border-right: 1px solid Gray;">
	<cf_space align="center" spaces="23" label="#DateFormat(Project.ProjectEnd, CLIENT.DateFormatShow)#"></td>
	<td style="border-right: 0px solid Gray;">
	
	<cftry>
	<cfset diff = datediff("d",Project.ProjectStart,Project.ProjectEnd)+1>
	<cf_space align="center" spaces="14" label="#diff#d">
	<cfcatch></cfcatch>
	</cftry>
	
	</td>
	
	<cfset ln = 0>
	
	<cfset ds = Project.ProjectStart>
	<cfset de = Project.ProjectEnd>
			
	</tr>	
	
		
</cfoutput>		