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
				
	    <tr bgcolor="E1F8FF" style="cursor: pointer;" class="line navigation_row">
		<cfif url.outputshow eq "0">
		<td align="right" bgcolor="white" colspan="2" style="height:20px;border-right: 1px solid Gray;">
		
		<img src="#SESSION.root#/Images/Expand4.gif"
	     alt="Progress"
	     id="pmax#clrow#"
	     border="0"
		 align="absmiddle"
	     class="hide"
	     style="cursor: pointer;"
	     onClick="javascript:showproject('#clrow#')">
		 
		<img src="#SESSION.root#/Images/Collapse4.gif"
	     alt="Collapse"
	     id="pmin#clrow#"
	     border="0"
		 align="absmiddle"
	     class="regular"
	     style="cursor: pointer;"
	     onClick="javascript:showproject('#clrow#')">
		
		</td>
		<cfelse>
		<td></td>
		</cfif>
		
		<td style="border-right: 1px solid Gray;" class="labelit">				
		<cfif subproject eq "">
			<cf_space spaces="72" class="labelit" label="Main" script="javascript:showproject('#clrow#')">
		<cfelse>
		    <cf_space spaces="72" class="labelit" label="#SubProject#" script="javascript:showproject('#clrow#')">	
		</cfif>
		</td>			
		<td style="border-right: 1px solid Gray;" class="labelit">
		<cf_space align="center" class="labelit" spaces="23" label="#DateFormat(Project.ProjectStart, CLIENT.DateFormatShow)#"></td>
		<td style="border-right: 1px solid Gray;" class="labelit">
		<cf_space align="center" class="labelit" spaces="23" label="#DateFormat(Project.ProjectEnd, CLIENT.DateFormatShow)#"></td>
		<td style="border-right: 1px solid Gray;" class="labelit">
		<cf_space align="center" class="labelit" spaces="14" label="#Project.ProjectDays#d"></td>
		
		<cfset ln = 0>
		
		<cfset ds = Project.ProjectStart>
		<cfset de = Project.ProjectEnd>
		
		<cfinclude template="ActivityProgressDefine.cfm">	
		
		<cfset color = "gray">
		
		<td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		
		<cfloop index="itm" from="1" to="#Mth#">				   
			<td style="border-left:1px dotted gray;">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<cfloop index="wk" from="1" to="4">	
				
				<cfset ln = ln+1>	
				
				<cfif ln gte elmS AND ln lte elmE>
				    <cfset color = "black">
				<cfelse>
					<cfset color = "white">
			   </cfif>				   
			      
			   <cfif ln lte elmC>	
			      <cfset bc = "ffffcf"> 
			   <cfelse>
			      <cfset bc = "f4f4f4">
			   </cfif>
			  						
				<td width="25%" bgcolor="#BC#" style="font-size:4px">
				
				&nbsp;  <!--- Dev 12/10/2015 do not removed &nbsp; --->
				
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				
				<cfif color eq "white">
				
					<tr><td></td></tr>	
				
				<cfelse>
				
				<tr><td height="4"></td></tr>
				<tr><td height="10" bgcolor="#color#"
				 style="border-bottom: 1px solid gray;border-top: 1px solid gray;"></td></tr>
				<tr><td height="4"></td></tr>
				
				</cfif>
				
				</table>	
				</td>
				
			</cfloop>
			</tr>	
			</table>	
			</td>
		</cfloop>
		
		</tr></table></td>
		
		</tr>	
				
</cfoutput>		