<cfquery name="Update" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  UPDATE 	Ref_EntityDocument
  SET       MailTo              = '#Form.MailTo#',
			<cfif form.MailToDocumentId neq "">MailToDocumentId = '#Form.MailToDocumentId#',</cfif>
			MailPriority        = '#Form.MailPriority#', 
			MailSubject         = '#Form.MailSubject#',
			MailSubjectCustom   = '#Form.MailSubjectCustom#',
			MailBody            = '#Form.MailBody#',
			MailBodyCustom      = '#Form.MailBodyCustom#'
  WHERE  	DocumentId = '#Form.DocumentId#'
</cfquery>

<cfif ParameterExists(Form.Save)>
	<script>
		alert('Mail content saved!')
	</script>
</cfif>

<cfif ParameterExists(Form.SaveClose)>
	<script>
		parent.parent.parent.ColdFusion.Window.hide('mydialog',true)
	</script>
</cfif>
