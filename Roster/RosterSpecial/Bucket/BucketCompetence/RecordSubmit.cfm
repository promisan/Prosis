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

<cfparam name="url.FunctionId" 	 default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.CompetenceId" default="">
<cfparam name="url.Action" 		 default="">

<cfif url.action eq "insert">

	 <cfquery name="AddCompetence" 
	 datasource="AppsSelection" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	INSERT INTO FunctionOrganizationCompetence
		VALUES (
			'#URL.FunctionId#',
			'#URL.CompetenceId#',
			'#SESSION.Acc#',
			'#SESSION.First#',
			'#SESSION.Last#',
			GETDATE()
		)
	 
	 </cfquery>

<cfelseif URL.Action eq "delete">

	<cfquery name="DeleteCompetence" 
	 datasource="AppsSelection" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	DELETE FROM  FunctionOrganizationCompetence
		WHERE  FunctionId = '#URL.FunctionId#' AND CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
</cfif>

<font color="0080FF">
	<b>Saved</b>
</font>