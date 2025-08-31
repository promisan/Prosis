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
<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
</cfquery>

<cfoutput>

<cfif url.personno neq "">
	
	<cfoutput>
		<script>	 	  
		  document.getElementById('personnoto').value        = '#url.personno#'	
		  document.getElementById('toname').innerHTML        = '#REPLACE(Person.FirstName,"'","","ALL")# #REPLACE(Person.LastName,"'","","ALL")#'	
		  document.getElementById('toindexno').innerHTML     = '#Person.IndexNo#'	
		  document.getElementById('togender').innerHTML      = '#Person.Gender#'	
		  document.getElementById('tonationality').innerHTML = '#Person.Nationality#'	  
		</script>
	</cfoutput>

</cfif>

</cfoutput>