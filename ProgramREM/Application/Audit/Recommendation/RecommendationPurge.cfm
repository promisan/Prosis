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
<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfparam name="URL.RecommendationId" default="">
<cfparam name="URL.crow" default="">

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
	UPDATE ProgramAudit.dbo.AuditObservationRecommendation 
		SET RecordStatus = 9
		WHERE ObservationId = '#URL.ObservationId#' and
		AuditId='#URL.AuditId#' and
		RecommendationId='#URL.RecommendationId#'
	</cfquery>	
	
		
	<cfoutput>
	<script language="JavaScript">
	 window.location="RecommendationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#URL.ObservationId#&crow=#URL.crow#";
	</script>
	</cfoutput>
	
	
</cfif>
