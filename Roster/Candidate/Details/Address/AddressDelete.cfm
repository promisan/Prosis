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
<cf_param name="url.entryScope"  default="Backoffice" type="string">
<cf_param name="url.mission" 	 default="" type="string">
<cf_param name="url.owner"		 default="" type="string">
<cf_param name="url.id" 		 default="" type="string">

<cfquery name="Address" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  ApplicantAddress 
	SET     ActionStatus = '9'
	WHERE  	PersonNo = '#url.id#' 
	AND 	AddressId  = '#url.id1#' 
</cfquery>

<cfoutput>
	
	<cfif url.entryScope eq "Backoffice">
	
	 	<script LANGUAGE = "JavaScript">
		 	ColdFusion.navigate('Address/Address.cfm?ID=#url.id#','addressbox');
	 	</script>			  
		
	<cfelseif url.entryScope eq "Portal">
	
		<cf_param name="url.applicantno" default="0" type="string">
		<cf_param name="url.section" 	 default="" type="string">
	
		<script>
			ptoken.location('#SESSION.root#/Roster/PHP/PHPEntry/Address/Address.cfm?owner=#url.owner#&mission=#url.mission#&ID=#url.id#&entryScope=#url.entryScope#&object=applicant&applicantno=#url.applicantno#&section=#url.section#');
		</script>
		
	</cfif>

</cfoutput>	