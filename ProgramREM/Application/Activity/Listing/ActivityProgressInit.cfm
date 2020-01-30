
<cfquery name="Program" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Program
		 WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>
	
<cfset mission = program.mission>	

<cfinclude template="../../Tools/ProgramActivityPendingPrepare.cfm">

<cf_FileLibraryScript>

<script>

function revise(st, no) {

	se  = document.getElementById("Rev"+no)
	
	if ((st == "1") || (st== "0")) {
	   se.className = "Hide"
	   se.value = ""  
	   } else {
	   se.className = "Regular"
	   }
}

function deleteprogress(prgid,actid,fileno) {
    ColdFusion.navigate('OutputProgressDelete.cfm?fileno='+fileno+'&progressid='+prgid+'&activityid='+actid,'box'+actid)
}

</script>