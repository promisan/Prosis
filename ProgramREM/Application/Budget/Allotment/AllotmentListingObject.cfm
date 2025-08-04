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

<cf_compression>

<cfif url.fund neq "">

	<cfquery name="Checking" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ProgramObject
		WHERE ProgramCode = '#URL.ProgramCode#'
		AND   ObjectCode = '#URL.ObjectCode#'		
		AND   Fund = '#url.fund#'		   
	 </cfquery>	
		
	<cfif url.select eq "true">
										
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ProgramObject
			(ProgramCode, ObjectCode,Fund)
			VALUES ('#url.ProgramCode#','#url.ObjectCode#','#url.fund#')			
	    </cfquery>
				
	</cfif>		 	


<cfelse>
	
	<cfif url.select eq "true">
				
			<cfquery name="FundList" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   DISTINCT ltrim(rtrim(F.Fund)) as Fund
					FROM     Ref_AllotmentEdition E,
					         Ref_AllotmentEditionFund F
					WHERE    E.EditionId IN (#Form.Edition#)					
					AND      E.EditionId = F.EditionId	
				</cfquery>
			 
			<cfloop query="FundList">
					
				<cfquery name="Insert" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ProgramObject
					(ProgramCode, ObjectCode,Fund)
					VALUES ('#url.ProgramCode#','#url.ObjectCode#','#fund#')			
			    </cfquery>
			
			</cfloop>
	
	<cfelse>
	
			<cfquery name="Checking" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM ProgramObject
				WHERE ProgramCode = '#URL.ProgramCode#'
				AND   ObjectCode = '#URL.ObjectCode#'				   
			 </cfquery>	
			 
	</cfif>		 	
	
</cfif>	