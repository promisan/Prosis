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
	
<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM Parameter		
</cfquery>
	
<cfif URL.ActivityId eq "">

	<cfset completed = 0>

	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
			
		<cfset No = Param.ActivityNo+1>
		<cfif No lt 10000>
		     <cfset No = 10000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Parameter
			SET ActivityNo = '#No#'			
		</cfquery>
	
	</cflock>		
		
	<cfquery name="OrgUnit" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT Org.*
		    FROM   ProgramPeriod Pe, 
			       Organization.dbo.Organization Org
			WHERE  Pe.ProgramCode = '#URL.ProgramCode#'
			AND    Pe.Period      = '#URL.Period#' 
			AND    Pe.OrgUnit     = Org.OrgUnit 
	</cfquery>
	
	<cfset st = "new">
		
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    INSERT INTO ProgramActivity (
			ProgramCode,
			ActivityPeriod,
			ActivityId,
			ActivityDate,
			Reference,
			RecordStatus,
			OrgUnit,
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName,
			Created)
	VALUES 
			('#URL.ProgramCode#',
			'#URL.Period#',
			'#No#',
			getDate(),
			'TMP',
			'9',
			'#OrgUnit.OrgUnit#',
			'#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#', 
			 getDate())
	</cfquery>
	
	<cfset URL.ActivityId = No>
	
<cfelse>	

	<!--- check if activity has been completed already --->
	
	<cfset completed = "1">
	
	<cfquery name="Activity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ProgramActivity
		WHERE  ActivityId = '#ActivityId#'		
	</cfquery>
	
	<cfquery name="Program" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Program
			WHERE  ProgramCode  = '#Activity.ProgramCode#'			
	</cfquery>
	
	<cfquery name="Output" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT OutputId
	    FROM   ProgramActivityOutput
		WHERE  ActivityId = '#ActivityId#'
		AND    RecordStatus!='9'
	</cfquery>
		
	<cfloop query = "Output">
	
		<cfquery name="Progress" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   TOP 1 *
		    FROM     ProgramActivityProgress
			WHERE    Outputid = '#OutputId#'
			AND      RecordStatus != '9'
			ORDER BY Created DESC
		</cfquery>
				
		<cfquery name="Param" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * FROM Ref_ParameterMission
			WHERE Mission = '#Program.Mission#'
		</cfquery>
				
		<cfif Progress.ProgressStatus neq Param.ProgressCompleted>
				
			<cfset completed = "0">
		
		</cfif>
		
	</cfloop>
	
</cfif>
