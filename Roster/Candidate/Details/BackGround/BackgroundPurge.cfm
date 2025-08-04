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
<cfparam name="URL.entryScope"    default="Backoffice">
<cfparam name="URL.Owner"         default="">
<cfparam name="URL.Mid"           default="">
<cfparam name="url.applicantno"  default="0">

<cfquery name="DeleteExperience" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  ApplicantBackground
	SET     Status       = '9'
	WHERE   ApplicantNo  = '#url.applicantno#'
	AND     ExperienceId = '#URL.ID0#'   
</cfquery>
		
<cfif url.entryScope eq "Backoffice">

	<cflocation url="../General.cfm?Owner=#url.owner#&Source=#url.source#&ID=#URL.ID#&ID2=#URL.ID2#&Topic=#URL.Topic#&applicantNo=#url.applicantno#&mid=#url.mid#" addtoken="No">		  
	
<cfelseif url.entryScope eq "Portal">

	<cfparam name="url.applicantno" default="0">
	<cfparam name="url.section" default="">
	<cfif url.id2 eq "Employment">
		<cfset template = "Background.cfm">
	<cfelse>
		<cfset template = "Education.cfm">
	</cfif>
	
	<cfoutput>
		<script>
			window.location = '#SESSION.root#/Roster/PHP/PHPEntry/Background/#template#?Owner=#url.owner#&ID=#url.id#&entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#&mid=#url.mid#';
		</script>
	</cfoutput>
	
</cfif>	