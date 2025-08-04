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
<cfparam name="URL.mode" default="">

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mandate
	WHERE MandateNo = '#URL.ID1#'
	AND   Mission = '#URL.ID#'
</cfquery>

<cfquery name="GetParameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.ID#'
</cfquery>

<cfoutput>

<script>
function PrintCustom(ad) {
	window.open("#SESSION.root#/#GetParameter.PersonActionTemplate#?ID=#URL.ID#&ID1=#URL.ID1#&ID2="+ad)
}
</script>

</cfoutput>


<cf_screentop height="100%" scroll="Yes" html="No" layout="innerbox" title="#URL.ID# Staffing period">		 

<cfset URL.mode="pdf">
<cfinclude template="../Inception/MandateEditLines.cfm">