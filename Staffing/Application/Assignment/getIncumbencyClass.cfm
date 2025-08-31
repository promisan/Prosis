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
<cfparam name="url.assignmentclass" default="">
<cfparam name="url.mission" default="">
<cfparam name="url.imcumbency" default="100">

<cfquery name="AssignmentClass" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_AssignmentClass
		 WHERE (Incumbency = '#url.incumbency#' or AssignmentClass = 'regular')
		 AND    Operational = 1
		 AND    AssignmentClass in (SELECT AssignmentClass FROm Ref_AssignmentClassMission WHERE Mission = '#url.mission#')
		 ORDER BY ListingOrder
</cfquery>	

<cfif AssignmentClass.recordcount eq "0">
	
	<cfquery name="AssignmentClass" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Ref_AssignmentClass
			 WHERE (Incumbency = '#url.incumbency#' or AssignmentClass = 'regular')
			  AND    Operational = 1
			  ORDER BY ListingOrder
	</cfquery>	

</cfif>

<select name="AssignmentClass" id="assignmentclass" size="1" class="regularxl">
	    <cfoutput query="AssignmentClass">
		<option value="#AssignmentClass#" <cfif url.AssignmentClass eq AssignmentClass>selected</cfif>>#Description#</option>
		</cfoutput>
</select>