
<cfquery name="update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE	Attachment
		SET		AttachmentMemo = '#url.memo#'
		WHERE	AttachmentId = '#url.AttachmentId#'
</cfquery>

<table>
	<tr>
		<td style="font-size:11px; font-weight:bold; color:#3F9CE9"><cf_tl id="Saved"></td>
	</tr>
</table>