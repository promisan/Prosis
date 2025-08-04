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
<!--- get a list [accesslist] with all units from the tree to which a user has been granted access  
this list also includes parent records in case the user has access to the child only in order to select from a tree listing correctly --->

<cf_treeunitList 
   mission="#mission#"    
   role="'CaseFileManager'">
   
<cf_tl id="Organization" var="1">	

	 <cf_UItreeitem value="organization"
	        display = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px' class='labelit'>#lt_text#</span>"
			parent  = "root"	
			href    = "javascript:list('ORG','')"												
			target  = "right"
	        expand  = "No">	
      
	<cfquery name="listUnit" 
	    datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT TreeOrder, 
			                OrgUnitName, 
							OrgUnit,  
							OrgUnitCode, 
							HierarchyCode,
							MissionOrgUnitId 
			FROM   #CLIENT.LanPrefix#Organization
			WHERE  Mission = '#Mission#'
			<!--- only the parent units to be selected here --->
		   	AND   (ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1)
			
			<!--- only relevant units to be shown for which access is defined --->
			
			AND   CONVERT(varchar(38), MissionOrgUnitId) + '_' + MandateNo IN (
			
						SELECT    CONVERT(varchar(38), MissionOrgUnitId) + '_' + MAX(MandateNo)
						FROM      Organization
						WHERE     Mission = '#Mission#'
						<cfif accesslist neq "full">
						AND       OrgUnit IN (#preserveSingleQuotes(accesslist)#)	  	
						<cfelseif accesslevel neq "ALL"> 
						AND    1=0  	
						</cfif>
						GROUP BY MissionOrgUnitId				
		   		
					)
			ORDER BY HierarchyCode		
	</cfquery>			
		
	<cfloop query="listUnit">
	
			 <cf_UItreeitem value="#orgunit#"
	        display = "<span style='font-size:14px;' class='labelit'>#OrgUnitName#</span>"
			parent  = "organization"	
			href    = "javascript:list('ORG','#orgunit#')"												
			target  = "right">		 
			 
	</cfloop>
	
