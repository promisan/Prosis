
<cfoutput>
<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%;overflow:hidden">
	<cfif url.mode eq "attachmentmultiple">
	<iframe src="#SESSION.root#/Tools/Document/FileFormDialogMultiple.cfm?host=#url.host#&mode=#url.mode#&box=#url.box#&dir=#url.dir#&ID=#url.id#&ID1=#url.id1#&reload=#url.reload#&documentserver=#url.documentserver#&pdfscript=#url.pdfscript#" width="100%" height="100%" frameborder="0"></iframe>
	<cfelse>
	<iframe src="#SESSION.root#/Tools/Document/FileFormDialogSingle.cfm?host=#url.host#&mode=#url.mode#&box=#url.box#&dir=#url.dir#&ID=#url.id#&ID1=#url.id1#&reload=#url.reload#&documentserver=#url.documentserver#&pdfscript=#url.pdfscript#" width="100%" height="100%" frameborder="0"></iframe>
	</cfif>
	</td></tr>
</table>
</cfoutput>