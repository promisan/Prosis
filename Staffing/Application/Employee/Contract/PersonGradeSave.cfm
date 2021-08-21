
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

	