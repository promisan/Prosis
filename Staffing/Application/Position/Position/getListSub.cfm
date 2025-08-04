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
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	 T.*	         							 
		FROM 	 Ref_PositionParentGroupList T 
		WHERE 	 T.GroupCode = '#url.cde#'  
		AND      ListCodeParent = '#url.val#'		
		ORDER BY T.GroupListOrder ASC
</cfquery>

<cfif getList.recordcount eq "0">

<cfelse>

<cfoutput>
<select class="regularxxl" name="ListCodeSub_#url.cde#" ID="ListCodeSub_#url.cde#">	
	<cfloop query="GetList">
		<option value="#GetList.GroupListCode#" <cfif url.sel eq GetList.GroupListCode>selected</cfif>>#GetList.Description#</option>
	</cfloop>
</select> 
</cfoutput>

</cfif>
