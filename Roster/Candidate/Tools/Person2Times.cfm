
<cfoutput>

<cfparam name="url.mid" default="">
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
	<iframe src="#SESSION.root#/Roster/Candidate/Tools/Person2TimesForm.cfm?personno=#url.personno#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>

</cfoutput>