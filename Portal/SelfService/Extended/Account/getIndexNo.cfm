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
<cfquery name="getPerson" 
	datasource="appsEmployee">
	SELECT   * 
	FROM     Person
    WHERE    IndexNo LIKE '%#url.IndexNo#%'
</cfquery>	

<cfoutput>

<cfif getPerson.recordcount eq "1">

	<script language="JavaScript">
	
	 document.getElementById('lastname').value   = '#getPerson.LastName#'
	 document.getElementById('firstname').value  = '#getPerson.FirstName#'
	
	 <cfif getPerson.Gender eq "M">
	  document.getElementById('gender').selectedIndex = 0
	 <cfelse>
	  document.getElementById('gender').selectedIndex = 1   
 	 </cfif>
	 document.getElementById('emailaddress').focus()
	 	 
	</script>
	
	<font face="Calibri" color="008080">Valid!</font>	


<cfelse>

	<font face="Calibri" color="red">Not found!</font>	

</cfif>	 

</cfoutput>