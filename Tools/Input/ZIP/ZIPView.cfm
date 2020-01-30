
<cf_param name="url.country" default="" type="String">

<cfoutput>
	<table width="100%" height="99%">
	<tr><td style="padding:4px;height:99%;width:100%">
	<iframe src="#session.root#/Tools/Input/ZIP/ZIPSearch.cfm?country=#url.country#" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>
	</td></tr>
	</table>
</cfoutput>