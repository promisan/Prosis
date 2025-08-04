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
<cfif trim(url.indexNo) neq "">
	<cfquery name="valIndex" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Person
	    WHERE 	indexNo='#trim(url.indexNo)#'
	</cfquery>

	<cfif valIndex.recordCount gt 0>
		<span style="color:red; font-weight:bold;"><cf_tl id="The specified ID is registered already">.</span>
	</cfif>
	
</cfif>