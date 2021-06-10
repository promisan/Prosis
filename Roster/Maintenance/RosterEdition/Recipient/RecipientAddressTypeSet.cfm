<cfquery name="qUpdate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  UPDATE Ref_SubmissionEditionAddressType
  SET    Operational = <cfif URL.op eq "enable">1<cfelse>0</cfif>
  WHERE  SubmissionEdition = '#URL.ID#'  
  AND    AddressType = '#URL.at#'
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientAddressType.cfm?submissionedition=#url.ID#','types');
	</script>
</cfoutput>
