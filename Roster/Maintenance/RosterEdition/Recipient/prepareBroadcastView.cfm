<cfparam name="url.id" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.mid" default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<iframe src="#SESSION.root#/Tools/Mail/Broadcast/BroadCastView.cfm?mode=iframe&id=#url.id#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>