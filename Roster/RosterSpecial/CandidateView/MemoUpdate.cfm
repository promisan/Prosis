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

<cfoutput>

<cfif Len(URL.ID1) gt 1000>

    <script language="JavaScript">
	
	   {
		alert("You entered a memo that exceeded the allowed length of 1000 characters.")
	   }
	
	</script>

<cfelse>
  
	<cfquery name="UpdatePosition1" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	  	UPDATE ApplicantFunction
		SET   FunctionJustification  = '#URL.ID1#'
		WHERE ApplicantNo            = '#URL.ApplicantNo#'
		AND   FunctionId             = '#URL.FunctionId#'
		
	</cfquery>	
	
	Saved
	
	<!---
	
	<script language="JavaScript">
	
	{
	parent.document.getElementById("#url.frm#Min").click()
	
	}
	
	</script>
	
	--->

</cfif>
</cfoutput>
