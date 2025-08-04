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

<!--- get --->

<cfquery name="get" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_SubmissionEditionPosition				
		WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
		AND    PositionNo = '#URL.PositionNo#' 
		AND    RecordStatus = '1'
</cfquery>

<cfif get.recordcount eq "0">

	<font color="FF0000">Revoked</font>

<cfelse>
	
	<cf_LanguageInput
		TableCode       = "EditionFunctionTitle" 
		Mode            = "get"
		Name            = "FunctionDescription"
		Operational     = "1"
		Label           = "Yes"
		Key1Value       = "#url.SubmissionEdition#"
		Key2Value       = "#url.Positionno#"
		Type            = "Input"
		Required        = "Yes"
		Message         = "Please enter a functional title"
		MaxLength       = "80"
		Size            = "60"
		Class           = "regularxl">	
		
	<cfoutput>#lt_content#</cfoutput>	

</cfif>