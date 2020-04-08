
<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<cfif url.mode eq "entry">
<iframe src="#SESSION.root#/System/Access/User/UserEntry.cfm?mode=#url.mode#&id=#url.id#" width="100%" height="100%" frameborder="0"></iframe>
<cfelse>
<iframe src="#SESSION.root#/System/Access/User/UserEdit.cfm?mode=#url.mode#&id=#url.id#" width="100%" height="100%" frameborder="0"></iframe>
</cfif>
</td></tr>
</table>
</cfoutput>