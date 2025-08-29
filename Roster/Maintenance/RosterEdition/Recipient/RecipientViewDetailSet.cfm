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
<cfswitch expression="#URL.op#">
	
	<cfcase value="true">
	
		<cfquery name="qUpdate" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SubmissionEditionOrganization
		  SET    Operational = 1
		  WHERE  SubmissionEdition = '#URL.ID#'  
		  AND    OrgUnit = '#URL.Org#'
		</cfquery>
		
	</cfcase>
	
	<cfcase value="false">
	
		<cfquery name="qUpdate" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SubmissionEditionOrganization
		  SET    Operational = 0
		  WHERE  SubmissionEdition = '#URL.ID#'  
		  AND    OrgUnit = '#URL.Org#'
		</cfquery>
		
	</cfcase>
	
	<cfcase value="removeall">
	
		<cfquery name="qUpdate" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SubmissionEditionOrganization
		  SET    Operational = 0
		  WHERE  SubmissionEdition = '#URL.ID#'  
		</cfquery>
						
		<cfoutput>
			<script>
				ptoken.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.ID#','recipients');
			</script>
		</cfoutput>
		
	</cfcase>

	<cfcase value="selectall">
	
		<cfquery name="qUpdate" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SubmissionEditionOrganization
		  SET    Operational = 1
		  WHERE  SubmissionEdition = '#URL.ID#'  
		</cfquery>
						
		<cfoutput>
			<script>
				ptoken.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.ID#','recipients');
			</script>
		</cfoutput>
		
	</cfcase>
	
</cfswitch>

<cfquery name="get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * FROM Ref_SubmissionEditionOrganization  
  WHERE  SubmissionEdition = '#URL.ID#'  
  AND    Operational = 1
</cfquery>

<cfoutput>
<script language="JavaScript">
	$('##lrecipients').html('<b>Recipients (#get.recordcount#)</b>');
</script>
</cfoutput>



