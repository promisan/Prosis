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
<cfparam name="url.account" default="">

<cfoutput>
	
	<cfif URL.account neq "">
					  
		<cfquery name="qUser" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM UserNames 
		WHERE Account = '#url.account#'
		</cfquery>
		
		<input type="text" class="regularxl" name="lookup" size="40" maxlength="40" value="#qUser.FirstName# #qUser.LastName#">
		
	<cfelse>
	  
	  	<input type="text" class="regularxl" name="lookup" value=""  size="40" maxlength="40" readonly >											  
	  
	</cfif>
	
	
	<input type="hidden" name="lastname" id="lastname">
	<input type="hidden" name="firstname" id="firstname">
	<input type="hidden" name="userid" id="userid" value="#url.account#" >


</cfoutput>