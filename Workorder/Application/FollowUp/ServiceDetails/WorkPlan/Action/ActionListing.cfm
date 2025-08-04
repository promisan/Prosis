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

<cfparam name="url.personno" default="">

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.systemfunctionid#"				
		Label           = "Yes">		
	
<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission WITH (NOLOCK)
	WHERE  Mission = '#url.Mission#'	
</cfquery>


<table width="100%" height="100%">
	
	<!--- control list data content --->
	
	<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#url.Mission#'	
	</cfquery>
	
	<cfoutput>
		<tr><td style="padding:5px;font-size:20px" class="labellarge">#url.mission# <cf_tl id="Agenda"></td></tr>
	</cfoutput>

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:5px">
		<cf_securediv id="divListingContainer" style="height:100%"
		  bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/WorkPlan/Action/ActionListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#&personno=#url.personno#">        	
	</td>	
	
   </tr>

</table>		
		