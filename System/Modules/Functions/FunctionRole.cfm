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
<cfparam name="url.dialogHeight" default="625">

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  L.*
    FROM    Ref_ModuleControl L
	WHERE   SystemFunctionId = '#URL.ID#'
</cfquery>

<table width="95%" align="center"  cellspacing="0" cellpadding="0">
	
	<tr><td height="10"></td></tr>	
	
	<cfif Line.AccessRole eq "1">
	
	<TR>
	   <td width="20">
	   <img width="48" height="48" style="padding:0 5px 5px 0;" src="<cfoutput>#SESSION.root#</cfoutput>/Images/Authorization.png" align="absmiddle" alt="System Function Admin" border="0">
	   </td>
	   <td style="padding-top:20px"><h2 style="font-size:22px;font-weight:200;">Grant access to the following ROLES:</h2></td>
	   
	</TR>
	
	<TR>   
	   <td></td>
       <td colspan="1">
	   	 <cf_securediv bind="url:#SESSION.root#/System/Modules/Functions/Role.cfm?id=#URL.ID#" id="irole">		
		</td>
	</TR>
	
	<cfelse>
	
	<TR>
	   <td width="40" height="38">
	   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/alert.gif" align="absmiddle" alt="System Function Admin" border="0">
	   </td>
	   <td >Access to this function is granted through User Administration</td>
	   
	</TR>
	
	</cfif>
	<tr><td colspan="2" height="25"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<cfif Line.AccessUserGroup eq "1">
		
		<tr><td height="10"></td></tr>			   
		<TR>
	        <td width="20">
			<img width="48" height="48" style="padding:0 5px 5px 0;" src="<cfoutput>#SESSION.root#</cfoutput>/Images/User-Group.png" align="absmiddle" alt="System Function Admin" border="0">
			</td>
			<td style="padding-top:20px"><h2 style="font-size:22px;font-weight:200;position:relative;top:-4px;">Grant access to the following USER GROUPS:</h2></td>
		</TR>
	
		<TR>	
		    <td></td>
			<td colspan="1">
			  <cf_securediv bind="url:#SESSION.root#/System/Modules/Functions/Group.cfm?id=#URL.ID#&dialogHeight=#url.dialogHeight#" id="igroup">		  
			</td>
		</TR>
	
	</cfif>
	<tr><td colspan="2" height="30"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<!--- show only for menu items that are per mission or for menu items that are part of a scope like the warehouse tasks which always 
	have a mission scope --->
	<cfif Line.MenuClass eq "Mission" or Line.MenuClass eq "Detail" or Line.MainmenuItem eq "0" 
		or (Line.MenuClass eq "Builder" and Line.FunctionClass eq "Application") 
		or (Line.SystemModule eq "SelfService")>
		
			<cfset vShow = 1>
			
			<cfif Line.SystemModule eq "SelfService">
			
				<cfquery name="getLineParent" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT 	L.*
					    FROM 	Ref_ModuleControl L
						WHERE 	SystemModule = 'SelfService'
						AND		FunctionClass = 'SelfService'
						AND  	FunctionName = '#Line.FunctionClass#'
				</cfquery>
				
				<cfif getLineParent.MenuClass eq "Mission">
					<cfset vShow = 1>
				<cfelse>
					<cfset vShow = 0>
				</cfif>

			</cfif>
			
			<cfif vShow eq 1>
				
				<tr><td height="10"></td></tr>
				<TR><td height="25">
					<img width="48" height="48" style="padding:0 5px 5px 0;" src="<cfoutput>#SESSION.root#</cfoutput>/Images/Disable-Tab.png" align="absmiddle" alt="Tree access" border="0">
					</td>
					<td style="padding-top:20px"><h2 style="font-size:22px;font-weight:200;position:relative;top:-4px;">Disable function for the the following ENTITIES (Trees):</h2></td>
				</TR>				
				<TR><td></td>
			         <td colspan="1">
					 	 <cf_securediv bind="url:#SESSION.root#/System/Modules/Functions/TreeDeny.cfm?id=#URL.ID#" id="itree">
					</td>
				</TR>
			</cfif>
	</cfif>
		
	</table>