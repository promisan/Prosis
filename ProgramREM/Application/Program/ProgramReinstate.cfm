
<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program P,ProgramPeriod Pe
	WHERE  P.ProgramCode = '#URL.ProgramCode#'		
	AND    Pe.Period     = '#URL.Period#'  
	AND    P.ProgramCode = Pe.ProgramCode
</cfquery>	

<cfif get.PeriodHierarchy neq "" and get.recordcount eq "1">
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProgramPeriod 
		SET    RecordStatus  = '1',  
		       RecordStatusDate = getDate(),
			   RecordStatusOfficer = '#session.acc#'
		WHERE  ProgramCode IN (SELECT ProgramCode 
		                       FROM   Program 
							   WHERE  Mission = '#get.mission#')					   
		AND    Period           = '#URL.Period#' 
		AND    PeriodHierarchy LIKE '#get.PeriodHierarchy#%'
	</cfquery>	
	
	<cfoutput>
	
	     <cf_tl id="Deactivate" var="1">
				<button name="Delete" 
				 style="width:150;height:27px" 
				 value="Reinstate" 
				 class="button10g" 
				 onClick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/ProgramDelete.cfm?programcode=#url.ProgramCode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
 		 
	</cfoutput>	
		
<cfelse>

<cfoutput>

	SELECT * 
	FROM   Program P,ProgramPeriod Pe
	WHERE  P.ProgramCode = '#URL.ProgramCode#'		
	AND    Pe.Period     = '#URL.Period#'  
	AND    P.ProgramCode = Pe.ProgramCode
	
	</cfoutput>

	<script>
		alert("Program could not be reinstated.")
	</script>		

</cfif>

