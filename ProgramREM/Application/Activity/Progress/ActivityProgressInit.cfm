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
<cfset FileNo = round(Rand()*100)>

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

<cf_ActivityProgressScript>
<cf_FileLibraryScript>
<cfajaximport tags="cfform,cfinput-datefield">

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