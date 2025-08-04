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
