<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
<cfparam name="url.mid" default="">
<iframe src="#SESSION.root#/Roster/Maintenance/RosterEdition/Position/PositionEditionViewDetail.cfm?idmenu=#url.idmenu#&positionno=#url.positionno#&submissionedition=#url.submissionedition#&mid=#url.mid#" 
  width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>