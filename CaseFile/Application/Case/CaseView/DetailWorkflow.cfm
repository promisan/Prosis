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

<cfparam name="URL.Mode" default="Regular">

<cfif url.mode eq "regular">
   <cfset tool = "Yes">
<cfelse>
   <cfset tool = "No">   
</cfif>

<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td id="#url.ajaxid#">

<cfquery name="GetClaim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Claim
	WHERE  ClaimId = '#url.ajaxid#'
</cfquery>

<cfquery name="Tab" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ClaimTypeTab
	WHERE   TabName = 'Control'	
	AND		Mission = '#GetClaim.Mission#'
</cfquery>

<cfinclude template="..\#Tab.TabTemplate#\ClaimWorkflow.cfm">
		
</td></tr>
</table>		

</cfoutput>
