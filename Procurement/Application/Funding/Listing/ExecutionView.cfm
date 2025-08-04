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

<cf_tl id="Advanced Inquiry #Url.mission# #url.period#" var="tInquiry">

<cf_screentop height="100%" scroll="no" layout="webapp" label="#tInquiry#" jquery="Yes" html="Yes" MenuAccess="Yes" SystemFunctionId="#url.systemfunctionid#">

<cf_listingscript mode="Regular">
<cf_dialogstaffing> 
	
<cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.systemfunctionid#"				
		Label           = "Yes">		
		
<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>

   <tr>

   <td height="100%" valign="top" style="padding-left:15px;padding-right:15px">
		<cf_securediv id="divListingContainer" style="height:100%" bind="url:#session.root#/Procurement/Application/Funding/Listing/ExecutionViewContent.cfm?SystemFunctionId=#url.systemfunctionid#&mission=#url.mission#&planningperiod=#url.planningperiod#&period=#url.period#">        	
	</td>	
	
   </tr>

</table>		
		