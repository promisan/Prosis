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

 <cfquery name="Search" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		FROM   RosterSearch
		WHERE  SearchId = '#url.ID#'		
</cfquery>

<cfparam name="Form.TopicStatus" type="any" default="AND">

    <cfquery name="Clean" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        DELETE FROM RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    (SearchClass = 'SelfAssessmentOperator' OR SearchClass = 'SelfAssessment')
	</cfquery>
		 
	<!--- ---------------------- ---> 		
	<!--- insert keyword entries --->
	<!--- ---------------------- --->
	
	<cfquery name="Master" 
	    datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * FROM Ref_Topic		
		WHERE  ValueClass = 'List'  <!--- Parent = 'Miscellaneous' --->
		AND    Operational = 1
		AND    Topic IN (SELECT Topic FROM Ref_TopicOwner WHERE Owner = '#url.owner#' AND Operational = 1)		
	</cfquery>
		
	<cfloop query="Master">
	
	<cfparam name="FORM.value_#Topic#" default="">
    <cfset value     = Evaluate("FORM.value_" & #Topic#)>
		
		<cfif value neq "">
			 		
			<cfquery name="InsertExperience" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RosterSearchline 
			         (Searchid,
					 SearchClass,
					 SelectId,
					 SelectParameter,
					 SelectDescription,
					 SearchStage)
			  VALUES ('#URL.id#', 
			          'SelfAssessment',
			          '#topic#',
			      	  '#value#',
					  '#Description# - #value#',
					  '5')
	    	  </cfquery>
				  
  		</cfif>			  
		
	</cfloop>	
		
<cfoutput>
<script>    
	ptoken.navigate('Topic/Topic.cfm?ID=#URL.ID#&owner=#url.owner#','topic')
	ProsisUI.closeWindow('topicdialog')	
</script>
</cfoutput>
