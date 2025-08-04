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

<!--- ---------------------------------------- --->
<!--- template to refresh listing in ajax mode --->
<!--- ---------------------------------------- --->

<cfparam name="url.programid" default="">
<cfparam name="url.col" default="">

<cf_tl id="Project" var="1">
<cfset tProject = "#Lt_text#">

<cf_tl id="Component" var="1">
<cfset tComponent = "#Lt_text#">

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM #CLIENT.LanPrefix#Program P, ProgramPeriod Pe
	WHERE P.ProgramCode = Pe.ProgramCode
	AND   Pe.ProgramId = '#url.programid#'	
</cfquery>
	
<cfoutput>
	
	<cfswitch expression="#URL.Col#">
	
		<cfcase value="nme">
		
			<cfif get.ProgramClass eq "Program">							   
				 #get.ProgramName#
			<cfelseif get.ProgramClass eq "Project">						     
				 <font size="1"><i>#tProject#</i></font>&nbsp;#get.ProgramName# 
			<cfelse>
			     <!--- <font size="1">#tComponent#</font> ---> #get.ProgramName#
		    </cfif>
									
			<cfif Get.recordcount eq "0">
			<i><font color="C0C0C0">removed</font></i>
			</cfif>
									
		</cfcase>
		
		<cfcase value="ref">
		
			<cfif get.ReferenceBudget1 neq "">#get.ReferenceBudget1#-#get.ReferenceBudget2#-#get.ReferenceBudget3#-#get.ReferenceBudget4#-#get.ReferenceBudget5#-#get.ReferenceBudget6#
			<cfelseif get.Reference neq "">#get.Reference#
			<cfelse>#get.ProgramCode#</cfif>
			
		</cfcase>
		
	
	</cfswitch>

</cfoutput>