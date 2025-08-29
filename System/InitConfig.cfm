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
<cfparam  name="client.LANGUAGEID" default="ENG">

<!--- It sets the application to 1 second --->
	<cfset applicationStop() />
<!--- scripts that initialises system databases --->


<!---- SYSTEM ---->
<cfquery name="System" 
   datasource="AppsSystem">
      SELECT * 
	  FROM Parameter 
</cfquery> 

<cfif System.DateFormat is "EU">
     <cfset CLIENT.DateFormatShow      = "dd/mm/yyyy">
	 <cfset CLIENT.DateFormatShowS     = "mm/yyyy">
	 <cfset APPLICATION.DateFormatCal  = "%d/%m/%Y">
<cfelse> 
     <cfset CLIENT.DateFormatShow      = "mm/dd/yyyy">
     <cfset CLIENT.DateFormatShowS     = "mm/yyyy">
     <cfset APPLICATION.DateFormatCal  = "%m/%d/%Y">
</cfif>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Config preparation"
	StepStatus     = "0">		
			
<!--- batches checks --->	
	<cfinclude template="Scheduler/ScheduleRegisterData.cfm">
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Integrity Check"
	StepStatus     = "0">		

<!--- integrity checks --->
	<cfinclude template="Modules/Functions/ModuleControl/IntegrityCheck.cfm">
	
     <!--- remove selfservice report instances for excel generated report instances 
	 
	 15/12/2021 : taken out as this deleted the report field selections 
    
	<cfquery name="clean" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ReportControl
			WHERE  SystemModule = 'Selfservice'
	</cfquery>		
	
	<cfloop query="clean">	

		<cfquery name="purge" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM   Ref_ReportControl
				WHERE  ControlId = '#controlid#'
		</cfquery>			

	</cfloop>
	
	--->
	 
<!--- registration of application system functions, tested and reviewed --->

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Register Module Functions"
	StepStatus     = "0">		

	<cfinclude template="Modules/Functions/ModuleControl/Portal.cfm">	
	<cfinclude template="Modules/Functions/ModuleControl/System.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Accounting.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Learning.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/CaseFile.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Payroll.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Accounting.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Roster.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Program.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Employee.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Attendance.cfm">
		
	<cfinclude template="Modules/Functions/ModuleControl/TravelClaim.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Warehouse.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/Procurement.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/WorkOrder.cfm">
	<cfinclude template="Modules/Functions/ModuleControl/CFReport.cfm">
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Register Widgets"
	StepStatus     = "0">	
		
<!--- Generate Widgets where needed !! NEW TOOL--->
	<cfinclude template="Modules/Functions/ModuleControl/Widgets.cfm">
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Register Language Views"
	StepStatus     = "0">		
	
<!--- generate entries for all languages --->		
	<cfinclude template="Modules/Functions/ModuleControl/ModuleLanguage.cfm">
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Update Roles"
	StepStatus     = "0">		

<!--- registration of application system roles and workflows --->
	<cfinclude template="../Tools/Control/InsertRolesData.cfm">
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Register Module Validations"
	StepStatus     = "0">		
	
<!--- registration of application validations --->
	<cfinclude template="../Tools/Control/InsertValidationsData.cfm">	
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Language Framework"
	StepStatus     = "0">		
	
<!--- language framework initialization --->
	<cfinclude template="Language/View/Init.cfm">	
	
	<cf_AppInit>
	
	<cfset this.applicationTimeout = createTimeSpan( 9999, 0, 0, 0 ) />
	