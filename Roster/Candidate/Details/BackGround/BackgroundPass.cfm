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
<!--- first we check if there is an applicant record for the source and personNo --->

<cfparam name="URL.entryScope"   default="Backoffice">
<cfparam name="url.section" 	 default="">
<cfparam name="URL.source"       default="Manual">  
<cfparam name="URL.Topic"        default="Employment"> 
<cfparam name="url.id1"          default="">
<cfparam name="url.applicantno"  default="">
<cfparam name="url.owner"        default="">
<cfparam name="url.mid"          default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>

<cfif url.applicantno eq "">
	
	<cfquery name="check" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM ApplicantSubmission
		WHERE PersonNo = '#url.id1#'
		AND   Source = '#url.source#'
		ORDER BY Created DESC
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
	   <cfset url.applicantno = check.applicantno>
	
	<cfelse>
	
	
	</cfif>

</cfif>

<cfoutput>

<iframe src="#session.root#/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#url.owner#&applicantno=#url.applicantno#&section=profile&entryScope=#url.entryscope#&Source=#url.source#&Topic=#url.topic#&ID=&ID1=#url.id1#&ID2=#url.id2#" frameborder="0" style="width:100%;height:100%"></iframe>


</cfoutput>
