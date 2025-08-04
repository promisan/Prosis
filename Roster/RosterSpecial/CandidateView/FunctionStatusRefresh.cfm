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

<cfparam name="url.idfunction" default="">
<cfparam name="url.owner"      default="">

<cfif url.idfunction neq "">
	
	 <cfquery name="getStatus"
		   datasource="AppsSelection"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
			SELECT		*, 
			            (SELECT count(*) 
						 FROM ApplicantFunction
						 WHERE FunctionId = '#url.idfunction#'
						 AND   Status = R.Status) as Counted 
			FROM		Ref_StatusCode R 
			WHERE   	R.Id     = 'FUN' 			
			AND         R.Owner  = '#url.owner#'		
			ORDER BY 	R.Status
	</cfquery>
	
	<cfoutput query="getStatus">
		
		<script>
		   try {		  
		 	document.getElementById('count_#status#').innerHTML = '<B>[#counted#]</B>'
			} catch(e) {}
		</script>
	
	</cfoutput>

</cfif>