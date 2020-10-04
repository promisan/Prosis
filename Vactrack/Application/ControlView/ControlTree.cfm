<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes" TreeTemplate="Yes">

<table width="100%" border="0" style="height:100%;padding-left:3px;padding-right:3px" align="center">		
	<tr><td style="height:100%;padding-left:10px;padding-top:10px" valign="top">
		
	<cf_UItree name="idtree" format="html">
		<cf_UItreeitem bind="cfc:service.Tree.VacTrackTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.systemfunctionid#')">
	</cf_UItree>

	</td>
	</tr>			
	
</table>

