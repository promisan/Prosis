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

<cfset wflink = "ProgramREM/Application/Program/Events/EventsView.cfm?eventid=#url.ajaxid#">
				
<cfquery name="Event" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    ProgramEvent M,
	        ProgramEventAction P, Ref_ProgramEvent R
	WHERE   P.ProgramEvent = R.Code
	AND     M.ProgramCode  = P.ProgramCode
	AND     M.ProgramEvent = P.ProgramEvent
	AND     P.EventId      = '#url.ajaxid#'	
</cfquery>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Program
	WHERE   ProgramCode = '#event.programcode#'	
</cfquery>
	
<cf_ActionListing 
    EntityCode       = "EntProjectEvent"
	EntityClass      = "#Event.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Program.Mission#"	
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Event.Description#"	
    ObjectKey1       = "#Event.ProgramCode#"
	ObjectKey2       = "#Event.ProgramEvent#"
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "No"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No">



			