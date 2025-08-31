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
<cfquery name="ParentList" 
        datasource="AppsSelection" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM Ref_ExperienceParent
		WHERE SearchEnable = 1
		AND Parent IN (SELECT Parent 
		               FROM Ref_ExperienceParent 
					   WHERE Area = '#URL.Area#')
		ORDER BY SearchOrder
</cfquery>
	
<cfloop query="ParentList">
	
	<cfquery name="Delete" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM RosterSearchLine
	 WHERE SearchId = '#URL.ID#'
	  AND SearchClass IN ('#Parent#','#Parent#Operator')	 
    </cfquery>		
	
	<cfparam name="Form.#Parent#Status" type="any" default="">
	<cfset Status  = Evaluate("FORM."&#Parent#&"Status")>
			
	<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RosterSearchLine
			     (SearchId,
				 SearchClass,
				 SelectId, SelectDescription, SearchStage)
	        VALUES ('#URL.ID#',
			       '#Parent#Operator', 
		          '#Status#','#Status#','5')
	 </cfquery>
	 
	<!--- insert keyword entries --->

    <cfparam name="Form.#Parent#FieldId" default="">
	
	<cfset FieldId = Evaluate("FORM.#Parent#FieldId")>
		
	<cfoutput>#fieldid#</cfoutput>	
			
	<cfloop index="Item" 
	        list="#FieldId#" 
	        delimiters="' ,">
			
			<cftry>
			
			<cfquery name="Insert" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RosterSearchLine
		         (SearchId,
				 SearchClass,
				 SelectId, SearchStage)
		      VALUES ('#URL.ID#',
			       '#Parent#', 
		          '#Item#','5')
		    </cfquery>
			
			<cfcatch></cfcatch>
			
			</cftry>
				
	</cfloop>	
		
	<!--- update from database --->
		
	<cfquery name="Update" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE RosterSearchLine
		 SET    SelectDescription = S.Description
		 FROM   RosterSearchLine INNER JOIN Ref_Experience S ON RosterSearchLine.SelectId =  S.ExperienceFieldId 
		 WHERE  RosterSearchLine.SearchId = '#URL.ID#'
		 AND    RosterSearchLine.SearchClass = '#Parent#'
    </cfquery>
		
</cfloop>	

<cfoutput>
<script>    
	ptoken.navigate('Search4Detail.cfm?id=#url.id#','profile')
	ProsisUI.closeWindow('keyworddialog')	
</script>
</cfoutput>

