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

<cfparam name="Attributes.Mission" default="">
<cfparam name="Attributes.Role" default="">
<cfparam name="Attributes.UserAccount" default="">

 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#OrgUnit">	

<cfquery name="Select" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
     SELECT   A.OrgUnit, '1' as Enabled, O.ParentOrgUnit, O.Mission, O.MandateNo 
     INTO     userQuery.dbo.#SESSION.acc#OrgUnit
     FROM     OrganizationAuthorization A, Organization O
     WHERE    A.Role        = '#Attributes.Role#' 
        AND   A.Mission     = '#Attributes.Mission#' 
      	AND   A.UserAccount = '#Attributes.UserAccount#'
	    AND   A.OrgUnit     = O.OrgUnit
</cfquery>

<cfquery name="List" 
 datasource="AppsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT     *
 FROM      userQuery.dbo.#SESSION.acc#OrgUnit
</cfquery>

<cfloop query = "List">
	
	<cfset par = List.ParentOrgUnit>
	
	<cfloop condition="par neq ''">
	
		<cfquery name="Parent" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization
			 WHERE    OrgUnitCode = '#Par#'
			 AND      Mission = '#List.Mission#'
			 AND      MandateNo = '#List.MandateNo#'
		</cfquery>
		
		<cfif Parent.recordcount eq "1">
		
			<cfquery name="Check" 
			 datasource="AppsOrganization" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 	SELECT  *
				FROM    userQuery.dbo.#SESSION.acc#OrgUnit
				WHERE   OrgUnit = '#Parent.OrgUnit#'
			</cfquery>
			
			<cfif Check.recordcount eq "0">
				
				<cfquery name="Insert" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO userQuery.dbo.#SESSION.acc#OrgUnit
				 			(OrgUnit,Enabled,Mission,MandateNo)
				 VALUES 	('#Parent.OrgUnit#',
				             '0',
							 '#List.Mission#',
							 '#List.MandateNo#')
				</cfquery>
					
			</cfif>
		
		</cfif>
		
		<cfset par = #Parent.ParentOrgUnit#>
	
	</cfloop> 

</cfloop>
