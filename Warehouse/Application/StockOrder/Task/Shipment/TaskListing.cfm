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

<table width="100%" height="100%">

<tr>
	<td height="2">
	
	<cfquery name="Get" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT     *
			FROM      Ref_TaskType
			WHERE     Code = '#url.tasktype#'
	</cfquery>
	
	<cfquery name="GetHeader" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT  *
			FROM    Status
			WHERE   Class = 'Taskorder' 
			AND     Status = '#URL.STA#'
	</cfquery>
	
		<font face="Verdana" size="1">TaskOrder:</font> 
		<font face="Verdana" size="3"> <cfoutput>#get.Description# / #getHeader.Description#</cfoutput></font>
	
	</td>
</tr>

<tr><td height="5"></td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="3"></td></tr>

<tr><td height="100%">		

<cfinclude template="TaskListingContent.cfm">		  
	
</td></tr>
</table>		
