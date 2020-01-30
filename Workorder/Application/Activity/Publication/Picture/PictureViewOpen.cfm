<cfquery name="getPicture" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Attachment
		WHERE	AttachmentId = '#url.AttachmentId#'
</cfquery>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#getPicture.filename#" 
			  option="#getPicture.AttachmentMemo#"
			  banner="blue"
			  jQuery="yes">

<cfoutput>
	<table width="100%" height="100%">
		<tr>
			<td width="100%" height="100%" valign="middle" align="center">
				<div style="max-width:100%;">
					<img 
						src="#session.rootdocument#/#getPicture.serverPath#/#getPicture.filename#" 
						style="width:100%;" 
						title="#getPicture.filename#">
				</div>
			</td>
		</tr>
	</table>
</cfoutput>