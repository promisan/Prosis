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
<cfquery name="getLookup" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	'Class' as Unit, S.unitClass as Parent, U.Description as Description
		FROM	ServiceItemUnit S INNER JOIN Ref_UnitClass U ON S.unitClass  = U.code
		AND		ServiceItem  = '#URL.ID1#'
		AND 	UnitClass   != 'regular'
		
		UNION
		
		SELECT	'Unit' as Unit, unit as Parent, UnitDescription as Description
		FROM	ServiceItemUnit 
		WHERE	ServiceItem = '#URL.ID1#'
		AND 	UnitClass  != 'regular'
		AND		UnitClass   = '#URL.unitClass#'
		AND     Unit       != '#URL.ID2#'
		AND     UnitParent is NULL or UnitParent = ''
</cfquery>

<select name="unitParent" id="unitParent" class="regularxl" style="width:280px">
	<option value="">N/A</option>
	<cfoutput query="getLookup">
	  <option value="#Parent#" <cfif Parent eq URL.unitParent>selected</cfif>>#Description# (#Parent#)</option>
  	</cfoutput>
</select>