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
<!--- Dev 21/10/2015
 ideally we need to log this access in the structure we have for old access logging --->

<cfquery name="FLY" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
   DELETE FROM OrganizationAuthorization
   WHERE OrgUnit        = '#URL.OrgUnit#'
   AND   ClassParameter = '#URL.IndicatorCode#'
   AND   Role           = '#URL.Role#'
   AND   UserAccount    = '#URL.UserAccount#'
</cfquery>

<cfinclude template="TargetViewDetailAccess.cfm">