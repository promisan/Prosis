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
<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse  = '#url.warehouse#'			
</cfquery>

<cfinvoke component = "Service.Access"  
     method             = "roleaccess"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 missionorgunitid   = "#getWarehouse.MissionOrgUnitId#"
	 Parameter          = "#url.SystemFunctionId#" 
	 AccessLevel        = "'1','2'"
	 returnvariable     = "access">	 
	 
<cfif url.transactiontype eq "8">
  <cfinclude template="PendingDetailTransfer.cfm">
<cfelse>
  <cfinclude template="PendingDetailAsset.cfm">
</cfif>
