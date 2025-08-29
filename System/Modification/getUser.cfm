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
<cfoutput>


<cfquery name="get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM UserNames
	WHERE  Account = '#url.useraccount#'	
</cfquery>

<cfset name = replaceNoCase("#get.FirstName# #get.LastName#","'","ALL")>

<script>
  
document.getElementById('requester').value = '#url.useraccount#'  
document.getElementById('email').value     = '#get.eMailAddress#'
 
 try {
   document.getElementById('requestername').value = '#name#'
  } catch(e) {}
  
</script>
</cfoutput>
