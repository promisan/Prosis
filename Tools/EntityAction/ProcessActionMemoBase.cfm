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
<cfquery name="Document" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   OrganizationObjectActionReport
		WHERE  ActionId   = '#Action.ActionId#'
	</cfquery>

	<!--- --------------- --->										
	<!--- show memo/notes --->
	<!--- --------------- --->
													
	<cfif (document.recordcount gte "1" and Action.ProcessMode eq "0") or Action.EnableTextArea gte "1">
				  
	   <tr><td colspan="2">
	   		
 		   	  <cfset url.MemoActionId = Action.ActionId>					  
			  <cfset url.textmode = "edit">
			  <table width="100%" border="0" align="center">
			  <tr><td>  						 						  					  	   				   
		   		<cfinclude template="ProcessActionMemo.cfm">	  								
				</td></tr>
		      </table>						
 			
	   </td></tr>
	   
	   <cfif Action.EnableTextArea eq "0">
	   
    		  	<input type = "hidden" name = "actionmemo" id="actionmemo"  value= "#ActionMemo#">
	   </cfif>	
   
   	</cfif>