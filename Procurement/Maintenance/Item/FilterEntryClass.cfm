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
<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_EntryClass		
		WHERE Code IN (SELECT EntryClass 
		               FROM ItemMaster 
					   WHERE (Mission = '#url.mission#' or Mission is NULL or Mission = ''))
		ORDER BY Code
</cfquery>
 
 
<select name="entryclass" id="entryclass" class="regularxl" onChange="search('<cfoutput>#URL.view#</cfoutput>')">
  <option value="" selected>Any</option>
	   <cfoutput query="Class">
		 <option value="#Code#">#Description#</option>
	   </cfoutput>        
</select>