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
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Applicant
    WHERE  PersonNo = '#url.personno#'
</cfquery>

<cfif Get.Recordcount eq "0">
	
	<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   Person
	    WHERE  PersonNo = '#url.personno#'
	</cfquery>

</cfif>

<cfif get.Recordcount eq "1">

<cfoutput>
	<input type="text" name="name" id="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:3px">				
	<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#">
</cfoutput>

</cfif>
			