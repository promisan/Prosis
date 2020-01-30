<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">

<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminProgram" 
		  returnvariable="ProgramAccess">
	
<cfif #ProgramAccess# eq "EDIT" or #ProgramAccess# eq "ALL">
	<cfset #ProgramAccess# = "ALL">
<cfelse>
	<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
		Method="program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"
		ReturnVariable="ProgramAccess">	
</cfif>

<cfif #ProgramAccess# neq "ALL">
			
	 <cf_message message = "DELETION DENIED:  Must have Manager Access to delete Outputs that contain active progress reports"
	  return = "back">
	  <cfabort>


<cfelse>

	<cfquery name="DeleteOutput" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	UPDATE ProgramAudit.dbo.AuditObservation 
		SET RecordStatus = 9
		WHERE ObservationId = '#URL.ObservationId#' and
		AuditId='#URL.AuditId#'
	</cfquery>	
	
		
	<cfoutput>
	<script language="JavaScript">
	 window.location="ObservationEntry.cfm?AuditId=#URL.AuditId#";
	</script>
	</cfoutput>
	
	
</cfif>
