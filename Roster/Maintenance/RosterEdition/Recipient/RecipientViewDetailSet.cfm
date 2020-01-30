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
				ColdFusion.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.ID#','recipients');
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
				ColdFusion.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientViewDetail.cfm?submissionedition=#url.ID#','recipients');
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



