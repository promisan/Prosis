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
<cftransaction>

    <cfquery name="DeletePanel" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ApplicantInterviewpanel
		WHERE InterviewId = '#URL.InterviewId#'
	</cfquery>
		
	<cfloop index="row" from="1" to="#Form.Row#">
	
		<cfparam name="FORM.PersonNo_#row#" default="">

		<cfset personNo  =   Evaluate("FORM.PersonNo_#row#")>
		<cfset memo      =   Evaluate("FORM.PanelMemo_#row#")>
		
		<cfif personNo neq "">
		
		     <cftry>
		
			 <cfquery name="InsertPanel" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ApplicantInterviewpanel
					 (PersonNo,
					  InterviewId,		  
					  PanelPersonno,
					  PanelMemo)
				  VALUES ('#URL.PersonNo#',		  
						  '#URL.InterviewId#',
						  '#personNo#',
						  '#memo#')
			</cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
		
		</cfif>
		
	</cfloop>
			
</cftransaction>	
			
<script>
	window.close()
	opener.history.go()
</script>	
