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

<cfoutput>

	<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_ModuleControl 
			WHERE    SystemFunctionId = '#url.Id#'
	</cfquery>
			
    <cftry>
	
	    <cfset url.mode = "portal">
		<cfinclude template="../Topics/#Searchresult.FunctionPath#/TopicEdit.cfm">
		   		
	    <cfcatch>
				
		   <table width="100%" height="100" cellspacing="0" cellpadding="0">
		   <tr>
			   <td align="center" class="labelit">
				   <font color="FF0000">Topic Editor could not be located. Please contact your administrator.</b></font>
			   </td>
		   </tr>
		   </table>
		  
		</cfcatch>
	
	</cftry>
	
</cfoutput>	
	
