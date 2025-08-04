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

<cfparam name="URL.positionno" default="0">
<cfparam name="URL.selected"   default="">

<cfquery name="Position" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Position 
		WHERE      PositionNo = '#URL.positionNo#'
</cfquery>

<cfquery name="Person" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Person 
		WHERE      PersonNo = '#URL.selected#'
</cfquery>

<cfoutput>

	<Table cellspacing="0" cellpadding="0" height="18">
		<tr>
		<td>
		<input type="text" name="PersonDescription" id="PersonDescription" class="regularxxl" size="30" maxlength="80" value="#Person.IndexNo# #Person.FirstName# #Person.LastName# <cfif Person.gender neq "">(#Person.Gender#)</cfif>" readonly>
		<input type="hidden" name="name" id="name" size="40" maxlength="60" value="#Person.LastName#" readonly>
		<input type="hidden" name="personno" id="personno" value="#URL.selected#" class="regular" size="10" maxlength="10" readonly style="text-align: center;">		
		</td>
		</tr>		
	</Table>
	
</cfoutput>
