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

<cfquery name="getMandate" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_Mandate
		 WHERE   Mission         = '#url.mission#'
		 AND     DateEffective  <= getDate() 
		 AND     DateExpiration >= getDate()
</cfquery>

<cfif getMandate.recordcount eq "0">

<cfquery name="getMandate" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  TOP 1 *
		 FROM    Ref_Mandate
		 WHERE   Mission         = '#url.mission#'
		 ORDER BY DateEffective DESC		 
</cfquery>

</cfif>

<cfquery name="getOrganization" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 SELECT    *
		 FROM      Organization
		 WHERE     Mission         = '#url.mission#'
		 AND       MandateNo       = '#getMandate.Mandateno#'		
		 ORDER BY  HierarchyCode
</cfquery>

<cfif url.selected neq "">
	
	<select name="OrgUnit" class="regularxxl" style="width:95%">
	
		<cfoutput query="getOrganization">
			<option value="#orgunit#" <cfif url.selected eq orgunit>selected</cfif>>#HierarchyCode# #OrgUnitName#</option>
		</cfoutput>
	
	</select>

<cfelse>
	
	<cfquery name="Assignment" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  *
			 FROM    PersonAssignment
			 WHERE   PersonNo = '#url.personno#'
			 AND     AssignmentStatus IN ('0','1')
			 AND     AssignmentClass = 'Regular'
			 ORDER BY DateEffective DESC
	</cfquery>		
			
	<select name="OrgUnit" class="regularxxl" style="width:95%">
	
	     <cfif url.scope eq "Inquiry">
		 
			 <cfoutput query="getOrganization">
			    <cfif assignment.orgunit eq orgunit>
				<option value="#orgunit#" selected>#HierarchyCode# #OrgUnitName#</option>
				</cfif>
			</cfoutput>
		 
		 <cfelse>
		 
			 <cfoutput query="getOrganization">
				<option value="#orgunit#" <cfif assignment.orgunit eq orgunit>selected</cfif>>#HierarchyCode# #OrgUnitName#</option>
			</cfoutput>
		 
		 </cfif>
	
	</select>


</cfif>

		