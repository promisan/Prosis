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
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_AssignmentClass
	     WHERE AssignmentClass = '#url.assignmentclass#' 
</cfquery>	

<cfif get.Incumbency eq "100">

  <script>
  	try{
     se = document.getElementsByName("incumbency")
	 se[0].checked = true
	}
	catch(e)
	{
	} 
   </script>
   
<cfelseif get.Incumbency eq "50">

	<script>
  	try{

     se = document.getElementsByName("incumbency")
	 se[1].checked = true
	}
	catch(e)
	{
		
	} 
	 
   </script>

<cfelse>

	<script>
		try {
			se = document.getElementsByName("incumbency")
			se[2].checked = true
		}
		catch(e)
		{
			
		}
   </script>
   
</cfif>	