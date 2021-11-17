

<!--- quote mail content --->

<cfparam name="url.mid" default="">

<cfoutput>

<table style="width:100%;height:100%">
	<tr>
		<td style="height:100%;width:100%;border:1px solid silver">			
		<iframe src="#SESSION.root#/Tools/Mail/MailPrepare.cfm?mode=cfwindow&mid=#url.mid#&id=#url.id#&subject=#url.subject#&to=#url.to#&renderer=HTMPDF&filename=#url.filename#&templatepath=#url.templatepath#&id1=#url.id1#" 
		 width="100%" height="100%" frameborder="0">
		</iframe>
		</td>
	</tr>
</table>

</cfoutput>

	   		