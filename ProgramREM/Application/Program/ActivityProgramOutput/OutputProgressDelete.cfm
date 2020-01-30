
<cfparam name="URL.ProgressID" default="">

<cfquery name="DeleteProgress" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
UPDATE ProgramActivityProgress  	
	Set RecordStatus = 9
	WHERE ProgressId = '#URL.ProgressId#'		  
</cfquery>		

<cfoutput>

<script language="JavaScript">
 window.location="../ProgramActivity/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#";
</script>
</cfoutput>
	
