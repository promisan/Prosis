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

<cfparam name="row"           default="0">
<cfparam name="sectionselect" default = "">

<cf_calendarscript>

<cfset rows = getTopicList.RecordCount>

<!--- 1. filter on the sectionselect value for the looing --->

<cfif sectionselect neq "">
	
	<cfquery name="getTopicListFilter" dbtype="query">
		SELECT * FROM getTopicList WHERE ElementSection = '#sectionselect#'
	</cfquery>
	
	<cfoutput query="getTopicListFilter">
	
		<cfset row = row + 1>	
		
		<cfif TopicClass eq 'Person'>		
		    <cfinclude template = "FieldPerson.cfm">
		<cfelse>
			<cfinclude template = "FieldCustom.cfm">
		</cfif>			
					    
	</cfoutput>	
	
	<cfif currentrow eq "1">
		<cfinclude template = "FieldStandard.cfm">
	</cfif>

<cfelse>
	
	<cfoutput query="getTopicList">
	
		<cfset row = row + 1>			
		<cfif TopicClass eq 'Person'>		
		    <cfinclude template = "FieldPerson.cfm">
		<cfelse>
			<cfinclude template = "FieldCustom.cfm">
		</cfif>							
		    
	</cfoutput>	
	
	<cfinclude template = "FieldStandard.cfm">

</cfif>

  