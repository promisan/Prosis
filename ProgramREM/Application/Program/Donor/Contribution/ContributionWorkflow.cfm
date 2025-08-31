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
<cfset link = "ProgramREM/Application/Program/Donor/Contribution/ContributionWorkflow.cfm?AjaxId=#URL.ajaxid#">
	
<cf_ActionListing 
	EntityCode       = "EntDonor"	
	EntityGroup      = "" 
	EntityStatus     = "0"			
	ObjectKey4       = "#URL.ajaxid#"
	ObjectURL        = "#link#"
	AjaxId           = "#URL.ajaxid#"
	Show             = "Yes" 
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "Yes">

