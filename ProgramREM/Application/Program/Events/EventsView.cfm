
<cfparam name="url.portal" default="0">
<cfparam name="url.mode"   default="view">

<cfoutput>

<script>

function workflowdrill(key,box,mode) {
	
	    se = document.getElementById(box)		
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {		
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"	
		 
		   ColdFusion.navigate('#SESSION.root#/ProgramREM/application/Program/Events/EventsWorkflow.cfm?ajaxid='+key,key)	
   		  
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 	
	
	}		

</script>
</cfoutput>

<cfif url.portal eq "0">
	
	<cfajaximport tags="cfdiv,cfform,cfinput-datefield">
	<cf_actionlistingscript>
	<cf_FileLibraryScript>
	<cf_calendarscript>
	
	<cf_screenTop height="100%" html="No" scroll="yes" flush="Yes" jquery="Yes">
		
		<table width="98%" align="center" border="0">
		
			<cfset url.attach = "0">
			
			<tr><td><cfinclude template="../Header/ViewHeader.cfm"></tr>
			
			<tr><td id="eventdetail">
			
				<cfif url.mode eq "edit">
					<cfinclude template="EventsEntryDetail.cfm">
				<cfelse>
					<cfinclude template="EventsEntryDetail.cfm">
				</cfif>
				</td>
			</tr>   
		
		</table>
	
	<cf_screenbottom html="No">

<cfelse>

	<table width="99%" align="center" border="0">				
		<tr><td id="eventdetail"><cfinclude template="EventsEntryDetail.cfm"></td></tr>   		
	</table>

</cfif>
