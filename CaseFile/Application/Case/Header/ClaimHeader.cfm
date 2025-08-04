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
<cfparam name="url.init" default="0">

<table height="100%" width="100%" align="center">
<tr><td align="center" valign="top" style="padding:6px">
	
	<cfif NOT IsDefined("URL.Mission")>
		<cfset url.claimId = Object.ObjectKeyValue4>
		<cfset url.mission = Object.Mission>
		<cfset vPath = "../../../CaseFile/Application/Case/Header">
	<cfelse>
		<cfset vPath = "../Header">
	</cfif>
	                      

<cfoutput>	

<cfinclude template="ClaimHeaderContent.cfm">

<!---

	<cf_getMid>   
	<iframe src="#vPath#/ClaimHeaderContent.cfm?mission=#url.mission#&claimid=#url.claimid#&init=#url.init#&mid=#mid#" width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0"></iframe>
	--->
	
</cfoutput>

</td></tr></table>