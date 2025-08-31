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
<cfparam name="Attributes.Datasource"   default="appsLedger">
<cfparam name="Attributes.Mission"      default="">
<cfparam name="Attributes.GLAccount"    default="">

<cfquery name="Param" 
  datasource="AppsLedger" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT AmountPresentation
  FROM   Ref_ParameterMission
  WHERE  Mission  = '#attributes.Mission#' 
</cfquery>

<cfoutput>

<cfif Param.AmountPresentation eq "Account">

	#attributes.GLAccount#
	
<cfelse>
	
	<cfquery name="getAccount" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Ref_Account
	  WHERE  GLAccount = '#attributes.glaccount#'  
	</cfquery>
	
	<cfif getAccount.AccountLabel eq "">
	#attributes.GLAccount#
	<cfelse>
	#getAccount.AccountLabel#
	</cfif>

</cfif>

</cfoutput>


