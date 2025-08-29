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
<cfparam name="url.selected" default="">

<cfquery name="ObservationList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AssetActionCategoryWorkflow C
	 WHERE   C.ActionCategory = '#url.actioncategory#'		
	 AND     C.Category       = '#url.Category#' 
	 AND     C.Operational = 1 
</cfquery>
	
<select name="Observation" class="regularxl">
    <cfoutput query="ObservationList">
		<option value="#Code#" <cfif url.selected eq code>selected</cfif>>#Description#</option>
	</cfoutput>
</select>