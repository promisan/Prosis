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
<cfquery name="verifyDelete"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM	OrganizationObjectQuestion
	WHERE 	questionId = '#URL.ID2#'
</cfquery>
<cfif verifyDelete.recordCount eq 0>

	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_EntityDocumentQuestion
		WHERE 	documentId = '#URL.ID1#'
		AND 	questionId = '#URL.ID2#'
	</cfquery>
	
</cfif>

<cfoutput>
<script language="JavaScript">   
   ColdFusion.navigate('objectElementQuestionList.cfm?entityCode=#URL.entityCode#&code=#URL.code#&type=#URL.type#','questionListing')            
</script>
</cfoutput>