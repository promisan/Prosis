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
<cfset Mission = "SMALL">

<cfoutput>
['#Mission#',null, 
['<u>By Organization</u>',null,

  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
      FROM Organization
   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
	  AND Mission = 'SMALL'
	  ORDER BY OrgUnitHierarchy, OrgUnitName 
  </cfquery>

  <cfloop query="level01">['#Level01.OrgUnitName#',null,
  
      <cfquery name="Level02" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
      FROM Organization
 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
      </cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#',null,
	  
	        <cfquery name="Level03" 
             datasource="AppsEmployee" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
             FROM Organization
      	     WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
             </cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#',null],
	  
       	     </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>],


['<u>Postgrade</u>',null,

  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
      FROM Organization
   	  WHERE (ParentOrgUnit is NULL OR ParentOrgUnit = '')
	  AND Mission = 'SMALL'
	  ORDER BY OrgUnitHierarchy, OrgUnitName 
  </cfquery>

  <cfloop query="level01">['#Level01.OrgUnitName#',null,
  
      <cfquery name="Level02" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
      FROM Organization
 	  WHERE ParentOrgUnit = '#Level01.OrgUnitCode#'
      </cfquery>
  
      <cfloop query="level02">['#Level02.OrgUnitName#',null,
	  
	        <cfquery name="Level03" 
             datasource="AppsEmployee" 
             username="#SESSION.login#" 
             password="#SESSION.dbpw#">
             SELECT DISTINCT OrgUnitHierarchy, OrgUnitName, OrgUnitCode 
             FROM Organization
      	     WHERE ParentOrgUnit = '#Level02.OrgUnitCode#'
             </cfquery>
  
             <cfloop query="level03">['#Level03.OrgUnitName#',null],
	  
       	     </cfloop>],
	  	  
	  </cfloop>],
  
  </cfloop>],

</cfoutput>

]

