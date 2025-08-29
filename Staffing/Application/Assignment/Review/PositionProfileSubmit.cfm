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
<cfparam name="#url.languagecode#" default="">

<cfif url.languagecode neq "">

<cf_ApplicantTextArea
		Table           = "Employee.dbo.PositionParentProfile" 
		Domain          = "Position"
		FieldOutput     = "JobNotes"
		Mode            = "save"
		Log             = "No"
		LanguageCode    = "#url.languagecode#"
		Key01           = "PositionParentId"
		Officer         = "N"
		Key01Value      = "#URL.ID#">

<cfset url.accessmode = "view">	
<cfinclude template="PositionProfileContent.cfm">


</cfif>
			
			