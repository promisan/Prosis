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

<cfquery name="GetList" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 T.*	         							 
		FROM 	 Ref_TopicList T 
		WHERE 	 T.Code = '#url.cde#'  
		AND      ListCodeParent = '#url.val#'
		AND 	 T.Operational = 1
		ORDER BY T.ListOrder ASC
</cfquery>

<cfif getList.recordcount eq "0">

<cfelse>

<cfoutput>
<select class="regularxxl" name="TopicSub_#url.cde#" ID="TopicSub_#url.cde#">	
	<cfloop query="GetList">
		<option value="#GetList.ListCode#" <cfif url.sel eq GetList.ListCode>selected</cfif>>#GetList.ListValue#</option>
	</cfloop>
</select> 
</cfoutput>

</cfif>
