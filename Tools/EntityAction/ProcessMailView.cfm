
<cfparam name="url.objectid"             default="">
<cfparam name="url.actioncode"           default="">
<cfparam name="url.text"                 default="">
<cfparam name="url.NotificationGlobal"   default="0">

<cfparam name="url.mid" default="">

<cfoutput>
	<table width="100%" height="100%">
	<tr><td style="height:100%;width:100%;overflow:hidden">
		<iframe src="#session.root#/Tools/EntityAction/ProcessMailViewContent.cfm?objectid=#url.objectid#&actioncode=#URL.actioncode#&text=#URL.text#&NotificationGlobal=#URL.NotificationGlobal#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	</table>
</cfoutput>