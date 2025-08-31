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
<cfparam name="url.PositionNo" 	 default="">
<cfparam name="url.CompetenceId" default="">
<cfparam name="url.Action" 		 default="">

<cfif url.action eq "true">

	<cfquery name="get" 
	 datasource="AppsEmployee" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	SELECT * FROM  PositionCompetence
		WHERE  PositionNo = '#URL.PositionNo#' 
		AND    CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
	 <cfif get.recordcount eq "0">

		 <cfquery name="AddCompetence" 
		 datasource="AppsEmployee" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">	 
		 
		 	INSERT INTO PositionCompetence
			VALUES (
				'#URL.PositionNo#',
				'#URL.Competenceid#',
				'#SESSION.Acc#',
				'#SESSION.First#',
				'#SESSION.Last#',
				GETDATE()
			)
		 
		 </cfquery>
	 
	 </cfif>

<cfelseif URL.Action eq "false">

	<cfquery name="DeleteCompetence" 
	 datasource="AppsEmployee" 
	 username="#SESSION.Login#" 
	 password="#SESSION.dbpw#">
	 
	 	DELETE FROM  PositionCompetence
		WHERE  PositionNo = '#URL.PositionNo#' AND CompetenceId = '#URL.CompetenceId#'

	 </cfquery>
	 
</cfif>

<font color="0080FF">
	<b>Saved</b>
</font>