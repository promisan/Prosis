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
<cfparam name="url.header" default="0">

<cfif url.header eq "1">	

	<cf_screentop jquery="yes" html="yes" layout="webapp" label="Personnel Event Inquiry">
	
	<cf_listingscript       mode="Regular">
	<cf_dialogstaffing>
	<cf_dialogPosition>
	<cf_actionlistingscript mode="Regular">
	<cf_fileLibraryScript   mode="Regular">
	
	 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">	
	
</cfif>	

<!--- moved to 2nd page for refresh
<cf_wfpending entityCode="PersonEvent"  
      table="#SESSION.acc#wfEvent" mailfields="No" IncludeCompleted="No">					
	  --->
			
<cfparam name="lt_content" default="Personnel Events">

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

   <tr>

   <td colspan="1" height="100%" valign="top" style="padding:10px">
		<cf_securediv id="divListingContainer" style="height:100%" bind="url:#session.root#/Staffing/Reporting/ActionLog/EventListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>

</table>		
		