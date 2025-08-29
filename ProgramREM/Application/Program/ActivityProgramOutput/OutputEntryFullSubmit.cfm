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
<!---
17/11/03  commented out delete query that over wrote old outputs with new ones:  KRW
--->

<TITLE>Submit Outputs</TITLE>

<cfset OutputAdded="NO">

 
<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

	<cfset Aoutput  = Evaluate("FORM.ActivityOutput_" & #Rec#)>
	 
	<cfif Aoutput neq "">
			
		<cfset SubPeriod     = Evaluate("FORM.Subperiod_" & #Rec#)>
		<cfset Reference     = Evaluate("FORM.Reference_" & #Rec#)>
		<cfset Aoutputdate   = Evaluate("FORM.TargetDate_" & #Rec#)>
		
		<cfif Aoutputdate neq "">
			<CF_DateConvert Value="#AOutputDate#">
			<cfset Aoutputdate = #dateValue#>
		</cfif>
		
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username=#SESSION.login# 
		password=#SESSION.dbpw#>
		INSERT INTO ProgramActivityOutput  
		         (ProgramCode, 
				  ActivityPeriod,
				  ActivityId, 
				  ActivityPeriodSub,
				  ActivityOutputDate,
				  ActivityOutput,
				  Reference,
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName,
				  Created)
		  VALUES ('#Form.ProgramCode#', 
		  		  '#Form.ActivityPeriod#',
		  		  '#Form.ActivityId#',
				  '#SubPeriod#',
				  <cfif #AoutputDate# eq "">NULL<cfelse>#AoutputDate#</cfif>,
				  '#Aoutput#',
				  '#Reference#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#',
				  getDate())
		</cfquery>		
		
		<cfquery name="LastNo" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT Max(OutputId) as OutputId
		 FROM   ProgramActivityOutput
		 WHERE  ActivityID     = '#Form.ActivityID#'
		  AND   ProgramCode    = '#Form.ProgramCode#'
		  AND   ActivityPeriod = '#Form.ActivityPeriod#'
		 </cfquery>
	 		
		<cf_LanguageInput
			TableCode       = "ProgramActivityOutput" 
			Mode            = "Save"
			Name1           = "ActivityOutput"
			NameSuffix      = "_#Rec#"
			Key1Value       = "#Form.ProgramCode#"
			Key2Value       = "#Form.ActivityPeriod#"
			Key3Value       = "#LastNo.OutputId#">
			
	</cfif>	
		
</cfloop>	

<cflocation url="../ActivityProgram/ActivityView.cfm?ProgramCode=#Form.ProgramCode#&Period=#Form.ActivityPeriod#" addtoken="No">		  

	

