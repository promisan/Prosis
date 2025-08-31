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
<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset eff = dateValue>
  
<cfif not isdate(eff)>
  
       	<script>
	    	 alert("Invalid date.")		 
		</script>	
  
<cfelse>
	
   <cfquery name="Check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM PersonGrade
		WHERE PersonNo = '#URL.ID#'
		AND DateEffective <= #eff#	
		AND Source     = 'System'			
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
		<script>
	    	 alert("You have entered an effective date which is not allowed as it fall after the first entry")		 
		</script>	
	
	<cfelse>
	
		<cftry>

		   <cfquery name="Add" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO PersonGrade
				(PersonNo,
				 DateEffective,
				 ContractLevel,
				 ContractStep,
				 Source,
				 OfficerUserid,
				 OfficerLastName,
				 OfficerFirstName)
				 VALUES		 
				 ('#URL.ID#',
				 #eff#,
				 '#form.contractLevel#',
				 '#form.contractStep#',
				 'Manual',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
			</cfquery> 
			
			<cfoutput>
			
				<script>
					ptoken.navigate('PersonGrade.cfm?id=#url.id#','dialoggrade')
				</script>
				
			</cfoutput>
			 
			 <cfcatch>
			 
				 <script>alert("You have entered an invalid date.")</script>
			 
			 </cfcatch>
			 
			</cftry> 
			
	</cfif>
		
</cfif>		

	