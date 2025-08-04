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
<cf_screentop jquery="yes" html="no">
<cf_listingscript>	
<cfajaximport tags="cfform,cfinput-datefield">
<!--- listing of receipts will drill down to receipt dialog --->

 <cf_LanguageInput
		TableCode       = "Ref_ModuleControl" 
		Mode            = "get"
		Name            = "FunctionName"
		Key1Value       = "#url.idmenu#"				
		Label           = "Yes">			
			
<cfparam name="lt_content" default="Medical Billing">

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

   <td colspan="1" height="100%" valign="top">
		<cfdiv id="divListingContainer" style="height:100%" bind="url:#session.root#/Workorder/Application/Medical/ServiceDetails/Charges/BillingListingContent.cfm?mission=#url.mission#&SystemFunctionId=#url.systemfunctionid#">        	
	</td>	
	
   </tr>

</table>		
		