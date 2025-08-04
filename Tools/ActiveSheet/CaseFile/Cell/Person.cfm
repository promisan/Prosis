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

<cfsilent>

<cfquery name="CellElement" 
    datasource="appsCaseFile" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM   Element E
	WHERE  ElementId = '#url.elementid#'
</cfquery>	

<cfquery name="GetTopic" dataSource = "AppsSelection">
	SELECT *
	FROM Applicant.dbo.Applicant
	WHERE PersonNo = '#Element.PersonNo#'
</cfquery>


</cfsilent>

<cfif url.mode eq "expanded">
<cfoutput>
	<table><tr><td width="450" align="center" style="padding:5px">
		#GetTopic.LastName#, #GetTopic.FirstName#<br>
		<cfif GetTopic.Gender eq 'M'>
			<cf_tl id="Male">
		<cfelseif GetTopic.Gender eq 'F'>
			<cf_tl id="Female">
		</cfif>
		<br>
		#DateFormat(GetTopic.DOB,CLIENT.DateFormatShow)#
	</td></tr></table>
</cfoutput>
<cfelse>
	<cfoutput>
		<table><tr><td style="padding:5px">
			#GetTopic.LastName#, #GetTopic.FirstName#
		</td></tr></table>
	</cfoutput>
</cfif>