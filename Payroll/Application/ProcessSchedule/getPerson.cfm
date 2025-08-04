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

<cfparam name="url.personno" default="">

<cfif url.personNo neq "">
		
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
	</cfquery>
		
</cfif>

<table width="100%" cellspacing="0" cellpadding="0">

<tr class="labelmedium"><td>
	
	<cfoutput>
		<input type="hidden" id="personno" name="personno" value="#Person.personNo#">						
	</cfoutput>
	
	</td>

	<td width="100%" style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:17px;border-left:1px solid silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	
	  <cfoutput>#Person.FirstName#&nbsp;#Person.LastName#</cfoutput>
	  
	</td>
	
	<cfif person.recordcount eq "1">
		<td style="width:30px;padding-left:2px;padding-right:2px;padding-top:1px;padding-bottom:0px;height:25px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
			<cfoutput>
			<cf_img icon="open" onclick="EditPerson('#Person.PersonNo#')">
			</cfoutput>
		</td>
	</cfif>
	
</tr>

</table>
