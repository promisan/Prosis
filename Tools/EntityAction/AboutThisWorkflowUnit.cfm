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
<cfquery name="object" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT * FROM OrganizationObject			
		WHERE ObjectId = '#url.objectid#'			
</cfquery>	

<cfquery name="set" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    UPDATE OrganizationObject
		SET    OrgUnit = '#url.orgunit#'
		WHERE ObjectId = '#url.objectid#'			
</cfquery>	
	
<!--- we try alsoto update the source table --->

<cfquery name="entity" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM            Ref_Entity
	WHERE EntityCode = '#object.EntityCode#'
</cfquery>

<cftry>

<cfquery name="update" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	UPDATE #entity.entityTableName#
	SET OrgUnit = '#url.orgunit#'
	<cfif Entity.EntityKeyField4 neq "">
	WHERE #Entity.EntityKeyField4# = '#Object.ObjectKeyValue4#'
	<cfelse>
	WHERE #Entity.EntityKeyField1# = '#Object.ObjectKeyValue1#'
		<cfif Entity.EntityKeyField2 neq "">
		AND   #Entity.EntityKeyField2# = '#Object.ObjectKeyValue2#'
		</cfif>
		<cfif Entity.EntityKeyField3 neq "">
		AND   #Entity.EntityKeyField3# = '#Object.ObjectKeyValue3#'
		</cfif>
	</cfif>	
</cfquery>	

<cfcatch></cfcatch>

</cftry>

<cfquery name="get" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT * FROM Organization
		WHERE  OrgUnit = '#url.orgunit#'				
</cfquery>	
	
<cfoutput>#get.OrgUnitName#</cfoutput>
	
	
			   