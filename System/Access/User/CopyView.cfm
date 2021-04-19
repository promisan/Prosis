
<cfparam name="url.mid" default="">
<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<iframe src="#SESSION.root#/System/Access/User/CopyAccess.cfm?group=#url.group#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>