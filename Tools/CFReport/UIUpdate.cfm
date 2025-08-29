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
<cfquery name="Criteria" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_ReportControlCriteria C
	 WHERE ControlId = '#Attributes.ControlId#'
	 ORDER BY CriteriaOrder, CriteriaCluster 
	</cfquery>
	
	<!--- analyse criteria --->
	<cfset box = 1>
	<cfset cnt = 0>
	<cfset cluster = "">
	
	<cfloop query="Criteria">
	
	    <cfset cnt = cnt + 1>
		
		<cfif #LookupMultiple# eq "1">
		    <cfif cnt gt 1>
				<cfset box = box + 1>
				<cfset cnt = "1">
			</cfif>
		    <cfinclude template="UIUpdateQuery.cfm">
			<cfset box = box + 1>
			<cfset cnt = 0>
					
		<cfelse>
		
		    <cfif #CriteriaCluster# neq "" 
			      AND #CriteriaCluster# neq "#Cluster#">
				<cfif cnt gt 1>
					<cfset box = box + 1>
					<cfset cnt = "1">
				</cfif>
			    <cfinclude template="UIUpdateQuery.cfm">	  
		
			<cfelseif #CriteriaCluster# eq "#Cluster#" 
			     and #CriteriaCluster# neq "">
				  <cfset cnt = cnt - 1>
				 <cfinclude template="UIUpdateQuery.cfm">
				 <cfset box = box + 1>
				<cfset cnt = 0>
				
			<cfelse>
			
			    <cfif cnt lt 5>
				   <cfinclude template="UIUpdateQuery.cfm">
				   
				<cfelse>
				   <cfset box = box + 1>  
				   <cfset cnt = 1>
				   <cfinclude template="UIUpdateQuery.cfm">
			   
			    </cfif>
				
			</cfif>
			
		</cfif>
			
		<cfset Cluster = #CriteriaCluster#> 
					
	</cfloop>