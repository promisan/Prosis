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

<cfparam name="FORM.selected" default="">

<cftransaction>
	
	<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM Ref_ParameterMission
	    WHERE Mission = '#URL.Mission#'
	</cfquery>
	
	<cfloop index="program" list="#Form.Selected#" delimiters="',">
	
		<cfparam name="Form.selected_#program#" default="">
			
		<cfset changeparent = evaluate("Form.selected_#program#")>
		
		<cfif changeparent eq "">
	
			<!--- check if the parent exists, if so it will need to be moved as well  --->
			
			<cfquery name="Parent" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT *
			    FROM   ProgramPeriod Pe
				WHERE  Pe.ProgramCode = '#Program#' 
				AND    Pe.Period      = '#url.period#'
				AND    Pe.PeriodParentCode IN (SELECT ProgramCode 
				                               FROM   Program 
								 		       WHERE  ProgramCode = Pe.PeriodParentCode)
			</cfquery>
			
			<cfif Parent.recordCount eq "1">
				<cfset prg = Parent.PeriodParentCode>
				<!--- perform the carry over --->		
				<cfinclude template="ProgramCarryOverAction.cfm">
			</cfif>
		
		</cfif>
		
		<!--- parent is done; now check if program exists for ProgramPeriod --->
		<cfset prg = Program>
		<!--- perform the carry over --->		
		<cfinclude template="ProgramCarryOverAction.cfm">
	
	</cfloop>	
	
	<!--- we apply the full check for this period again --->
	
	<cf_programPeriodHierarchy mission="#url.mission#" period="#url.periodcurrent#">
			
</cftransaction> 

<script language="JavaScript1.2">    
    
    try {
    opener.history.go() } catch(e) {}   
	window.close()
	// history.go()
</script>
