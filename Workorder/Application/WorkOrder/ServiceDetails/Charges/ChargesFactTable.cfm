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
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Charges">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Usage">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#_Provisioning">

<cfquery name="getUnit" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT DISTINCT OrgUnit
		FROM   Organization.dbo.Organization
		WHERE  Mission IN (
						SELECT DISTINCT O.mission
						FROM   Organization.dbo.OrganizationAuthorization O
						WHERE  O.UserAccount = '#SESSION.acc#' 					
						AND    O.OrgUnit is NULL
					    )
		UNION
		
		SELECT DISTINCT O.OrgUnit
		FROM   Organization.dbo.OrganizationAuthorization O
		WHERE  O.UserAccount = '#SESSION.acc#' 		
		AND    O.OrgUnit is not NULL
</cfquery>		

<cfset unit = ValueList(getUnit.orgunit)> 	

<cfquery name="Charges" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	SELECT 	*
    INTO   UserQuery.dbo.#SESSION.acc#_Charges
	FROM   skWorkOrderCharges 
	WHERE  Mission = '#url.Mission#'
	AND    OrgUnit_dim IN (#preservesinglequotes(unit)#)	
</cfquery>   

<cfquery name="Usage" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	SELECT 	*
    INTO    UserQuery.dbo.#SESSION.acc#_Usage
	FROM    skWorkOrderUsage 
	WHERE   Mission = '#url.Mission#'
	AND     OrgUnit_dim IN (#preservesinglequotes(unit)#)		
</cfquery>   

<cfquery name="Provisioning" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   	SELECT 	*
    INTO   UserQuery.dbo.#SESSION.acc#_Provisioning
	FROM   skWorkOrderProvisioning 
	WHERE  Mission = '#url.Mission#'
	AND    OrgUnit_dim IN (#preservesinglequotes(unit)#)		
</cfquery>   

<cfset client.table1_ds = "#SESSION.acc#_Charges">
<cfset client.table2_ds = "#SESSION.acc#_Usage">
<cfset client.table3_ds = "#SESSION.acc#_Provisioning">
