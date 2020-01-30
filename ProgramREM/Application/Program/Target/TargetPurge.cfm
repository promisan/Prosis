
<cfquery name="update" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
		UPDATE 	ProgramTarget
		SET		RecordStatus = '9'
		WHERE	ProgramCode  = '#url.programcode#'
		AND		Period       = '#url.period#'
		AND		Targetid     = '#url.targetid#' 
	
</cfquery>

<cfoutput>
	<script>
   	   _cf_loadingtexthtml='';	
   	   ptoken.navigate('#session.root#/ProgramREM/Application/Program/Target/TargetListing.cfm?programCode=#url.programcode#&period=#url.period#&ProgramAccess=EDIT&category=#url.category#', 'targetdetail_#url.category#')	
	</script>
</cfoutput>