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

	

