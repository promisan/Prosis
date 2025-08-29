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
<cfparam name="form.MailToDocumentId" default="">
<cfparam name="form.MailToCustom"     default="">

<cfquery name="Update" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  UPDATE 	Ref_EntityDocument
  SET       MailTo              = '#Form.MailTo#',
			<cfif form.MailToDocumentId neq "">MailToDocumentId = '#Form.MailToDocumentId#',</cfif>
			<cfif form.MailToCustom     neq "">MailToCustom = '#Form.MailToCustom#',</cfif>
			MailPriority        = '#Form.MailPriority#', 
			MailSubject         = '#Form.MailSubject#',
			MailSubjectCustom   = '#Form.MailSubjectCustom#',
			MailBody            = '#Form.MailBody#',
			MailBodyCustom      = '#Form.MailBodyCustom#'
  WHERE  	DocumentId          = '#Form.DocumentId#'
</cfquery>

<cfif ParameterExists(Form.Save)>
	<script>
		alert('Mail content saved!')
	</script>
</cfif>

<cfif ParameterExists(Form.SaveClose)>
	<script>
		parent.parent.parent.ProsisUI.closeWindow('maildialog',true)
	</script>
</cfif>
