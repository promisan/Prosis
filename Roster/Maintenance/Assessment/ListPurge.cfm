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

<cfquery name="Delete" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_Assessment
		 WHERE AssessmentCategory = '#URL.Code#'
		 AND SkillCode = '#URL.skillcode#'
		 AND Owner = '#URL.Owner#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListingDelete.cfm?code=#url.code#','del_#url.code#')
	</script>
</cfoutput>

