
<cfoutput>

<cfparam name="url.mid" default="">

<table width="100%" height="100%">
<tr><td>
<iframe src="#SESSION.root#/Staffing/Portal/Staffing/StaffingPosition.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&mandate=#url.mandate#&mid=#url.mid#" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>
