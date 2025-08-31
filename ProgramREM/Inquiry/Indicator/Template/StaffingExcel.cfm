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
<cfparam name="client.recordid" default="''">

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#IndicatorStaffing">

<cfquery name="Staffing" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	INTO   userQuery.dbo.#SESSION.acc#IndicatorStaffing
	FROM   EmployeeSnapshot.dbo.HRPO_AppStaffingDetail
	<cfif client.recordid neq "">
	WHERE  RecordNo IN (#preservesinglequotes(client.recordid)#)
	</cfif>	
 </cfquery> 
 
<cfset client.table1   = "#SESSION.acc#IndicatorStaffing">	


