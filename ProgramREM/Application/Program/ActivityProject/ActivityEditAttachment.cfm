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

<!--- Query returning search results for activities  --->
<cfquery name="EditActivity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, 
	         O.OrgUnitName, 
			 O.OrgUnitCode, 
			 O.OrgUnitClass, 
			 O.Mission, 
			 O.MandateNo		
	FROM     #CLIENT.LanPrefix#ProgramActivity A left join Organization.dbo.#CLIENT.LanPrefix#Organization O
	ON       A.OrgUnit = O.OrgUnit
	WHERE    A.ActivityID = '#URL.ActivityId#'  
</cfquery>


<table width="95%" align="center" class="formpadding">

		<tr><td height="5"></td></tr>		
		<tr><td height="40" class="labelmedium2">Attach relevant documents</td></tr>		
				
		<tr><td height="5"></td></tr>
		
		<tr><td colspan="2">										
							
		<!--- Query returning program parameters --->
		<cfquery name="Parameter" 
		datasource="AppsProgram" >
		    SELECT *
		    FROM Parameter
		</cfquery>
		
		<cfif access eq "All" OR access eq "EDIT">   
		
		<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#EditActivity.ProgramCode#" 
			Filter="act#activityid#"
			Insert="yes"
			Box="att#activityid#"
			loadscript="no"
			Remove="yes"
			Highlight="no"
			Rowheader="no"
			Width="100%"
			Listing="yes">		
			
		<cfelse>				
							
		<cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#EditActivity.ProgramCode#" 
			Filter="act#activityid#"
			Insert="no"
			Box="att#activityid#"
			loadscript="no"
			Remove="no"
			Highlight="no"
			Rowheader="no"
			Width="100%"
			Listing="yes">	
			
		</cfif>	
											
		</td>
		</TR>	
		
		<tr><td id="outputsave"></td></tr>
		
</table>						