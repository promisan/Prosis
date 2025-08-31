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
<cfparam name="url.ClaimType" default="">

<cfquery name="Tab" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimTypeTab
	WHERE   TabName = 'Control'	
	<cfif url.claimtype neq "">
	AND     Code    = '#url.ClaimType#' xxx
	</cfif>
	AND     Mission='#url.mission#'
</cfquery>

<cfif Tab.TabTemplate eq "">
	    
	<cfquery name="ClaimTypeList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ClaimType		
	</cfquery>
	
	<cfloop query="ClaimTypeList">
	
		<cftry>
	
		<cfquery name="Tab" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ClaimTypeTab
			(Mission,Code,TabName)
			VALUES
			('#url.mission#','#code#','Control')		
		</cfquery>
		
		<cfcatch></cfcatch>
		
		</cftry>
	
	</cfloop>

	<cf_tl id= "Module scope (ControlEmployee/ControlOrganization) could not be determined." class="Message" var ="1">
	<cfset vText1 = lt_text>
	
	<cf_tl id= "Please contact your administrator" class="Message" var ="1">
	<cfset vText2 = lt_text>
	
    <cf_message message="#vText1# #vText2#">

<cfelse>

	<cfparam name="url.mid" default="">
	
	<cflocation addtoken="No" url="#SESSION.root#/CaseFile/Application/Case/#Tab.TabTemplate#/ClaimView.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mid=#url.mid#">

</cfif>



