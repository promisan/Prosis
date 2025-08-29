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
<cfquery name="Activity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramActivity
	WHERE   ActivityId = '#url.activityid#'	
</cfquery>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program P,
	        ProgramPeriod Pe
	WHERE   P.ProgramCode = Pe.ProgramCode
	AND     Pe.Period      = '#url.Period#'
	AND     P.ProgramCode = '#url.programCode#'	
</cfquery>

<cfset link = "ProgramREM/Application/Program/ActivityProject/ActivityView.cfm?activityid=#URL.ActivityId#">

<cf_ActionListing 
    EntityCode       = "EntProgramAction"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""
	AjaxId           = "#url.activityid#"
	Mission          = "#Program.Mission#"
	OrgUnit          = "#Program.OrgUnit#"
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Program.Reference#"
    ObjectKey1       = "#Program.ProgramCode#"
	ObjectKey2       = "#Program.Period#"
	ObjectKey3       = "#Activity.ActivityId#"
	ObjectURL        = "#link#">