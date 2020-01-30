<!-- 
	IncidentPersonEditSubmit.cfm
	
	Process user request to create a new IncidentPerson record.

	Called by: IncidentPersonEdit.cfm via Dialog.editincidentperson() 
	
	Modification history:
	17Mar04 - created by MM
-->	
<cfset dateValue = "">
<cfif #FORM.ApprovalDate# NEQ "">
	<CF_DateConvert Value="#Form.ApprovalDate#">
	<cfset aDate = #dateValue#>
</cfif>

<cfquery name="Update_IncidentPerson" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
  	UPDATE 	IncidentPerson
  	SET 	Decision = #FORM.Decision#,
			<cfif #FORM.ApprovalDate# NEQ "">ApprovalDate = #aDate#,<cfelse>ApprovalDate = NULL,</cfif>
			Remarks	 = RTRIM(SUBSTRING('#FORM.Remarks#',1,200))
	WHERE 	Incident = #FORM.Incident#
	AND		PersonNo = '#FORM.PersonNo#'
</cfquery>

<cfoutput>
<script language="JavaScript">
	opener.history.go()
    window.close()
</script>
</cfoutput>