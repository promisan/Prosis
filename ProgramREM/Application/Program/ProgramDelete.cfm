
<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Program P,
	       ProgramPeriod Pe
	WHERE  P.ProgramCode = Pe.ProgramCode 
	AND    P.ProgramCode = '#URL.ProgramCode#'		
	AND    Pe.Period     = '#URL.Period#'  	
</cfquery>	

<cfif get.PeriodHierarchy neq "" and get.recordcount eq "1">

	<!--- we disable all projects under it in this period as well --->
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ProgramPeriod 
		SET    RecordStatus        = '9',  
		       RecordStatusDate    = getDate(),
			   RecordStatusOfficer = '#session.acc#'
		WHERE  ProgramCode IN (SELECT ProgramCode 
		                       FROM   Program 
							   WHERE  Mission = '#get.mission#')					   
		AND    Period = '#URL.Period#' 		
		AND    PeriodHierarchy LIKE '#get.PeriodHierarchy#%'
	</cfquery>	
	
	<cfoutput>
	
			<cf_tl id="Reinstate" var="1">
			<button name="Delete" 
			 style="width:160;height:27" 
			 value="Deactivate" 
			 class="button10g"
			 onClick="ptoken.navigate('#SESSION.root#/ProgramRem/Application/Program/ProgramReinstate.cfm?programcode=#url.programcode#&period=#URL.Period#','recordstatus')">#lt_text# : #url.period#</button>
				 
     </cfoutput>				 
				
<cfelse>

	<cfoutput>
	<script>
		alert("#get.ProgramClass# could not be deactivated.")
	</script>
	</cfoutput>		

</cfif>

