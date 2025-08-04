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

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Program P,
	        ProgramPeriod Pe, 
			ProgramPeriodReview R
	WHERE   P.ProgramCode = Pe.ProgramCode
	AND     R.ProgramCode = Pe.ProgramCode
	AND     R.Period      = Pe.Period
	AND     R.ReviewId = '#url.ajaxid#'   	
</cfquery>

<cfquery name="Cycle" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ReviewCycle
	WHERE     CycleId = '#Program.ReviewCycleId#'  
</cfquery>	

<cfset link = "ProgramREM/Application/Program/ReviewCycle/ReviewCycleView.cfm?reviewid=#URL.Ajaxid#">

<cf_ActionListing 
    EntityCode       = "EntProgramReview"
	EntityClass      = "#Cycle.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	AjaxId           = "#url.ajaxid#"	
	OrgUnit          = "#Program.OrgUnit#"
	ObjectReference  = "#Program.ProgramName#"
	ObjectReference2 = "#Program.Reference#"
    ObjectKey1       = "#Program.ProgramCode#"
	ObjectKey2       = "#Program.Period#"
	ObjectKey4       = "#url.ajaxid#"
	ObjectURL        = "#link#">