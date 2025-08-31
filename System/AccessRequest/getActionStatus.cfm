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
	<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   UserRequest
		<cfif url.ajaxid eq "">
		WHERE 1=0
		<cfelse>
		WHERE  RequestId = '#url.ajaxid#' 
		</cfif>		
	</cfquery>

	<cfif get.ActionStatus eq "9">
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="FF0000">This request was cancelled</font>
				
	</td></tr>
	</table>
	
	<cfelseif get.ActionStatus eq "3">
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="green">This request is completed</font>
				
	</td></tr>
	</table>
	
	
	<cfelse>
	
	
	<table>
	<tr><td class="labellarge" style="padding-top:10px;padding-left:20px">
	
			<b><font color="gray">This request is in process</font>
				
	</td></tr>	
	</table>
	
	
	</cfif>