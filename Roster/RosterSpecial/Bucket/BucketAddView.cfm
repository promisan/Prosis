
<cfparam name="url.edition" default="">

<cfoutput>
	<table width="100%" height="100%">
		<tr>
		<td valign="top" height="100%">
		<iframe src="#session.root#/Roster/RosterSpecial/Bucket/BucketAdd.cfm?functionno=#url.functionno#&owner=#url.owner#&edition=#url.edition#" width="100%" height="99%" frameborder="0"></iframe>
		</td>
		</tr>
</table>
</cfoutput>